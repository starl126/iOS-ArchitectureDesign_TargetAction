//
//  CALayer+LX.m
//  test
//
//  Created by 天边的星星 on 2019/4/25.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "CALayer+LX.h"
#import <CoreText/CoreText.h>

@implementation CALayer (chain)

#pragma mark --- layer常见属性
- (CALayer* (^)(CGRect))lx_frame {
    return ^(CGRect frame) {
        self.frame = frame;
        return self;
    };
}
- (CALayer* (^)(CGRect))lx_bounds {
    return ^(CGRect bounds) {
        self.bounds = bounds;
        return self;
    };
}
- (CALayer* (^)(CGPoint))lx_position {
    return ^(CGPoint position) {
        self.position = position;
        return self;
    };
}
- (CALayer* (^)(CGFloat))lx_zPosition {
    return ^(CGFloat zPosition) {
        self.zPosition = zPosition;
        return self;
    };
}
- (CALayer* (^)(CGPoint))lx_anchorPoint {
    return ^(CGPoint value) {
        self.anchorPoint = value;
        return self;
    };
}
- (CALayer* (^)(CGFloat))lx_anchorPointZ {
    return ^(CGFloat value) {
        self.anchorPointZ = value;
        return self;
    };
}
- (CALayer* (^)(CATransform3D))lx_transform {
    return ^(CATransform3D value) {
        self.transform = value;
        return self;
    };
}
- (CALayer* (^)(BOOL))lx_hidden {
    return ^(BOOL value) {
        self.hidden = value;
        return self;
    };
}
- (CALayer* (^)(CGFloat))lx_cornerRadius {
    return ^(CGFloat radius) {
        self.cornerRadius = radius;
        return self;
    };
}
- (CALayer* (^)(CGFloat))lx_borderWidth {
    return ^(CGFloat width) {
        self.borderWidth = width;
        return self;
    };
}
- (CALayer* (^)(BOOL))lx_masksToBounds {
    return ^(BOOL masks) {
        self.masksToBounds = masks;
        return self;
    };
}
- (CALayer* (^)(UIColor*))lx_borderColor {
    return ^(UIColor* color) {
        self.borderColor = color.CGColor;
        return self;
    };
}
- (CALayer* (^)(BOOL))lx_opaque{
    return ^(BOOL value) {
        self.opaque = value;
        return self;
    };
}
- (CALayer* (^)(id))lx_contents {
    return ^(id value) {
        self.contents = value;
        return self;
    };
}
- (CALayer* (^)(CGRect))lx_contentsRect {
    return ^(CGRect value) {
        self.contentsRect = value;
        return self;
    };
}
- (CALayer* (^)(CGFloat))lx_contentsScale {
    return ^(CGFloat value) {
        self.contentsScale = value;
        return self;
    };
}
- (CALayer* (^)(CGRect))lx_contentsCenter {
    return ^(CGRect value) {
        self.contentsCenter = value;
        return self;
    };
}
- (CALayer* (^)(UIColor*))lx_backgroundColor {
    return ^(UIColor* value) {
        self.backgroundColor = value.CGColor;
        return self;
    };
}
- (CALayer* (^)(CALayerContentsGravity))lx_contentsGravity {
    return ^(CALayerContentsGravity value) {
        self.contentsGravity = value;
        return self;
    };
}
- (CALayer* (^)(BOOL))lx_shouldRasterize {
    return ^(BOOL value) {
        self.shouldRasterize = value;
        return self;
    };
}
- (CALayer* (^)(CGFloat))lx_rasterizationScale {
    return ^(CGFloat value) {
        self.rasterizationScale = value;
        return self;
    };
}
- (CALayer* (^)(UIColor*))lx_shadowColor {
    return ^(UIColor* value) {
        self.shadowColor = value.CGColor;
        return self;
    };
}
- (CALayer* (^)(float))lx_shadowOpacity {
    return ^(float value) {
        self.shadowOpacity = value;
        return self;
    };
}
- (CALayer* (^)(CGSize))lx_shadowOffset {
    return ^(CGSize value) {
        self.shadowOffset = value;
        return self;
    };
}
- (CALayer* (^)(CGFloat))lx_shadowRadius {
    return ^(CGFloat value) {
        self.shadowRadius = value;
        return self;
    };
}
- (CALayer* (^)(CGPathRef))lx_shadowPath {
    return ^(CGPathRef value) {
        self.shadowPath = value;
        return self;
    };
}

