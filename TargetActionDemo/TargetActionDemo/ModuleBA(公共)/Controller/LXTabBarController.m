//
//  LXTabBarController.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2019/6/29.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXTabBarController.h"

@implementation LXTabBarController

#pragma mark --- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupViews];
}
- (void)p_setupViews {
    
    LXAHomeController* AHome = [[LXAHomeController alloc] init];
    LXNavigationController* nav1 = [[LXNavigationController alloc] initWithRootViewController:AHome];
    nav1.tabBarItem = [self p_setTabBarItemTitle:@"首页" image:nil selectedImage:nil];
    
    LXBHomeController* BHome = [[LXBHomeController alloc] init];
    LXNavigationController* nav2 = [[LXNavigationController alloc] initWithRootViewController:BHome];
    nav2.tabBarItem = [self p_setTabBarItemTitle:@"直播" image:nil selectedImage:nil];
    
    LXCHomeController* CHome = [[LXCHomeController alloc] init];
    LXNavigationController* nav3 = [[LXNavigationController alloc] initWithRootViewController:CHome];
    nav3.tabBarItem = [self p_setTabBarItemTitle:@"消息" image:nil selectedImage:nil];
    
    LXDHomeController* DHome = [[LXDHomeController alloc] init];
    LXNavigationController* nav4 = [[LXNavigationController alloc] initWithRootViewController:DHome];
    nav4.tabBarItem = [self p_setTabBarItemTitle:@"关注" image:nil selectedImage:nil];
    
    LXEHomeController* EHome = [[LXEHomeController alloc] init];
    LXNavigationController* nav5 = [[LXNavigationController alloc] initWithRootViewController:EHome];
    nav5.tabBarItem = [self p_setTabBarItemTitle:@"更多" image:nil selectedImage:nil];
    
    self.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
}
- (UITabBarItem*)p_setTabBarItemTitle:(NSString*)title image:(NSString*)image selectedImage:(NSString*)selectedImage {
    UIImage* normalImage = [UIImage imageNamed:image];
    UIImage* selImage    = [UIImage imageNamed:selectedImage];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selImage];
    return tabBarItem;
}
- (void)p_setupNavTitleAttribute {
    
}

@end
