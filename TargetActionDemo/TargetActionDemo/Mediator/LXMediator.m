//
//  LXMediator.m
//  test
//
//  Created by 天边的星星 on 2019/4/30.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXMediator.h"

@interface LXMediator ()

@property (nonatomic, strong) NSCache* cachedTarget;

@end

@implementation LXMediator

static LXMediator* instance = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}
+ (instancetype)sharedMediator {
    return [[self alloc] init];
}
- (id)copyWithZone:(NSZone *)zone {
    return instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return instance;
}

#pragma mark --- actions
- (id)performTarget:(NSString*)targetName action:(NSString*)actionName cacheTarget:(BOOL)cacheTarget para:(id)obj {
    if (obj) {
        return [self performTarget:targetName action:actionName cacheTarget:cacheTarget paraArray:@[obj]];
    }else {
        return [self performTarget:targetName action:actionName cacheTarget:cacheTarget paraArray:nil];
    }
}
- (id)performTarget:(NSString*)targetName action:(NSString*)actionName cacheTarget:(BOOL)cacheTarget paraObjects:(id)object,... {
    
    //解析参数
    NSMutableArray* arrM = NSMutableArray.array;
    id next;
    va_list list;
    if (object) {
        [arrM addObject:object];
        va_start(list, object);
        while ((next = va_arg(list, id))) {
            [arrM addObject:next];
        };
        va_end(list);
    }
    
    return [self performTarget:targetName action:actionName cacheTarget:cacheTarget paraArray:arrM.copy];
}
- (id)performTarget:(NSString*)targetName action:(NSString*)actionName cacheTarget:(BOOL)cacheTarget paraArray:(NSArray*)paraArr {
    
    NSString* targetNameClass = [NSString stringWithFormat:@"Target_%@", targetName];
    NSObject* target = [self.cachedTarget objectForKey:targetNameClass];
    Class targetCls;
    if (target == nil) {
        targetCls = NSClassFromString(targetNameClass);
        if (targetCls == nil) {//不存在此类型
            NSAssert(targetCls, @"target-action机制错误： %@类型不存在", targetNameClass);
            return nil;
        }else {
            target = [[targetCls alloc] init];
        }
    }
    
    if (cacheTarget) {
        [self.cachedTarget setObject:target forKey:targetNameClass];
    }
    
    NSString* actionFullName = [NSString stringWithFormat:@"Action_%@", actionName];
    SEL sel = NSSelectorFromString(actionFullName);
    if ([target respondsToSelector:sel]) {//有方法执行
        return [LXMediator p_safePerformAction:sel target:target params:paraArr];
    }else {//找不到方法，那么去找对于target的Action_NotFound方法统一处理
        [self.cachedTarget removeObjectForKey:targetNameClass];
        sel = NSSelectorFromString(@"Action_NotFound");
        
        if ([target respondsToSelector:sel]) {
            return [LXMediator p_safePerformAction:sel target:target params:nil];
        }else {
            NSAssert(false, @"target-action机制错误： Action_NotFound方法不存在");
            return nil;
        }
    }
}
/*
 url规则为：scheme://[target]/[action]?[params]
 url sample:
 bbb://targetA/actionB?id=@"122"
 */
