//
//  LXHttpTaskPool.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/10.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXHttpTaskPool.h"
#import "LXHttpSessionTask.h"
#import <CommonCrypto/CommonDigest.h>

@implementation LXHttpTaskModel

#pragma mark --- init
+ (LXHttpTaskModel* (^)(NSString* _Nonnull url,id _Nullable parameters,NSString* method))lx_init {
    return ^(NSString* _Nonnull url,id _Nullable parameters,NSString* method) {
        LXHttpTaskModel* instance = [LXHttpTaskModel new];
        instance.identifier = [self p_actionForTaskIdentifierInUrl:url param:parameters];
        
        LXHttpSessionTask* sessionTask = [LXHttpSessionTask new];
        sessionTask.lx_sessionUrlParameters(url,method,parameters);
        
        instance.dataTask = sessionTask;
        return instance;
    };
}

#pragma mark --- configure
- (LXHttpTaskModel* (^)(LXHttpResponseCallback _Nullable resCallback))lx_responseCallback {
    return ^(LXHttpResponseCallback _Nullable resCallback) {
        self.dataTask.lx_resCallback(resCallback);
        return self;
    };
}
- (LXHttpTaskModel* (^)(LXHttpUploadProgressCallback _Nullable uploadProgressCallback))lx_uploadProgressCallback {
    return ^(LXHttpUploadProgressCallback _Nullable uploadProgress) {
        self.dataTask.lx_uploadProgressCallback(uploadProgress);
        return self;
    };
}
- (LXHttpTaskModel* (^)(LXHttpDownloadProgressCallback _Nullable downloadProgressCallback))lx_downloadProgressCallback {
    return ^(LXHttpDownloadProgressCallback _Nullable downloadProgress) {
        self.dataTask.lx_downloadProgressCallback(downloadProgress);
        return self;
    };
}

#pragma mark --- private
/// 请求唯一识别码
+ (NSString*)p_actionForTaskIdentifierInUrl:(NSString* _Nonnull)url param:(id _Nullable)param {
    NSAssert(url, @"url地址为空,Method=%s",__PRETTY_FUNCTION__);
    
    NSMutableData* dataM = [url dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
    NSString* identifier = nil;
    if ([NSJSONSerialization isValidJSONObject:param]) {
        NSData* httpBody = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:NULL];
        [dataM appendData:httpBody];
        identifier = [self p_MD5ForData:dataM];
    }else {
        identifier = [self p_MD5ForData:dataM];
    }
    return identifier;
}

/// 二进制数据进行MD5
+ (NSString *)p_MD5ForData:(NSData*)data {
    
    NSAssert(data && data.length, @"MD5二进制为空,Method=%s",__PRETTY_FUNCTION__);
    
    unsigned char result[16];
    CC_MD5(data.bytes, (CC_LONG)data.length, result); // This is the md5 call
    return [NSString stringWithFormat:
           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
           result[0], result[1], result[2], result[3],
           result[4], result[5], result[6], result[7],
           result[8], result[9], result[10], result[11],
           result[12], result[13], result[14], result[15]
           ];
}

@end

@interface LXHttpTaskPool ()

@property (nonatomic, assign) NSUInteger maxRunningTaskCount;
@property (nonatomic, assign) NSUInteger maxWaitingTaskCount;

/// 进行中任务池
@property (nonatomic, strong) NSMutableArray<LXHttpTaskModel*>* runningTaskPool;
/// 等待中任务池
@property (nonatomic, strong) NSMutableArray<LXHttpTaskModel*>* waitingTaskPool;
/// 暂停中任务池
@property (nonatomic, strong) NSMutableArray<LXHttpTaskModel*>* suspendTaskPool;

/// 任务池操作回调
@property (nonatomic, copy, nullable) LXPoolTaskCRUDStateCallback stateCallback;
/// 任务请求完成回调
@property (nonatomic, copy, nullable) LXPoolTaskCompletedCallback completedCallback;
/// 任务上传实时回调
@property (nonatomic, copy, nullable) LXPoolTaskUploadProgressCallback uploadProgressCallback;
/// 任务下载实时回调
@property (nonatomic, copy, nullable) LXPoolTaskDownloadProgressCallback downloadProgressCallback;

