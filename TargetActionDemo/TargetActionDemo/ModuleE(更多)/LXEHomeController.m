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
    NSString* url = @"http://www.kuaidi100.com/query?type=shentong&postid=234444";
    self.sessionTask.lx_sessionUrlParameters(url,@"GET",nil)
    .lx_resCallback(^(NSURLResponse* _Nonnull response, id _Nullable responseObject, NSError* _Nullable error) {
        NSLog(@"data = %@", responseObject);
    })
    .lx_resume()
    .lx_uploadProgressCallback(^(NSProgress* uploadProgress) {
        NSLog(@"上传%lld --- %lld", uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
    })
    .lx_downloadProgressCallback(^(NSProgress* downloadProgress) {
        NSLog(@"下载%lld --- %lld", downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    });
}

@end
