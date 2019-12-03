//
//  AppDelegate+RootVc.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2019/12/3.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "AppDelegate+RootVc.h"
#import "LXTabBarController.h"

@implementation AppDelegate (RootVc)

- (UIViewController *)appRootVC {
    LXTabBarController* rootVc = [LXTabBarController new];
    return rootVc;
}

@end
