//
//  LXXCTestExample.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/5/13.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXXCTestExample.h"

@implementation LXXCTestExample

- (int)example1:(NSNumber *)input {
//    LXLog(@"input = %@", input);
    return [input intValue];
}
- (int)callExample1 {
    return [self example1:@(1)];
}
static NSInteger num3 = 300;
NSInteger num4 = 3000;

+ (void)blockTest {
    NSInteger num = 30;
    static NSInteger num2 = 3;
    __block NSInteger num5 = 30000;
    
    void (^block)(void) = ^{
        NSLog(@"%zd", num);
        NSLog(@"%zd", num2);
        NSLog(@"%zd", num3);
        NSLog(@"%zd", num4);
        NSLog(@"%zd", num5);
    };
    block();
    
    NSLog(@"%@", [^{
        NSLog(@"globalBlock");
    } class]);
}

@end
