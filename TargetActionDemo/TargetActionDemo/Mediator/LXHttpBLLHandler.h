//
//  LXHttpBLLHandler.h
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/13.
//  Copyright © 2020 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHttpTaskPool.h"

NS_ASSUME_NONNULL_BEGIN
/// 业务层: 此层和业务直接相关，变动性大
@interface LXHttpBLLHandler : NSObject

+ (instancetype)sharedHandler;
- (instancetype)init NS_UNAVAILABLE;

#pragma mark --- 无缓存api
/// 'POST'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_POSTHttpHandler;

/// 'GET'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_GETHttpHandler;

/// 'HEAD'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_HEADHttpHandler;

/// 'PUT'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_PUTHttpHandler;

/// 'POST'请求,依次设置url地址 参数 任务完成回调 任务上传回调 任务下载回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback,LXPoolTaskUploadProgressCallback _Nullable uploadProgressCallback,LXPoolTaskDownloadProgressCallback _Nullable downloadProgressCallback))lx_POSTHttpProgressHandler;

#pragma mark --- 有缓存api
/// 'POST'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_POSTHttpCacheHandler;

/// 'GET'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_GETHttpCacheHandler;

/// 'HEAD'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_HEADHttpCacheHandler;

/// 'PUT'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback))lx_PUTHttpCacheHandler;

/// 'POST'请求,依次设置url地址 参数 任务完成回调 任务上传回调 任务下载回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXPoolTaskCompletedCallback completedCallback,LXPoolTaskUploadProgressCallback _Nullable uploadProgressCallback,LXPoolTaskDownloadProgressCallback _Nullable downloadProgressCallback))lx_POSTHttpCacheProgressHandler;

@end

NS_ASSUME_NONNULL_END
