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
typedef NS_ENUM(NSInteger, LXHttpResCodeType) {
    
#pragma mark --- 通用应用层码
    /** 请求失败 */
    LXHttpResCodeTypeFailure      = -1,
    /** 系统错误 */
    LXHttpResCodeTypeSystemError  = -100,
    /** 成功 */
    LXHttpResCodeTypeSuccess      = 0,
    /** 登录过期 */
    LXHttpResCodeTypeTokenExpired = 103,
    /** 参数异常，鉴权失败 */
    LXHttpResCodeTypeParaIllegal  = 109,
    
#pragma mark --- 网络层码
    /** 网络链接失败 */
    LXHttpResCodeTypeDisconnect = -500,
    /** 网络请求超时 */
    LXHttpResCodeTypeTimeOut    = -1001,
    /** 手动取消任务 */
    LXHttpResCodeTypeCancelTask = -999,
    
#pragma mark --- 任务层错误码
    /** 任务操作错误，比如删除，添加... */
    LXHttpResCodeTypeTaskOperationError = -300,
    /** 任务添加错误 */
    LXHttpResCodeTypeTaskAddFail        = -301,
    /** 任务已经存在 */
    LXHttpResCodeTypeTaskExisted        = -302,
    /** 任务删除失败 */
    LXHttpResCodeTypeTaskDeleteFail     = -303,
    /** 任务暂停失败 */
    LXHttpResCodeTypeTaskSuspendFail    = -304,
    /** 任务重启或者开启失败 */
    LXHttpResCodeTypeTaskResumeFail     = -305
};

@interface LXHttpResData: NSObject

/** 原始数据 */
@property (nonatomic, readonly) NSDictionary* originInfo;
/** 状态码 */
@property (nonatomic, readonly) NSInteger code;
/** 响应数据 */
@property (nonatomic, strong, readonly) id data;
/** 服务器返回消息 */
@property (nonatomic, readonly) NSString* msg;
/** 请求地址 */
@property (nonatomic, readonly) NSString* urlStr;

+ (instancetype)httpResDataWithUrl:(NSString*)url data:(id _Nullable)data error:(NSError *_Nullable)error;
+ (instancetype)httpResTaskErrorWithUrl:(NSString*)url code:(LXHttpResCodeType)code;

@end

/// 定义业务层任务完成回调
typedef void (^LXBLLTaskCompletedCallback)(LXHttpTaskModel* _Nonnull task, LXHttpResData* _Nonnull resData);

/// 业务层: 此层和业务直接相关，变动性大
@interface LXHttpBLLHandler : NSObject

+ (instancetype)sharedHandler;
- (instancetype)init NS_UNAVAILABLE;

#pragma mark --- 无缓存api
/// 'POST'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_POSTHttpHandler;

/// 'GET'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_GETHttpHandler;

/// 'HEAD'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_HEADHttpHandler;

/// 'PUT'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_PUTHttpHandler;

/// 'POST'请求,依次设置url地址 参数 任务完成回调 任务上传回调 任务下载回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback,LXPoolTaskUploadProgressCallback _Nullable uploadProgressCallback,LXPoolTaskDownloadProgressCallback _Nullable downloadProgressCallback))lx_POSTHttpProgressHandler;

#pragma mark --- 有缓存api
/// 'POST'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_POSTHttpCacheHandler;

/// 'GET'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_GETHttpCacheHandler;

/// 'HEAD'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_HEADHttpCacheHandler;

/// 'PUT'请求,依次设置url地址 参数 任务完成回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback))lx_PUTHttpCacheHandler;

/// 'POST'请求,依次设置url地址 参数 任务完成回调 任务上传回调 任务下载回调
- (LXHttpBLLHandler* (^)(NSString* _Nonnull url,id _Nullable parameters,LXBLLTaskCompletedCallback completedCallback,LXPoolTaskUploadProgressCallback _Nullable uploadProgressCallback,LXPoolTaskDownloadProgressCallback _Nullable downloadProgressCallback))lx_POSTHttpCacheProgressHandler;

@end

NS_ASSUME_NONNULL_END
