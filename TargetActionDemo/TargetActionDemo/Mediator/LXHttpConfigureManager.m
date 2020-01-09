//
//  LXHttpConfigureManager.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/9.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXHttpConfigureManager.h"

@interface LXHttpConfigureManager ()

@property (nonatomic, strong) AFHTTPSessionManager* defaultSessionManager;

@property (nonatomic, strong) AFHTTPSessionManager* customizedSessionManager;
@property (nonatomic, strong) NSURLSessionConfiguration* customizedSessionConfiguration;

@end

@implementation LXHttpConfigureManager

+ (instancetype)defaultConfigure {
    static dispatch_once_t onceToken;
    static LXHttpConfigureManager* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[LXHttpConfigureManager alloc] init];
    });
    return instance;
}
+ (instancetype)customizedConfigure {
    LXHttpConfigureManager* manager = [[LXHttpConfigureManager alloc] init];
    return manager;
}

#pragma mark --- actions
- (LXHttpConfigureManager* (^)(NSURLRequestCachePolicy requestCachePolicy))lx_requestCachePolicy {
    return ^(NSURLRequestCachePolicy requestCachePolicy) {
        self.customizedSessionConfiguration.requestCachePolicy = requestCachePolicy;
        return self;
    };
}
- (LXHttpConfigureManager* (^)(NSTimeInterval timeout))lx_timeoutIntervalForRequest {
    return ^(NSTimeInterval timeout) {
        self.customizedSessionConfiguration.timeoutIntervalForRequest = timeout;
        return self;
    };
}
- (LXHttpConfigureManager* (^)(NSTimeInterval timeout))lx_timeoutIntervalForResource {
    return ^(NSTimeInterval timeout) {
         self.customizedSessionConfiguration.timeoutIntervalForResource = timeout;
         return self;
     };
}
- (LXHttpConfigureManager* (^)(NSURLRequestNetworkServiceType networkServiceType))lx_networkServiceType {
    return ^(NSURLRequestNetworkServiceType networkServiceType){
        self.customizedSessionConfiguration.networkServiceType = networkServiceType;
        return self;
    };
}
- (LXHttpConfigureManager* (^)(BOOL allowsCellularAccess))lx_allowsCellularAccess {
    return ^(BOOL allowsCellularAccess) {
        self.customizedSessionConfiguration.allowsCellularAccess = allowsCellularAccess;
        return self;
    };
}
- (LXHttpConfigureManager* (^)(BOOL waitsForConnectivity))lx_waitsForConnectivity {
    return ^(BOOL waitsForConnectivity) {
        self.customizedSessionConfiguration.waitsForConnectivity = waitsForConnectivity;
        return self;
    };
}
- (LXHttpConfigureManager* (^)(BOOL HTTPShouldSetCookies))lx_HTTPShouldSetCookies {
    return ^(BOOL HTTPShouldSetCookies) {
        self.customizedSessionConfiguration.HTTPShouldSetCookies = HTTPShouldSetCookies;
        return self;
    };
}
- (LXHttpConfigureManager* (^)(NSInteger HTTPMaximumConnectionsPerHost))lx_HTTPMaximumConnectionsPerHost {
    return ^(NSInteger HTTPMaximumConnectionsPerHost) {
        self.customizedSessionConfiguration.HTTPMaximumConnectionsPerHost = HTTPMaximumConnectionsPerHost;
        return self;
    };
}

/// 设置指定会话管理器的认证授权配置
- (void)p_actionForSetSessionAuthenticationChallengeInManager:(AFHTTPSessionManager*)manager {
    
    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession* _Nonnull session, NSURLAuthenticationChallenge* _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
           
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
}
- (AFHTTPSessionManager* (^)(void))lx_defaultSessionManager {
    return ^{
        return self.defaultSessionManager;
    };
}
- (AFHTTPSessionManager* (^)(void))lx_customizedSessionManager {
    return ^{
        return self.customizedSessionManager;
    };
}
#pragma mark --- setter and getter
- (AFHTTPSessionManager*)defaultSessionManager {
    
    if (!_defaultSessionManager) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 20;
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        config.timeoutIntervalForResource = 20;
        config.allowsCellularAccess = YES;
        config.HTTPMaximumConnectionsPerHost = 20;
        
        _defaultSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:config];
        
        AFSecurityPolicy* securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setValidatesDomainName:YES];
        securityPolicy.allowInvalidCertificates = NO;
        _defaultSessionManager.securityPolicy = securityPolicy;
        
        [self p_actionForSetSessionAuthenticationChallengeInManager:_defaultSessionManager];
        
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
        _defaultSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", @"image/jpeg",nil];
        
        //如果是表单，则使用'application/x-www-form-urlencoded'
        [_defaultSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return _defaultSessionManager;
}
- (NSURLSessionConfiguration *)customizedSessionConfiguration {
    if (!_customizedSessionConfiguration) {
        _customizedSessionConfiguration = [[NSURLSessionConfiguration alloc] init];
    }
    return _customizedSessionConfiguration;
}
- (AFHTTPSessionManager *)customizedSessionManager {
    if (!_customizedSessionManager) {
        _customizedSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:self.customizedSessionConfiguration];
        [self p_actionForSetSessionAuthenticationChallengeInManager:_customizedSessionManager];
        _customizedSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", @"image/jpeg",nil];
        [_customizedSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return _customizedSessionManager;
}

@end
