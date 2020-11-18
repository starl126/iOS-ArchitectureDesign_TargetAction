//
//  LXNavigationController.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2019/6/29.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXNavigationController.h"

@interface LXNavigationController ()

@end

@implementation LXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers && self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
#pragma mark - rotate and status bar
- (BOOL)shouldAutorotate {
    BOOL autorotate = [self.visibleViewController shouldAutorotate];
    return autorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIInterfaceOrientationMask mask = [self.visibleViewController supportedInterfaceOrientations];
    return mask;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    UIInterfaceOrientation ori = [self.visibleViewController preferredInterfaceOrientationForPresentation];
    return ori;
}
- (BOOL)prefersStatusBarHidden {
    return [self.visibleViewController prefersStatusBarHidden];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.visibleViewController preferredStatusBarStyle];
}

#ifdef DEBUG
- (void)dealloc {
    LXLog(@"销毁 --- %@", NSStringFromClass(self.class));
}
#endif

@end