@end

@implementation LXHttpTaskPool

#pragma mark --- life cycle
- (instancetype)init {
    if (self = [super init]) {
        _maxRunningTaskCount = 10;
        _maxWaitingTaskCount = 20;
        
        _runningTaskPool = [NSMutableArray arrayWithCapacity:_maxRunningTaskCount];
        _waitingTaskPool = [NSMutableArray arrayWithCapacity:_maxWaitingTaskCount];
        _suspendTaskPool = [NSMutableArray array];
    }
    return self;
}

#pragma mark --- 任务池配置
- (LXHttpTaskPool* (^)(NSUInteger maxRunningTaskCount))lx_maxRunningTaskCount {
    return ^(NSUInteger maxRunningTaskCount) {
        self.maxRunningTaskCount = maxRunningTaskCount;
        return self;
    };
}
- (LXHttpTaskPool * _Nonnull (^)(NSUInteger))lx_maxWaitingTaskCount {
    return ^(NSUInteger maxWaitingTaskCount) {
        self.maxWaitingTaskCount = maxWaitingTaskCount;
        return self;
    };
}

#pragma mark --- 任务池CRUD
- (LXHttpTaskPool* (^)(LXHttpTaskModel* _Nonnull task))lx_addTask {
    return ^(LXHttpTaskModel* _Nonnull task) {
        [self p_actionForAddTask:task];
        return self;
    };
}
- (LXHttpTaskPool* (^)(NSArray<LXHttpTaskModel*>* _Nonnull tasks))lx_addTasks {
    return ^(NSArray<LXHttpTaskModel*>* _Nonnull tasks) {
        for (LXHttpTaskModel* one in tasks) {
            [self p_actionForAddTask:one];
        }
        return self;
    };
}
- (LXHttpTaskPool* (^)(LXHttpTaskModel* _Nonnull task))lx_deleteTask {
    return ^(LXHttpTaskModel* _Nonnull task) {
        [self p_actionForDeleteTask:task];
        return self;
    };
}
- (LXHttpTaskPool* (^)(NSString* _Nonnull taskIdentifier))lx_deleteIdentifierTask {
    return ^(NSString* _Nonnull taskIdentifier) {
        [self p_actionForDeleteTaskIdentifier:taskIdentifier];
        return self;
    };
}
- (LXHttpTaskPool* (^)(void))lx_deleteAllTasks {
    return ^ {
        [self p_actionForDeleteAllTasks];
        return self;
    };
}
- (LXHttpTaskPool* (^)(LXHttpTaskModel* _Nonnull task))lx_suspendTask {
    return ^(LXHttpTaskModel* _Nonnull task) {
        [self p_actionForSuspendTask:task];
        return self;
    };
}
- (LXHttpTaskPool * _Nonnull (^)(NSString * _Nonnull))lx_suspendIdentifierTask {
    return ^(NSString * _Nonnull taskIdentifier) {
        [self p_actionForSuspendTaskIdentifier:taskIdentifier];
        return self;
    };
}
- (LXHttpTaskPool * _Nonnull (^)(LXHttpTaskModel * _Nonnull task))lx_resumeTask {
    return ^(LXHttpTaskModel * _Nonnull task) {
        [self p_actionForResumeTaskIdentifier:task.identifier];
        return self;
    };
}
- (LXHttpTaskPool* (^)(NSString* _Nonnull taskIdentifier))lx_resumeIdentifierTask {
    return ^(NSString* _Nonnull taskIdentifier) {
        [self p_actionForResumeTaskIdentifier:taskIdentifier];
        return self;
    };
}

#pragma mark --- private

