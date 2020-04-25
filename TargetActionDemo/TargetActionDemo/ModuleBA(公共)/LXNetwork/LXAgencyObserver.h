//
//  LXObserver.h
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/8.
//  Copyright © 2019 starxin. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN
///代理观察者
@interface LXAgencyObserver : NSObject

///委托者控件
@property (nonatomic, unsafe_unretained) UIView* lx_consignorView;
///是否正在请求网络中，在请求中则禁止掉滚动回调接口
@property (nonatomic, assign, getter=isRequesting) BOOL lx_requesting;
///请求网络事件回调
@property (nonatomic, copy) dispatch_block_t lx_needRequestBlock;

@end

NS_ASSUME_NONNULL_END
