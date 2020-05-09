//
//  LXEHomeController.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2019/6/29.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXEHomeController.h"
#import "LXHttpSessionTask.h"

@interface LXEHomeController ()

@property (nonatomic, strong) LXHttpSessionTask* sessionTask;

@end

@implementation LXEHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更多";
    self.view.lx_backgroundColor(UIColor.whiteColor);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
