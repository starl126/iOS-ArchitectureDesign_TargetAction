//
//  LXMediator.h
//  test
//
//  Created by 刘欣 on 2019/4/30.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXMediator : NSObject<NSCopying, NSMutableCopying>

+ (instancetype)sharedMediator;

#pragma mark --- instance method

/**
 执行方法，需要传入对象名称和方法名称，必传参数

 @param targetName 执行方法的对象名称，具体规则可自己指定
 @param actionName 方法名称
 @param object 参数，必须是id类型，非oc对象请使用封包
 @return 返回target-action机制运行返回的对象，可根据实际情况处理
 */
- (id)performTarget:(NSString*)targetName action:(NSString*)actionName cacheTarget:(BOOL)cacheTarget paraObjects:(id _Nullable)object,...;
- (id)performTarget:(NSString*)targetName action:(NSString*)actionName cacheTarget:(BOOL)cacheTarget paraArray:(NSArray* _Nullable)paraArr;
- (id)performTarget:(NSString*)targetName action:(NSString*)actionName cacheTarget:(BOOL)cacheTarget para:(id _Nullable)obj;

/**
 App外调用入口
 
 @param url url scheme
 @param completion 回调数据 object返回的对象，success是否调用成功
 */
- (void)performActionWithUrl:(NSURL*)url completion:(void (^)(id object, BOOL success))completion;

#pragma mark --- class method
+ (id)performTarget:(NSString*)targetName action:(NSString*)actionName paraObjects:(id _Nullable)object,...;
+ (id)performTarget:(NSString*)targetName action:(NSString*)actionName paraArray:(NSArray* _Nullable)paraArr;
+ (id)performTarget:(NSString*)targetName action:(NSString*)actionName para:(id _Nullable)obj;
+ (void)performActionWithUrl:(NSURL *)url completion:(void (^)(id object, BOOL success))completion;

#pragma mark --- 缓存清理
- (void)releaseCachedTargetWithTargetName:(NSString*)targetName;

@end

NS_ASSUME_NONNULL_END
