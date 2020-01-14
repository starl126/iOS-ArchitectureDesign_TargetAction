//
//  LXHttpCacheMediator.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/9.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXHttpCacheTool.h"
#import <CommonCrypto/CommonDigest.h>

#define kLXHttpMemoryCacheSize 5*1024*1024
#define kLXHttpDiskCacheSize   30*1024*1024

@interface LXHttpCacheTool ()

@end

@implementation LXHttpCacheTool

#pragma mark --- life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self p_configure];
    }
    return self;
}
- (void)p_configure {
    NSURLCache* urlCache = [[NSURLCache alloc] initWithMemoryCapacity:kLXHttpMemoryCacheSize diskCapacity:kLXHttpDiskCacheSize diskPath:@"LXHttpCacheDirectory"];
    [NSURLCache setSharedURLCache:urlCache];
}

#pragma mark --- actions
- (LXHttpCacheTool* (^)(NSURLRequest* _Nonnull request, NSData* _Nonnull data))lx_saveCacheForRequest {
    return ^(NSURLRequest* _Nonnull request, NSData* _Nonnull data) {
        [self p_actionForSaveUrlCacheInRequest:request data:data];
        return self;
    };
}
- (LXHttpCacheTool* (^)(NSArray<NSURLRequest*>* _Nonnull requests, NSArray<NSData*>* datas))lx_saveCacheForRequests {
    return ^(NSArray<NSURLRequest*>* _Nonnull requests, NSArray<NSData*>* datas) {
        NSAssert(requests && datas && requests.count && datas.count, @"保存缓存时，requests或者datas任何一方为空");
        NSAssert(requests.count == datas.count, @"保存缓存时，requests或者datas的对象数目不一致");
        
        for (NSUInteger i=0; i<requests.count; i++) {
            [self p_actionForSaveUrlCacheInRequest:requests[i] data:datas[i]];
        }
        return self;
    };
}
- (LXHttpCacheTool* (^)(NSURLRequest* _Nonnull request))lx_deleteCacheForRequest {
    return ^(NSURLRequest* _Nonnull request) {
        NSURLRequest* correctRequest = [self p_actionForCorrectRequest:request];
        [NSURLCache.sharedURLCache removeCachedResponseForRequest:correctRequest];
        return self;
    };
}
- (LXHttpCacheTool* (^)(NSArray<NSURLRequest*>* _Nonnull requests))lx_deleteCacheForRequests {
    return ^(NSArray<NSURLRequest*>* _Nonnull requests) {
        for (NSUInteger i=0; i<requests.count; i++) {
            NSURLRequest* correctRequest = [self p_actionForCorrectRequest:requests[i]];
            [NSURLCache.sharedURLCache removeCachedResponseForRequest:correctRequest];
        }
        return self;
    };
}
- (LXHttpCacheTool* (^)(void))lx_deleteAllCache {
    return ^ {
        [NSURLCache.sharedURLCache removeAllCachedResponses];
        return self;
    };
}

- (NSData* (^)(NSURLRequest* _Nonnull request))lx_cacheForRequest {
    return ^(NSURLRequest* _Nonnull request) {
        return [self p_actionForGetUrlCacheInRequest:request];
    };
}
- (NSArray<NSData*>* _Nullable (^)(NSArray<NSURLRequest*>* _Nonnull requests))lx_cacheForRequests {
    return ^(NSArray<NSURLRequest*>* _Nonnull requests) {
        NSMutableArray* arrM = [NSMutableArray arrayWithCapacity:requests.count];
        for (NSUInteger i=0; i<requests.count; i++) {
            NSData* data = [self p_actionForGetUrlCacheInRequest:requests[i]];
            if (data) {
                [arrM addObject:data];
            }else {
                [arrM addObject:NSData.new];
            }
        }
        return arrM.copy;
    };
}


#pragma mark --- private
/// 保存指定请求指定数据的http cache
- (void)p_actionForSaveUrlCacheInRequest:(NSURLRequest*)request data:(NSData*)data {
    NSAssert(request&&data, @"保存http缓存时，请求和数据任何一方不能为空");
    
    // 改造request
    NSURLRequest* correctRequest = [self p_actionForCorrectRequest:request];
    
    NSURLResponse* response = [[NSURLResponse alloc] initWithURL:correctRequest.URL MIMEType:@"application/json" expectedContentLength:data.length textEncodingName:@"utf-8"];
    NSCachedURLResponse* cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
    [NSURLCache.sharedURLCache storeCachedResponse:cachedResponse forRequest:correctRequest];
}
/// 获取指定请求的缓存数据
- (NSData* _Nullable)p_actionForGetUrlCacheInRequest:(NSURLRequest*)request {
    // 改造request
     NSURLRequest* correctRequest = [self p_actionForCorrectRequest:request];
    NSCachedURLResponse* cachedResponse = [NSURLCache.sharedURLCache cachedResponseForRequest:correctRequest];
    return cachedResponse.data;
}
/// 校正request，采用url地址+'?'+参数的MD5
- (NSURLRequest*)p_actionForCorrectRequest:(NSURLRequest*)oriRequest {
    NSData* httpBody = oriRequest.HTTPBody;
    NSString* correctUrl = oriRequest.URL.absoluteString.mutableCopy;
    if (httpBody && httpBody.length) {
        NSString* correctBodyStr = [LXHttpCacheTool p_MD5ForData:httpBody];
        correctUrl = [correctUrl stringByAppendingFormat:@"?%@", correctBodyStr];
    }
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:kLXURL(correctUrl)];
    return request;
}
+ (NSString *)p_MD5ForData:(NSData*)data {
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

- (void)dealloc {
    LXLog(@"dealloc --- %@", NSStringFromClass(self.class));
}

@end
