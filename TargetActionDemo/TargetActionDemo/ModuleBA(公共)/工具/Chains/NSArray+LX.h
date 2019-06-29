//
//  NSArray+LX.h
//  test
//
//  Created by 天边的星星 on 2019/5/5.
//  Copyright © 2019 starxin. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (LX)

- (NSArray* (^)(const id _Nonnull [_Nullable], NSUInteger))lx_initWithObjectsAndCount;
- (NSArray* (^)(id))lx_arrayByAddingObject;
- (NSArray* (^)(NSArray*))lx_arrayByAddingObjectsFromArray;
- (NSArray* (^)(id _Nonnull __unsafe_unretained [_Nonnull], NSRange))lx_getObjectsInRange;
- (NSArray* (^)(NSInteger (NS_NOESCAPE*)(id, id, void* _Nullable), void* _Nullable))lx_sortedArrayUsingFunctionAndContext;
- (NSArray* (^)(NSInteger (NS_NOESCAPE*)(id, id, void* _Nullable), void* _Nullable, NSData* _Nullable))lx_sortedArrayUsingFunctionContextHint;
- (NSArray* (^)(NSRange))lx_subarrayWithRange;
- (NSArray* (^)(NSURL*, NSError**))lx_writeToURLError API_AVAILABLE(ios(11_0));
- (NSArray* (^)(SEL))lx_makeObjectsPerformSelector;
- (NSArray* (^)(SEL,id _Nullable))lx_makeObjectsPerformSelectorWithObject;
- (NSArray* (^)(NSIndexSet*))lx_objectsAtIndexes;
- (NSArray* (^)(void (NS_NOESCAPE^)(id, NSUInteger, BOOL*)))lx_enumerateObjectsUsingBlock;
- (NSArray* (^)(NSEnumerationOptions, void (NS_NOESCAPE^)(id, NSUInteger, BOOL*)))lx_enumerateObjectsWithOptionsUsingBlock;
- (NSArray* (^)(NSComparator))lx_sortedArrayUsingComparator;
- (NSArray* (^)(NSSortOptions, NSComparator))lx_sortedArrayWithOptionsUsingComparator;
- (NSArray* (^)(NSIndexSet*, NSEnumerationOptions, void (NS_NOESCAPE^)(id, NSUInteger, BOOL*)))lx_enumerateObjectsAtIndexesOptionsUsingBlock;
+ (NSArray* (^)(void))lx_array;
+ (NSArray* (^)(id))lx_arrayWithObject;
+ (NSArray* (^)(const id _Nonnull [_Nonnull], NSUInteger))lx_arrayWithObjectsCount;
+ (NSArray* (^)(id, ...))lx_arrayWithObjects;
+ (NSArray* (^)(NSArray*))lx_arrayWithArray;
- (NSArray* (^)(id, ...))lx_initWithObjects;
- (NSArray* (^)(NSArray*))lx_initWithArray;
- (NSArray* (^)(NSArray*, BOOL))lx_initWithArrayCopyItems;
- (NSArray* (^)(NSURL*, NSError**))lx_initWithContentsOfURLError API_AVAILABLE(ios(11_0));
+ (NSArray* (^)(NSURL*, NSError**))lx_arrayWithContentsOfURLError NS_AVAILABLE_IOS(11_0);
- (NSArray* (^)(id _Nullable __unsafe_unretained [_Nonnull]))lx_getObjects;
+ (NSArray* (^)(NSString*))lx_arrayWithContentsOfFile;
+ (NSArray* (^)(NSURL*))lx_arrayWithContentsOfURL;
- (NSArray* (^)(NSString*))lx_initWithContentsOfFile;
- (NSArray* (^)(NSURL*))lx_initWithContentsOfURL;

- (NSUInteger (^)(void))lx_count;
- (NSUInteger (^)(id))lx_indexOfObject;
- (NSUInteger (^)(id, NSRange))lx_indexOfObjectInRange;
- (NSUInteger (^)(id))lx_indexOfObjectIdenticalTo;
- (NSUInteger (^)(id, NSRange))lx_indexOfObjectIdenticalToInRange;
- (NSUInteger (^)(BOOL (NS_NOESCAPE^)(id, NSUInteger, BOOL*)))lx_indexOfObjectPassingTest;
- (NSUInteger (^)(NSEnumerationOptions, BOOL (NS_NOESCAPE^)(id, NSUInteger, BOOL*)))lx_indexOfObjectWithOptionsPassingTest;
- (NSUInteger (^)(id, NSRange, NSBinarySearchingOptions, NSComparator))lx_indexOfObjectInSortedRangeOptionsUsingComparator;
- (NSUInteger (^)(NSIndexSet*, NSEnumerationOptions, BOOL (NS_NOESCAPE^)(id, NSUInteger, BOOL*)))lx_indexOfObjectAtIndexesOptionsPassingTest;


