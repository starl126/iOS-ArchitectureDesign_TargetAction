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
 
}


@end