- (void)p_actionForAddTask:(LXHttpTaskModel*)task {
    
    NSString* identifier = task.identifier;
    //判断是否已经存在进行中池子
      int exist = 0;//1：存在于进行中池子 2：存在于暂停中池子 3：存在于等待中池子
      for (LXHttpTaskModel* one in self.runningTaskPool) {
          if ([identifier isEqualToString:one.identifier]) {
              exist = 1;
              break;
          }
      }
    if (exist == 1) {//进行中任务池中存在
        LXLog(@"警告⚠️: 该任务已经存在于进行中任务池,request==%@", task.dataTask.lx_request());
        if (self.stateCallback) {
            self.stateCallback(@"该任务已经存在于进行中任务池", LXTaskCRUDResultTypeExist, task);
        }
        return;
    }
    
    //判断是否存在于暂停中池子
    for (LXHttpTaskModel* one in self.suspendTaskPool) {
        if ([identifier isEqualToString:one.identifier]) {
          exist = 2;
          break;
        }
    }
    if (exist == 2) {
        LXLog(@"警告⚠️: 该任务已经存在于暂停中任务池,request==%@", task.dataTask.lx_request());
        if (self.stateCallback) {
            self.stateCallback(@"该任务已经存在于暂停中任务池", LXTaskCRUDResultTypeExist, task);
        }
        return;
    }
    
    //判断是否存在于等待中任务池
    for (LXHttpTaskModel* one in self.waitingTaskPool) {
        if ([identifier isEqualToString:one.identifier]) {
          exist = 3;
          break;
        }
    }
    if (exist == 3) {
        LXLog(@"警告⚠️: 该任务已经存在于等待中任务池,request==%@", task.dataTask.lx_request());
        if (self.stateCallback) {
            self.stateCallback(@"该任务已经存在于等待中任务池", LXTaskCRUDResultTypeExist, task);
        }
        return;
    }
    
    if (exist == 0) {
        if (self.runningTaskPool.count >= self.maxRunningTaskCount && self.waitingTaskPool.count >= self.maxWaitingTaskCount) {
            LXLog(@"警告⚠️:所有任务池爆满,请检查进程所有请求状态,request==%@",task.dataTask.lx_request());
            if (self.stateCallback) {
                self.stateCallback(@"所有任务池爆满,请检查会话所有请求状态", LXTaskCRUDResultTypeAddFail, task);
            }
            return;
        }
        if (self.runningTaskPool.count >= self.maxRunningTaskCount && self.waitingTaskPool.count < self.maxWaitingTaskCount) {
            LXLog(@"警告⚠️:进行中任务池爆满,任务存放于等待中任务池,request==%@",task.dataTask.lx_request());
            if (self.stateCallback) {
                self.stateCallback(@"进行中任务池爆满,任务存放于等待中任务池", LXTaskCRUDResultTypeAddSuccess, task);
            }
            [self.waitingTaskPool addObject:task];
            [self p_actionForConfigureTaskCallback:task];
            return;
        }
        if (self.runningTaskPool.count < self.maxRunningTaskCount) {
            LXLog(@"提醒⚠️:任务存放于进行中任务池,request==%@",task.dataTask.lx_request());
            [self p_actionForConfigureTaskCallback:task];
            task.dataTask.lx_resume();
            
            if (self.stateCallback) {
                self.stateCallback(@"任务存放于进行中任务池", LXTaskCRUDResultTypeAddSuccess, task);
            }
            [self.runningTaskPool addObject:task];
        }
    }
}
- (void)p_actionForDeleteTask:(LXHttpTaskModel*)task {
    [self p_actionForDeleteTaskIdentifier:task.identifier];
}
- (void)p_actionForDeleteTaskIdentifier:(NSString*)identifier {
    LXHttpTaskModel* taskModel = nil;
    BOOL success = NO;
    
    for (NSUInteger i=0; i<self.runningTaskPool.count; i++) {
        if ([identifier isEqualToString:self.runningTaskPool[i].identifier]) {
            taskModel = self.runningTaskPool[i];
            self.runningTaskPool[i].dataTask.lx_cancel();
            [self.runningTaskPool removeObjectAtIndex:i];
            success = YES;
            break;
        }
    }
    if (success) {
        LXLog(@"提醒⚠️:进行中任务删除成功,task identifier==%@",identifier);
        if (self.stateCallback) {
            self.stateCallback(@"进行中任务删除成功", LXTaskCRUDResultTypeDeleteSuccess, taskModel);
        }
        return;
    }
    
    for (NSUInteger i=0; i<self.waitingTaskPool.count; i++) {
        if ([identifier isEqualToString:self.waitingTaskPool[i].identifier]) {
            taskModel = self.waitingTaskPool[i];
            [self.waitingTaskPool removeObjectAtIndex:i];
            success = YES;
            break;
        }
    }
    if (success) {
        LXLog(@"提醒⚠️:等待中任务删除成功,task identifier==%@",identifier);
        if (self.stateCallback) {
            self.stateCallback(@"等待中任务删除成功", LXTaskCRUDResultTypeDeleteSuccess, taskModel);
        }
        return;
    }
    
    for (NSUInteger i=0; i<self.suspendTaskPool.count; i++) {
        if ([identifier isEqualToString:self.suspendTaskPool[i].identifier]) {
            taskModel = self.suspendTaskPool[i];
            self.suspendTaskPool[i].dataTask.lx_cancel();
            [self.suspendTaskPool removeObjectAtIndex:i];
            success = YES;
            break;
        }
    }
    if (success) {
        LXLog(@"提醒⚠️:暂停中任务删除成功,task identifier==%@",identifier);
        if (self.stateCallback) {
            self.stateCallback(@"暂停中任务删除成功", LXTaskCRUDResultTypeDeleteSuccess, taskModel);
        }
    }else {
        LXLog(@"警告⚠️:任务池中不存在该任务,task identifier==%@",identifier);
        if (self.stateCallback) {
            self.stateCallback(@"任务池中不存在该任务", LXTaskCRUDResultTypeNotExist, nil);
        }
    }
}
- (void)p_actionForDeleteAllTasks {
    for (LXHttpTaskModel* one in self.runningTaskPool) {
        one.dataTask.lx_cancel();
    }
    
    for (LXHttpTaskModel* one in self.suspendTaskPool) {
        one.dataTask.lx_cancel();
    }
    
    [self.runningTaskPool removeAllObjects];
    [self.waitingTaskPool removeAllObjects];
    [self.suspendTaskPool removeAllObjects];
    
    if (self.stateCallback) {
        self.stateCallback(@"任务池中所有任务删除成功", LXTaskCRUDResultTypeDeleteSuccess, nil);
    }
}
- (void)p_actionForSuspendTask:(LXHttpTaskModel*)task {
    NSString* identifier = task.identifier;
    [self p_actionForSuspendTaskIdentifier:identifier];
}
- (void)p_actionForSuspendTaskIdentifier:(NSString*)identifier {
    BOOL success = NO;
    LXHttpTaskModel* taskModel = nil;
    
    for (LXHttpTaskModel* one in self.runningTaskPool) {
        if ([one.identifier isEqualToString:identifier]) {
            one.dataTask.lx_suspend();
            taskModel = one;
            [self.suspendTaskPool addObject:one];
            [self.runningTaskPool removeObject:one];
            success = YES;
            break;
        }
    }
    if (success) {
        if (self.stateCallback) {
            self.stateCallback(@"提醒⚠️:进行中任务池暂停此任务成功", LXTaskCRUDResultTypeSuspendSuccess, taskModel);
        }
        return;
    }
    
    for (LXHttpTaskModel* one in self.waitingTaskPool) {
        if ([identifier isEqualToString:one.identifier]) {
            taskModel = one;
            [self.waitingTaskPool removeObject:one];
            [self.suspendTaskPool addObject:one];
            success = YES;
            break;
        }
    }
    if (success) {
        if (self.stateCallback) {
            self.stateCallback(@"提醒⚠️:等待中任务池暂停此任务成功", LXTaskCRUDResultTypeSuspendSuccess, taskModel);
        }
        return;
    }
    
    for (LXHttpTaskModel* one in self.suspendTaskPool) {
        if ([identifier isEqualToString:one.identifier]) {
            taskModel = one;
            success = YES;
            break;
        }
    }
    if (success) {
        if (self.stateCallback) {
            self.stateCallback(@"提醒⚠️:暂停中任务池已存在此任务", LXTaskCRUDResultTypeExist, taskModel);
        }
        return;
    }
    
    if (self.stateCallback) {
        self.stateCallback(@"提醒⚠️:任务池不存在此任务", LXTaskCRUDResultTypeNotExist, nil);
    }
}
- (void)p_actionForResumeTaskIdentifier:(NSString*)identifier {
    BOOL success = NO;
    LXHttpTaskModel* taskModel = nil;
    
    for (LXHttpTaskModel* one in self.runningTaskPool) {
        if ([one.identifier isEqualToString:identifier]) {
            taskModel = one;
            success = YES;
            break;
        }
    }
    if (success) {
        if (self.stateCallback) {
            self.stateCallback(@"提醒⚠️:进行中任务池已存在此任务", LXTaskCRUDResultTypeExist, taskModel);
        }
        return;
    }
    
    for (LXHttpTaskModel* one in self.waitingTaskPool) {
        if ([one.identifier isEqualToString:identifier]) {
            success = YES;
            taskModel = one;
            NSUInteger idx = [self.waitingTaskPool indexOfObject:one];
            [self.waitingTaskPool exchangeObjectAtIndex:0 withObjectAtIndex:idx];
            break;
        }
    }
    if (success) {
        if (self.stateCallback) {
            self.stateCallback(@"提醒⚠️:等待中任务池存在此任务,已处理好", LXTaskCRUDResultTypeResumeSuccess, taskModel);
        }
        return;
    }
    
    NSString* msg = nil;
    LXTaskCRUDResultType resultType = LXTaskCRUDResultTypeResumeFail;
    for (LXHttpTaskModel* one in self.suspendTaskPool) {
        if ([one.identifier isEqualToString:identifier]) {
            success = YES;
            taskModel = one;
            
            if (self.runningTaskPool.count >= self.maxRunningTaskCount && self.waitingTaskPool.count >= self.maxWaitingTaskCount) {
                msg = @"提醒⚠️:所有任务池爆满,请检查进程所有请求状态";
                resultType = LXTaskCRUDResultTypeResumeFail;
            }else if (self.runningTaskPool.count >= self.maxWaitingTaskCount && self.waitingTaskPool.count < self.maxWaitingTaskCount) {
                msg = @"提醒⚠️:等待中任务池添加此任务成功";
                resultType = LXTaskCRUDResultTypeSuccess;
                [self.waitingTaskPool addObject:one];
                [self.suspendTaskPool removeObject:one];
            }else if (self.runningTaskPool.count < self.maxRunningTaskCount) {
                msg = @"提醒⚠️:进行中任务池添加此任务成功";
                resultType = LXTaskCRUDResultTypeSuccess;
                [self.runningTaskPool addObject:one];
                [self.suspendTaskPool removeObject:one];
                one.dataTask.lx_resume();
            }
            break;
        }
    }
    if (success) {
        if (self.stateCallback) {
            self.stateCallback(msg, resultType, taskModel);
        }
        return;
    }
    
    if (self.stateCallback) {
        self.stateCallback(@"提醒⚠️:任务池不存在此任务", LXTaskCRUDResultTypeNotExist, nil);
    }
}
- (BOOL)p_actionForIsExistTaskIdentifier:(NSString*)identifier {
    
    NSArray<NSString*>* identifiers = [self.runningTaskPool valueForKeyPath:@"identifier"];
    if ([identifiers containsObject:identifier]) {
        return YES;
    }
    
    identifiers = [self.waitingTaskPool valueForKeyPath:@"identifier"];
    if ([identifiers containsObject:identifier]) {
        return YES;
    }
    
    identifiers = [self.suspendTaskPool valueForKeyPath:@"identifier"];
    if ([identifiers containsObject:identifier]) {
        return YES;
    }
    
    return NO;
}
- (void)p_actionForCompletedTask:(LXHttpTaskModel*)task response:(NSURLResponse*)response responseObject:(id)responseObj error:(NSError*)error {
    LXHttpTaskModel* _task = task;
    [self.runningTaskPool removeObject:_task];
    if (self.waitingTaskPool && self.waitingTaskPool.count) {
        self.waitingTaskPool.firstObject.dataTask.lx_resume();
        [self.runningTaskPool addObject:self.waitingTaskPool.firstObject];
        [self.waitingTaskPool removeObjectAtIndex:0];
    }
    
    if (self.completedCallback) {
        self.completedCallback(_task, response, responseObj, error);
    }
}
- (void)p_actionForUploadProgressTask:(LXHttpTaskModel*)task progress:(NSProgress*)uploadProgress {
    if (self.uploadProgressCallback) {
        self.uploadProgressCallback(task, uploadProgress);
    }
}
- (void)p_actionForDownloadProgressTask:(LXHttpTaskModel*)task progress:(NSProgress*)downloadProgress {
    if (self.downloadProgressCallback) {
        self.downloadProgressCallback(task, downloadProgress);
    }
}
- (void)p_actionForConfigureTaskCallback:(LXHttpTaskModel*)task {
    kLXWeakSelf;
    task.dataTask.lx_resCallback(^(NSURLResponse* _Nonnull response, id _Nullable responseObject, NSError* _Nullable error) {
        [weakSelf p_actionForCompletedTask:task response:response responseObject:responseObject error:error];
    })
    .lx_uploadProgressCallback(^ (NSProgress* uploadProgress) {
        [weakSelf p_actionForUploadProgressTask:task progress:uploadProgress];
    })
    .lx_downloadProgressCallback(^ (NSProgress* downloadProgress){
        [weakSelf p_actionForDownloadProgressTask:task progress:downloadProgress];
    });
}

