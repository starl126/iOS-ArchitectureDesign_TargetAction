//
//  LXHttpBLLHandler.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/13.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXHttpBLLHandler.h"

@interface LXHttpBLLHandler ()

@property (nonatomic, strong) LXHttpTaskPool* taskPool;

@end

@implementation LXHttpBLLHandler

#pragma mark --- life cycle
+ (instancetype)sharedHandler {
    static dispatch_once_t onceToken;
    static LXHttpBLLHandler* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [LXHttpBLLHandler new];
    });
    return instance;
}
- (instancetype)init {
    if (self = [super init]) {
        self.taskPool = [LXHttpTaskPool new];
    }
    return self;
}

#pragma mark --- actions
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_POSTHttpHandler {
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback) {
        self.taskPool.lx_addTask(LXHttpTaskModel.lx_init(url,parameters,@"POST"))
        .lx_taskCompletedCallBack(completedCallback);
        
        return self;
    };
}
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_GETHttpHandler {
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback) {
        self.taskPool.lx_addTask(LXHttpTaskModel.lx_init(url,parameters,@"GET"))
        .lx_taskCompletedCallBack(completedCallback);
        
        return self;
    };
}
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_HEADHttpHandler {
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback) {
        self.taskPool.lx_addTask(LXHttpTaskModel.lx_init(url,parameters,@"HEAD"))
        .lx_taskCompletedCallBack(completedCallback);
        
        return self;
    };
}
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_PUTHttpHandler {
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback) {
        self.taskPool.lx_addTask(LXHttpTaskModel.lx_init(url,parameters,@"PUT"))
        .lx_taskCompletedCallBack(completedCallback);
        
        return self;
    };
}

- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback,LXPoolTaskUploadProgressCallback _Nullable uploadProgressCallback,LXPoolTaskDownloadProgressCallback _Nullable downloadProgressCallback))lx_POSTHttpProgressHandler {
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completed,LXPoolTaskUploadProgressCallback _Nullable upload,LXPoolTaskDownloadProgressCallback _Nullable download) {
        self.taskPool.lx_addTask(LXHttpTaskModel.lx_init(url,parameters,@"POST"))
        .lx_taskCompletedCallBack(completed)
        .lx_taskUploadProgressCallback(upload)
        .lx_taskDownloadProgressCallback(download);
        
        return self;
    };
}

@end
