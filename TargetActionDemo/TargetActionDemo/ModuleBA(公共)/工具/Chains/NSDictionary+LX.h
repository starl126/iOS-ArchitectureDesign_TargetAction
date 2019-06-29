//
//  NSDictionary+LX.h
//  test
//
//  Created by 天边的星星 on 2019/5/1.
//  Copyright © 2019 starxin. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (chain)

- (id (^)(NSString*))lx_objectForKey;
- (NSDictionary* (^)(NSArray*, NSArray<id<NSCopying>>*))lx_initWithObjectsForKeys;
- (NSDictionary* (^)(const id _Nonnull [_Nullable], const id<NSCopying> _Nonnull  [_Nullable], NSUInteger))lx_initWithObjectsForKeysCount;

- (BOOL (^)(NSDictionary*   ))lx_isEqualToDictionary;
- (BOOL (^)(NSURL*, NSError**))lx_writeToURLError API_AVAILABLE(ios(11_0));

- (NSEnumerator* (^)(void))lx_keyEnumerator;
- (NSEnumerator* (^)(void))lx_objectEnumerator;
- (NSArray*      (^)(NSArray*, id))lx_objectsForKeysNotFoundMarker;
- (NSArray*      (^)(SEL))lx_keysSortedByValueUsingSelector;
- (NSDictionary* (^)(id _Nonnull __unsafe_unretained [_Nullable], id _Nonnull __unsafe_unretained [_Nullable], NSUInteger))lx_getObjectsAndKeysCount;
- (NSDictionary* (^)(void (NS_NOESCAPE ^)(id, id, BOOL*)))lx_enumerateKeysAndObjectsUsingBlock;
- (NSDictionary* (^)(NSEnumerationOptions, void (NS_NOESCAPE ^)(id, id, BOOL*)))enumerateKeysAndObjectsWithOptionsUsingBlock;

- (NSArray* (^)(id))lx_allKeysForObject;
- (NSArray* (^)(NSComparator NS_NOESCAPE))lx_keysSortedByValueUsingComparator;
- (NSArray* (^)(NSSortOptions, NSComparator NS_NOESCAPE))lx_keysSortedByValueWithOptionsUsingComparator;

- (NSSet*   (^)(BOOL (NS_NOESCAPE ^)(id, id, BOOL*)))lx_keysOfEntriesPassingTestPredicate;
- (NSSet*   (^)(NSEnumerationOptions, BOOL (NS_NOESCAPE ^)(id, id, BOOL*)))lx_keysOfEntriesWithOptionsPassingTest;


+ (NSDictionary* (^)(id, id<NSCopying>))lx_dictionaryWithObjectAndKey;
+ (NSDictionary* (^)(id,...))lx_dictionaryWithObjectsAndKeys;
+ (NSDictionary* (^)(NSDictionary*))lx_dictionaryWithDictionary;
+ (NSDictionary* (^)(NSArray*, NSArray<id<NSCopying>>*))lx_dictionaryWithObjectsForKeys;
- (NSDictionary* (^)(id, ...))lx_initWithObjectsAndKeys;
- (NSDictionary* (^)(NSDictionary*))lx_initWithDictionary;
- (NSDictionary* (^)(NSDictionary*, BOOL))lx_initWithDictionaryCopyItems;
- (NSDictionary* (^)(NSURL*, NSError**))lx_initWithContentsOfURLError API_AVAILABLE(ios(11_0));
+ (NSDictionary* (^)(NSURL*, NSError**))lx_dictionaryWithContentsOfURLError NS_AVAILABLE_IOS(11_0);

@end

@interface NSMutableDictionary (chain)

- (NSMutableDictionary* (^)(id))lx_removeObjectForKey;
- (NSMutableDictionary* (^)(id, id<NSCopying>))lx_setObjectForKey;
- (NSMutableDictionary* (^)(NSUInteger))lx_initWithCapacity;
- (NSMutableDictionary* (^)(NSDictionary*))lx_addEntriesFromDictionary;
- (NSMutableDictionary* (^)(void))lx_removeAllObjects;
- (NSMutableDictionary* (^)(NSArray<id<NSCopying>>*))lx_removeObjectsForKeys;
- (NSMutableDictionary* (^)(NSDictionary*))lx_setDictionary;
- (NSMutableDictionary* (^)(id, id<NSCopying>))lx_setObjectForKeyedSubscript;
+ (NSMutableDictionary* (^)(NSUInteger))lx_dictionaryWithCapacity;
+ (NSMutableDictionary* (^)(NSString*))lx_dictionaryWithContentsOfFile;
+ (NSMutableDictionary* (^)(NSURL*))lx_dictionaryWithContentsOfURL;
- (NSMutableDictionary* (^)(NSString*))lx_initWithContentsOfFile;
- (NSMutableDictionary* (^)(NSURL*))lx_initWithContentsOfURL;

@end

NS_ASSUME_NONNULL_END
