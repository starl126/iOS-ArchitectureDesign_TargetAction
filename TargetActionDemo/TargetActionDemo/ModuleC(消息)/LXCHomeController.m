//
//  LXCHomeController.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2019/6/29.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXCHomeController.h"
#import "LXConstant.h"

#define LX_DEPRECATED_IOS(iosIntro,iosDep,...) (__attribute__((availability(ios,introduced=_iosIntro,deprecated=_iosDep,message="" __VA_ARGS__))))

@interface LXCHomeController ()

@property (nonatomic, strong) NSMapTable *mapTable;

@end

@implementation LXCHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    self.view.lx_backgroundColor(UIColor.orangeColor);
    self.mapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory capacity:0];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    LXLog(@"%@", self.mapTable);
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event  {
//    [self.mapTable setObject:@"key2" forKey:@"starxin"];
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.view.backgroundColor = [UIColor lightGrayColor];
//    vc.navigationItem.title = @"Test";
//    [self.mapTable setObject:vc forKey:@"key1"];
//    [self.navigationController pushViewController:vc animated:YES];
    
    CGFloat safeTop = kLXViewSafeAreaInsets(UIApplication.sharedApplication.keyWindow).top;
}
- (void)p_test:(NSInteger)num {
    LXLog(@"%s",__PRETTY_FUNCTION__);
}


@end
