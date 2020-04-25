//
//  LXBHomeController.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2019/6/29.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXBHomeController.h"

@interface LXName : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL male;

@end

@implementation LXName


@end

@interface LXBHomeController ()

@end

@implementation LXBHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"直播";
    self.view.lx_backgroundColor(UIColor.whiteColor);
}
extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    dispatch_benchmark(10, ^{
        
    });
}
void target_stop_hook() {
    printf("发生了一次target stop");
}

@end
