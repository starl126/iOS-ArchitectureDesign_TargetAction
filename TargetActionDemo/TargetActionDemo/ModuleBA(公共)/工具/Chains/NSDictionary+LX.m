//
//  NSDictionary+LX.m
//  test
//
//  Created by 刘欣 on 2019/5/1.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "NSDictionary+LX.h"

@implementation NSDictionary (chain)

- (id (^)(NSString*))lx_objectForKey {
    return ^(NSString* value) {
        return [self objectForKey:value];
    };
}
- (NSDictionary* (^)(NSArray*, NSArray<id<NSCopying>>*))lx_initWithObjectsForKeys {
    return ^(NSArray* objects, NSArray<id<NSCopying>>* keys) {
        return [self initWithObjects:objects forKeys:keys];
    };
}
- (NSDictionary* (^)(const id _Nonnull [_Nullable], const id<NSCopying> _Nonnull  [_Nullable], NSUInteger))lx_initWithObjectsForKeysCount {
    return ^(const id _Nonnull objs[_Nullable], const id<NSCopying> _Nonnull  keys[_Nullable] , NSUInteger count) {
        NSDictionary* dict = nil;
        @try {
            dict = [self initWithObjects:objs forKeys:keys count:count];
        } @catch (NSException *exception) {
            NSLog(@"初始化字典错误,SEL=%@，reason = %@", @"lx_initWithObjectsForKeysCount",exception.reason);
        } @finally {
            return dict;
        }
    };
}
- (BOOL (^)(NSDictionary*))lx_isEqualToDictionary {
    return ^(NSDictionary* value) {
        return [self isEqualToDictionary:value];
    };
}
- (BOOL (^)(NSURL*, NSError**))lx_writeToURLError API_AVAILABLE(ios(11_0)) {
    return ^(NSURL* value, NSError** error) {
        return [self writeToURL:value error:error];
    };
}
- (NSEnumerator* (^)(void))lx_keyEnumerator {
    return ^() {
        return [self keyEnumerator];
    };
}
- (NSEnumerator* (^)(void))lx_objectEnumerator {
    return ^() {
        return [self objectEnumerator];
    };
}
- (NSArray* (^)(NSArray*, id))lx_objectsForKeysNotFoundMarker {
    return ^(NSArray* arr, id obj) {
        return [self objectsForKeys:arr notFoundMarker:obj];
    };
}
- (NSArray* (^)(SEL))lx_keysSortedByValueUsingSelector {
    return ^(SEL sel) {
        return [self keysSortedByValueUsingSelector:sel];
    };
}
- (NSDictionary* (^)(id _Nonnull __unsafe_unretained [_Nullable], id _Nonnull __unsafe_unretained [_Nullable], NSUInteger))lx_getObjectsAndKeysCount {
    return ^(id _Nonnull __unsafe_unretained objects[_Nullable], id _Nonnull __unsafe_unretained keys[_Nullable], NSUInteger count) {
        @try {
            [self getObjects:objects andKeys:keys count:count];
        } @catch (NSException *exception) {
            NSLog(@"获取字典的values和keys错误, reason=%@", exception.reason);
        } @finally {
            
        }
        return self;
    };
}
- (NSDictionary* (^)(void (NS_NOESCAPE ^)(id, id, BOOL*)))lx_enumerateKeysAndObjectsUsingBlock {
    return ^(void (NS_NOESCAPE ^value)(id, id, BOOL*)) {
        [self enumerateKeysAndObjectsUsingBlock:value];
        return self;
    };
}
- (NSDictionary* (^)(NSEnumerationOptions, void (NS_NOESCAPE ^)(id, id, BOOL*)))enumerateKeysAndObjectsWithOptionsUsingBlock {
    return ^(NSEnumerationOptions opt, void (NS_NOESCAPE ^block)(id, id, BOOL*)) {
        [self enumerateKeysAndObjectsWithOptions:opt usingBlock:block];
        return self;
    };
}

