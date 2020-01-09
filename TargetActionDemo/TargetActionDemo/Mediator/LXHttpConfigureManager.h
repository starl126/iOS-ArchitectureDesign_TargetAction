//
//  LXHttpConfigureManager.h
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/9.
//  Copyright © 2020 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 基础层：网络请求配置层
@interface LXHttpConfigureManager : NSObject

#pragma mark --- init
/// 默认配置,单例
+ (instancetype)defaultConfigure;

/// 自定义配置，仅在自定义配置下才能进行个性化设置，非单例
+ (instancetype)customizedConfigure;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark --- set
/// 设置请求缓存类型，默认是NSURLRequestReloadIgnoringLocalCacheData
- (LXHttpConfigureManager* (^)(NSURLRequestCachePolicy requestCachePolicy))lx_requestCachePolicy;

/// 设置请求超时时间，默认是20s
- (LXHttpConfigureManager* (^)(NSTimeInterval timeout))lx_timeoutIntervalForRequest;

/// 设置请求资源响应超时时间，默认是7days
- (LXHttpConfigureManager* (^)(NSTimeInterval timeout))lx_timeoutIntervalForResource;

/// 设置网络服务类型
- (LXHttpConfigureManager* (^)(NSURLRequestNetworkServiceType networkServiceType))lx_networkServiceType;

/// 设置是否允许蜂窝网络
- (LXHttpConfigureManager* (^)(BOOL allowsCellularAccess))lx_allowsCellularAccess;

/// 设置是否等待网络重新连接
- (LXHttpConfigureManager* (^)(BOOL waitsForConnectivity))lx_waitsForConnectivity API_AVAILABLE(ios(11.0));

/// 设置是否允许设置cookie
- (LXHttpConfigureManager* (^)(BOOL HTTPShouldSetCookies))lx_HTTPShouldSetCookies;

/// 设置每个host允许的最大连接数，默认mac是6，ios是4
- (LXHttpConfigureManager* (^)(NSInteger HTTPMaximumConnectionsPerHost))lx_HTTPMaximumConnectionsPerHost;

#pragma mark --- AFHTTPSessionManager
- (AFHTTPSessionManager* (^)(void))lx_defaultSessionManager;
- (AFHTTPSessionManager* (^)(void))lx_customizedSessionManager;

@end

NS_ASSUME_NONNULL_END
