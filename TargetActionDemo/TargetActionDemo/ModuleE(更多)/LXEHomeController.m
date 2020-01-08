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
    self.sessionTask = [LXHttpSessionTask new];
    NSString* url = @"http://app-dev.qizhidao.com/qzd-bff-app/qzd/v1/policy/project/permit/declare/search";
    NSString* accessToken = @"eyJhbGciOiJIUzUxMiIsInppcCI6IkRFRiJ9.eNpkzkkOwjAMQNG7eN1IduJQqzfgGE7aiiA6QFuJQdwdlwUbtvbTt19QlgUauJbnqbQ6QQVFV2go1sISKPgKdGtNkGAIHAQxGjqvxWY1ihxyjg59IsddTi5xRqekvm8Tx4533N3nvSjoib7FZUt_xTH1v7NIhuaLrv10G6DBCvI0zDo-jvaJ7WN9EPbBLLPg-wMAAP__.iYseOnYg01dnf6WGgYvs4A4iP2FAZCkAtCTUhRPkcfT1o4mK03pvs68Uj396OpcVFTx3im0Mb1uXRkY-xABoDw";
    
    NSString* signature = @"ae76aa6bb6563b7373ae9559bafe75c3.tGSAu63rRs";
    NSDictionary* param = @{
        @"provinceCode": @"一样",
        @"current": @(1),
        @"currentPage": @(1),
        @"pageSize": @(20),
        @"cityCode": @"测试"
    };
    NSDictionary* header = @{
        @"accessToken": accessToken,
        @"signature": signature
    };

    self.sessionTask.lx_sessionUrlParameters(url,@"GET",param)
    .lx_header(header)
    .lx_resCallback(^(LXHttpResData* data) {
        NSLog(@"data = %@", data);
    })
    .lx_resume();
}

@end
