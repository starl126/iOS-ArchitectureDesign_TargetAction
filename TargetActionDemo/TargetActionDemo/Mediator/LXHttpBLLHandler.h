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

@interface LXHttpBLLHandler : NSObject

+ (instancetype)sharedHandler;
- (instancetype)init NS_UNAVAILABLE;

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

@end

NS_ASSUME_NONNULL_END
