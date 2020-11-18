//
//  main.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2019/6/29.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <dlfcn.h>
#import <sys/types.h>
#import <sys/sysctl.h>


//void anti_gdb_debug() {
//
//    void *handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
//
//    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
//
//    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
//
//    dlclose(handle);
//
//}
int main(int argc, char * argv[]) {

    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
