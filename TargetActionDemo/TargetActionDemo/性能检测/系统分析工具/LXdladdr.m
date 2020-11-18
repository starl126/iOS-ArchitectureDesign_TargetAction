//
//  LXdladdr.m
//  TargetActionDemo
//
//  Created by Starl on 2020/11/18.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXdladdr.h"
#import <dlfcn.h>
#import <objc/runtime.h>

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

@end
