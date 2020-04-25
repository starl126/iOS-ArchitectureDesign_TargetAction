//
//  LXCHomeController.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2019/6/29.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXCHomeController.h"

#define LX_DEPRECATED_IOS(iosIntro,iosDep,...) (__attribute__((availability(ios,introduced=_iosIntro,deprecated=_iosDep,message="" __VA_ARGS__))))

@interface LXCHomeController ()

@end

@implementation LXCHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    self.view.lx_backgroundColor(UIColor.orangeColor);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event  {
    NSArray* arr = [NSArray array];
    if (arr[2]) {
        
    }
}
- (void)p_test {
    
}


@end
