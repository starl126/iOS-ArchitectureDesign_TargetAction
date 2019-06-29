//
//  NSArray+LX.m
//  test
//
//  Created by 刘欣 on 2019/5/5.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "NSArray+LX.h"

@implementation NSArray (LX)

- (NSArray* (^)(const id _Nonnull [_Nullable], NSUInteger))lx_initWithObjectsAndCount {
    return ^(const id _Nonnull objs[_Nullable] , NSUInteger count) {
        return [self initWithObjects:objs count:count];
    };
}
- (NSArray* (^)(id))lx_arrayByAddingObject {
    return ^(id obj) {
        NSArray* newArr = nil;
        @try {
            newArr = [self arrayByAddingObject:obj];
        } @catch (NSException *exception) {
            NSLog(@"创建新的数组错误，错误信息为加入了空的对象到数组里面");
        } @finally {
            return newArr;
        }
    };
}
- (NSArray* (^)(NSArray*))lx_arrayByAddingObjectsFromArray {
    return ^(NSArray* arr) {
        return [self arrayByAddingObjectsFromArray:arr];
    };
}
- (NSArray* (^)(id _Nonnull __unsafe_unretained [_Nonnull], NSRange))lx_getObjectsInRange {
    return ^(id _Nonnull __unsafe_unretained objs[_Nonnull], NSRange range) {
        @try {
            [self getObjects:objs range:range];
        } @catch (NSException *exception) {
            NSLog(@"获取指定range的数组错误，抛出异常=%@", exception.name);
        } @finally {
            return self;
        }
    };
}
- (NSArray* (^)(NSInteger (NS_NOESCAPE*)(id, id, void* _Nullable), void* _Nullable))lx_sortedArrayUsingFunctionAndContext {
    return ^(NSInteger (NS_NOESCAPE* func)(id, id, void* _Nullable), void* _Nullable context) {
        return [self sortedArrayUsingFunction:func context:context];
    };
}
- (NSArray* (^)(NSInteger (NS_NOESCAPE*)(id, id, void* _Nullable), void* _Nullable, NSData* _Nullable))lx_sortedArrayUsingFunctionContextHint {
    return ^(NSInteger (NS_NOESCAPE* func)(id, id, void* _Nullable), void* _Nullable context, NSData* _Nullable hint) {
        return [self sortedArrayUsingFunction:func context:context hint:hint];
    };
}
- (NSArray* (^)(NSRange))lx_subarrayWithRange {
    return ^(NSRange r) {
        return [self subarrayWithRange:r];
    };
}
- (NSArray* (^)(NSURL*, NSError**))lx_writeToURLError {
    return ^(NSURL* url, NSError** err) {
        [self writeToURL:url error:err];
        return self;
    };
}
- (NSArray* (^)(SEL))lx_makeObjectsPerformSelector {
    return ^(SEL sel) {
        [self makeObjectsPerformSelector:sel];
        return self;
    };
}
- (NSArray* (^)(SEL,id _Nullable))lx_makeObjectsPerformSelectorWithObject {
    return ^(SEL sel,id _Nullable obj) {
        [self makeObjectsPerformSelector:sel withObject:obj];
        return self;
    };
}
- (NSArray* (^)(NSIndexSet*))lx_objectsAtIndexes {
    return ^(NSIndexSet* set) {
        return [self objectsAtIndexes:set];
    };
}
- (NSArray* (^)(void (NS_NOESCAPE^)(id, NSUInteger, BOOL*)))lx_enumerateObjectsUsingBlock {
    return ^(void (NS_NOESCAPE^ block)(id, NSUInteger, BOOL*)) {
        [self enumerateObjectsUsingBlock:block];
        return self;
    };
}
- (NSArray* (^)(NSEnumerationOptions, void (NS_NOESCAPE^)(id, NSUInteger, BOOL*)))lx_enumerateObjectsWithOptionsUsingBlock {
    return ^(NSEnumerationOptions opt, void (NS_NOESCAPE^ block)(id, NSUInteger, BOOL*)) {
        [self enumerateObjectsWithOptions:opt usingBlock:block];
        return self;
    };
}
- (NSArray* (^)(NSComparator))lx_sortedArrayUsingComparator {
    return ^(NSComparator comp) {
        [self sortedArrayUsingComparator:comp];
        return self;
    };
}
- (NSArray* (^)(NSSortOptions, NSComparator))lx_sortedArrayWithOptionsUsingComparator {
    return ^(NSSortOptions opt, NSComparator comp) {
        [self sortedArrayWithOptions:opt usingComparator:comp];
        return self;
    };
}
- (NSArray* (^)(NSIndexSet*, NSEnumerationOptions, void (NS_NOESCAPE^)(id, NSUInteger, BOOL*)))lx_enumerateObjectsAtIndexesOptionsUsingBlock {
    return ^(NSIndexSet* set, NSEnumerationOptions opt, void (NS_NOESCAPE^ block)(id, NSUInteger, BOOL*)) {
        [self enumerateObjectsAtIndexes:set options:opt usingBlock:block];
        return self;
    };
}
+ (NSArray* (^)(void))lx_array {
    return ^ {
        return [self array];
    };
}
+ (NSArray* (^)(id))lx_arrayWithObject {
    return ^(id obj) {
        return [self arrayWithObject:obj];
    };
}
+ (NSArray* (^)(const id _Nonnull [_Nonnull], NSUInteger))lx_arrayWithObjectsCount {
    return ^(const id _Nonnull objs[_Nonnull], NSUInteger count) {
        return [self arrayWithObjects:objs count:count];
    };
}
+ (NSArray* (^)(id, ...))lx_arrayWithObjects {
    return ^(id first, ...) {
        NSMutableArray* arrM = [NSMutableArray arrayWithObject:first];
        va_list list;
        va_start(list, first);
        id obj;
        while ((obj = va_arg(list, id))) {
            [arrM addObject:obj];
        }
        va_end(list);
        return arrM.copy;
    };
}
+ (NSArray* (^)(NSArray*))lx_arrayWithArray {
    return ^(NSArray* arr) {
        return [self arrayWithArray:arr];
    };
}
- (NSArray* (^)(id, ...))lx_initWithObjects {
    return ^(id first, ...) {
        NSMutableArray* arrM = [NSMutableArray arrayWithObject:first];
        va_list list;
        va_start(list, first);
        id next;
        while ((next = va_arg(list, id))) {
            [arrM addObject:next];
        }
        return arrM.copy;
    };
}
- (NSArray* (^)(NSArray*))lx_initWithArray {
    return ^(NSArray* arr) {
        return [self initWithArray:arr];
    };
}
- (NSArray* (^)(NSArray*, BOOL))lx_initWithArrayCopyItems {
    return ^(NSArray* arr, BOOL copyItem) {
        return [self initWithArray:arr copyItems:copyItem];
    };
}
- (NSArray* (^)(NSURL*, NSError**))lx_initWithContentsOfURLError {
    return ^(NSURL* url, NSError** error) {
       return [self initWithContentsOfURL:url error:error];
    };
}
+ (NSArray* (^)(NSURL*, NSError**))lx_arrayWithContentsOfURLError {
    return ^(NSURL* url, NSError** error) {
        return [self arrayWithContentsOfURL:url error:error];
    };
}
- (NSArray* (^)(id _Nullable __unsafe_unretained [_Nonnull]))lx_getObjects {
    return ^(id _Nullable __unsafe_unretained objs[_Nonnull]) {
        [self getObjects:objs];
        return self;
    };
}
+ (NSArray* (^)(NSString*))lx_arrayWithContentsOfFile {
    return ^(NSString* value) {
        return [self arrayWithContentsOfFile:value];
    };
}
+ (NSArray* (^)(NSURL*))lx_arrayWithContentsOfURL {
    return ^(NSURL* value) {
        return [self arrayWithContentsOfURL:value];
    };
}
- (NSArray* (^)(NSString*))lx_initWithContentsOfFile {
    return ^(NSString* value) {
        return [self initWithContentsOfFile:value];
    };
}
- (NSArray* (^)(NSURL*))lx_initWithContentsOfURL {
    return ^(NSURL* value) {
        return [self initWithContentsOfURL:value];
    };
}
- (NSUInteger (^)(void))lx_count {
    return ^ {
        return self.count;
    };
}
- (NSUInteger (^)(id))lx_indexOfObject {
    return ^(id value) {
        return [self indexOfObject:value];
    };
}
- (NSUInteger (^)(id, NSRange))lx_indexOfObjectInRange {
    return ^(id value, NSRange range) {
        return [self indexOfObject:value inRange:range];
    };
}
- (NSUInteger (^)(id))lx_indexOfObjectIdenticalTo {
    return ^(id value) {
        return [self indexOfObjectIdenticalTo:value];
    };
}
- (NSUInteger (^)(id, NSRange))lx_indexOfObjectIdenticalToInRange {
    return ^(id value, NSRange range) {
        return [self indexOfObjectIdenticalTo:value inRange:range];
    };
}
- (NSUInteger (^)(BOOL (NS_NOESCAPE^)(id, NSUInteger, BOOL*)))lx_indexOfObjectPassingTest {
    return ^(BOOL (NS_NOESCAPE^ predicate)(id, NSUInteger, BOOL*)) {
        return [self indexOfObjectPassingTest:predicate];
    };
}
- (NSUInteger (^)(NSEnumerationOptions, BOOL (NS_NOESCAPE^)(id, NSUInteger, BOOL*)))lx_indexOfObjectWithOptionsPassingTest {
    return ^(NSEnumerationOptions opt, BOOL (NS_NOESCAPE^ predicate)(id, NSUInteger, BOOL*)) {
        return [self indexOfObjectWithOptions:opt passingTest:predicate];
    };
}
- (NSUInteger (^)(id, NSRange, NSBinarySearchingOptions, NSComparator))lx_indexOfObjectInSortedRangeOptionsUsingComparator {
    return ^(id obj, NSRange range, NSBinarySearchingOptions opt, NSComparator comp) {
        return [self indexOfObject:obj inSortedRange:range options:opt usingComparator:comp];
    };
}
- (NSUInteger (^)(NSIndexSet*, NSEnumerationOptions, BOOL (NS_NOESCAPE^)(id, NSUInteger, BOOL*)))lx_indexOfObjectAtIndexesOptionsPassingTest {
    return ^(NSIndexSet* set, NSEnumerationOptions opt, BOOL (NS_NOESCAPE^ predicate)(id, NSUInteger, BOOL*)) {
        return [self indexOfObjectAtIndexes:set options:opt passingTest:predicate];
    };
}
- (BOOL (^)(id))lx_containsObject {
    return ^(id obj) {
        return [self containsObject:obj];
    };
}
- (BOOL (^)(NSArray*))lx_isEqualToArray {
    return ^(NSArray* arr) {
        return [self isEqualToArray:arr];
    };
}
- (BOOL (^)(NSString*, BOOL))lx_writeToFileAtomically {
    return ^(NSString* str, BOOL atomic) {
        return [self writeToFile:str atomically:atomic];
    };
}
- (BOOL (^)(NSURL*, BOOL))lx_writeToURLAtomically {
    return ^(NSURL* url, BOOL atomic) {
        return [self writeToURL:url atomically:atomic];
    };
}
- (id (^)(NSUInteger))lx_objectAtIndex {
    return ^(NSUInteger idx) {
        return [self objectAtIndex:idx];
    };
}
- (id (^)(NSArray*))lx_firstObjectCommonWithArray {
    return ^(NSArray* arr) {
        return [self firstObjectCommonWithArray:arr];
    };
}
- (id (^)(void))lx_firstObject {
    return ^ {
        return [self firstObject];
    };
}
- (id (^)(void))lx_lastObject {
    return ^ {
        return [self lastObject];
    };
}
- (id (^)(NSUInteger))lx_objectAtIndexedSubscript {
    return ^(NSUInteger idx) {
        return [self objectAtIndexedSubscript:idx];
    };
}
- (NSEnumerator* (^)(void))lx_objectEnumerator {
    return ^ {
        return [self objectEnumerator];
    };
}
- (NSEnumerator* (^)(void))lx_reverseObjectEnumerator {
    return ^ {
        return [self reverseObjectEnumerator];
    };
}
- (NSString* (^)(NSString*))lx_componentsJoinedByString {
    return ^(NSString* str) {
        return [self componentsJoinedByString:str];
    };
}
- (NSData* (^)(void))lx_sortedArrayHint {
    return ^ {
        return [self sortedArrayHint];
    };
}
- (NSIndexSet* (^)(BOOL (NS_NOESCAPE ^)(id, NSUInteger, BOOL*)))lx_indexesOfObjectsPassingTest {
    return ^(BOOL (NS_NOESCAPE^ predicate)(id, NSUInteger, BOOL*)) {
        return [self indexesOfObjectsPassingTest:predicate];
    };
}
- (NSIndexSet* (^)(NSEnumerationOptions, BOOL (NS_NOESCAPE^)(id, NSUInteger, BOOL*)))lx_indexesOfObjectsWithOptionsPassingTest {
    return ^(NSEnumerationOptions opt, BOOL (NS_NOESCAPE^ predicate)(id, NSUInteger, BOOL*)) {
        return [self indexesOfObjectsWithOptions:opt passingTest:predicate];
    };
}
- (NSIndexSet* (^)(NSIndexSet*, NSEnumerationOptions, BOOL (NS_NOESCAPE ^)(id, NSUInteger, BOOL*)))lx_indexesOfObjectsAtIndexesOptionsPassingTest {
    return ^(NSIndexSet* set, NSEnumerationOptions opt, BOOL (NS_NOESCAPE^ predicate)(id, NSUInteger, BOOL*)) {
        return [self indexesOfObjectsAtIndexes:set options:opt passingTest:predicate];
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

@implementation NSMutableArray (chain)

- (NSMutableArray* (^)(id))lx_addObject {
    return ^(id value) {
        [self addObject:value];
        return self;
    };
}
- (NSMutableArray* (^)(id, NSUInteger))lx_insertObjectAtIndex {
    return ^(id value, NSUInteger idx) {
        [self insertObject:value atIndex:idx];
        return self;
    };
}
- (NSMutableArray* (^)(void))lx_removeLastObject {
    return ^ {
        [self removeLastObject];
        return self;
    };
}
- (NSMutableArray* (^)(NSUInteger))lx_removeObjectAtIndex {
    return ^(NSUInteger idx) {
        [self removeObjectAtIndex:idx];
        return self;
    };
}
- (NSMutableArray* (^)(NSUInteger, id))lx_replaceObjectAtIndexWithObject {
    return ^(NSUInteger idx, id value) {
        [self replaceObjectAtIndex:idx withObject:value];
        return self;
    };
}
- (NSMutableArray* (^)(NSUInteger))lx_initWithCapacity {
    return ^(NSUInteger value) {
        return [self initWithCapacity:value];
    };
}
- (NSMutableArray* (^)(NSArray*))lx_addObjectsFromArray {
    return ^(NSArray* value) {
        [self addObjectsFromArray:value];
        return self;
    };
}
- (NSMutableArray* (^)(NSUInteger, NSUInteger))lx_exchangeObjectAtIndexWithObjectAtIndex {
    return ^(NSUInteger idx1, NSUInteger idx2) {
        [self exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
        return self;
    };
}
- (NSMutableArray* (^)(void))lx_removeAllObjects {
    return ^ {
        [self removeAllObjects];
        return self;
    };
}
- (NSMutableArray* (^)(NSRange))lx_removeObjectsInRange {
    return ^(NSRange value) {
        [self removeObjectsInRange:value];
        return self;
    };
}
- (NSMutableArray* (^)(id))lx_removeObject {
    return ^(id value) {
        [self removeObject:value];
        return self;
    };
}
- (NSMutableArray* (^)(id, NSRange))lx_removeObjectIdenticalToInRange {
    return ^(id value, NSRange range) {
        [self removeObjectIdenticalTo:value inRange:range];
        return self;
    };
}
- (NSMutableArray* (^)(id))lx_removeObjectIdenticalTo {
    return ^(id value) {
        [self removeObjectIdenticalTo:value];
        return self;
    };
}
- (NSMutableArray* (^)(NSArray*))lx_removeObjectsInArray {
    return ^(NSArray* value) {
        [self removeObjectsInArray:value];
        return self;
    };
}
- (NSMutableArray* (^)(NSRange, NSArray*, NSRange))lx_replaceObjectsInRangeFromArrayRange {
    return ^(NSRange range1, NSArray* arr, NSRange range2) {
        [self replaceObjectsInRange:range1 withObjectsFromArray:arr range:range2];
        return self;
    };
}
- (NSMutableArray* (^)(NSRange, NSArray*))lx_replaceObjectsInRangeWithArray {
    return ^(NSRange range, NSArray* arr) {
        [self replaceObjectsInRange:range withObjectsFromArray:arr];
        return self;
    };
}
- (NSMutableArray* (^)(NSArray*))lx_setArray {
    return ^(NSArray* arr) {
        [self setArray:arr];
        return self;
    };
}
- (NSMutableArray* (^)(NSInteger (NS_NOESCAPE*)(id, id, void* _Nullable), void* _Nullable))lx_sortUsingFunctionContext {
    return ^(NSInteger (NS_NOESCAPE* func)(id, id, void* _Nullable), void* _Nullable context) {
        [self sortUsingFunction:func context:context];
        return self;
    };
}
- (NSMutableArray* (^)(SEL))lx_sortUsingSelector {
    return ^(SEL sel) {
        [self sortUsingSelector:sel];
        return self;
    };
}
- (NSMutableArray* (^)(NSArray*, NSIndexSet*))lx_insertObjectsAtIndexes {
    return ^(NSArray* arr, NSIndexSet* set) {
        [self insertObjects:arr atIndexes:set];
        return self;
    };
}
- (NSMutableArray* (^)(NSIndexSet*))lx_removeObjectsAtIndexes {
    return ^(NSIndexSet* set) {
        [self removeObjectsAtIndexes:set];
        return self;
    };
}
- (NSMutableArray* (^)(NSIndexSet*, NSArray*))lx_replaceObjectsAtIndexesWithObjects {
    return ^(NSIndexSet* set, NSArray* arr) {
        [self replaceObjectsAtIndexes:set withObjects:arr];
        return self;
    };
}
- (NSMutableArray* (^)(id, NSUInteger))lx_setObjectAtIndexedSubscript {
    return ^(id obj, NSUInteger idx) {
        [self setObject:obj atIndexedSubscript:idx];
        return self;
    };
}
- (NSMutableArray* (^)(NSComparator))lx_sortUsingComparator {
    return ^(NSComparator comp) {
        [self sortUsingComparator:comp];
        return self;
    };
}
- (NSMutableArray* (^)(NSSortOptions, NSComparator))lx_sortWithOptionsUsingComparator {
    return ^(NSSortOptions opt, NSComparator comp) {
        [self sortWithOptions:opt usingComparator:comp];
        return self;
    };
}
+ (NSMutableArray* (^)(NSUInteger))lx_arrayWithCapacity {
    return ^(NSUInteger value) {
        return [self arrayWithCapacity:value];
    };
}
+ (NSMutableArray* (^)(NSURL*))lx_arrayWithContentsOfURL {
    return ^(NSURL* value) {
        return [self arrayWithContentsOfURL:value];
    };
}
+ (NSMutableArray* (^)(NSString*))lx_arrayWithContentsOfFile {
    return ^(NSString* value) {
        return [self arrayWithContentsOfFile:value];
    };
}
- (NSMutableArray* (^)(NSString*))lx_initWithContentsOfFile {
    return ^(NSString* value) {
        return [self initWithContentsOfFile:value];
    };
}
- (NSMutableArray* (^)(NSURL*))lx_initWithContentsOfURL {
    return ^(NSURL* value) {
        return [self initWithContentsOfURL:value];
    };
}

@end
