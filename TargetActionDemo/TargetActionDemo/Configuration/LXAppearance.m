//
//  LXAppearance.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2019/12/3.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXAppearance.h"
#import <objc/runtime.h>

@implementation LXAppearance

+ (void)load {
    [[UITabBar appearanceWhenContainedInInstancesOfClasses:@[LXTabBarController.class]] setTranslucent:NO];
    
    [UITabBar appearanceWhenContainedInInstancesOfClasses:@[LXTabBarController.class]].barTintColor = UIColor.whiteColor;
    [UITabBar appearanceWhenContainedInInstancesOfClasses:@[LXTabBarController.class]].backgroundColor = UIColor.whiteColor;
    [UITabBar appearanceWhenContainedInInstancesOfClasses:@[LXTabBarController.class]].backgroundImage = UIImage.new;
    
    NSDictionary* normalAtt = @{NSForegroundColorAttributeName: kLXHexColor(0x7D7D7D)};
    NSDictionary* selectAtt = @{NSForegroundColorAttributeName: kLXMainColor};

    if (@available(iOS 13.0, *)) {
        UITabBarAppearance* tabBarAppearance = [UITabBarAppearance new];
        [tabBarAppearance.stackedLayoutAppearance.normal setTitleTextAttributes:normalAtt];
        [tabBarAppearance.stackedLayoutAppearance.selected setTitleTextAttributes:selectAtt];
        tabBarAppearance.shadowColor = UIColor.clearColor;
        tabBarAppearance.shadowImage = UIImage.new;
        
        [[UITabBar appearanceWhenContainedInInstancesOfClasses:@[LXTabBarController.class]] setStandardAppearance:tabBarAppearance];
    }else {
        [[UITabBar appearanceWhenContainedInInstancesOfClasses:@[LXTabBarController.class]] setShadowImage:UIImage.new];
        [[UITabBar appearanceWhenContainedInInstancesOfClasses:@[LXTabBarController.class]] setBackgroundImage:UIImage.new];
        
        [[UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[UITabBar.class]] setTitleTextAttributes:normalAtt forState:UIControlStateNormal];
        [[UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[UITabBar.class]] setTitleTextAttributes:selectAtt forState:UIControlStateSelected];
    }
    
    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    
    [[UIView appearance] setExclusiveTouch:YES];
 
    if (@available(iOS 13.0, *)) {
        [UIScrollView appearance].automaticallyAdjustsScrollIndicatorInsets = NO;
        [UIActivityIndicatorView appearance].activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
    }else {
        [UIActivityIndicatorView appearance].activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    
    [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[LXNavigationController.class]].translucent = NO;
    [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[LXNavigationController.class]].shadowImage = UIImage.new;
    [[UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[LXNavigationController.class]] setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
}

@end

@interface UIViewController (PresentStyle)

@end

@implementation UIViewController (PresentStyle)

+ (void)load {
    if (@available(iOS 13.0, *)) {
        
        SEL originalSel = @selector(presentViewController:animated:completion:);
        SEL swizzledSel = @selector(LX_presentViewController:animated:completion:);
        
        Method originalMethod = class_getInstanceMethod(self, originalSel);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSel);
        IMP swizzledImp = method_getImplementation(swizzledMethod);
        
        if (class_addMethod(self, originalSel, swizzledImp, method_getTypeEncoding(swizzledMethod))) {
            class_replaceMethod(self, originalSel, swizzledImp, method_getTypeEncoding(swizzledMethod));
        }else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}
- (void)LX_presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion API_AVAILABLE(ios(13.0)) {
    if (viewController.modalPresentationStyle == UIModalPresentationPageSheet || viewController.modalPresentationStyle == UIModalPresentationAutomatic) {
        viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    viewController.modalPresentationCapturesStatusBarAppearance = YES;
    [self LX_presentViewController:viewController animated:animated completion:completion];
}

@end
