//
//  CALayer+LX.h
//  test
//
//  Created by 刘欣 on 2019/4/25.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//这是图层的扩展
@interface CALayer (chain)

#pragma mark --- layer 常见属性设置
- (CALayer* (^)(CGRect  ))lx_frame;
- (CALayer* (^)(CGRect  ))lx_bounds;
- (CALayer* (^)(CGPoint ))lx_position;
- (CALayer* (^)(CGFloat ))lx_zPosition;
- (CALayer* (^)(CGPoint ))lx_anchorPoint;
- (CALayer* (^)(CGFloat ))lx_anchorPointZ;

- (CALayer* (^)(CATransform3D))lx_transform;

- (CALayer* (^)(BOOL    ))lx_hidden;
- (CALayer* (^)(BOOL    ))lx_opaque;
- (CALayer* (^)(id      ))lx_contents;
- (CALayer* (^)(CGRect  ))lx_contentsRect;
- (CALayer* (^)(CGFloat ))lx_contentsScale;
- (CALayer* (^)(CGRect  ))lx_contentsCenter;
- (CALayer* (^)(UIColor*))lx_backgroundColor;

- (CALayer* (^)(CALayerContentsGravity))lx_contentsGravity;

- (CALayer* (^)(BOOL   ))lx_shouldRasterize;
- (CALayer* (^)(CGFloat))lx_rasterizationScale;

- (CALayer* (^)(UIColor* ))lx_shadowColor;
- (CALayer* (^)(float    ))lx_shadowOpacity;
- (CALayer* (^)(CGSize   ))lx_shadowOffset;
- (CALayer* (^)(CGFloat  ))lx_shadowRadius;
- (CALayer* (^)(CGPathRef))lx_shadowPath;


- (CALayer* (^)(CGFloat ))lx_cornerRadius;
- (CALayer* (^)(CGFloat ))lx_borderWidth;
- (CALayer* (^)(BOOL    ))lx_masksToBounds;
- (CALayer* (^)(UIColor*))lx_borderColor;

#pragma mark --- layer 常见方法
- (CALayer* (^)(CALayer*))lx_addSublayer;
- (CALayer* (^)(CALayer*, unsigned))lx_insertSublayerAtIndex;
- (CALayer* (^)(CALayer*, CALayer*))lx_insertSublayerBelowIndex;
- (CALayer* (^)(CALayer*, CALayer*))lx_insertSublayerAboveIndex;
- (CALayer* (^)(CALayer*, CALayer*))lx_replaceOldSublayerToNew;

- (CGPoint (^)(CGPoint, CALayer*))lx_convertPointFromLayer;
- (CGPoint (^)(CGPoint, CALayer*))lx_convertPointToLayer;
- (CGRect  (^)(CGRect,  CALayer*))lx_convertRectFromLayer;
- (CGRect  (^)(CGRect,  CALayer*))lx_convertRectToLayer;

- (BOOL (^)(CGPoint))lx_containsPoint;

- (CALayer* (^)(void))lx_setNeedsDisplay;
- (CALayer* (^)(CGRect))lx_setNeedsDisplayInRect;
- (CALayer* (^)(CAAnimation*, NSString*))lx_addAnimationForKey;
- (CALayer* (^)(void))lx_removeAllAnimations;
- (CALayer* (^)(NSString*))lx_removeAnimationForKey;

- (NSArray<NSString*>* (^)(void))lx_animationKeys;
- (CAAnimation* (^)(NSString*))lx_animationForKey;

///调用此方法，必须在代理对象被销毁前设为nil，否则会出现野指针错误
- (CALayer* (^)(id<CALayerDelegate>))lx_delegate;


#pragma mark --- gradient layer

/**
 @abstract 颜色渐变类型
 - LXGradientDirectionUpToDown: 从上到小
 - LXGradientDirectionDownToUp: 从下到上
 - LXGradientDirectionLeftToRight: 从左到右
 - LXGradientDirectionRightToLeft: 从右到左
 - LXGradientDirectionUpLeftToDownRight: 左上到右下
 - LXGradientDirectionUpRightToDownLeft: 右上到左下
 - LXGradientDirectionDownLeftToUpRight: 左下到右上
 - LXGradientDirectionDownRightToUpLeft: 右下到左上
 */
typedef NS_ENUM(NSInteger,LXGradientDirection) {
    
    LXGradientDirectionUpToDown = 0,
    LXGradientDirectionDownToUp = 1,
    LXGradientDirectionLeftToRight = 2,
    LXGradientDirectionRightToLeft = 3,
    
    LXGradientDirectionUpLeftToDownRight = 4,
    LXGradientDirectionUpRightToDownLeft = 5,
    LXGradientDirectionDownLeftToUpRight = 6,
    LXGradientDirectionDownRightToUpLeft = 7
};


