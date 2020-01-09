//
//  LXHttpSessionTask.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/8.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXHttpSessionTask.h"
#import "LXHttpConfigureManager.h"

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

@end


@interface LXHttpSessionTask ()

///请求配置管理器,全局单例
@property (nonatomic, strong) LXHttpConfigureManager* configureManager;
///会话任务
@property (nonatomic, strong) NSURLSessionDataTask* dataTask;
///网络请求
@property (nonatomic, readonly) NSMutableURLRequest* requestM;
///响应回调
@property (nonatomic, copy) void (^ _Nullable responseCallback)(LXHttpResData* _Nullable data);
///上传进度回调
@property (nonatomic, copy) void (^ _Nullable uploadProgressCallback)(NSProgress* _Nonnull uploadProgress);
///下载进度回调
@property (nonatomic, copy) void (^ _Nullable downloadProgressCallback)(NSProgress* _Nonnull downloadProgress);

@end

@implementation LXHttpSessionTask

#pragma mark --- life cycle

- (instancetype)init {
    if (self = [super init]) {
        self.configureManager = [LXHttpConfigureManager defaultConfigure];
        _requestM = [self.configureManager.lx_defaultSessionManager().requestSerializer requestWithMethod:@"POST" URLString:@"http://google.com" parameters:nil error:NULL];
    }
    return self;
}