- (NSArray* (^)(id))lx_allKeysForObject {
    return ^(id object) {
        return [self allKeysForObject:object];
    };
}
- (NSArray* (^)(NSComparator NS_NOESCAPE))lx_keysSortedByValueUsingComparator {
    return ^(NSComparator com) {
        return [self keysSortedByValueUsingComparator:com];
    };
}
- (NSArray* (^)(NSSortOptions, NSComparator NS_NOESCAPE))lx_keysSortedByValueWithOptionsUsingComparator {
    return ^(NSSortOptions opt, NSComparator com) {
        return [self keysSortedByValueWithOptions:opt usingComparator:com];
    };
}
- (NSSet* (^)(BOOL (NS_NOESCAPE ^)(id, id, BOOL*)))lx_keysOfEntriesPassingTestPredicate {
    return ^(BOOL (NS_NOESCAPE ^block)(id, id, BOOL*)) {
        return [self keysOfEntriesPassingTest:block];
    };
}
- (NSSet* (^)(NSEnumerationOptions, BOOL (NS_NOESCAPE ^)(id, id, BOOL*)))lx_keysOfEntriesWithOptionsPassingTest {
    return ^(NSEnumerationOptions opt, BOOL (NS_NOESCAPE ^block)(id, id, BOOL*)) {
        return [self keysOfEntriesWithOptions:opt passingTest:block];
    };
}
+ (NSDictionary* (^)(id, id<NSCopying>))lx_dictionaryWithObjectAndKey {
    return ^(id obj, id<NSCopying> key) {
        return [self dictionaryWithObject:obj forKey:key];
    };
}
+ (NSDictionary* (^)(id,...))lx_dictionaryWithObjectsAndKeys {
    return ^(id obj, ...) {
        NSMutableDictionary* dictM = NSMutableDictionary.dictionary;
        va_list list;
        
        if (obj) {
            va_start(list, obj);
            id value = obj;
            id key;
            id next;
            int i=0;
            while ((next = va_arg(list, id))) {
                if (i%2==0) {//key
                    key = next;
                }else {//value
                    value = next;
                }
                if (key && value) {
                    [dictM setObject:value forKey:key];
                    value = nil;
                    key = nil;
                }
                i++;
            }
        }
        va_end(list);
        return dictM.copy;
    };
}
+ (NSDictionary* (^)(NSDictionary*))lx_dictionaryWithDictionary {
    return ^(NSDictionary* value) {
        return [self dictionaryWithDictionary:value];
    };
}
+ (NSDictionary* (^)(NSArray*, NSArray<id<NSCopying>>*))lx_dictionaryWithObjectsForKeys {
    return ^(NSArray* objects, NSArray<id<NSCopying>>* keys) {
        return [self dictionaryWithObject:objects forKey:keys];
    };
}
- (NSDictionary* (^)(id, ...))lx_initWithObjectsAndKeys {
    return ^(id obj, ...) {
        NSMutableDictionary* dictM = NSMutableDictionary.dictionary;
        va_list list;
        
        if (obj) {
            va_start(list, obj);
            id value = obj;
            id key;
            id next;
            int i=0;
            while ((next = va_arg(list, id))) {
                if (i%2==0) {//key
                    key = next;
                }else {//value
                    value = next;
                }
                if (key && value) {
                    [dictM setObject:value forKey:key];
                    value = nil;
                    key = nil;
                }
                i++;
            }
        }
        va_end(list);
        return dictM.copy;
    };
}
- (NSDictionary* (^)(NSDictionary*))lx_initWithDictionary {
    return ^(NSDictionary* value) {
        return [self initWithDictionary:value];
    };
}
- (NSDictionary* (^)(NSDictionary*, BOOL))lx_initWithDictionaryCopyItems {
    return ^(NSDictionary* value, BOOL copy) {
        return [self initWithDictionary:value copyItems:copy];
    };
}
- (NSDictionary* (^)(NSURL*, NSError**))lx_initWithContentsOfURLError API_AVAILABLE(ios(11_0)) {
    return ^(NSURL* url, NSError** error) {
        return [self initWithContentsOfURL:url error:error];
    };
}
+ (NSDictionary* (^)(NSURL*, NSError**))lx_dictionaryWithContentsOfURLError NS_AVAILABLE_IOS(11_0) {
    return ^(NSURL* url, NSError** error) {
        return [self dictionaryWithContentsOfURL:url error:error];
    };
}

#pragma mark --- 重定义打印信息
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString* strM = NSMutableString.alloc.init;
    [self p_actionForObject:self result:strM level:0 isInDict:NO];
    return strM.copy;
}

/**
 递归输出一个对象，针对对象内部的对象层层递归,按照输出格式呈树形打印

 @param obj 被打印的对象
 @param strM 打印的最终字符串
 @param level 当前对象的层级，顶层是0，层级往下递增
 @param isInDict 是否是字典里的key和value，如果不是，则没必要拼接换行符；是，则需要拼接换行符
 */
