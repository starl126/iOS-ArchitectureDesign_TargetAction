//
//  LXHttpBLLHandler.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/13.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXHttpBLLHandler.h"
#import "LXHttpCacheTool.h"

@interface LXHttpBLLHandler ()

@property (nonatomic, strong) LXHttpTaskPool* taskPool;
@property (nonatomic, strong) LXHttpCacheTool* cachePool;


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
        self.cachePool = [LXHttpCacheTool new];
    }
    return self;
}

#pragma mark --- 无缓存api
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_POSTHttpHandler {
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback) {
//        LXHttpTaskModel* taskModel = LXHttpTaskModel.lx_init(url,parameters,@"POST");
//        taskModel.dataTask.lx_header([self p_header]);
//        self.taskPool.lx_addTask(taskModel)
//        .lx_taskCompletedCallBack(completedCallback);
        
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

#pragma mark --- 有缓存api
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_POSTHttpCacheHandler {
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback) {
        //首先判断缓存是否存在
        LXHttpTaskModel* taskModel = LXHttpTaskModel.lx_init(url,parameters,@"POST");
        NSURLRequest* request = taskModel.dataTask.lx_request();
        NSData* cache = self.cachePool.lx_cacheForRequest(request);
        if (cache) {
            if (completedCallback) {
                LXHttpResData* resData = [LXHttpResData httpResDataWithUrl:url data:cache error:nil];
                completedCallback(taskModel,resData);
            }
        }
        kLXWeakSelf;
        //继续请求接口，然后更新本地缓存数据
//        self.taskPool.lx_addTask(taskModel)
//        .lx_taskCompletedCallBack(^(LXHttpTaskModel* _Nullable task, LXHttpResData* resData) {
//            if (NSJSONSerialization isValidJSONObject:resData.) {
//
//            }
//            weakSelf.cachePool.lx_saveCacheForRequest(request,);
//        });
        
        return self;
    };
}
//- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_GETHttpCacheHandler {
//
//}
//- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_HEADHttpCacheHandler {
//
//}
//- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_PUTHttpCacheHandler {
//
//}
//- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback,LXPoolTaskUploadProgressCallback _Nullable uploadProgressCallback,LXPoolTaskDownloadProgressCallback _Nullable downloadProgressCallback))lx_POSTHttpCacheProgressHandler {
//
//}


@end
