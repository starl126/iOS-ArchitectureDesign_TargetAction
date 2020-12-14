//
//  LXdladdr.m
//  TargetActionDemo
//
//  Created by Starl on 2020/11/18.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXdladdr.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import <dlfcn.h>

#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <mach-o/ldsyms.h>

@implementation LXdladdr

+ (NSArray <NSString *> *)getNonDyldClassName {
    
    NSMutableArray<NSString *> *arrM = [NSMutableArray arrayWithCapacity:10];
    
    /// 获取当前工程下自定义类的文件名
    static struct dl_info app_info;
    if (app_info.dli_saddr == NULL) {
        int success = dladdr((__bridge void *)[UIApplication.sharedApplication.delegate class], &app_info);
        if (success == 0) {/// 获取失败
            char *err = dlerror();
            LXLog(@"获取当前app的动态路径错误: %s", err);
            return nil;
        }
    }
    
    /// 获取app加载的所有类，并通过类的dladdr来筛选出工程中自定义的类
    Class *buffer = NULL;
    int total = objc_getClassList(NULL, 0);
    buffer = (__unsafe_unretained Class *)malloc(sizeof(Class) * total);
    
    int clsCount = objc_getClassList(buffer, total);
    for (int i=0; i<clsCount; i++) {
        Class cls = buffer[i];
        
        struct dl_info cls_info = {0};
        int success = dladdr((__bridge void *)cls, &cls_info);
        if (success == 0) {
            LXLog(@"dladdr 失败的类：%s", class_getName(cls));
            continue;
        }
        
        /// 判断是非是自定义类
        if (cls_info.dli_fname == NULL || strcmp(cls_info.dli_fname, app_info.dli_fname) != 0) {
//            LXLog(@"系统函数: dli_sname = %s\ndli_fname = %s\nclass_getName = %s", cls_info.dli_sname, cls_info.dli_fname,class_getName(cls));
        } else {
            const char *clsName = class_getName(cls);
            [arrM addObject:[NSString stringWithFormat:@"%s", clsName]];
            LXLog(@"自定义函数: dli_sname = %s\ndli_fname = %s\nclass_getName = %s", cls_info.dli_sname, cls_info.dli_fname, clsName);
        }
    }
    free(buffer);
    return arrM.copy;
}

NSArray<NSString *>* KGReadConfiguration(char *sectionName,const struct mach_header *mhp);

static uint32_t _image_header_size(const struct mach_header *mh) {
    
    bool is_header_64_bit = (mh->magic == MH_MAGIC_64 || mh->magic == MH_CIGAM_64);
    return (is_header_64_bit ? sizeof(struct mach_header_64) : sizeof(struct mach_header));
}

static void _image_visit_load_commands(const struct mach_header *mh, void (^visitor)(struct load_command *lc, bool *stop)) {
    
    assert(visitor != NULL);
    
    uintptr_t lc_cursor = (uintptr_t)mh + _image_header_size(mh);
    
    for (uint32_t idx = 0; idx < mh->ncmds; idx++) {
        struct load_command *lc = (struct load_command *)lc_cursor;
        
        bool stop = false;
        visitor(lc, &stop);
        
        if (stop) {
            return;
        }
        
        lc_cursor += lc->cmdsize;
    }
}

static uint64_t _image_text_segment_size(const struct mach_header *mh) {
    
    static const char *text_segment_name = "__TEXT";
    
    __block uint64_t text_size = 0;
    
    _image_visit_load_commands(mh, ^ (struct load_command *lc, bool *stop) {
        if (lc->cmdsize == 0) {
            return;
        }
        if (lc->cmd == LC_SEGMENT) {
            struct segment_command *seg_cmd = (struct segment_command *)lc;
            if (strcmp(seg_cmd->segname, text_segment_name) == 0) {
                text_size = seg_cmd->vmsize;
                *stop = true;
                return;
            }
        }
        if (lc->cmd == LC_SEGMENT_64) {
            struct segment_command_64 *seg_cmd = (struct segment_command_64 *)lc;
            if (strcmp(seg_cmd->segname, text_segment_name) == 0) {
                text_size = seg_cmd->vmsize;
                *stop = true;
                return;
            }
        }
    });
    
    return text_size;
}

static const uuid_t *_image_retrieve_uuid(const struct mach_header *mh) {
    
    __block const struct uuid_command *uuid_cmd = NULL;
    
    _image_visit_load_commands(mh, ^ (struct load_command *lc, bool *stop) {
        if (lc->cmdsize == 0) {
            return;
        }
        if (lc->cmd == LC_UUID) {
            uuid_cmd = (const struct uuid_command *)lc;
            *stop = true;
        }
    });
    
    if (uuid_cmd == NULL) {
        return NULL;
    }
    
    return &uuid_cmd->uuid;
}

static void _print_image(const struct mach_header *mh, bool added) {
    Dl_info image_info;
    int result = dladdr(mh, &image_info);
    
    if (result == 0) {
        printf("Could not print info for mach_header: %p\n\n", mh);
        return;
    }
    
    const char *image_name = image_info.dli_fname;
    
    const intptr_t image_base_address = (intptr_t)image_info.dli_fbase;
    const uint64_t image_text_size = _image_text_segment_size(mh);
    
    char image_uuid[37];
    const uuid_t *image_uuid_bytes = _image_retrieve_uuid(mh);
    uuid_unparse(*image_uuid_bytes, image_uuid);
    
    const char *log = added ? "Added" : "Removed";
    printf("%s: 0x%02lx (0x%02llx) %s <%s>\n\n", log, image_base_address, image_text_size, image_name, image_uuid);
}

static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    _print_image(mhp, true);
}

//注册main之前的析构函数
#if DEBUG
__attribute__((constructor))
#else
#endif
void initProphet() {
    //动态链接库加载的时候的hook，可能会回调次数比较多，可能不建议
    _dyld_register_func_for_add_image(dyld_callback);
}

@end
