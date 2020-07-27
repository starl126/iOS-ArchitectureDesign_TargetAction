//
//  LXXCTestExample.h
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/5/13.
//  Copyright © 2020 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXXCTestExample : NSObject

- (int)example1:(NSNumber *)input;
- (int)callExample1;

@property (nonatomic, assign) int age, salary;

+ (void)blockTest;

@end

NS_ASSUME_NONNULL_END
