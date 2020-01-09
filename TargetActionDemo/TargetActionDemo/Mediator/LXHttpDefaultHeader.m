//
//  LXHttpDefaultHeader.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/1/9.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXHttpDefaultHeader.h"
#import <sys/utsname.h>

@implementation LXHttpDefaultHeader

+ (NSDictionary*)httpDefaultHeader {
    return [self appInfoHeader];
}

#pragma mark --- setter and getter
+ (NSDictionary *)appInfoHeader {
    NSDictionary* appInfo = [NSBundle mainBundle].infoDictionary;
    NSString* appName = [appInfo objectForKey:@"CFBundleDisplayName"];
    NSString* shortVer = [appInfo objectForKey:@"CFBundleShortVersionString"];
    NSString* os = [[UIDevice currentDevice] systemVersion];
    NSString* userAgent = [NSString stringWithFormat:@"Mozilla/5.0 (iOS; OS/%@ AppName/%@) Version/%@ Device/%@ AppleWebKit/537.36 (KHTML, like Gecko)  Safari/537.36",os,appName,shortVer,self.deviceDetailType];
    
    if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        NSMutableString *mutableUserAgent = [userAgent mutableCopy];
        if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
            userAgent = mutableUserAgent;
        }
    }
    return @{@"version": shortVer, @"User-Agent": userAgent};
}
+ (NSDictionary *)deviceDetailInfo {
    return @{
        @"iPhone5,1": @"iPhone 5",       @"iPhone5,2": @"iPhone 5",
        @"iPhone5,3": @"iPhone 5c",      @"iPhone5,4": @"iPhone 5c",
        @"iPhone6,1": @"iPhone 5s",      @"iPhone6,2": @"iPhone 5s",
        @"iPhone7,1": @"iPhone 6 Plus",  @"iPhone7,2": @"iPhone 6",
        @"iPhone8,1": @"iPhone 6s",      @"iPhone8,2": @"iPhone 6s Plus",
        @"iPhone8,4": @"iPhone SE",      @"iPhone9,1": @"iPhone 7",
        @"iPhone9,2": @"iPhone 7 Plus",  @"iPhone10,1": @"iPhone 8",
        @"iPhone10,4": @"iPhone 8",      @"iPhone10,2": @"iPhone 8 Plus",
        @"iPhone10,5": @"iPhone 8 Plus", @"iPhone10,3": @"iPhone X",
        @"iPhone10,6": @"iPhone X",      @"iPhone11,2": @"iPhone XS",
        @"iPhone11,4": @"iPhone XS Max", @"iPhone11,6": @"iPhone XS Max",
        @"iPhone11,8": @"iPhone XR",     @"i386": @"iPhone Simulator",
        @"x86_64": @"iPhone Simulator",  @"iPod": @"iPod Touch",
        @"iPad1,1": @"iPad 1G",          @"iPad2,1": @"iPad 2",
        @"iPad2,2": @"iPad 2",           @"iPad2,3": @"iPad 2",
        @"iPad2,4": @"iPad 2",           @"iPad2,5": @"iPad Mini 1G",
        @"iPad2,6": @"iPad Mini 1G",     @"iPad2,7": @"iPad Mini 1G",
        @"iPad3,1": @"iPad 3",           @"iPad3,2": @"iPad 3",
        @"iPad3,3": @"iPad 3",           @"iPad3,4": @"iPad 4",
        @"iPad3,5": @"iPad 4",           @"iPad3,6": @"iPad 4",
        @"iPad4,1": @"iPad Air",         @"iPad4,2": @"iPad Air",
        @"iPad4,3": @"iPad Air",         @"iPad4,4": @"iPad Mini 2G",
        @"iPad4,5": @"iPad Mini 2G",     @"iPad4,6": @"iPad Mini 2G",
        @"iPad4,7": @"iPad Mini 3",      @"iPad4,8": @"iPad Mini 3",
        @"iPad4,9": @"iPad Mini 3",      @"iPad5,1": @"iPad Mini 4",
        @"iPad5,2": @"iPad Mini 4",      @"iPad5,3": @"iPad Air 2",
        @"iPad5,4": @"iPad Air 2",       @"iPad6,3": @"iPad Pro 9.7",
        @"iPad6,4": @"iPad Pro 9.7",     @"iPad6,7": @"iPad Pro 12.9",
        @"iPad6,8": @"iPad Pro 12.9",
    };
}
+ (NSString *)deviceDetailType {

    struct utsname deviceInfo;
    int success = uname(&deviceInfo);
    if (success != 0) {
        return @"unrecognized device";
    }
    
    NSString* deviceStr = [NSString stringWithCString:deviceInfo.machine encoding:NSUTF8StringEncoding];
    
    id obj = [self.deviceDetailInfo objectForKey:deviceStr];
    if (obj) {
        return obj;
    }else {
        return @"unknow device";
    }
}

@end
