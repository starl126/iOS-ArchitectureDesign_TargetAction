//
//  LXHttpBLLHandler.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/13.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXHttpBLLHandler.h"
#import "LXHttpCacheTool.h"

@implementation LXHttpResData

+ (instancetype)httpResDataWithUrl:(NSString*)url data:(id _Nullable)data error:(NSError *_Nullable)error {
    return [[self alloc] initWithUrl:url data:data error:error];
}
- (instancetype)initWithUrl:(NSString *)url data:(id)data error:(NSError *)error {
    if (self = [super init]) {
        
        _urlStr = url.copy;
        if (error) {
            _code = error.code;
            if (error.code == LXHttpResCodeTypeTimeOut) {
                _msg = @"网络请求超时";
            }else if (error.code == LXHttpResCodeTypeDisconnect) {
                _msg = @"网络连接断开，请核实";
            }else if (error.code == LXHttpResCodeTypeCancelTask) {
                _msg = @"取消了网络请求";
            }else {
                _msg = @"未知错误";
            }
        }else {
            if ([data isKindOfClass:NSDictionary.class]) {
                _originInfo = data;
                _data = data[@"data"];
                _msg = data[@"msg"];
                
                if (data[@"code"]) {
                    _code = [data[@"code"] integerValue];
                }else if (data[@"status"]) {
                    _code = [data[@"status"] integerValue];
                }else {
                    _code = -1;
                }
            }else {
                _code = -1;
                _msg = @"未知错误";
                LXLog(@"接口: %@ 返回异常结构数据", url);
            }
        }
    }
    return self;
}
+ (instancetype)httpResTaskErrorWithUrl:(NSString*)url code:(LXHttpResCodeType)code {
    LXHttpResData* instance = [LXHttpResData new];
    instance->_code = code;
    instance->_msg  = @"任务操作出现异常";
    instance->_urlStr = url.copy;
    return instance;
}

@end

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
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_POSTHttpHandler {
    
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback) {
    
        LXHttpTaskModel* taskModel = LXHttpTaskModel.lx_init(url,parameters,@"POST");
        taskModel.dataTask.lx_header([self p_header]);
        self.taskPool.lx_addTask(taskModel)
        .lx_taskCompletedCallBack([self p_initPoolTaskCompBridgeBLLCompCallback:completedCallback cache:NO callback:YES]);
        
        return self;
    };
}
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_GETHttpHandler {
    
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback) {
        
        LXHttpTaskModel* taskModel = LXHttpTaskModel.lx_init(url,parameters,@"GET");
        taskModel.dataTask.lx_header([self p_header]);
        self.taskPool.lx_addTask(taskModel)
        .lx_taskCompletedCallBack([self p_initPoolTaskCompBridgeBLLCompCallback:completedCallback cache:NO callback:YES]);
        
        return self;
    };
}
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_HEADHttpHandler {
    
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback) {
        
        LXHttpTaskModel* taskModel = LXHttpTaskModel.lx_init(url,parameters,@"HEAD");
        taskModel.dataTask.lx_header([self p_header]);
        self.taskPool.lx_addTask(taskModel)
        .lx_taskCompletedCallBack([self p_initPoolTaskCompBridgeBLLCompCallback:completedCallback cache:NO callback:YES]);
        
        return self;
    };
}
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_PUTHttpHandler {
    
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback) {

        LXHttpTaskModel* taskModel = LXHttpTaskModel.lx_init(url,parameters,@"PUT");
        taskModel.dataTask.lx_header([self p_header]);
        self.taskPool.lx_addTask(taskModel)
        .lx_taskCompletedCallBack([self p_initPoolTaskCompBridgeBLLCompCallback:completedCallback cache:NO callback:YES]);
        
        return self;
    };
}

- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback,LXPoolTaskUploadProgressCallback _Nullable uploadProgressCallback,LXPoolTaskDownloadProgressCallback _Nullable downloadProgressCallback))lx_POSTHttpProgressHandler {
    
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completed,LXPoolTaskUploadProgressCallback _Nullable upload,LXPoolTaskDownloadProgressCallback _Nullable download) {
        
        LXHttpTaskModel* taskModel = LXHttpTaskModel.lx_init(url,parameters,@"PUT");
        taskModel.dataTask.lx_header([self p_header]);
        self.taskPool.lx_addTask(taskModel)
        .lx_taskCompletedCallBack([self p_initPoolTaskCompBridgeBLLCompCallback:completed cache:NO callback:YES])
        .lx_taskUploadProgressCallback(upload)
        .lx_taskDownloadProgressCallback(download);
        
        return self;
    };
}

