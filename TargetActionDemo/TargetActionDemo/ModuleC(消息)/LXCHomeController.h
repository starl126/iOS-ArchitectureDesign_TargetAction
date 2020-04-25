//
//  LXCHomeController.h
//  TargetActionDemo
//
//  Created by 天边的星星 on 2019/6/29.
//  Copyright © 2019 starxin. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_subclassing_restricted))
///消息
@interface LXCHomeController : UIViewController

- (void)p_test:(NSInteger)num __attribute__((availability(ios,introduced=9,deprecated=11,message="use")));

@end

NS_ASSUME_NONNULL_END