/**
 创建一个渐变图层，从左到右的渐变，
 @abstract CGRect: 尺寸和位置,NSArray<UIColor*>*: 颜色数组，非空,NSArray<NSNumber*>*: 颜色数组对应的坐标位置数组,非空
 @warning 数组不能为空，且2个数组的个数需一致
 */
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>* _Nonnull, NSArray<NSNumber*>* _Nonnull))lx_gradientLayerForLR;

/**
 创建一个渐变图层，从右到左的渐变，
 @abstract CGRect: 尺寸和位置,NSArray<UIColor*>*: 颜色数组，非空,NSArray<NSNumber*>*: 颜色数组对应的坐标位置数组,非空
 @warning 数组不能为空，且2个数组的个数需一致
 */
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>* _Nonnull, NSArray<NSNumber*>* _Nonnull))lx_gradientLayerForRL;

/**
 创建一个渐变图层，从上到下的渐变，
 @abstract CGRect: 尺寸和位置,NSArray<UIColor*>*: 颜色数组，非空,NSArray<NSNumber*>*: 颜色数组对应的坐标位置数组,非空
 @warning 数组不能为空，且2个数组的个数需一致
 */
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>* _Nonnull, NSArray<NSNumber*>* _Nonnull))lx_gradientLayerForUD;

/**
 创建一个渐变图层，从下到上的渐变，
 @abstract CGRect: 尺寸和位置,NSArray<UIColor*>*: 颜色数组，非空,NSArray<NSNumber*>*: 颜色数组对应的坐标位置数组,非空
 @warning 数组不能为空，且2个数组的个数需一致
 */
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>* _Nonnull, NSArray<NSNumber*>* _Nonnull))lx_gradientLayerForDU;

/**
 创建一个渐变图层，从左上到右下的渐变，
 @abstract CGRect: 尺寸和位置,NSArray<UIColor*>*: 颜色数组，非空,NSArray<NSNumber*>*: 颜色数组对应的坐标位置数组,非空
 @warning 数组不能为空，且2个数组的个数需一致
 */
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>* _Nonnull, NSArray<NSNumber*>* _Nonnull))lx_gradientLayerForLURD;

/**
 创建一个渐变图层，从右上到左下的渐变，
 @abstract CGRect: 尺寸和位置,NSArray<UIColor*>*: 颜色数组，非空,NSArray<NSNumber*>*: 颜色数组对应的坐标位置数组,非空
 @warning 数组不能为空，且2个数组的个数需一致
 */
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>* _Nonnull, NSArray<NSNumber*>* _Nonnull))lx_gradientLayerForRULD;

/**
 创建一个渐变图层，从左下到右上的渐变，
 @abstract CGRect: 尺寸和位置,NSArray<UIColor*>*: 颜色数组，非空,NSArray<NSNumber*>*: 颜色数组对应的坐标位置数组,非空
 @warning 数组不能为空，且2个数组的个数需一致
 */
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>* _Nonnull, NSArray<NSNumber*>* _Nonnull))lx_gradientLayerForLDRU;

/**
 创建一个渐变图层，从右下到左上的渐变，
 @abstract CGRect: 尺寸和位置,NSArray<UIColor*>*: 颜色数组，非空,NSArray<NSNumber*>*: 颜色数组对应的坐标位置数组,非空
 @warning 数组不能为空，且2个数组的个数需一致
 */
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>* _Nonnull, NSArray<NSNumber*>* _Nonnull))lx_gradientLayerForRDLU;

/**
 创建一个渐变图层，
 @abstract CGRect: 尺寸和位置,NSArray<UIColor*>*: 颜色数组，非空,NSArray<NSNumber*>*: 颜色数组对应的坐标位置数组,非空 \
           LXGradientDirection: 指明渐变的方向
 @warning 数组不能为空，且2个数组的个数需一致
 */
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>* _Nonnull, NSArray<NSNumber*>* _Nonnull, LXGradientDirection))lx_gradientLayer;

/**
 创建一个渐变的文本layer,采用的是渐变layer的mask属性来合成渐变色文本
 @abstract CGRect: 尺寸和位置,NSString: 文本内容, UIFont: 文本字体大小, NSArray<UIColor*>*: 颜色数组，非空,NSArray<NSNumber*>*: 颜色数组对应的坐标位置数组,非空 \
 LXGradientDirection: 指明渐变的方向
 @warning 数组不能为空，且2个数组的个数需一致
 */
+ (CAGradientLayer* (^)(CGRect, NSString*, UIFont*, NSArray<UIColor*>* _Nonnull, NSArray<NSNumber*>* _Nonnull, LXGradientDirection))lx_gradientTextLayer;



@end

NS_ASSUME_NONNULL_END
