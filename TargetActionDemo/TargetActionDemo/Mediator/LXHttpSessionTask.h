//
//  LXHttpSessionTask.h
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/8.
//  Copyright © 2020 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 响应回调Block定义
typedef void (^LXHttpResponseCallback)(NSURLResponse* _Nonnull response, id _Nullable responseObject, NSError* _Nullable error);
/// 上传实时回调Block定义
typedef void (^LXHttpUploadProgressCallback)(NSProgress* _Nonnull);
/// 下载实时回调Block定义
typedef void (^LXHttpDownloadProgressCallback)(NSProgress* _Nonnull);

/// 基础层：完成会话单个请求任务对象
@interface LXHttpSessionTask : NSObject

#pragma mark --- 任务配置
/// 设置网络请求的url地址，method和参数,必传，必须首先设置
- (LXHttpSessionTask* (^)(NSString* _Nullable url,NSString* _Nonnull method,id _Nullable parameters))lx_sessionUrlParameters;

/// 设置'POST'网络请求的url地址和参数
- (LXHttpSessionTask* (^)(NSString* _Nullable url,id _Nullable parameters))lx_sessionPOSTUrlParameters;

/// 设置'GET'网络请求的url地址和参数
- (LXHttpSessionTask* (^)(NSString* _Nullable url,id _Nullable parameters))lx_sessionGETUrlParameters;

/// 设置'DELETE'网络请求的url地址和参数
- (LXHttpSessionTask* (^)(NSString* _Nullable url,id _Nullable parameters))lx_sessionDELETEUrlParameters;

/// 设置'HEAD'网络请求的url地址和参数
- (LXHttpSessionTask* (^)(NSString* _Nullable url,id _Nullable parameters))lx_sessionHEADUrlParameters;

/// 设置'PUT'网络请求的url地址和参数
- (LXHttpSessionTask* (^)(NSString* _Nullable url,id _Nullable parameters))lx_sessionPUTUrlParameters;

/// 设置网络请求的header
- (LXHttpSessionTask* (^)(NSDictionary* _Nullable header))lx_header;

/// 设置响应回调
- (LXHttpSessionTask* (^)(LXHttpResponseCallback _Nullable resCallback))lx_resCallback;

/// 设置上传进度回调
- (LXHttpSessionTask* (^)(LXHttpUploadProgressCallback _Nullable uploadProgress))lx_uploadProgressCallback;

/// 设置下载进度回调
- (LXHttpSessionTask* (^)(LXHttpDownloadProgressCallback _Nullable downloadProgress))lx_downloadProgressCallback;

#pragma mark --- 任务操作
/// 取消网络请求任务
- (LXHttpSessionTask* (^)(void))lx_cancel;

/// 暂停网络请求任务
- (LXHttpSessionTask* (^)(void))lx_suspend;

/// 开始或者继续网络请求任务
- (LXHttpSessionTask* (^)(void))lx_resume;

#pragma mark --- 任务状态获取
/// 获取当前任务的request
- (NSURLRequest* (^)(void))lx_request;

/// 获取当前任务的状态
- (NSURLSessionTaskState (^)(void))lx_state;

/// 获取当前任务上传进度
- (NSProgress* _Nonnull (^)(void))lx_uploadProgress;

/// 获取当前任务下载进度
- (NSProgress* _Nonnull (^)(void))lx_downloadProgress;

@end

NS_ASSUME_NONNULL_END
