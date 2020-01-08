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

@interface LXHttpSessionTask : NSObject


/// configure session task url,method and parameters in queue
- (LXHttpSessionTask* (^)(NSString* _Nullable url,NSString* _Nonnull method,id _Nullable parameters))lx_sessionUrlParameters;

/// set session task header
- (LXHttpSessionTask* (^)(NSDictionary* _Nullable header))lx_header;

/// set session task's response call back
- (LXHttpSessionTask* (^)(void (^_Nullable responseCallback)(LXHttpResData* _Nullable data)))lx_resCallback;


/// cancel the existed session task,if no existed,do nothing
- (LXHttpSessionTask* (^)(void))lx_cancel;

/// suspend the running session task,if no any running,do nothing
- (LXHttpSessionTask* (^)(void))lx_suspend;

/// resume the suspend session task,if the current task dont suspend,do nothing
- (LXHttpSessionTask* (^)(void))lx_resume;

@end

NS_ASSUME_NONNULL_END
