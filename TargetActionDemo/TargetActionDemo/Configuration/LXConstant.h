//
//  LXConstant.h
//  TargetActionDemo
//
//  Created by 天边的星星 on 2019/12/3.
//  Copyright © 2019 starxin. All rights reserved.
//

#ifndef LXConstant_h
#define LXConstant_h

#define kLXWeakSelf          __weak typeof(self) weakSelf = self
#define kLXWeakObj(OBJ)      __weak typeof(OBJ) OBJ##Weak = OBJ
#define kLXImageNamed(NAME)  [UIImage imageNamed:NAME]
#define kLXURL(STR)          ({NSString* urlString = [STR stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];\
                             NSURL *url = [NSURL URLWithString:urlString];(url);})
#define kLXBlockOnMain(block) ([NSThread isMainThread] ? block() : dispatch_async(dispatch_get_main_queue(),block))

#pragma mark --- 尺寸大小
#define kLXDeviceSize        ({CGFloat scale = 2.0/UIScreen.mainScreen.currentMode.pixelAspectRatio;\
                             CGSize physicalSize = CGSizeMake(UIScreen.mainScreen.currentMode.size.width/scale, \
                             UIScreen.mainScreen.currentMode.size.height/scale);(physicalSize);})
#define kLXDeviceWidth       kLXDeviceSize.width
#define kLXDeviceHeight      kLXDeviceSize.height
#define kLXAppSize           UIScreen.mainScreen.bounds.size
#define kLXAppWidth          UIScreen.mainScreen.bounds.size.width
#define kLXAppHeight         UIScreen.mainScreen.bounds.size.height

#pragma mark --- 字体
#define kLXAdaptiveFont       (kLXDeviceWidth == 320 ? -1 : ((kLXDeviceWidth == 375) ? 0 : 1))
#define kLXSystemFont(FONT)   ([UIFont systemFontOfSize:FONT + kLXAdaptiveFont])
#define kLXBoldSysFont(FONT)  ([UIFont boldSystemFontOfSize:FONT + kLXAdaptiveFont])
#define kLXMidSysFont(FONT)   ([UIFont systemFontOfSize:FONT + kLXAdaptiveFont weight:UIFontWeightMedium])
#define kLXLightSysFont(FONT) ([UIFont systemFontOfSize:FONT + kLXAdaptiveFont weight:UIFontWeightLight])
#define kLXNumberFont(FONT)   [UIFont fontWithName:@"Futura" size:FONT+kLXAdaptiveFont]

#pragma mark --- 设备适配
#define kLXAdaptiveMargin(VALUE) ({int sign = 1;\
                                  if (VALUE < 0) {\
                                  sign = -1;}\
                                  float result = sign*round(((sign*VALUE)*(kLQDeviceWidth == 320 ? 0.9 : ((kLQDeviceWidth == 375) ? 1 : 1.1))));\
                                  (result);})
#define kLXViewSafeAreaInsets(VIEW) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = VIEW.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})
#define kLXStatusBarHeight    ({CGFloat statusHeight = 20;\
                              CGFloat safeTop = kLXViewSafeAreaInsets(UIApplication.sharedApplication.keyWindow).top;\
                              if (safeTop == 44) { \
                                 statusHeight = 44;\
                              }\
                              (statusHeight);})

#define kLXTopWindow          ({UIWindow* window = nil; if (@available(iOS 13.0, *)) { \
                                    for (UIWindowScene* wScene in [UIApplication sharedApplication].connectedScenes) { \
                                        if (wScene.activationState != UISceneActivationStateUnattached) { \
                                            window = wScene.windows.lastObject; break; } } \
                                        }else {\
                                            window = [UIApplication sharedApplication].keyWindow; \
                                        }\
                               (window);})
#define kLXNavBarHeight       ({CGFloat statusHeight = 20;\
                               CGFloat safeTop = kLXViewSafeAreaInsets(UIApplication.sharedApplication.keyWindow).top;\
                               if (safeTop == 44) { \
                                  statusHeight = 44;\
                                }\
                               (statusHeight + 44);})
#define kLXIsXSeriesDevice     (kLXViewSafeAreaInsets(UIApplication.sharedApplication.keyWindow).top > 20)

#define kLXTextCalculateSize(TEXT,MAXWIDTH,FONT)  ({CGSize sizeC = CGSizeZero;\
                                                    do { \
                                                    sizeC = [TEXT boundingRectWithSize:CGSizeMake(MAXWIDTH, CGFLOAT_MAX) \
                                                    options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin \
                                                    attributes:@{NSFontAttributeName:FONT} context:nil].size; \
                                                    }while(0); \
                                                    (CGSizeMake(ceil(sizeC.width),ceil(sizeC.height)));})

#define kLXLabelSizeWithTextAndFont(content, font, width) ({UILabel* calculateLbl = [[UILabel alloc] init];\
                                                              [calculateLbl setFont: font];\
                                                              calculateLbl.text = content;calculateLbl.numberOfLines = 0;\
                                                              CGSize size = [calculateLbl sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];\
                                                              (size);})
#pragma mark --- 字符串安全
#define kLXSafePlacerStr(STR)      ((STR == nil || !STR.length) ? @"--" : STR)
#define kLXSafeEmptyStr(STR)       (STR == nil ? @""  : STR)

#pragma mark --- 颜色
#define kLXHexColorAlpha(C, A)       [UIColor colorWithRed:((C>>16)&0xFF)/255.0f green:((C>>8)&0xFF)/255.0f blue:(C&0xFF)/255.0f alpha:A]
#define kLXHexColor(C)               [UIColor colorWithRed:((C>>16)&0xFF)/255.0f green:((C>>8)&0xFF)/255.0f blue:(C&0xFF)/255.0f alpha:1.0f]
#define kLXMainColor                 kLXHexColor(0x427AFF)
#define kLXRedColor                  kLXHexColor(0xED5F64)
#define kLXUnreadDotColor            kLXHexColor(0xF73A2F)
#define kLXSeperateLineColor         [[UIColor blackColor] colorWithAlphaComponent:0.1]
#define kLXBlackTextColor            kLXHexColor(0x0A0A17)

#endif /* LXConstant_h */