#pragma mark --- 任务池状态
- (BOOL (^)(LXHttpTaskModel* _Nonnull task))lx_taskExist {
    return ^(LXHttpTaskModel* _Nonnull task) {
        return [self p_actionForIsExistTaskIdentifier:task.identifier];
    };
}
- (BOOL (^)(NSString* _Nonnull taskIdentifier))lx_identifierTaskExist {
    return ^(NSString* _Nonnull taskIdentifier) {
        return [self p_actionForIsExistTaskIdentifier:taskIdentifier];
    };
}

#pragma mark --- 任务池任务状态回调
- (LXHttpTaskPool * _Nonnull (^)(LXPoolTaskCRUDStateCallback _Nullable stateCallback))lx_taskPoolActionCallback {
    return ^(LXPoolTaskCRUDStateCallback _Nullable stateCallback) {
        self.stateCallback = stateCallback;
        return self;
    };
}
- (LXHttpTaskPool* (^)(LXPoolTaskCompletedCallback _Nullable completedCallback))lx_taskCompletedCallBack {
    return ^(LXPoolTaskCompletedCallback _Nullable completedCallback) {
        self.completedCallback = completedCallback;
        return self;
    };
}
- (LXHttpTaskPool* (^)(LXPoolTaskUploadProgressCallback _Nullable uploadProgress))lx_taskUploadProgressCallback {
    return ^(LXPoolTaskUploadProgressCallback _Nullable uploadProgress) {
        self.uploadProgressCallback = uploadProgress;
        return self;
    };
}
- (LXHttpTaskPool* (^)(LXPoolTaskDownloadProgressCallback _Nullable downloadProgress))lx_taskDownloadProgressCallback {
    return ^(LXPoolTaskDownloadProgressCallback _Nullable downloadProgress) {
        self.downloadProgressCallback = downloadProgress;
        return self;
    };
}

- (void)dealloc {
    LXLog(@"dealloc --- %@", NSStringFromClass(self.class));
}

@end