- (BOOL (^)(id))lx_containsObject;
- (BOOL (^)(NSArray*))lx_isEqualToArray;
- (BOOL (^)(NSString*, BOOL))lx_writeToFileAtomically;
- (BOOL (^)(NSURL*, BOOL))lx_writeToURLAtomically;

- (id (^)(NSUInteger))lx_objectAtIndex;
- (id (^)(NSArray*))lx_firstObjectCommonWithArray;
- (id (^)(void))lx_firstObject;
- (id (^)(void))lx_lastObject;
- (id (^)(NSUInteger))lx_objectAtIndexedSubscript;

- (NSEnumerator* (^)(void))lx_objectEnumerator;
- (NSEnumerator* (^)(void))lx_reverseObjectEnumerator;

- (NSString* (^)(NSString*))lx_componentsJoinedByString;
- (NSData*   (^)(void))lx_sortedArrayHint;

- (NSIndexSet* (^)(BOOL (NS_NOESCAPE ^)(id, NSUInteger, BOOL*)))lx_indexesOfObjectsPassingTest;
- (NSIndexSet* (^)(NSEnumerationOptions, BOOL (NS_NOESCAPE ^)(id, NSUInteger, BOOL*)))lx_indexesOfObjectsWithOptionsPassingTest;
- (NSIndexSet* (^)(NSIndexSet*, NSEnumerationOptions, BOOL (NS_NOESCAPE ^)(id, NSUInteger, BOOL*)))lx_indexesOfObjectsAtIndexesOptionsPassingTest;

@end

@interface NSMutableArray (chain)

- (NSMutableArray* (^)(id))lx_addObject;
- (NSMutableArray* (^)(id, NSUInteger))lx_insertObjectAtIndex;
- (NSMutableArray* (^)(void))lx_removeLastObject;
- (NSMutableArray* (^)(NSUInteger))lx_removeObjectAtIndex;
- (NSMutableArray* (^)(NSUInteger, id))lx_replaceObjectAtIndexWithObject;
- (NSMutableArray* (^)(NSUInteger))lx_initWithCapacity;
- (NSMutableArray* (^)(NSArray*))lx_addObjectsFromArray;
- (NSMutableArray* (^)(NSUInteger, NSUInteger))lx_exchangeObjectAtIndexWithObjectAtIndex;
- (NSMutableArray* (^)(void))lx_removeAllObjects;
- (NSMutableArray* (^)(NSRange))lx_removeObjectsInRange;
- (NSMutableArray* (^)(id))lx_removeObject;
- (NSMutableArray* (^)(id, NSRange))lx_removeObjectIdenticalToInRange;
- (NSMutableArray* (^)(id))lx_removeObjectIdenticalTo;
- (NSMutableArray* (^)(NSArray*))lx_removeObjectsInArray;
- (NSMutableArray* (^)(NSRange, NSArray*, NSRange))lx_replaceObjectsInRangeFromArrayRange;
- (NSMutableArray* (^)(NSRange, NSArray*))lx_replaceObjectsInRangeWithArray;
- (NSMutableArray* (^)(NSArray*))lx_setArray;
- (NSMutableArray* (^)(NSInteger (NS_NOESCAPE*)(id, id, void* _Nullable), void* _Nullable))lx_sortUsingFunctionContext;
- (NSMutableArray* (^)(SEL))lx_sortUsingSelector;
- (NSMutableArray* (^)(NSArray*, NSIndexSet*))lx_insertObjectsAtIndexes;
- (NSMutableArray* (^)(NSIndexSet*))lx_removeObjectsAtIndexes;
- (NSMutableArray* (^)(NSIndexSet*, NSArray*))lx_replaceObjectsAtIndexesWithObjects;
- (NSMutableArray* (^)(id, NSUInteger))lx_setObjectAtIndexedSubscript;
- (NSMutableArray* (^)(NSComparator))lx_sortUsingComparator;
- (NSMutableArray* (^)(NSSortOptions, NSComparator))lx_sortWithOptionsUsingComparator;
+ (NSMutableArray* (^)(NSUInteger))lx_arrayWithCapacity;
+ (NSMutableArray* (^)(NSURL*))lx_arrayWithContentsOfURL;
+ (NSMutableArray* (^)(NSString*))lx_arrayWithContentsOfFile;
- (NSMutableArray* (^)(NSString*))lx_initWithContentsOfFile;
- (NSMutableArray* (^)(NSURL*))lx_initWithContentsOfURL;


@end

NS_ASSUME_NONNULL_END
