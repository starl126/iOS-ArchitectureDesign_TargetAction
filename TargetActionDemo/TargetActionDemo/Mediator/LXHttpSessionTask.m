//
//  LXHttpSessionTask.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/8.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXHttpSessionTask.h"
#import "LXHttpConfigureManager.h"

@interface LXHttpSessionTask ()

/// 请求配置管理器,全局单例
@property (nonatomic, strong) LXHttpConfigureManager* configureManager;
/// 会话任务
@property (nonatomic, strong) NSURLSessionDataTask* dataTask;
/// 网络请求
@property (nonatomic, readonly) NSMutableURLRequest* requestM;
/// 响应回调
@property (nonatomic, copy, nullable) LXHttpResponseCallback responseCallback;
/// 上传进度回调
@property (nonatomic, copy, nullable) LXHttpUploadProgressCallback uploadProgressCallback;
/// 下载进度回调
@property (nonatomic, copy, nullable) LXHttpDownloadProgressCallback downloadProgressCallback;

/// 上传进度
@property (nonatomic, strong) NSProgress* uploadProgress;

/// 下载进度
@property (nonatomic, strong) NSProgress* downloadProgress;

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

#pragma mark --- 任务配置
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
- (LXHttpSessionTask* (^)(LXHttpResponseCallback _Nullable resCallback))lx_resCallback {
    return ^(LXHttpResponseCallback _Nullable resCallback) {
        self.responseCallback = resCallback;
        return self;
    };
}
- (LXHttpSessionTask* (^)(LXHttpUploadProgressCallback _Nullable uploadProgress))lx_uploadProgressCallback {
    return ^(LXHttpUploadProgressCallback uploadProgressCallback) {
        self.uploadProgressCallback = uploadProgressCallback;
        return self;
    };
}
- (LXHttpSessionTask* (^)(LXHttpDownloadProgressCallback _Nullable downloadProgress))lx_downloadProgressCallback {
    return ^(LXHttpDownloadProgressCallback downloadProgressCallback) {
        self.downloadProgressCallback = downloadProgressCallback;
        return self;
    };
}

#pragma mark --- 任务操作
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
            weakSelf.uploadProgress = uploadProgress;
            if (weakSelf.uploadProgressCallback) {
                weakSelf.uploadProgressCallback(uploadProgress);
            }
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            weakSelf.downloadProgress = downloadProgress;
            if (weakSelf.downloadProgressCallback) {
                weakSelf.downloadProgressCallback(downloadProgress);
            }
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (weakSelf.responseCallback) {
                weakSelf.responseCallback(response,responseObject,error);
            }
        }];
        NSAssert(self.dataTask, @"session data task is empty");
        if (self.dataTask) {
            [self.dataTask resume];
        }
        return self;
    };
}

#pragma mark --- 任务状态获取
- (NSURLRequest* (^)(void))lx_request {
    return ^{
        return self.requestM.copy;
    };
}
- (NSURLSessionTaskState (^)(void))lx_state {
    return ^ {
        return self.dataTask.state;
    };
}
- (NSProgress* _Nonnull (^)(void))lx_uploadProgress {
    return ^ {
        return self.uploadProgress;
    };
}
- (NSProgress* _Nonnull (^)(void))lx_downloadProgress {
    return ^ {
        return self.downloadProgress;
    };
}

#pragma mark --- private
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

- (void)dealloc {
    self->_uploadProgressCallback = nil;
    self->_downloadProgressCallback = nil;
    self->_responseCallback = nil;
    LXLog(@"dealloc --- %@", NSStringFromClass(self.class));
}

@end