#pragma mark --- layer常见方法
- (CALayer* (^)(CALayer*))lx_addSublayer {
    return ^(CALayer* value) {
        [self addSublayer:value];
        return self;
    };
}
- (CALayer* (^)(CALayer*, unsigned))lx_insertSublayerAtIndex {
    return ^(CALayer* value, unsigned idx) {
        [self insertSublayer:value atIndex:idx];
        return self;
    };
}
- (CALayer* (^)(CALayer*, CALayer*))lx_insertSublayerBelowIndex {
    return ^(CALayer* value1, CALayer* value2) {
        [self insertSublayer:value1 below:value2];
        return self;
    };
}
- (CALayer* (^)(CALayer*, CALayer*))lx_insertSublayerAboveIndex {
    return ^(CALayer* value1, CALayer* value2) {
        [self insertSublayer:value1 above:value2];
        return self;
    };
}
- (CALayer* (^)(CALayer*, CALayer*))lx_replaceOldSublayerToNew {
    return ^(CALayer* value1, CALayer* value2) {
        [self replaceSublayer:value1 with:value2];
        return self;
    };
}
- (CGPoint (^)(CGPoint, CALayer*))lx_convertPointFromLayer {
    return ^(CGPoint value, CALayer* layer) {
        CGPoint convert = [self convertPoint:value fromLayer:layer];
        return convert;
    };
}
- (CGPoint (^)(CGPoint, CALayer*))lx_convertPointToLayer {
    return ^(CGPoint p, CALayer* layer) {
        return [self convertPoint:p toLayer:layer];
    };
}
- (CGRect (^)(CGRect, CALayer*))lx_convertRectFromLayer {
    return ^(CGRect value, CALayer* layer) {
        return [self convertRect:value fromLayer:layer];
    };
}
- (CGRect (^)(CGRect, CALayer*))lx_convertRectToLayer {
    return ^(CGRect value, CALayer* layer) {
        return [self convertRect:value toLayer:layer];
    };
}
- (BOOL (^)(CGPoint))lx_containsPoint {
    return ^(CGPoint value) {
        return [self containsPoint:value];
    };
}
- (CALayer* (^)(void))lx_setNeedsDisplay {
    return ^() {
        [self setNeedsDisplay];
        return self;
    };
}
- (CALayer* (^)(CGRect))lx_setNeedsDisplayInRect {
    return ^(CGRect value) {
        [self setNeedsDisplayInRect:value];
        return self;
    };
}
- (CALayer* (^)(CAAnimation*, NSString*))lx_addAnimationForKey {
    return ^(CAAnimation* ani, NSString* key) {
        [self addAnimation:ani forKey:key];
        return self;
    };
}
- (CALayer* (^)(void))lx_removeAllAnimations {
    return ^() {
        [self removeAllAnimations];
        return self;
    };
}
- (CALayer* (^)(NSString*))lx_removeAnimationForKey {
    return ^(NSString* value) {
        [self removeAnimationForKey:value];
        return self;
    };
}
- (NSArray<NSString*>* (^)(void))lx_animationKeys {
    return ^() {
        return [self animationKeys];
    };
}
- (CAAnimation* (^)(NSString*))lx_animationForKey {
    return ^(NSString* key) {
        return [self animationForKey:key];
    };
}
- (CALayer* (^)(id<CALayerDelegate>))lx_delegate {
    return ^(id<CALayerDelegate> value) {
        self.delegate = value;
        return self;
    };
}