- (void)p_actionForObject:(id)obj result:(NSMutableString*)strM level:(NSUInteger)level isInDict:(BOOL)isInDict {
    
    __block NSUInteger count = level;
    NSMutableString* spaceStr = [[NSMutableString alloc] init];
    for (int i=0; i<count; i++) {
        [spaceStr appendString:@"\t"];
    }
    
    if ([obj isKindOfClass:NSDictionary.class]) {//字典
        if (isInDict) {
            [strM appendString:@"{\n"];
        }else {
            [strM appendFormat:@"%@{\n", spaceStr];
        }
        
        NSDictionary* dict = (NSDictionary*)obj;
        count++;
        [dict enumerateKeysAndObjectsUsingBlock:^(id _Nonnull nextkey, id  _Nonnull nextobj, BOOL * _Nonnull stop) {
            
            [strM appendFormat:@"%@%@: ", spaceStr, nextkey];
            
            if ([nextobj isKindOfClass:NSDictionary.class] ||
                [nextobj isKindOfClass:NSArray.class]) {//字典或者数组
                [self p_actionForObject:nextobj result:strM level:count isInDict:YES];
            }else if ([nextobj isKindOfClass:NSNull.class]) {//空对象
                [strM appendString:@"(null)\n"];
            }else {//其他
                [strM appendFormat:@"%@\n", nextobj];
            }
        }];

        [strM appendFormat:@"%@}\n", spaceStr];
    }else if ([obj isKindOfClass:NSArray.class]) {//数组

        [strM appendString:@"[\n"];
        NSArray* arr = (NSArray*)obj;
        
        count++;
        [arr enumerateObjectsUsingBlock:^(id _Nonnull nextobj, NSUInteger idx, BOOL * _Nonnull stop) {
  
            if ([nextobj isKindOfClass:NSDictionary.class] ||
                [nextobj isKindOfClass:NSArray.class]) {//字典或者数组
                [self p_actionForObject:nextobj result:strM level:count isInDict:NO];
            }else if ([nextobj isKindOfClass:NSNull.class]) {//空对象
                [strM appendFormat:@"%@(null)\n", spaceStr];
            }else {//其他
                [strM appendFormat:@"%@%@\n", spaceStr, nextobj];
            }
        }];
        [strM appendFormat:@"%@]\n", spaceStr];
    }else if ([obj isKindOfClass:NSNull.class]) {
        [strM appendFormat:@"%@(null)\n", spaceStr];
    }else {
        [strM appendFormat:@"%@%@\n", spaceStr, obj];
    }
}

@end

@implementation NSMutableDictionary (chain)

- (NSMutableDictionary* (^)(id))lx_removeObjectForKey {
    return ^(id<NSCopying> value) {
        [self removeObjectForKey:value];
        return self;
    };
}
- (NSMutableDictionary* (^)(id, id<NSCopying>))lx_setObjectForKey {
    return ^(id obj, id key) {
        [self setObject:obj forKey:key];
        return self;
    };
}
- (NSMutableDictionary* (^)(NSUInteger))lx_initWithCapacity {
    return ^(NSUInteger value) {
        return [self initWithCapacity:value];
    };
}
- (NSMutableDictionary* (^)(NSDictionary*))lx_addEntriesFromDictionary {
    return ^(NSDictionary* value) {
        [self addEntriesFromDictionary:value];
        return self;
    };
}
- (NSMutableDictionary* (^)(void))lx_removeAllObjects {
    return ^ {
        [self removeAllObjects];
        return self;
    };
}
- (NSMutableDictionary* (^)(NSArray<id<NSCopying>>*))lx_removeObjectsForKeys {
    return ^(NSArray<id<NSCopying>>* arr) {
        [self removeObjectsForKeys:arr];
        return self;
    };
}
- (NSMutableDictionary* (^)(NSDictionary*))lx_setDictionary {
    return ^(NSDictionary* value) {
        [self setDictionary:value];
        return self;
    };
}
- (NSMutableDictionary* (^)(id, id<NSCopying>))lx_setObjectForKeyedSubscript {
    return ^(id obj, id<NSCopying> key) {
        [self setObject:obj forKeyedSubscript:key];
        return self;
    };
}
+ (NSMutableDictionary* (^)(NSUInteger))lx_dictionaryWithCapacity {
    return ^(NSUInteger value) {
        return [self dictionaryWithCapacity:value];
    };
}
+ (NSMutableDictionary* (^)(NSString*))lx_dictionaryWithContentsOfFile {
    return ^(NSString* path) {
        return [self dictionaryWithContentsOfFile:path];
    };
}
+ (NSMutableDictionary* (^)(NSURL*))lx_dictionaryWithContentsOfURL {
    return ^(NSURL* url) {
        return [self dictionaryWithContentsOfURL:url];
    };
}
- (NSMutableDictionary* (^)(NSString*))lx_initWithContentsOfFile {
    return ^(NSString* path) {
        return [self initWithContentsOfFile:path];
    };
}
- (NSMutableDictionary* (^)(NSURL*))lx_initWithContentsOfURL {
    return ^(NSURL* url) {
        return [self initWithContentsOfURL:url];
    };
}

@end