#pragma mark --- 有缓存api
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_POSTHttpCacheHandler {
    
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback) {
        return self.lx_httpCacheHandler(url,parameters,@"POST",completedCallback,NULL,NULL);
    };
}
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_GETHttpCacheHandler {
    
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback) {
        return self.lx_httpCacheHandler(url,parameters,@"GET",completedCallback,NULL,NULL);
    };
    
}
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_HEADHttpCacheHandler {

    return ^(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback) {
        return self.lx_httpCacheHandler(url,parameters,@"HEAD",completedCallback,NULL,NULL);
    };
}
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_PUTHttpCacheHandler {

    return ^(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback) {
        return self.lx_httpCacheHandler(url,parameters,@"PUT",completedCallback,NULL,NULL);
    };
}
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback,LXPoolTaskUploadProgressCallback _Nullable uploadProgressCallback,LXPoolTaskDownloadProgressCallback _Nullable downloadProgressCallback))lx_POSTHttpCacheProgressHandler {
    
    return ^(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback,LXPoolTaskUploadProgressCallback upload,LXPoolTaskDownloadProgressCallback download) {
        return self.lx_httpCacheHandler(url,parameters,@"PUT",completedCallback,NULL,NULL);
    };
}

- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,NSString* method,LXBLLTaskCompletedCallback _Nullable completedCallback,LXPoolTaskUploadProgressCallback _Nullable upload,LXPoolTaskDownloadProgressCallback _Nullable download))lx_httpCacheHandler {
    
    return ^(NSString* _Nonnull url,id _Nullable parameters,NSString* method,LXBLLTaskCompletedCallback completedCallback,LXPoolTaskUploadProgressCallback _Nullable upload,LXPoolTaskDownloadProgressCallback _Nullable download) {
        
        LXHttpTaskModel* taskModel = LXHttpTaskModel.lx_init(url,parameters,method);
        //判断任务池中是否此任务
        if (self.taskPool.lx_taskExist(taskModel) && completedCallback) {
            completedCallback(taskModel,[LXHttpResData httpResTaskErrorWithUrl:url code:LXHttpResCodeTypeTaskExisted]);
            return self;
        }
        
        //首先判断缓存是否存在
        NSURLRequest* request = taskModel.dataTask.lx_request();
        NSData* cache = self.cachePool.lx_cacheForRequest(request);
        
        if (cache) {
            if (completedCallback) {
                id json = [NSJSONSerialization JSONObjectWithData:cache options:NSJSONReadingMutableContainers error:NULL];
                LXHttpResData* resData = [LXHttpResData httpResDataWithUrl:url data:json error:nil];
                completedCallback(taskModel,resData);
            }
        }
        
        //继续请求接口，然后更新本地缓存数据
        taskModel.dataTask.lx_header([self p_header]);
        self.taskPool.lx_addTask(taskModel)
        .lx_taskCompletedCallBack([self p_initPoolTaskCompBridgeBLLCompCallback:completedCallback cache:YES callback:!cache])
        .lx_taskDownloadProgressCallback(download)
        .lx_taskUploadProgressCallback(upload);
        
        return self;
    };
}

#pragma mark --- private

/// 桥接任务池任务完成回调为业务层任务完成回调
/// @param BLLCompCallback 业务层任务完成回调
/// @param cache 是否需要缓存该数据
- (LXPoolTaskCompletedCallback)p_initPoolTaskCompBridgeBLLCompCallback:(LXBLLTaskCompletedCallback)BLLCompCallback cache:(BOOL)cache callback:(BOOL)callback {
    
    LXBLLTaskCompletedCallback _BLLCompCallback = BLLCompCallback;
    
    LXPoolTaskCompletedCallback poolCallback = ^(LXHttpTaskModel* _Nonnull task, NSURLResponse* _Nonnull response, id _Nullable responseObject, NSError* _Nullable error) {
        
        if (cache && !error && responseObject) {
            if ([responseObject isKindOfClass:NSDictionary.class] && [responseObject[@"code"] integerValue]==0) {
                NSData* cacheData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:NULL];
                self.cachePool.lx_saveCacheForRequest(task.dataTask.lx_request(),cacheData);
            }
        }
        LXHttpResData* resData = [LXHttpResData httpResDataWithUrl:response.URL.absoluteString data:responseObject error:error];
        if (callback && _BLLCompCallback) {
            _BLLCompCallback(task, resData);
        }
     };
    return poolCallback;
}
- (NSDictionary*)p_header {
    NSDictionary* header = @{
    };
    return header;
}

@end