#pragma mark --- gradient layer
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>*, NSArray<NSNumber*>*))lx_gradientLayerForLR {
    return ^(CGRect frame, NSArray<UIColor*>* colors, NSArray<NSNumber*>* locations) {
        return CALayer.lx_gradientLayer(frame, colors, locations, LXGradientDirectionLeftToRight);
    };
}
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>*, NSArray<NSNumber*>*))lx_gradientLayerForRL {
    return ^(CGRect frame, NSArray<UIColor*>* colors, NSArray<NSNumber*>* locations){
        return CALayer.lx_gradientLayer(frame, colors, locations, LXGradientDirectionRightToLeft);
    };
}
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>*, NSArray<NSNumber*>*))lx_gradientLayerForUD {
    return ^(CGRect frame, NSArray<UIColor*>* colors, NSArray<NSNumber*>* locations) {
        return CALayer.lx_gradientLayer(frame, colors, locations, LXGradientDirectionUpToDown);
    };
}
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>*, NSArray<NSNumber*>*))lx_gradientLayerForDU {
    return ^(CGRect frame, NSArray<UIColor*>* colors, NSArray<NSNumber*>* locations) {
        return CALayer.lx_gradientLayer(frame, colors, locations, LXGradientDirectionDownToUp);
    };
}
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>*, NSArray<NSNumber*>*))lx_gradientLayerForLURD {
    return ^(CGRect frame, NSArray<UIColor*>* colors, NSArray<NSNumber*>* locations) {
        return CALayer.lx_gradientLayer(frame, colors, locations, LXGradientDirectionUpLeftToDownRight);
    };
}
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>*, NSArray<NSNumber*>*))lx_gradientLayerForRULD {
    return ^(CGRect frame, NSArray<UIColor*>* colors, NSArray<NSNumber*>* locations) {
        return CALayer.lx_gradientLayer(frame, colors, locations, LXGradientDirectionUpRightToDownLeft);
    };
}
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>*, NSArray<NSNumber*>*))lx_gradientLayerForLDRU {
    return ^(CGRect frame, NSArray<UIColor*>* colors, NSArray<NSNumber*>* locations) {
        return CALayer.lx_gradientLayer(frame, colors, locations, LXGradientDirectionDownLeftToUpRight);
    };
}
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>*, NSArray<NSNumber*>*))lx_gradientLayerForRDLU {
    return ^(CGRect frame, NSArray<UIColor*>* colors, NSArray<NSNumber*>* locations) {
        return CALayer.lx_gradientLayer(frame, colors, locations, LXGradientDirectionDownRightToUpLeft);
    };
}
+ (CAGradientLayer* (^)(CGRect, NSArray<UIColor*>*, NSArray<NSNumber*>*, LXGradientDirection))lx_gradientLayer {
    
    return ^(CGRect frame, NSArray<UIColor*>* colors, NSArray<NSNumber*>* locations, LXGradientDirection direction) {
        
        NSMutableArray* arrM = NSMutableArray.array;
        [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrM addObject:(__bridge id)obj.CGColor];
        }];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = frame;
        gradientLayer.colors = arrM.copy;
        gradientLayer.locations = locations;
        CGPoint start,end;
        
        switch (direction) {
            case LXGradientDirectionUpToDown:
            {
                start = CGPointZero;
                end   = CGPointMake(0, 1);
            }
                break;
            case LXGradientDirectionDownToUp:
            {
                start = CGPointMake(0, 1);
                end   = CGPointZero;
            }
                break;
            case LXGradientDirectionLeftToRight:
            {
                start = CGPointZero;
                end   = CGPointMake(1, 0);
            }
                break;
            case LXGradientDirectionRightToLeft:
            {
                start = CGPointMake(1, 0);
                end   = CGPointZero;
            }
                break;
            case LXGradientDirectionUpLeftToDownRight:
            {
                start = CGPointZero;
                end   = CGPointMake(1, 1);
            }
                break;
            case LXGradientDirectionUpRightToDownLeft:
            {
                start = CGPointMake(1, 0);
                end   = CGPointMake(0, 1);
            }
                break;
            case LXGradientDirectionDownLeftToUpRight:
            {
                start = CGPointMake(0, 1);
                end   = CGPointMake(1, 0);
            }
                break;
            case LXGradientDirectionDownRightToUpLeft:
            {
                start = CGPointMake(1, 1);
                end   = CGPointZero;
            }
                break;
            default:
                break;
        }
        
        gradientLayer.startPoint = start;
        gradientLayer.endPoint   = end;
        
        return gradientLayer;
    };
}
+ (CAGradientLayer* (^)(CGRect, NSString*, UIFont*, NSArray<UIColor*>*, NSArray<NSNumber*>*, LXGradientDirection))lx_gradientTextLayer {
    return ^(CGRect frame, NSString* text, UIFont* textFont, NSArray<UIColor*>* colors, NSArray<NSNumber*>* locations, LXGradientDirection direction) {
        CAGradientLayer* gradientLayer = CALayer.lx_gradientLayer(frame,colors, locations, direction);
        
        //创建mask layer
        CATextLayer* textLayer = [[CATextLayer alloc] init];
        textLayer.frame = frame;
        textLayer.string = text;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.contentsScale = UIScreen.mainScreen.scale;
        textLayer.truncationMode = kCATruncationEnd;
        
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)textFont.fontName, textFont.pointSize, NULL);
        textLayer.font = fontRef;
        textLayer.fontSize = textFont.pointSize;
        textLayer.foregroundColor = UIColor.redColor.CGColor;
        
        //设置mask layer
        gradientLayer.mask = textLayer;
        
        //释放字体
        CFRelease(fontRef);
        
        return gradientLayer;
    };
}

@end
