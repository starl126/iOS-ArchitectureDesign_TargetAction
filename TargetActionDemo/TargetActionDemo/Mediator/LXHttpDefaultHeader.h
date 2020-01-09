//
//  LXHttpDefaultHeader.h
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/9.
//  Copyright © 2020 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 基础层：请求的默认header配置
@interface LXHttpDefaultHeader : NSObject

/// 获取 网络请求默认的头文件
+ (NSDictionary*)httpDefaultHeader;

@end

NS_ASSUME_NONNULL_END
