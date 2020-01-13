//
//  LXHttpTaskPool.h
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/10.
//  Copyright © 2020 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHttpSessionTask.h"

NS_ASSUME_NONNULL_BEGIN

/// 响应回调Block定义
typedef void (^LXHttpResponseCallback)(LXHttpResData* _Nullable);
/// 上传实时回调Block定义
typedef void (^LXHttpUploadProgressCallback)(NSProgress* _Nonnull);
/// 下载实时回调Block定义
typedef void (^LXHttpDownloadProgressCallback)(NSProgress* _Nonnull);

@interface LXHttpTaskModel : NSObject

///任务的唯一标识符
@property (nonatomic, copy, nonnull) NSString* identifier;
///当前任务
@property (nonatomic, strong, nonnull) LXHttpSessionTask* dataTask;



/// 初始化方法,依次传入url地址、参数和Method
+ (LXHttpTaskModel* (^)(NSString* _Nonnull url,id _Nullable parameters,NSString* method))lx_init;

/// 设置响应回调
- (LXHttpTaskModel* (^)(LXHttpResponseCallback _Nullable resCallback))lx_responseCallback;

/// 设置上传实时回调
- (LXHttpTaskModel* (^)(LXHttpUploadProgressCallback _Nullable uploadProgressCallback))lx_uploadProgressCallback;

/// 设置下载实时回调
- (LXHttpTaskModel* (^)(LXHttpDownloadProgressCallback _Nullable downloadProgressCallback))lx_downloadProgressCallback;

@end


typedef NS_ENUM(NSInteger, LXTaskCRUDResultType) {
    /// 任务池操作成功
    LXTaskCRUDResultTypeSuccess        = 0,
    /// 任务池加入成功
    LXTaskCRUDResultTypeAddSuccess     = 1,
    /// 任务池删除成功
    LXTaskCRUDResultTypeDeleteSuccess  = 2,
    /// 任务池暂停成功
    LXTaskCRUDResultTypeSuspendSuccess = 3,
    /// 任务池开启成功
    LXTaskCRUDResultTypeResumeSuccess  = 4,
    
    /// 任务池加入失败
    LXTaskCRUDResultTypeAddFail     = -1,
    /// 任务池删除失败
    LXTaskCRUDResultTypeDeleteFail  = -2,
    /// 任务池暂停失败
    LXTaskCRUDResultTypeSuspendFail = -3,
    /// 任务池开启失败
    LXTaskCRUDResultTypeResumeFail  = -4,
    
    /// 任务池已存在此任务(若此任务状态没变化，也理解为存在此任务池中)
    LXTaskCRUDResultTypeExist = 200,
    /// 任务池不存在此任务
    LXTaskCRUDResultTypeNotExist = -200
};

/// 任务池CRUD操作状态回调
typedef void (^LXPoolTaskCRUDStateCallback)(NSString* _Nonnull msg, LXTaskCRUDResultType code,LXHttpTaskModel* _Nullable task);

/// 任务池任务完成回调
typedef void (^LXPoolTaskCompletedCallback)(LXHttpTaskModel* _Nonnull task, LXHttpResData* resData);

/// 任务池上传实时回调
typedef void (^LXPoolTaskUploadProgressCallback)(LXHttpTaskModel* _Nonnull task, NSProgress* _Nonnull progress);

/// 任务池下载实时回调
typedef void (^LXPoolTaskDownloadProgressCallback)(LXHttpTaskModel* _Nonnull task, NSProgress* _Nonnull progress);

/// 任务队列管理池：进行中任务池、等待中任务池和暂停任务池,可进行进行中任务池最大数和等待中任务池最大数限制
@interface LXHttpTaskPool : NSObject

#pragma mark --- 任务池配置
/// 设置最大并发执行任务数，默认10
- (LXHttpTaskPool* (^)(NSUInteger maxRunningTaskCount))lx_maxRunningTaskCount;

/// 设置最大等待任务数，默认是20
- (LXHttpTaskPool* (^)(NSUInteger maxWaitingTaskCount))lx_maxWaitingTaskCount;

#pragma mark --- 任务池CRUD

/// 添加任务并根据进行中的任务决定是否执行，遵循‘FIFO’原则
- (LXHttpTaskPool* (^)(LXHttpTaskModel* _Nonnull task))lx_addTask;

/// 添加任务组并根据进行中的任务决定是否执行，遵循‘FIFO’原则
- (LXHttpTaskPool* (^)(NSArray<LXHttpTaskModel*>* _Nonnull tasks))lx_addTasks;

/// 删除指定任务，针对进行中的任务，先执行cancel再移除；等待中的任务直接删除；暂停中任务先执行cancel再移除
- (LXHttpTaskPool* (^)(LXHttpTaskModel* _Nonnull task))lx_deleteTask;

/// 删除指定标识任务，针对进行中的任务，先执行cancel再移除；等待中的任务直接删除；暂停中任务先执行cancel再移除
- (LXHttpTaskPool* (^)(NSString* _Nonnull taskIdentifier))lx_deleteIdentifierTask;

/// 删除所有的任务，针对进行中的任务，先执行cancel再移除；等待中的任务则直接删除；暂停中任务先执行cancel再移除
- (LXHttpTaskPool* (^)(void))lx_deleteAllTasks;

/// 暂停指定任务，进行中的任务暂停，等待中的任务修改为暂停中任务，其他则不做任何处理
- (LXHttpTaskPool* (^)(LXHttpTaskModel* _Nonnull task))lx_suspendTask;

/// 暂停指定标识任务，针对进行中的任务可暂停，其他则不做任何处理
- (LXHttpTaskPool* (^)(NSString* _Nonnull taskIdentifier))lx_suspendIdentifierTask;

/// 继续或者开启指定任务，等待中的任务若进行中任务满则待进行中任务有空闲时则优先执行；进行中的任务，则不做任何操作；暂停中的任务根据任务池状态做出相应操作
- (LXHttpTaskPool* (^)(LXHttpTaskModel* _Nonnull task))lx_resumeTask;

/// 继续或者开启指定任务，等待中的任务若进行中任务满则待进行中任务有空闲时则优先执行；进行中的任务，则不做任何操作；暂停中的任务根据任务池状态做出相应操作
- (LXHttpTaskPool* (^)(NSString* _Nonnull taskIdentifier))lx_resumeIdentifierTask;


#pragma mark --- 任务池状态
/// 判断指定任务是否存在于任务池中
- (BOOL (^)(LXHttpTaskModel* _Nonnull task))lx_taskExist;

/// 判断指定标识任务是否存在于任务池中
- (BOOL (^)(NSString* _Nonnull taskIdentifier))lx_identifierTaskExist;

#pragma mark --- 任务池任务状态回调
/// 任务池CRUD状态回调
- (LXHttpTaskPool* (^)(LXPoolTaskCRUDStateCallback _Nullable stateCallback))lx_taskPoolActionCallback;

/// 任务请求完成回调
- (LXHttpTaskPool* (^)(LXPoolTaskCompletedCallback _Nullable completedCallback))lx_taskCompletedCallBack;

/// 任务上传实时回调
- (LXHttpTaskPool* (^)(LXPoolTaskUploadProgressCallback _Nullable uploadProgress))lx_taskUploadProgressCallback;

/// 任务下载实时回调
- (LXHttpTaskPool* (^)(LXPoolTaskDownloadProgressCallback _Nullable downloadProgress))lx_taskDownloadProgressCallback;

@end

NS_ASSUME_NONNULL_END