- (void)performActionWithUrl:(NSURL*)url completion:(void (^)(id object, BOOL success))completion {
    [LXMediator performActionWithUrl:url completion:completion];
}
+ (void)performActionWithUrl:(NSURL*)url completion:(void (^)(id object, BOOL success))completion {
    
    NSMutableArray* paras = NSMutableArray.array;
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *element = [param componentsSeparatedByString:@"="];
        if (element.count < 2) {
            continue;
        }
        [paras addObject:element.lastObject];
    }

    // 安全考虑，防止黑客通过远程方式调用本地模块。后期可根据需要加入更加复杂的安全逻辑
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        if (completion) {
            completion(nil, NO);
        }
        return;
    }
    
    id result = [self performTarget:url.host action:actionName paraArray:paras.copy];
    if (completion) {
        if (result) {
            completion(result, YES);
        }else {
            completion(nil, NO);
        }
    }
}
+ (id)p_safePerformAction:(SEL)action target:(NSObject*)target params:(NSArray*)params {
    
    NSMethodSignature* sig = [target methodSignatureForSelector:action];
    if (sig == nil) {//找不到方法
        NSAssert(false, @"target-action机制错误： %@对象的方法%@不存在",NSStringFromClass(target.class), NSStringFromSelector(action));
        return nil;
    }

    const char* returnType = [sig methodReturnType];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
    invocation.target = target;
    invocation.selector = action;
    
    //校正参数匹配性,DEBUG熔断处理
    NSUInteger paramsCount = sig.numberOfArguments;
    NSAssert(paramsCount >= params.count+2, @"方法名：%@和传输参数不匹配",NSStringFromSelector(action));
    
    if (paramsCount > 2) {
        //参数传递
        [params enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (paramsCount <= idx+2) {//Release截流处理
                *stop = YES;
            }
            //参数校验处理
            const char* argumentType = [sig getArgumentTypeAtIndex:idx+2];
            if (strcmp(argumentType, @encode(id)) == 0) {
                [invocation setArgument:&obj atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(NSInteger)) == 0) {
                NSInteger result = [obj integerValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(CGFloat)) == 0) {
                CGFloat result = [obj doubleValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(NSUInteger)) == 0) {
                NSUInteger result = [obj unsignedIntegerValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(BOOL)) == 0) {
                NSUInteger result = [obj boolValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(float)) == 0) {
                float result = [obj floatValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(int)) == 0) {
                int result = [obj intValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(short)) == 0) {
                short result = [obj shortValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(long)) == 0) {
                long result = [obj longValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(unsigned int)) == 0) {
                unsigned int result = [obj unsignedIntValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(unsigned short)) == 0) {
                unsigned short result = [obj unsignedShortValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(unsigned long)) == 0) {
                unsigned long result = [obj unsignedLongValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(unsigned long long)) == 0) {
                unsigned long long result = [obj unsignedLongLongValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(char)) == 0) {
                char result = [obj charValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else if (strcmp(argumentType, @encode(unsigned char)) == 0) {
                unsigned char result = [obj unsignedCharValue];
                [invocation setArgument:&result atIndex:idx+2];
            }else {
                [invocation setArgument:&obj atIndex:idx+2];
            }
        }];
    }
    [invocation invokeWithTarget:target];
    
    //返回类型判断
    if (strcmp(returnType, @encode(void)) == 0) {
        return nil;
    }else if (strcmp(returnType, @encode(id)) == 0) {
        __unsafe_unretained id returnValue = nil;
        [invocation getReturnValue:&returnValue];
        return returnValue;
    }else if (strcmp(returnType, @encode(NSInteger)) == 0) {
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(BOOL)) == 0) {
        BOOL result = false;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(NSUInteger)) == 0) {
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(CGFloat)) == 0) {
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(BOOL)) == 0) {
        BOOL result = false;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(float)) == 0) {
        float result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(double)) == 0) {
        double result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(int)) == 0) {
        int result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(short)) == 0) {
        short result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(long)) == 0) {
        long result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(unsigned int)) == 0) {
        unsigned int result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(unsigned short)) == 0) {
        unsigned short result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(unsigned long)) == 0) {
        unsigned long result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(unsigned long long)) == 0) {
        unsigned long long result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(char)) == 0) {
        char result;
        [invocation getReturnValue:&result];
        return @(result);
    }else if (strcmp(returnType, @encode(unsigned char)) == 0) {
        unsigned char result;
        [invocation getReturnValue:&result];
        return @(result);
    }else {
        return nil;
    }
}
+ (id)performTarget:(NSString*)targetName action:(NSString*)actionName para:(id)obj {
    return [self performTarget:targetName action:actionName paraArray:@[obj]];
}
+ (id)performTarget:(NSString*)targetName action:(NSString*)actionName paraObjects:(id)object,... {
    //解析参数
    NSMutableArray* arrM = NSMutableArray.array;
    id next;
    va_list list;
    if (object) {
        [arrM addObject:object];
        va_start(list, object);
        while ((next = va_arg(list, id))) {
            [arrM addObject:next];
        };
        va_end(list);
    }
    return [self performTarget:targetName action:actionName paraArray:arrM.copy];
}
+ (id)performTarget:(NSString*)targetName action:(NSString*)actionName paraArray:(NSArray*)paraArr {
    
    NSString* targetNameClass = [NSString stringWithFormat:@"Target_%@", targetName];
    Class targetCls = NSClassFromString(targetNameClass);
    if (targetCls == nil) {//不存在此类型
        NSAssert(targetCls, @"target-action机制错误： %@类型不存在", targetNameClass);
        return nil;
    }
    NSString* actionFullName = [NSString stringWithFormat:@"Action_%@", actionName];
    SEL sel = NSSelectorFromString(actionFullName);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    if ([targetCls respondsToSelector:sel]) {//有方法执行
        return [LXMediator p_safePerformAction:sel target:targetCls params:paraArr];
    }else {//找不到方法，那么去找对于target的Action_NotFound方法统一处理
        sel = NSSelectorFromString(@"Action_NotFound");
        
        if ([targetCls respondsToSelector:sel]) {
            return [LXMediator p_safePerformAction:sel target:targetCls params:nil];
        }else {
            NSAssert(false, @"target-action机制错误： Action_NotFound方法不存在");
            return nil;
        }
    }
#pragma clang diagnostic pop
}

- (void)releaseCachedTargetWithTargetName:(NSString*)targetName {
    NSString* targetClsName = [NSString stringWithFormat:@"Target_%@", targetName];
    [self.cachedTarget removeObjectForKey:targetClsName];
}

#pragma mark --- lazy
- (NSCache *)cachedTarget {
    if (!_cachedTarget) {
        _cachedTarget = NSCache.alloc.init;
        _cachedTarget.totalCostLimit = 1024;
    }
    return _cachedTarget;
}
- (void)dealloc {
    NSLog(@"dealloc --- %@", NSStringFromClass(self.class));
}

@end
