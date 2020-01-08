//
//  LXHttpSessionTask.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/8.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXHttpSessionTask.h"
#import <sys/utsname.h>

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

@property (nonatomic,strong) AFHTTPSessionManager* sessionManager;

///默认的每个请求的header字段
@property (nonatomic, strong,) NSDictionary* appInfoHeader;
///设备的详细类型
@property (nonatomic, copy) NSString* deviceDetailType;
///设备信息字典
@property (nonatomic, strong) NSDictionary* deviceDetailInfo;
///会话任务
@property (nonatomic, strong) NSURLSessionDataTask* dataTask;
///网络请求
@property (nonatomic, readonly) NSMutableURLRequest* requestM;
///响应回调
@property (nonatomic, copy) void (^_Nullable responseCallback)(LXHttpResData* _Nullable data);

@end

@implementation LXHttpSessionTask

#pragma mark --- life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self p_configRequestSerializer:NO];
        [self p_configRequestDefaultHeader];
    }
    return self;
}
///配置请求序列对象
- (void)p_configRequestSerializer:(BOOL)formUrlLencoded {
    
    if (formUrlLencoded) {
        self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self.sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }else {
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    _requestM = [self.sessionManager.requestSerializer requestWithMethod:@"POST" URLString:@"http://google.com" parameters:nil error:NULL];
}
///配置请求默认头文件
- (void)p_configRequestDefaultHeader {
    for (id key in self.appInfoHeader.allKeys) {
        [self.requestM setValue:self.appInfoHeader[key] forHTTPHeaderField:key];
    }
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
        self.dataTask = [self.sessionManager dataTaskWithRequest:self.requestM uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            
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

#pragma mark --- setter and getter
- (AFHTTPSessionManager*)sessionManager {
    
    if (!_sessionManager) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 20;
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:config];
        
        AFSecurityPolicy* securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setValidatesDomainName:YES];
        securityPolicy.allowInvalidCertificates = NO;
        _sessionManager.securityPolicy = securityPolicy;
        
        [_sessionManager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession* _Nonnull session, NSURLAuthenticationChallenge* _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
            
            NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            __block NSURLCredential* cred = nil;
            
            // 判断服务器返回的证书是否是服务器信任的
            if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                
                cred = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if (cred) {
                    disposition = NSURLSessionAuthChallengeUseCredential; //使用证书
                }
                else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling; // 忽略证书 默认的做法
                }
            }else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge; // 取消请求,忽略证书
            }
            return disposition;
            
        }];
        
        /*
         NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"cer"];
         NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
         AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate
         withPinnedCertificates:[NSSet setWithObjects:cerData, nil]];
         // 是否允许自己建立的证书有效
         securityPolicy.allowInvalidCertificates = YES;
         // 是否设置证书上的域名和客户端请求的域名有效才能请求成功，一般证书上的域名和客户端域名是相对独立的
         securityPolicy.validatesDomainName = NO;
         _sessionManager.securityPolicy = securityPolicy;
         */
        // set responseSerializer's types
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", @"image/jpeg",nil];
    }
    return _sessionManager;
}
- (NSDictionary *)appInfoHeader {
    if (!_appInfoHeader) {
        NSDictionary* appInfo = [NSBundle mainBundle].infoDictionary;
        NSString* appName = [appInfo objectForKey:@"CFBundleDisplayName"];
        NSString* shortVer = [appInfo objectForKey:@"CFBundleShortVersionString"];
        NSString* os = [[UIDevice currentDevice] systemVersion];
        NSString* userAgent = [NSString stringWithFormat:@"Mozilla/5.0 (iOS; OS/%@ AppName/%@) Version/%@ Device/%@ AppleWebKit/537.36 (KHTML, like Gecko)  Safari/537.36",os,appName,shortVer,self.deviceDetailType];
        
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        _appInfoHeader = @{@"version": shortVer, @"User-Agent": userAgent};
    }
    return _appInfoHeader;
}
- (NSDictionary *)deviceDetailInfo {
    if (!_deviceDetailInfo) {
        _deviceDetailInfo = @{
            @"iPhone5,1": @"iPhone 5",       @"iPhone5,2": @"iPhone 5",
            @"iPhone5,3": @"iPhone 5c",      @"iPhone5,4": @"iPhone 5c",
            @"iPhone6,1": @"iPhone 5s",      @"iPhone6,2": @"iPhone 5s",
            @"iPhone7,1": @"iPhone 6 Plus",  @"iPhone7,2": @"iPhone 6",
            @"iPhone8,1": @"iPhone 6s",      @"iPhone8,2": @"iPhone 6s Plus",
            @"iPhone8,4": @"iPhone SE",      @"iPhone9,1": @"iPhone 7",
            @"iPhone9,2": @"iPhone 7 Plus",  @"iPhone10,1": @"iPhone 8",
            @"iPhone10,4": @"iPhone 8",      @"iPhone10,2": @"iPhone 8 Plus",
            @"iPhone10,5": @"iPhone 8 Plus", @"iPhone10,3": @"iPhone X",
            @"iPhone10,6": @"iPhone X",      @"iPhone11,2": @"iPhone XS",
            @"iPhone11,4": @"iPhone XS Max", @"iPhone11,6": @"iPhone XS Max",
            @"iPhone11,8": @"iPhone XR",     @"i386": @"iPhone Simulator",
            @"x86_64": @"iPhone Simulator",  @"iPod": @"iPod Touch",
            @"iPad1,1": @"iPad 1G",          @"iPad2,1": @"iPad 2",
            @"iPad2,2": @"iPad 2",           @"iPad2,3": @"iPad 2",
            @"iPad2,4": @"iPad 2",           @"iPad2,5": @"iPad Mini 1G",
            @"iPad2,6": @"iPad Mini 1G",     @"iPad2,7": @"iPad Mini 1G",
            @"iPad3,1": @"iPad 3",           @"iPad3,2": @"iPad 3",
            @"iPad3,3": @"iPad 3",           @"iPad3,4": @"iPad 4",
            @"iPad3,5": @"iPad 4",           @"iPad3,6": @"iPad 4",
            @"iPad4,1": @"iPad Air",         @"iPad4,2": @"iPad Air",
            @"iPad4,3": @"iPad Air",         @"iPad4,4": @"iPad Mini 2G",
            @"iPad4,5": @"iPad Mini 2G",     @"iPad4,6": @"iPad Mini 2G",
            @"iPad4,7": @"iPad Mini 3",      @"iPad4,8": @"iPad Mini 3",
            @"iPad4,9": @"iPad Mini 3",      @"iPad5,1": @"iPad Mini 4",
            @"iPad5,2": @"iPad Mini 4",      @"iPad5,3": @"iPad Air 2",
            @"iPad5,4": @"iPad Air 2",       @"iPad6,3": @"iPad Pro 9.7",
            @"iPad6,4": @"iPad Pro 9.7",     @"iPad6,7": @"iPad Pro 12.9",
            @"iPad6,8": @"iPad Pro 12.9",
        };
    }
    return _deviceDetailInfo;
}
- (NSString *)deviceDetailType {
    if (!_deviceDetailType) {
        
        struct utsname deviceInfo;
        int success = uname(&deviceInfo);
        if (success != 0) {
            _deviceDetailType = @"unrecognized device";
        }
        
        NSString* deviceStr = [NSString stringWithCString:deviceInfo.machine encoding:NSUTF8StringEncoding];
        
        id obj = [self.deviceDetailInfo objectForKey:deviceStr];
        if (obj) {
            _deviceDetailType = obj;
        }else {
            _deviceDetailType = @"unknow device";
        }
    }
    return _deviceDetailType;
}

@end
