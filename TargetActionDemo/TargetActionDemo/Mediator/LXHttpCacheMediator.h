//
//  LXHttpCacheMediator.h
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/9.
//  Copyright © 2020 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 缓存层
@interface LXHttpCacheMediator : NSObject

#pragma mark --- 请求缓存操作api，注意：系统层缓存策略只针对'GET'请求

/// 保存指定request的cache，传入NSURLRequest对象和NSData对象
- (LXHttpCacheMediator* (^)(NSURLRequest* _Nonnull request, NSData* _Nonnull data))lx_saveCacheForRequest;

/// 保存指定request数组的二进制对象cache，传入NSURLRequest对象数组和NSData对象数组
- (LXHttpCacheMediator* (^)(NSArray<NSURLRequest*>* _Nonnull requests, NSArray<NSData*>* datas))lx_saveCacheForRequests;

/// 删除指定request的cache，传入NSURLRequest对象
- (LXHttpCacheMediator* (^)(NSURLRequest* _Nonnull request))lx_deleteCacheForRequest;

/// 删除指定request数组的caches，传入NSURLRequest对象数组
- (LXHttpCacheMediator* (^)(NSArray<NSURLRequest*>* _Nonnull requests))lx_deleteCacheForRequests;

/// 清除系统所有的cache
- (LXHttpCacheMediator* (^)(void))lx_deleteAllCache;

/// 获取指定request的cache
- (NSData* _Nullable (^)(NSURLRequest* _Nonnull request))lx_cacheForRequest;

/// 获取指定request数组的cache二进制对象数组
- (NSArray<NSData*>* _Nullable (^)(NSArray<NSURLRequest*>* _Nonnull requests))lx_cacheForRequests;

@end

NS_ASSUME_NONNULL_END
