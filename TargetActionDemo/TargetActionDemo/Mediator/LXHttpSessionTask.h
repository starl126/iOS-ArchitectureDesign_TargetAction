//
//  LXHttpSessionTask.h
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/8.
//  Copyright © 2020 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LXHttpResCodeType) {
    
#pragma mark --- 通用应用层码
    /** 请求失败 */
    LXHttpResCodeTypeFailure = -1,
    /** 系统错误 */
    LXHttpResCodeTypeSystemError = -100,
    /** 成功 */
    LXHttpResCodeTypeSuccess = 0,
    /** 登录过期 */
    LXHttpResCodeTypeTokenExpired = 103,
    /** 参数异常，鉴权失败 */
    LXHttpResCodeTypeParaIllegal = 109,
    
#pragma mark --- 网络层码
    /** 网络链接失败 */
    LXHttpResCodeTypeDisconnect = -500,
    /** 网络请求超时 */
    LXHttpResCodeTypeTimeOut = -1001,
    /** 手动取消任务 */
    LXHttpResCodeTypeCancelTask = -999,
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

@end

/// 基础层：完成会话单个请求任务对象
@interface LXHttpSessionTask : NSObject

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
- (LXHttpSessionTask* (^)(void (^_Nullable responseCallback)(LXHttpResData* _Nullable data)))lx_resCallback;

/// 设置上传进度回调
- (LXHttpSessionTask* (^)(void (^ _Nullable uploadProgressCallback)(NSProgress* _Nonnull uploadProgress)))lx_uploadProgressCallback;

/// 设置下载进度回调
- (LXHttpSessionTask* (^)(void (^ _Nullable downloadProgressCallback)(NSProgress* _Nonnull downloadProgress)))lx_downloadProgressCallback;

/// 取消网络请求任务
- (LXHttpSessionTask* (^)(void))lx_cancel;

/// 暂停网络请求任务
- (LXHttpSessionTask* (^)(void))lx_suspend;

/// 开始或者继续网络请求任务
- (LXHttpSessionTask* (^)(void))lx_resume;

/// 获取当前任务的request
- (NSURLRequest* (^)(void))lx_request;

@end

NS_ASSUME_NONNULL_END
