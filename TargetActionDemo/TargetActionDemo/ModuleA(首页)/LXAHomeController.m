//
//  LXAHomeController.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2019/6/29.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXAHomeController.h"
#import "LXHttpBLLHandler.h"

@interface LXAHomeController ()


@end

@implementation LXAHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.view.lx_backgroundColor(UIColor.lightGrayColor);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSDictionary *dict = @{@"name": @"star", @"age": @(23)};
    for (id key in dict) {
        LXLog(@"%@", key);
    }
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:@[@(1), @(2)]];
    [self p_first:arrM];
    
}
- (void)p_first:(NSMutableArray *)arrM {
    NSArray *arr = [self p_second:arrM];
    arr = [arr mutableCopy];
    
}
- (NSArray *)p_second:(NSArray *)arr {
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:arr];
    
    arr = [NSArray arrayWithArray:arrM];
    return arr;
}

@end