#pragma mark --- actions
- (LXHttpSessionTask* (^)(NSString* _Nullable url,NSString* _Nonnull method,id _Nullable parameters))lx_sessionUrlParameters {
    return ^(NSString* _Nullable u,NSString* _Nonnull m,id _Nullable para) {
        NSAssert(u, @"url request is empty");
        NSAssert(m, @"request method is empty");
  
        NSString* correctUrlStr = [u stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        NSURLComponents* urlComponents = [NSURLComponents componentsWithString:correctUrlStr];
        if (para) {
            if ([m isEqualToString:@"GET"] || [m isEqualToString:@"HEAD"] || [m isEqualToString:@"DELETE"]) {//拼接url 地址
                NSString* query = [self p_actionForJoinUrlWithQuery:para];
                urlComponents.query = query;
            }else {
                BOOL isJson = [NSJSONSerialization isValidJSONObject:para];
                if (isJson) {
                    NSData* httpBody = [NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted error:NULL];
                    self.requestM.HTTPBody = httpBody;
                }
            }
        }
        
        self.requestM.URL = urlComponents.URL;
        self.requestM.HTTPMethod = m;
        return self;
    };
}
- (LXHttpSessionTask* (^)(NSString* _Nullable url,id _Nullable parameters))lx_sessionPOSTUrlParameters {
    return ^(NSString* _Nullable u,id _Nullable para) {
        return self.lx_sessionUrlParameters(u,@"POST", para);
    };
}
- (LXHttpSessionTask* (^)(NSString* _Nullable url,id _Nullable parameters))lx_sessionGETUrlParameters {
    return ^(NSString* _Nullable u,id _Nullable para) {
        return self.lx_sessionUrlParameters(u,@"GET", para);
    };
}
- (LXHttpSessionTask* (^)(NSString* _Nullable url,id _Nullable parameters))lx_sessionDELETEUrlParameters {
    return ^(NSString* _Nullable u,id _Nullable para) {
        return self.lx_sessionUrlParameters(u,@"DELETE", para);
    };
}
- (LXHttpSessionTask* (^)(NSString* _Nullable url,id _Nullable parameters))lx_sessionHEADUrlParameters {
    return ^(NSString* _Nullable u,id _Nullable para) {
        return self.lx_sessionUrlParameters(u,@"HEAD", para);
    };
}
- (LXHttpSessionTask* (^)(NSString* _Nullable url,id _Nullable parameters))lx_sessionPUTUrlParameters {
    return ^(NSString* _Nullable u,id _Nullable para) {
        return self.lx_sessionUrlParameters(u,@"PUT", para);
    };
}
- (LXHttpSessionTask* (^)(NSDictionary* _Nullable header))lx_header {
    return ^(NSDictionary* _Nullable header) {
        if (header && header.count) {
            for (id key in header.allKeys) {
                [self.requestM setValue:header[key] forHTTPHeaderField:key];
            }
        }
        return self;
    };
}
- (LXHttpSessionTask* (^)(void (^_Nullable responseCallback)(LXHttpResData* _Nullable data)))lx_resCallback {
    return ^(void (^_Nullable responseCallback)(LXHttpResData* _Nullable data)) {
        self.responseCallback = responseCallback;
        return self;
    };
}
- (LXHttpSessionTask* (^)(void (^ _Nullable uploadProgressCallback)(NSProgress* _Nonnull uploadProgress)))lx_uploadProgressCallback {
    return ^(void (^ _Nullable uploadProgressCallback)(NSProgress* _Nonnull uploadProgress)) {
        self.uploadProgressCallback = uploadProgressCallback;
        return self;
    };
}
- (LXHttpSessionTask * _Nonnull (^)(void (^ _Nullable downloadProgressCallback)(NSProgress * _Nonnull downloadProgress)))lx_downloadProgressCallback {
    return ^(void (^ _Nullable downloadProgressCallback)(NSProgress * _Nonnull downloadProgress)) {
        self.downloadProgressCallback = downloadProgressCallback;
        return self;
    };
}
- (LXHttpSessionTask* (^)(void))lx_cancel {
    return ^() {
        if (self.dataTask && (self.dataTask.state == NSURLSessionTaskStateRunning || self.dataTask.state == NSURLSessionTaskStateSuspended)) {
            [self.dataTask cancel];
        }
        return self;
    };
}
- (LXHttpSessionTask* (^)(void))lx_suspend {
    return ^{
        if (self.dataTask && self.dataTask.state == NSURLSessionTaskStateRunning) {
            [self.dataTask suspend];
        }
        return self;
    };
}
- (LXHttpSessionTask* (^)(void))lx_resume {
    return ^{
        
        kLXWeakSelf;
        self.dataTask = [self.configureManager.lx_defaultSessionManager() dataTaskWithRequest:self.requestM uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            if (weakSelf.uploadProgressCallback) {
                weakSelf.uploadProgressCallback(uploadProgress);
            }
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            if (weakSelf.downloadProgressCallback) {
                weakSelf.downloadProgressCallback(downloadProgress);
            }
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            LXHttpResData* data = [LXHttpResData httpResDataWithUrl:weakSelf.requestM.URL.absoluteString data:responseObject error:error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.responseCallback) {
                    weakSelf.responseCallback(data);
                }
            });
        }];
        NSAssert(self.dataTask, @"session data task is empty");
        if (self.dataTask) {
            [self.dataTask resume];
        }
        return self;
    };
}
- (NSURLRequest* (^)(void))lx_request {
    return ^{
        return self.requestM.copy;
    };
}
///这里只对数组，字符串和字典，对于数组，&拼接数组元素，对于字符串，直接拼接
- (NSString*)p_actionForJoinUrlWithQuery:(id)parameters {
    NSMutableString* query = self.requestM.URL.query.mutableCopy;
    BOOL exist = query && query.length;
    if (!exist) {
        query = [NSMutableString string];
    }
    
    if ([parameters isKindOfClass:NSDictionary.class]) {
        NSDictionary* dict = (NSDictionary*)parameters;
        for (id key in dict.allKeys) {
            [query appendFormat:@"&%@=%@",key,dict[key]];
        }
    }else if ([parameters isKindOfClass:NSArray.class]) {
        for (id value in parameters) {
            [query appendFormat:@"&%@",value];
        }
    }else if ([parameters isKindOfClass:NSString.class]) {
        [query appendFormat:@"&%@",parameters];
    }else {}
    if (!exist) {
        if ([query hasPrefix:@"&"]) {
            [query deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }
    return query.copy;
}

@end
