//
//  UIView+LX.m
//  test
//
//  Created by 天边的星星 on 2019/4/26.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "UIView+LX.h"

@implementation UIView (chain)

#pragma mark --- frame 相关属性
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}
- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}
- (void)setBottom:(CGFloat)bottom {
    self.y = bottom-self.height;
}
- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}
- (void)setRight:(CGFloat)right {
    self.x = right-self.width;
}

#pragma mark --- chain methods
- (UIView* (^)(CGFloat))lx_x {
    return ^(CGFloat value) {
        CGRect frame = self.frame;
        self.frame = CGRectMake(value, frame.origin.y, frame.size.width, frame.size.height);
        return self;
    };
}
- (UIView* (^)(CGFloat))lx_y {
    return ^(CGFloat value) {
        CGRect frame = self.frame;
        self.frame = CGRectMake(frame.origin.x, value, frame.size.width, frame.size.height);
        return self;
    };
}
- (UIView* (^)(CGFloat))lx_width {
    return ^(CGFloat value) {
        CGRect frame = self.frame;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, value, frame.size.height);
        return self;
    };
}
- (UIView* (^)(CGFloat))lx_height {
    return ^(CGFloat value) {
        CGRect frame = self.frame;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, value);
        return self;
    };
}
- (UIView* (^)(CGSize))lx_size {
    return ^(CGSize size) {
        CGRect frame = self.frame;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
        return self;
    };
}
- (UIView* (^)(CGPoint))lx_center {
    return ^(CGPoint point) {
        self.center = point;
        return self;
    };
}
- (UIView* (^)(CGFloat))lx_centerX {
    return ^(CGFloat value) {
        self.center = CGPointMake(value, self.center.y);
        return self;
    };
}
- (UIView* (^)(CGFloat))lx_centerY {
    return ^(CGFloat value) {
        self.center = CGPointMake(self.center.x, value);
        return self;
    };
}
- (UIView* (^)(CGPoint))lx_origin {
    return ^(CGPoint point) {
        self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
        return self;
    };
}
- (UIView* (^)(CGFloat))lx_bottom {
    return ^(CGFloat value) {
        self.frame = CGRectMake(self.frame.origin.x, value-self.frame.size.height, self.frame.size.width, self.frame.size.height);
        return self;
    };
}
- (UIView* (^)(CGFloat))lx_right {
    return ^(CGFloat value) {
        self.frame = CGRectMake(value-self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        return self;
    };
}
- (UIView* (^)(CGRect))lx_frame {
    return ^(CGRect value) {
        self.frame = value;
        return self;
    };
}
- (UIView* (^)(CGRect))lx_bounds {
    return ^(CGRect value) {
        self.bounds = value;
        return self;
    };
}
- (UIView* (^)(CGAffineTransform))lx_transform {
    return ^(CGAffineTransform value) {
        self.transform = value;
        return self;
    };
}

- (UIView* (^)(BOOL))lx_clipsToBounds {
    return ^(BOOL value) {
        self.clipsToBounds = value;
        return self;
    };
}
- (UIView* (^)(BOOL))lx_opaque {
    return ^(BOOL value) {
        self.opaque = value;
        return self;
    };
}
- (UIView* (^)(BOOL))lx_hidden {
    return ^(BOOL value) {
        self.hidden = value;
        return self;
    };
}
- (UIView* (^)(UIColor*))lx_backgroundColor {
    return ^(UIColor* color) {
        self.backgroundColor = color;
        return self;
    };
}
- (UIView* (^)(CGFloat))lx_alpha {
    return ^(CGFloat value) {
        self.alpha = value;
        return self;
    };
}
- (UIView* (^)(UIViewContentMode))lx_contentMode {
    return ^(UIViewContentMode value) {
        self.contentMode = value;
        return self;
    };
}
- (CGPoint (^)(CGPoint, UIView*))lx_convertPointToView {
    return ^(CGPoint p, UIView* v) {
        return [self convertPoint:p toView:v];
    };
}
- (CGPoint (^)(CGPoint, UIView*))lx_convertPointFromView {
    return ^(CGPoint p, UIView* v) {
        return [self convertPoint:p fromView:v];
    };
}
- (CGRect (^)(CGRect, UIView*))lx_convertRectToView {
    return ^(CGRect rect, UIView* v) {
        return [self convertRect:rect toView:v];
    };
}
- (CGRect  (^)(CGRect,  UIView*))lx_convertRectFromView {
    return ^(CGRect rect, UIView* v) {
        return [self convertRect:rect fromView:v];
    };
}
- (CGSize (^)(CGSize))lx_sizeThatFits {
    return ^(CGSize value) {
        return [self sizeThatFits:value];
    };
}
- (UIView* (^)(void))lx_sizeToFit {
    return ^() {
        [self sizeToFit];
        return self;
    };
}
- (void (^)(void))lx_removeFromSuperview {
    return ^ {
        [self removeFromSuperview];
    };
}
- (UIView* (^)(UIView*, NSInteger))lx_insertSubviewAtIndex {
    return ^(UIView* v, NSInteger idx) {
        [self insertSubview:v atIndex:idx];
        return self;
    };
}
- (UIView* (^)(NSInteger, NSInteger))lx_exchangeSubviewWithIndex {
    return ^(NSInteger idx1, NSInteger idx2) {
        [self exchangeSubviewAtIndex:idx1 withSubviewAtIndex:idx2];
        return self;
    };
}
- (UIView* (^)(UIView*))lx_addSubview {
    return ^(UIView* v) {
        [self addSubview:v];
        return self;
    };
}
- (UIView* (^)(UIView*, UIView*))lx_insertSubviewBelowSubview {
    return ^(UIView* v1, UIView* v2) {
        [self insertSubview:v1 belowSubview:v2];
        return self;
    };
}
- (UIView* (^)(UIView*, UIView*))lx_insertSubviewAboveSubview {
    return ^(UIView* v1, UIView* v2) {
        [self insertSubview:v1 aboveSubview:v2];
        return self;
    };
}
- (UIView* (^)(UIView*))lx_bringSubViewToFront {
    return ^(UIView* v) {
        [self bringSubviewToFront:v];
        return self;
    };
}
- (UIView* (^)(UIView*))lx_sendSubviewToBack {
    return ^(UIView* v) {
        [self sendSubviewToBack:v];
        return self;
    };
}
- (BOOL (^)(UIView*))lx_isDescendantOfView {
    return ^(UIView* v) {
        return [self isDescendantOfView:v];
    };
}
- (UIView* (^)(void))lx_setNeedsLayout {
    return ^ {
        [self setNeedsLayout];
        return self;
    };
}
- (UIView* (^)(void))lx_layoutIfNeeded {
    return ^ {
        [self layoutIfNeeded];
        return self;
    };
}
- (UIView* (^)(UIEdgeInsets))lx_layoutMargins {
    return ^(UIEdgeInsets inset) {
        self.layoutMargins = inset;
        return self;
    };
}
- (UIView* (^)(void))lx_setNeedsDisplay {
    return ^() {
        [self setNeedsDisplay];
        return self;
    };
}
- (UIView* (^)(CGRect))lx_setNeedsDisplayInRect {
    return ^(CGRect rect) {
        [self setNeedsDisplayInRect:rect];
        return self;
    };
}
- (UIView* (^)(UIView*))lx_maskView {
    return ^(UIView* v) {
        self.maskView = v;
        return self;
    };
}
- (UIView* (^)(UIColor*))lx_tintColor {
    return ^(UIColor* color) {
        self.tintColor = color;
        return self;
    };
}
+ (void (^)(NSString*, void* _Nullable ))lx_beginAnimationIDInContext {
    return ^(NSString* animaId, void* context) {
        [self beginAnimations:animaId context:context];
    };
}
+ (void (^)(void))lx_commitAnimations {
    return ^ {
        [self commitAnimations];
    };
}
+ (void (^)(id _Nullable))lx_setAnimationDelegate {
    return ^(id delegate) {
        [self setAnimationDelegate:delegate];
    };
}
+ (void (^)(SEL _Nullable ))lx_setAnimationWillStartSelector {
    return ^(SEL sel) {
        [self setAnimationWillStartSelector:sel];
    };
}
+ (void (^)(SEL _Nullable ))lx_setAnimationDidStopSelector {
    return ^(SEL sel) {
        [self setAnimationDidStopSelector:sel];
    };
}
+ (void (^)(NSTimeInterval))lx_setAnimationDuration {
    return ^(NSTimeInterval value) {
        [self setAnimationDuration:value];
    };
}
+ (void (^)(NSTimeInterval))lx_setAnimationDelay {
    return ^(NSTimeInterval value) {
        [self setAnimationDelay:value];
    };
}
+ (void (^)(NSDate*))lx_setAnimationStartDate {
    return ^(NSDate* value) {
        [self setAnimationStartDate:value];
    };
}
+ (void (^)(UIViewAnimationCurve))lx_setAnimationCurve {
    return ^(UIViewAnimationCurve curve) {
        [self setAnimationCurve:curve];
    };
}
+ (void (^)(float))lx_setAnimationRepeatCount {
    return ^(float value) {
        [self setAnimationRepeatCount:value];
    };
}
+ (void (^)(BOOL))lx_setAnimationRepeatAutoreverses {
    return ^(BOOL value) {
        [self setAnimationRepeatAutoreverses:value];
    };
}
+ (void (^)(BOOL))lx_setAnimationBeginsFromCurrentState {
    return ^(BOOL value) {
        [self setAnimationBeginsFromCurrentState:value];
    };
}
+ (void (^)(UIViewAnimationTransition, UIView*, BOOL))lx_setAnimationTransitionForViewWithCache {
    return ^(UIViewAnimationTransition transition, UIView* v, BOOL cache) {
        [self setAnimationTransition:transition forView:v cache:cache];
    };
}
+ (void (^)(BOOL))lx_setAnimationsEnabled {
    return ^(BOOL enable) {
        [self setAnimationsEnabled:enable];
    };
}
+ (void (^)(dispatch_block_t))lx_performWithoutAnimationInActions {
    return ^(dispatch_block_t block) {
        [self performWithoutAnimation:block];
    };
}
+ (void (^)(NSTimeInterval, NSTimeInterval, UIViewAnimationOptions, dispatch_block_t, LXAnimationBOOLCompletion))lx_animateWithDurationDelayOptionsAnimationsCompletion {
    return ^(NSTimeInterval durantion, NSTimeInterval delay, UIViewAnimationOptions opts, dispatch_block_t animations, LXAnimationBOOLCompletion completion) {
        [self animateWithDuration:durantion delay:delay options:opts animations:animations completion:completion];
    };
}
+ (void (^)(NSTimeInterval, dispatch_block_t, LXAnimationBOOLCompletion))lx_animateWithDurationAnimationsCompletion {
    return ^(NSTimeInterval dura, dispatch_block_t animations, LXAnimationBOOLCompletion completion) {
        [self animateWithDuration:dura animations:animations completion:completion];
    };
}
+ (void (^)(NSTimeInterval, dispatch_block_t))lx_animateWithDurationAnimations {
    return ^(NSTimeInterval dura, dispatch_block_t animations) {
        [self animateWithDuration:dura animations:animations];
    };
}
+ (void (^)(NSTimeInterval, NSTimeInterval, CGFloat, CGFloat, UIViewAnimationOptions, dispatch_block_t, LXAnimationBOOLCompletion))lx_animateWithDurationDelayDampVelocityOptionsAnimationsCompletion {
    return ^(NSTimeInterval dura, NSTimeInterval delay, CGFloat damp, CGFloat velocity, UIViewAnimationOptions opt, dispatch_block_t ani, LXAnimationBOOLCompletion com) {
        [self animateWithDuration:dura delay:delay usingSpringWithDamping:damp initialSpringVelocity:velocity options:opt animations:ani completion:com];
    };
}
+ (void (^)(UIView*, NSTimeInterval, UIViewAnimationOptions, dispatch_block_t, LXAnimationBOOLCompletion))lx_transitionWithViewDurationOptionsAnimationsCompletion {
    return ^(UIView* v, NSTimeInterval dura, UIViewAnimationOptions opt, dispatch_block_t anim, LXAnimationBOOLCompletion com) {
        [self transitionWithView:v duration:dura options:opt animations:anim completion:com];
    };
}
+ (void (^)(UIView*, UIView*, NSTimeInterval dura, UIViewAnimationOptions opt, LXAnimationBOOLCompletion))lx_transitionFromViewToViewDurationOptionsCompletion {
    
    return ^(UIView* fromV, UIView* toView, NSTimeInterval dura, UIViewAnimationOptions opt, LXAnimationBOOLCompletion com) {
        [self transitionFromView:fromV toView:toView duration:dura options:opt completion:com];
    };
}
+ (void (^)(UISystemAnimation, NSArray<UIView*>*, UIViewAnimationOptions, dispatch_block_t, LXAnimationBOOLCompletion))lx_performSystemAnimationOnViewsOptionsAnimationsCompletion {
    
    return ^(UISystemAnimation sysAni, NSArray<UIView*>* onViews, UIViewAnimationOptions opt, dispatch_block_t ani, LXAnimationBOOLCompletion com) {
        [self performSystemAnimation:sysAni onViews:onViews options:opt animations:ani completion:com];
    };
}
+ (void (^)(NSTimeInterval, NSTimeInterval, UIViewKeyframeAnimationOptions, dispatch_block_t, LXAnimationBOOLCompletion))lx_animateKeyframesWithDurationDelayOptionsAnimationsCompletion {
    
    return ^(NSTimeInterval dura, NSTimeInterval delay, UIViewKeyframeAnimationOptions opt, dispatch_block_t ani, LXAnimationBOOLCompletion com) {
        [self animateKeyframesWithDuration:dura delay:delay options:opt animations:ani completion:com];
    };
}
+ (void (^)(double, double, dispatch_block_t))lx_addKeyframeWithRelativeStartTimeDurationAnimations {
    
    return ^(double frameStartTime, double frameDuration, dispatch_block_t anim) {
        [self addKeyframeWithRelativeStartTime:frameStartTime relativeDuration:frameDuration animations:anim];
    };
}
- (UIView* (^)(UIGestureRecognizer*))lx_addGestureRecognizer {
    return ^(UIGestureRecognizer* gesture) {
        [self addGestureRecognizer:gesture];
        return self;
    };
}
- (UIView* (^)(UIGestureRecognizer*))lx_removeGestureRecognizer {
    return ^(UIGestureRecognizer* gesture) {
        [self removeGestureRecognizer:gesture];
        return self;
    };
}
- (CGSize (^)(CGSize))lx_systemLayoutSizeFittingSize {
    return ^(CGSize size) {
        return [self systemLayoutSizeFittingSize:size];
    };
}
- (CGSize (^)(CGSize, UILayoutPriority, UILayoutPriority))lx_systemLayoutSizeFittingSizeHorizonPriorityVerticalPriority {
    return ^(CGSize size, UILayoutPriority horizonPriority, UILayoutPriority verticalPriority) {
        return [self systemLayoutSizeFittingSize:size withHorizontalFittingPriority:horizonPriority verticalFittingPriority:verticalPriority];
    };
}
- (UIView* (^)(BOOL))lx_snapshotViewAfterScreenUpdates {
    return ^(BOOL updates) {
        return [self snapshotViewAfterScreenUpdates:updates];
    };
}
- (UIView* (^)(CGRect, BOOL, UIEdgeInsets))lx_resizableSnapshotViewFromRectAfterUpdatesCapInsets {
    return ^(CGRect rect, BOOL updates, UIEdgeInsets insets) {
        return [self resizableSnapshotViewFromRect:rect afterScreenUpdates:updates withCapInsets:insets];
    };
}


@end

@implementation UILabel (chain)

- (UILabel* (^)(NSString*))lx_text {
    return ^(NSString* value) {
        self.text = value;
        return self;
    };
}
- (UILabel* (^)(UIFont*))lx_font {
    return ^(UIFont* value) {
        self.font = value;
        return self;
    };
}
- (UILabel* (^)(UIColor*))lx_textColor {
    return ^(UIColor* value) {
        self.textColor = value;
        return self;
    };
}
- (UILabel* (^)(UIColor*))lx_shadowColor {
    return ^(UIColor* value) {
        self.shadowColor = value;
        return self;
    };
}
- (UILabel* (^)(CGSize))lx_shadowOffset {
    return ^(CGSize value) {
        self.shadowOffset = value;
        return self;
    };
}
- (UILabel* (^)(NSTextAlignment))lx_textAlignment {
    return ^(NSTextAlignment value) {
        self.textAlignment = value;
        return self;
    };
}
- (UILabel* (^)(NSLineBreakMode))lx_lineBreakMode {
    return ^(NSLineBreakMode value) {
        self.lineBreakMode = value;
        return self;
    };
}
- (UILabel* (^)(NSAttributedString*))lx_attributedText {
    return ^(NSAttributedString* value) {
        self.attributedText = value;
        return self;
    };
}
- (UILabel* (^)(UIColor*))lx_highlightedTextColor {
    return ^(UIColor* value) {
        self.highlightedTextColor = value;
        return self;
    };
}
- (UILabel* (^)(BOOL))lx_highlighted {
    return ^(BOOL value) {
        self.highlighted = value;
        return self;
    };
}
- (UILabel* (^)(BOOL))lx_userInteractionEnabled {
    return ^(BOOL value) {
        self.userInteractionEnabled = value;
        return self;
    };
}
- (UILabel* (^)(BOOL))lx_enabled {
    return ^(BOOL value) {
        self.enabled = value;
        return self;
    };
}
- (UILabel* (^)(NSInteger))lx_numberOfLines {
    return ^(NSInteger value) {
        self.numberOfLines = value;
        return self;
    };
}
- (UILabel* (^)(BOOL))lx_adjustsFontSizeToFitWidth {
    return ^(BOOL value) {
        self.adjustsFontSizeToFitWidth = value;
        return self;
    };
}
- (UILabel* (^)(CGFloat))lx_preferredMaxLayoutWidth {
    return ^(CGFloat value) {
        self.preferredMaxLayoutWidth = value;
        return self;
    };
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (UILabel* (^)(CGFloat))lx_minimumFontSize {
    return ^(CGFloat value) {
        self.minimumFontSize = value;
        return self;
    };
}
- (UILabel* (^)(BOOL))lx_adjustsLetterSpacingToFitWidth {
    return ^(BOOL value) {
        self.adjustsLetterSpacingToFitWidth = value;
        return self;
    };
}
#pragma clang diagnostic pop
- (UILabel* (^)(NSInteger))lx_tag {
    return ^(NSInteger value) {
        self.tag = value;
        return self;
    };
}
- (UILabel* (^)(BOOL))lx_clipsToBounds {
    return ^(BOOL value) {
        self.clipsToBounds = value;
        return self;
    };
}
- (UILabel* (^)(BOOL))lx_opaque {
    return ^(BOOL value) {
        self.opaque = value;
        return self;
    };
}
- (UILabel* (^)(BOOL))lx_hidden {
    return ^(BOOL value) {
        self.hidden = value;
        return self;
    };
}

- (UILabel* (^)(CGFloat))lx_alpha {
    return ^(CGFloat value) {
        self.alpha = value;
        return self;
    };
}
- (UILabel* (^)(UIViewContentMode))lx_contentMode {
    return ^(UIViewContentMode value) {
        self.contentMode = value;
        return self;
    };
}

@end

@implementation UIButton (chain)

- (UIButton* (^)(BOOL))lx_enabled {
    return ^(BOOL value) {
        self.enabled = value;
        return self;
    };
}
- (UIButton* (^)(BOOL))lx_selected {
    return ^(BOOL value) {
        self.selected = value;
        return self;
    };
}
- (UIButton* (^)(BOOL))lx_highlighted {
    return ^(BOOL value) {
        self.highlighted = value;
        return self;
    };
}
- (UIButton* (^)(BOOL))lx_adjustsImageWhenHighlighted {
    return ^(BOOL value) {
        self.adjustsImageWhenHighlighted = value;
        return self;
    };
}
- (UIButton* (^)(BOOL))lx_adjustsImageWhenDisabled {
    return ^(BOOL value) {
        self.adjustsImageWhenDisabled = value;
        return self;
    };
}
- (UIButton* (^)(BOOL))lx_showsTouchWhenHighlighted {
    return ^(BOOL value) {
        self.showsTouchWhenHighlighted = value;
        return self;
    };
}

- (UIButton* (^)(UIControlContentVerticalAlignment))lx_contentVerticalAlignment {
    return ^(UIControlContentVerticalAlignment value) {
        self.contentVerticalAlignment = value;
        return self;
    };
}
- (UIButton* (^)(UIControlContentHorizontalAlignment))lx_contentHorizontalAlignment {
    return ^(UIControlContentHorizontalAlignment value) {
        self.contentHorizontalAlignment = value;
        return self;
    };
}

- (UIButton* (^)(UIEdgeInsets))lx_contentEdgeInsets {
    return ^(UIEdgeInsets value) {
        self.contentEdgeInsets = value;
        return self;
    };
}
- (UIButton* (^)(UIEdgeInsets))lx_titleEdgeInsets {
    return ^(UIEdgeInsets value) {
        self.titleEdgeInsets = value;
        return self;
    };
}
- (UIButton* (^)(UIEdgeInsets))lx_imageEdgeInsets {
    return ^(UIEdgeInsets value) {
        self.imageEdgeInsets = value;
        return self;
    };
}

- (UIButton* (^)(UIColor*))lx_tintColor {
    return ^(UIColor* value) {
        self.tintColor = value;
        return self;
    };
}

- (UIButton* (^)(NSString*))lx_normalTitle {
    return ^(NSString* value) {
        [self setTitle:value forState:UIControlStateNormal];
        return self;
    };
}
- (UIButton* (^)(NSString*))lx_highlightedTitle {
    return ^(NSString* value) {
        [self setTitle:value forState:UIControlStateHighlighted];
        return self;
    };
}
- (UIButton* (^)(NSString*))lx_disabledTitle {
    return ^(NSString* value) {
        [self setTitle:value forState:UIControlStateDisabled];
        return self;
    };
}
- (UIButton* (^)(NSString*))lx_selectedTitle {
    return ^(NSString* value) {
        [self setTitle:value forState:UIControlStateSelected];
        return self;
    };
}

- (UIButton* (^)(UIColor*))lx_normalTitleColor {
    return ^(UIColor* value) {
        [self setTitleColor:value forState:UIControlStateNormal];
        return self;
    };
}
- (UIButton* (^)(UIColor*))lx_highlightedTitleColor {
    return ^(UIColor* value) {
        [self setTitleColor:value forState:UIControlStateHighlighted];
        return self;
    };
}
- (UIButton* (^)(UIColor*))lx_disabledTitleColor {
    return ^(UIColor* value) {
        [self setTitleColor:value forState:UIControlStateDisabled];
        return self;
    };
}
- (UIButton* (^)(UIColor*))lx_selectedTitleColor {
    return ^(UIColor* value) {
        [self setTitleColor:value forState:UIControlStateSelected];
        return self;
    };
}

- (UIButton* (^)(UIColor*))lx_normalTitleShadowColor {
    return ^(UIColor* value) {
        [self setTitleShadowColor:value forState:UIControlStateNormal];
        return self;
    };
}
- (UIButton* (^)(UIColor*))lx_highlightedTitleShadowColor {
    return ^(UIColor* value) {
        [self setTitleShadowColor:value forState:UIControlStateHighlighted];
        return self;
    };
}
- (UIButton* (^)(UIColor*))lx_disabledTitleShadowColor {
    return ^(UIColor* value) {
        [self setTitleShadowColor:value forState:UIControlStateDisabled];
        return self;
    };
}
- (UIButton* (^)(UIColor*))lx_selectedTitleShadowColor {
    return ^(UIColor* value) {
        [self setTitleShadowColor:value forState:UIControlStateSelected];
        return self;
    };
}

- (UIButton* (^)(UIImage*))lx_normalImage {
    return ^(UIImage* value) {
        [self setImage:value forState:UIControlStateNormal];
        return self;
    };
}
- (UIButton* (^)(UIImage*))lx_highlightedImage {
    return ^(UIImage* value) {
        [self setImage:value forState:UIControlStateHighlighted];
        return self;
    };
}
- (UIButton* (^)(UIImage*))lx_disabledImage {
    return ^(UIImage* value) {
        [self setImage:value forState:UIControlStateDisabled];
        return self;
    };
}
- (UIButton* (^)(UIImage*))lx_selectedImage {
    return ^(UIImage* value) {
        [self setImage:value forState:UIControlStateSelected];
        return self;
    };
}

- (UIButton* (^)(UIImage*))lx_normalBackgroundImage {
    return ^(UIImage* value) {
        [self setBackgroundImage:value forState:UIControlStateNormal];
        return self;
    };
}
- (UIButton* (^)(UIImage*))lx_highlightedBackgroundImage {
    return ^(UIImage* value) {
        [self setBackgroundImage:value forState:UIControlStateHighlighted];
        return self;
    };
}
- (UIButton* (^)(UIImage*))lx_disabledBackgroundImage {
    return ^(UIImage* value) {
        [self setBackgroundImage:value forState:UIControlStateDisabled];
        return self;
    };
}
- (UIButton* (^)(UIImage*))lx_selectedBackgroundImage {
    return ^(UIImage* value) {
        [self setBackgroundImage:value forState:UIControlStateSelected];
        return self;
    };
}

- (UIButton* (^)(NSAttributedString*))lx_normalAttributedTitle {
    return ^(NSAttributedString* value) {
        [self setAttributedTitle:value forState:UIControlStateNormal];
        return self;
    };
}
- (UIButton* (^)(NSAttributedString*))lx_highlightedAttributedTitle {
    return ^(NSAttributedString* value) {
        [self setAttributedTitle:value forState:UIControlStateHighlighted];
        return self;
    };
}
- (UIButton* (^)(NSAttributedString*))lx_disabledAttributedTitle {
    return ^(NSAttributedString* value) {
        [self setAttributedTitle:value forState:UIControlStateDisabled];
        return self;
    };
}
- (UIButton* (^)(NSAttributedString*))lx_selectedAttributedTitle {
    return ^(NSAttributedString* value) {
        [self setAttributedTitle:value forState:UIControlStateSelected];
        return self;
    };
}

- (UIButton* (^)(UIFont*))lx_font {
    return ^(UIFont* value) {
        self.titleLabel.font = value;
        return self;
    };
}
- (UIButton* (^)(NSLineBreakMode))lx_lineBreakMode {
    return ^(NSLineBreakMode value) {
        self.titleLabel.lineBreakMode = value;
        return self;
    };
}
- (UIButton* (^)(NSInteger))lx_tag {
    return ^(NSInteger value) {
        self.tag = value;
        return self;
    };
}
- (UIButton* (^)(BOOL))lx_clipsToBounds {
    return ^(BOOL value) {
        self.clipsToBounds = value;
        return self;
    };
}
- (UIButton* (^)(BOOL))lx_opaque {
    return ^(BOOL value) {
        self.opaque = value;
        return self;
    };
}
- (UIButton* (^)(BOOL))lx_hidden {
    return ^(BOOL value) {
        self.hidden = value;
        return self;
    };
}

- (UIButton* (^)(CGFloat))lx_alpha {
    return ^(CGFloat value) {
        self.alpha = value;
        return self;
    };
}
- (UIButton* (^)(UIViewContentMode))lx_contentMode {
    return ^(UIViewContentMode value) {
        self.contentMode = value;
        return self;
    };
}
+ (UIButton* (^)(UIButtonType))lx_buttonWithType {
    return ^(UIButtonType type) {
        return [self buttonWithType:type];
    };
}
- (UIButton* (^)(NSString*, UIControlState))lx_setTitleForState {
    return ^(NSString* text, UIControlState state) {
        [self setTitle:text forState:state];
        return self;
    };
}
- (UIButton* (^)(UIColor*,  UIControlState))lx_setTitleColorForState {
    return ^(UIColor* color, UIControlState state) {
        [self setTitleColor:color forState:state];
        return self;
    };
}
- (UIButton* (^)(UIColor*,  UIControlState))lx_setTitleShadowColorForState {
    return ^(UIColor* color, UIControlState state) {
        [self setTitleShadowColor:color forState:state];
        return self;
    };
}
- (UIButton* (^)(UIImage*,  UIControlState))lx_setImageForState {
    return ^(UIImage* img, UIControlState state) {
        [self setImage:img forState:state];
        return self;
    };
}
- (UIButton* (^)(UIImage*,  UIControlState))lx_setBackgroundImageForState {
    return ^(UIImage* img, UIControlState state) {
        [self setBackgroundImage:img forState:state];
        return self;
    };
}
- (UIButton* (^)(NSAttributedString*, UIControlState))lx_setAttributedTitleForState {
    return ^(NSAttributedString* attText, UIControlState state) {
        [self setAttributedTitle:attText forState:state];
        return self;
    };
}
- (NSString* (^)(UIControlState))lx_titleForState {
    return ^(UIControlState state) {
        return [self titleForState:state];
    };
}
- (UIColor* (^)(UIControlState))lx_titleColorForState {
    return ^(UIControlState state) {
        return [self titleColorForState:state];
    };
}
- (UIColor* (^)(UIControlState))lx_titleShadowColorForState {
    return ^(UIControlState state) {
        return [self titleShadowColorForState:state];
    };
}
- (UIImage* (^)(UIControlState))lx_imageForState {
    return ^(UIControlState state) {
        return [self imageForState:state];
    };
}
- (UIImage* (^)(UIControlState))lx_backgroundImageForState {
    return ^(UIControlState state) {
        return [self backgroundImageForState:state];
    };
}
- (NSAttributedString* (^)(UIControlState))lx_attributedTitleForState {
    return ^(UIControlState state) {
        return [self attributedTitleForState:state];
    };
}

@end

@implementation UITextField (chain)

- (UITextField* (^)(NSString*))lx_text {
    return ^(NSString* value) {
        self.text = value;
        return self;
    };
}
- (UITextField* (^)(NSString*))lx_placeholder {
    return ^(NSString* value) {
        self.placeholder = value;
        return self;
    };
}
- (UITextField* (^)(NSAttributedString*))lx_attributedText {
    return ^(NSAttributedString* value) {
        self.attributedText = value;
        return self;
    };
}
- (UITextField* (^)(NSAttributedString*))lx_attributedPlaceholder {
    return ^(NSAttributedString* value) {
        self.attributedPlaceholder = value;
        return self;
    };
}

- (UITextField* (^)(UIColor*))lx_textColor {
    return ^(UIColor* value) {
        self.textColor = value;
        return self;
    };
}
- (UITextField* (^)(UIFont*))lx_font {
    return ^(UIFont* value) {
        self.font = value;
        return self;
    };
}
- (UITextField* (^)(NSTextAlignment))lx_textAlignment {
    return ^(NSTextAlignment value) {
        self.textAlignment = value;
        return self;
    };
}
- (UITextField* (^)(UITextBorderStyle))lx_borderStyle {
    return ^(UITextBorderStyle value) {
        self.borderStyle = value;
        return self;
    };
}

- (UITextField* (^)(BOOL))lx_clearsOnBeginEditing {
    return ^(BOOL value) {
        self.clearsOnBeginEditing = value;
        return self;
    };
}
- (UITextField* (^)(BOOL))lx_adjustsFontSizeToFitWidth {
    return ^(BOOL value) {
        self.adjustsFontSizeToFitWidth = value;
        return self;
    };
}

- (UITextField* (^)(CGFloat))lx_minimumFontSize {
    return ^(CGFloat value) {
        self.minimumFontSize = value;
        return self;
    };
}
- (UITextField* (^)(UIImage*))lx_background {
    return ^(UIImage* value) {
        self.background = value;
        return self;
    };
}
- (UITextField* (^)(UIImage*))lx_disabledBackground {
    return ^(UIImage* value) {
        self.disabledBackground = value;
        return self;
    };
}

- (UITextField* (^)(UIView*))lx_leftView {
    return ^(UIView* value) {
        self.leftView = value;
        return self;
    };
}
- (UITextField* (^)(UIView*))lx_rightView {
    return ^(UIView* value) {
        self.rightView = value;
        return self;
    };
}

- (UITextField* (^)(UITextFieldViewMode))lx_clearButtonMode {
    return ^(UITextFieldViewMode value) {
        self.clearButtonMode = value;
        return self;
    };
}
- (UITextField* (^)(UITextFieldViewMode))lx_leftViewMode {
    return ^(UITextFieldViewMode value) {
        self.leftViewMode = value;
        return self;
    };
}
- (UITextField* (^)(UITextFieldViewMode))lx_rightViewMode {
    return ^(UITextFieldViewMode value) {
        self.rightViewMode = value;
        return self;
    };
}
- (UITextField* (^)(id<UITextFieldDelegate>))lx_delegate {
    return ^(id<UITextFieldDelegate> delegate) {
        self.delegate = delegate;
        return self;
    };
}
- (UITextField* (^)(NSDictionary<NSAttributedStringKey,id>*))lx_typingAttributes {
    return ^(NSDictionary<NSAttributedStringKey,id>* dict) {
        self.typingAttributes = dict;
        return self;
    };
}

@end

@implementation UIControl (chain)

- (UIControl* (^)(BOOL))lx_enabled {
    return ^(BOOL enable) {
        self.enabled = enable;
        return self;
    };
}
- (UIControl* (^)(BOOL))lx_selected {
    return ^(BOOL selected) {
        self.selected = selected;
        return self;
    };
}
- (UIControl* (^)(BOOL))lx_highlighted {
    return ^(BOOL highlighted) {
        self.highlighted = highlighted;
        return self;
    };
}
- (UIControl* (^)(UIControlContentVerticalAlignment))lx_contentVerticalAlignment {
    return ^(UIControlContentVerticalAlignment alignment) {
        self.contentVerticalAlignment = alignment;
        return self;
    };
}
- (UIControl* (^)(UIControlContentHorizontalAlignment))lx_contentHorizontalAlignment {
    return ^(UIControlContentHorizontalAlignment alignment) {
        self.contentHorizontalAlignment = alignment;
        return self;
    };
}
- (UIControl* (^)(id, SEL, UIControlEvents))lx_addTargetActionControlEvents {
    return ^(id target, SEL action, UIControlEvents events) {
        [self addTarget:target action:action forControlEvents:events];
        return self;
    };
}
- (UIControl* (^)(id, SEL, UIControlEvents))lx_removeTargetActionControlEvents {
    return ^(id target, SEL action, UIControlEvents events) {
        [self removeTarget:target action:action forControlEvents:events];
        return self;
    };
}
- (NSArray<NSString*>* (^)(id, UIControlEvents))lx_actionsForTargetControlEvent {
    return ^(id target, UIControlEvents events) {
        return [self actionsForTarget:target forControlEvent:events];
    };
}
- (UIControl* (^)(SEL, id, UIEvent*))lx_sendActionToTargetForEvent {
    return ^(SEL action, id target, UIEvent* event) {
        [self sendAction:action to:target forEvent:event];
        return self;
    };
}
- (UIControl* (^)(UIControlEvents))lx_sendActionsForControlEvents {
    return ^(UIControlEvents events) {
        [self sendActionsForControlEvents:events];
        return self;
    };
}

@end

@implementation UIImageView (chain)

- (UIImageView* (^)(UIImage*))lx_initWithImage {
    return ^(UIImage* img) {
        return [self initWithImage:img];
    };
}
- (UIImageView* (^)(UIImage*, UIImage*))lx_initWithImageHighlightedImage {
    return ^(UIImage* img, UIImage* highlightedImg) {
        return [self initWithImage:img highlightedImage:highlightedImg];
    };
}
- (UIImageView* (^)(UIImage*))lx_image {
    return ^(UIImage* img) {
        self.image = img;
        return self;
    };
}
- (UIImageView* (^)(UIImage*))lx_highlightedImage {
    return ^(UIImage* img) {
        self.highlightedImage = img;
        return self;
    };
}
- (UIImageView* (^)(BOOL))lx_userInteractionEnabled {
    return ^(BOOL enable) {
        self.userInteractionEnabled = enable;
        return self;
    };
}
- (UIImageView* (^)(BOOL))lx_highlighted {
    return ^(BOOL hightlighted) {
        self.highlighted = hightlighted;
        return self;
    };
}
- (UIImageView* (^)(NSArray<UIImage*>*))lx_animationImages {
    return ^(NSArray<UIImage*>* arr) {
        self.animationImages = arr;
        return self;
    };
}
- (UIImageView* (^)(NSArray<UIImage*>*))lx_highlightedAnimationImages {
    return ^(NSArray<UIImage*>* arr) {
        self.highlightedAnimationImages = arr;
        return self;
    };
}
- (UIImageView* (^)(NSTimeInterval))lx_animationDuration {
    return ^(NSTimeInterval value) {
        self.animationDuration = value;
        return self;
    };
}
- (UIImageView* (^)(NSInteger))lx_animationRepeatCount {
    return ^(NSInteger count) {
        self.animationRepeatCount = count;
        return self;
    };
}
- (UIImageView* (^)(UIColor*))lx_tintColor {
    return ^(UIColor* color) {
        self.tintColor = color;
        return self;
    };
}
- (UIImageView* (^)(void))lx_startAnimating {
    return ^ {
        [self startAnimating];
        return self;
    };
}
- (UIImageView* (^)(void))lx_stopAnimating {
    return ^ {
        [self stopAnimating];
        return self;
    };
}

@end

@implementation UITextView (chain)

- (UITextView* (^)(id<UITextViewDelegate>))lx_delegate {
    return ^(id<UITextViewDelegate> delegate) {
        self.delegate = delegate;
        return self;
    };
}
- (UITextView* (^)(NSString*))lx_text {
    return ^(NSString* text) {
        self.text = text;
        return self;
    };
}
- (UITextView* (^)(UIFont*))lx_font {
    return ^(UIFont* font) {
        self.font = font;
        return self;
    };
}
- (UITextView* (^)(UIColor*))lx_textColor {
    return ^(UIColor* color) {
        self.textColor = color;
        return self;
    };
}
- (UITextView* (^)(NSRange))lx_selectedRange {
    return ^(NSRange range) {
        self.selectedRange = range;
        return self;
    };
}
- (UITextView* (^)(NSRange))lx_scrollRangeToVisible {
    return ^(NSRange range) {
        [self scrollRangeToVisible:range];
        return self;
    };
}
- (UITextView* (^)(UIView*))lx_inputView {
    return ^(UIView* v) {
        self.inputView = v;
        return self;
    };
}
- (UITextView* (^)(UIView*))lx_inputAccessoryView {
    return ^(UIView* v) {
        self.inputAccessoryView = v;
        return self;
    };
}
- (UITextView* (^)(NSTextAlignment))lx_textAlignment {
    return ^(NSTextAlignment aligment) {
        self.textAlignment = aligment;
        return self;
    };
 }
- (UITextView* (^)(UIDataDetectorTypes))lx_dataDetectorTypes {
    return ^(UIDataDetectorTypes datectorType) {
        self.dataDetectorTypes = datectorType;
        return self;
    };
}
- (UITextView* (^)(NSAttributedString*))lx_attributedText {
    return ^(NSAttributedString* attText) {
        self.attributedText = attText;
        return self;
    };
}
- (UITextView* (^)(NSDictionary<NSAttributedStringKey, id>*))lx_typingAttributes {
    return ^(NSDictionary<NSAttributedStringKey, id>* dict) {
        self.typingAttributes = dict;
        return self;
    };
}
- (UITextView* (^)(BOOL))lx_editable {
    return ^(BOOL editable) {
        self.editable = editable;
        return self;
    };
}
- (UITextView* (^)(BOOL))lx_selectable {
    return ^(BOOL selectable) {
        self.selectable = selectable;
        return self;
    };
}
- (UITextView* (^)(BOOL))lx_allowsEditingTextAttributes {
    return ^(BOOL value) {
        self.allowsEditingTextAttributes = value;
        return self;
    };
}
- (UITextView* (^)(BOOL))lx_clearsOnInsertion {
    return ^(BOOL value) {
        self.clearsOnInsertion = value;
        return self;
    };
}
- (UITextView* (^)(CGRect, NSTextContainer*))lx_initWithFrameInTextContainer {
    return ^(CGRect frame, NSTextContainer* container) {
        return [self initWithFrame:frame textContainer:container];
    };
}
- (UITextView* (^)(UIEdgeInsets))lx_textContainerInset {
    return ^(UIEdgeInsets insets) {
        self.textContainerInset = insets;
        return self;
    };
}
- (UITextView* (^)(NSDictionary<NSAttributedStringKey, id>*))lx_linkTextAttributes {
    return ^(NSDictionary<NSAttributedStringKey, id>* dict) {
        self.linkTextAttributes = dict;
        return self;
    };
}

@end

@implementation UISlider (chain)

- (UISlider* (^)(float))lx_value {
    return ^(float value) {
        self.value = value;
        return self;
    };
}
- (UISlider* (^)(float))lx_minimumValue {
    return ^(float value) {
        self.minimumValue = value;
        return self;
    };
}
- (UISlider* (^)(float))lx_maximumValue {
    return ^(float value) {
        self.maximumValue = value;
        return self;
    };
}
- (UISlider* (^)(UIImage*))lx_minimumValueImage {
    return ^(UIImage* img) {
        self.minimumValueImage = img;
        return self;
    };
}
- (UISlider* (^)(UIImage*))lx_maximumValueImage {
    return ^(UIImage* img) {
        self.maximumValueImage = img;
        return self;
    };
}
- (UISlider* (^)(BOOL))lx_continuous {
    return ^(BOOL continuous) {
        self.continuous = continuous;
        return self;
    };
}
- (UISlider* (^)(UIColor*))lx_minimumTrackTintColor {
    return ^(UIColor *color) {
        self.minimumTrackTintColor = color;
        return self;
    };
}
- (UISlider* (^)(UIColor*))lx_maximumTrackTintColor {
    return ^(UIColor *color) {
        self.maximumTrackTintColor = color;
        return self;
    };
}
- (UISlider* (^)(UIColor*))lx_thumbTintColor {
    return ^(UIColor *color) {
        self.thumbTintColor = color;
        return self;
    };
}
- (UISlider* (^)(float, BOOL))lx_setValueAnimated {
    return ^(float value, BOOL animated) {
        [self setValue:value animated:animated];
        return self;
    };
}
- (UISlider* (^)(UIImage*, UIControlState))lx_setThumbImageForState {
    return ^(UIImage* img, UIControlState state) {
        [self setThumbImage:img forState:state];
        return self;
    };
}
- (UISlider* (^)(UIImage*, UIControlState))lx_setMinimumTrackImageForState {
    return ^(UIImage* img, UIControlState state) {
        [self setMinimumTrackImage:img forState:state];
        return self;
    };
}
- (UISlider* (^)(UIImage*, UIControlState))lx_setMaximumTrackImageForState {
    return ^(UIImage* img, UIControlState state) {
        [self setMaximumTrackImage:img forState:state];
        return self;
    };
}
- (UIImage* (^)(UIControlState))lx_thumbImageForState {
    return ^(UIControlState state) {
        return [self thumbImageForState:state];
    };
}
- (UIImage* (^)(UIControlState))lx_minimumTrackImageForState {
    return ^(UIControlState state) {
        return [self minimumTrackImageForState:state];
    };
}
- (UIImage* (^)(UIControlState))lx_maximumTrackImageForState {
    return ^(UIControlState state) {
        return [self maximumTrackImageForState:state];
    };
}

@end

@implementation UISwitch (chain)

- (UISwitch* (^)(UIColor*))lx_onTintColor {
    return ^(UIColor* color) {
        self.onTintColor = color;
        return self;
    };
}
- (UISwitch* (^)(UIColor*))lx_tintColor {
    return ^(UIColor* color) {
        self.tintColor = color;
        return self;
    };
}
- (UISwitch* (^)(UIColor*))lx_thumbTintColor {
    return ^(UIColor* color) {
        self.thumbTintColor = color;
        return self;
    };
}
- (UISwitch* (^)(BOOL))lx_on {
    return ^(BOOL on) {
        self.on = on;
        return self;
    };
}
- (UISwitch* (^)(CGRect))lx_initWithFrame {
    return ^(CGRect rect) {
        return [self initWithFrame:rect];
    };
}
- (UISwitch* (^)(BOOL, BOOL))lx_setOnAndAnimated {
    return ^(BOOL on, BOOL animated) {
        [self setOn:on animated:animated];
        return self;
    };
}

@end

@implementation UICollectionView (chain)

- (UICollectionView* (^)(CGRect, UICollectionViewLayout*))lx_initWithFrameLayout {
    return ^(CGRect rect, UICollectionViewLayout* layout) {
        return [self initWithFrame:rect collectionViewLayout:layout];
    };
}
- (UICollectionView* (^)(UICollectionViewLayout*))lx_collectionViewLayout {
    return ^(UICollectionViewLayout* layout) {
        self.collectionViewLayout = layout;
        return self;
    };
}
- (UICollectionView* (^)(id<UICollectionViewDelegate>))lx_delegate {
    return ^(id<UICollectionViewDelegate> delegate) {
        self.delegate = delegate;
        return self;
    };
}
- (UICollectionView* (^)(id<UICollectionViewDataSource>))lx_dataSource {
    return ^(id<UICollectionViewDataSource> delegate) {
        self.dataSource = delegate;
        return self;
    };
}
- (UICollectionView* (^)(id<UICollectionViewDataSourcePrefetching>))lx_prefetchDataSource NS_AVAILABLE_IOS(10_0) {
    return ^(id<UICollectionViewDataSourcePrefetching> delegate) {
        self.prefetchDataSource = delegate;
        return self;
    };
}
- (UICollectionView* (^)(BOOL))lx_prefetchingEnabled NS_AVAILABLE_IOS(10_0) {
    return ^(BOOL enable) {
        self.prefetchingEnabled = enable;
        return self;
    };
}
- (UICollectionView* (^)(id<UICollectionViewDragDelegate>))lx_dragDelegate NS_AVAILABLE_IOS(11_0) {
    return ^(id<UICollectionViewDragDelegate> delegate) {
        self.dragDelegate = delegate;
        return self;
    };
}
- (UICollectionView* (^)(id<UICollectionViewDropDelegate>))lx_dropDelegate NS_AVAILABLE_IOS(11_0) {
    return ^(id<UICollectionViewDropDelegate> delegate) {
        self.dropDelegate = delegate;
        return self;
    };
}
- (UICollectionView* (^)(BOOL))lx_dragInteractionEnabled API_AVAILABLE(ios(11.0)) {
    return ^(BOOL enable) {
        self.dragInteractionEnabled = enable;
        return self;
    };
}
- (UICollectionView* (^)(UICollectionViewReorderingCadence))lx_reorderingCadence API_AVAILABLE(ios(11.0)) {
    return ^(UICollectionViewReorderingCadence cadence) {
        self.reorderingCadence = cadence;
        return self;
    };
}
- (UICollectionView* (^)(UIView*))lx_backgroundView {
    return ^(UIView* v) {
        self.backgroundView = v;
        return self;
    };
}
- (UICollectionView* (^)(Class, NSString*))lx_registerClassReuseCellIdentifier {
    return ^(Class cls, NSString* reuse) {
        [self registerClass:cls forCellWithReuseIdentifier:reuse];
        return self;
    };
}
- (UICollectionView* (^)(UINib*, NSString*))lx_registerNibReuseCellIdentifier {
    return ^(UINib* nib, NSString* reuse) {
        [self registerNib:nib forCellWithReuseIdentifier:reuse];
        return self;
    };
}
- (UICollectionView* (^)(Class, NSString*, NSString*))lx_registerClassSupplementaryViewKindReuseIdentifier {
    return ^(Class cls, NSString* kind, NSString* reuse) {
        [self registerClass:cls forSupplementaryViewOfKind:kind withReuseIdentifier:reuse];
        return self;
    };
}
- (UICollectionView* (^)(UINib*, NSString*, NSString*))lx_registerNibSupplementaryViewKindReuseIdentifier {
    return ^(UINib* nib, NSString* kind, NSString* reuse) {
        [self registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:reuse];
        return self;
    };
}
- (UICollectionViewCell* (^)(NSString*, NSIndexPath*))lx_dequeueReusableCellWithReuseIdentifierIndexPath {
    return ^(NSString* reuse, NSIndexPath* indexPath) {
        return [self dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    };
}
- (UICollectionReusableView* (^)(NSString*, NSString*, NSIndexPath*))lx_dequeueReusableSupplementaryViewKindIndexPath {
    return ^(NSString* kind, NSString* reuse ,NSIndexPath* indexPath) {
        return [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuse forIndexPath:indexPath];
    };
}
- (UICollectionView* (^)(BOOL))lx_allowsSelection {
    return ^(BOOL value) {
        self.allowsSelection = value;
        return self;
    };
}
- (UICollectionView* (^)(BOOL))lx_allowsMultipleSelection {
    return ^(BOOL value) {
        self.allowsMultipleSelection = value;
        return self;
    };
}
- (UICollectionView* (^)(NSIndexPath*, BOOL, UICollectionViewScrollPosition))lx_selectItemAtIndexPathAnimatedScrollPosition {
    return ^(NSIndexPath* index, BOOL value, UICollectionViewScrollPosition position) {
        [self selectItemAtIndexPath:index animated:value scrollPosition:position];
        return self;
    };
}
- (UICollectionView* (^)(NSIndexPath*, BOOL))lx_deselectItemAtIndexPathAnimated {
    return ^(NSIndexPath* index, BOOL animated) {
        [self deselectItemAtIndexPath:index animated:animated];
        return self;
    };
}
- (UICollectionView* (^)(void))lx_reloadData {
    return ^() {
        [self reloadData];
        return self;
    };
}
- (UICollectionView* (^)(UICollectionViewLayout*, BOOL))lx_setCollectionViewLayoutAnimated {
    return ^(UICollectionViewLayout* layout, BOOL animated) {
        [self setCollectionViewLayout:layout animated:YES];
        return self;
    };
}
- (UICollectionView* (^)(UICollectionViewLayout*, BOOL, LXAnimationBOOLCompletion))lx_setCollectionViewLayoutAnimatedCompletion {
    return ^(UICollectionViewLayout* layout, BOOL animated, LXAnimationBOOLCompletion completion) {
        [self setCollectionViewLayout:layout animated:animated completion:completion];
        return self;
    };
}
- (UICollectionViewTransitionLayout* (^)(UICollectionViewLayout*,UICollectionViewLayoutInteractiveTransitionCompletion))lx_startInteractiveTransitionToCollectionViewLayoutCompletion {
    return ^(UICollectionViewLayout* layout, UICollectionViewLayoutInteractiveTransitionCompletion completion) {
        return [self startInteractiveTransitionToCollectionViewLayout:layout completion:completion];
    };
}
- (UICollectionView* (^)(void))lx_finishInteractiveTransition {
    return ^ {
        [self finishInteractiveTransition];
        return self;
    };
}
- (UICollectionView* (^)(void))lx_cancelInteractiveTransition {
    return ^ {
        [self cancelInteractiveTransition];
        return self;
    };
}
- (NSInteger (^)(void))lx_numberOfSections {
    return ^ {
#if UIKIT_DEFINE_AS_PROPERTIES
        return self.numberOfSections;
#else
        return [self numberOfSections];
#endif
    };
}
- (NSInteger (^)(NSInteger))lx_numberOfItemsInSection {
    return ^(NSInteger value) {
        return [self numberOfItemsInSection:value];
    };
}
- (UICollectionViewLayoutAttributes* (^)(NSIndexPath*))lx_layoutAttributesForItemAtIndexPath {
    return ^(NSIndexPath* value) {
        return [self layoutAttributesForItemAtIndexPath:value];
    };
}
- (UICollectionViewLayoutAttributes* (^)(NSString*, NSIndexPath*))lx_layoutAttributesForSupplementaryElementKindIndexPath {
    return ^(NSString* kind, NSIndexPath* index) {
        return [self layoutAttributesForSupplementaryElementOfKind:kind atIndexPath:index];
    };
}
- (NSIndexPath* (^)(CGPoint))lx_indexPathForItemAtPoint {
    return ^(CGPoint value) {
        return [self indexPathForItemAtPoint:value];
    };
}
- (NSIndexPath* (^)(UICollectionViewCell*))lx_indexPathForCell {
    return ^(UICollectionViewCell* value) {
        return [self indexPathForCell:value];
    };
}
- (UICollectionViewCell* (^)(NSIndexPath*))lx_cellForItemAtIndexPath {
    return ^(NSIndexPath* value) {
        return [self cellForItemAtIndexPath:value];
    };
}
- (NSArray<NSIndexPath*>* (^)(void))lx_indexPathsForVisibleItems {
    return ^ {
        return [self indexPathsForVisibleItems];
    };
}
- (NSArray<UICollectionViewCell*>* (^)(void))lx_visibleCells {
    return ^ {
        return [self visibleCells];
    };
}
- (UICollectionReusableView* (^)(NSString*, NSIndexPath*))lx_supplementaryViewForElementKindIndexPath {
    return ^(NSString* kind, NSIndexPath* index) {
        return [self supplementaryViewForElementKind:kind atIndexPath:index];
    };
}
- (NSArray<UICollectionReusableView*>* (^)(NSString*))lx_visibleSupplementaryViewsOfKind {
    return ^(NSString* kind) {
        return [self visibleSupplementaryViewsOfKind:kind];
    };
}
- (NSArray<NSIndexPath*>* (^)(NSString*))lx_indexPathsForVisibleSupplementaryElementsOfKind {
    return ^(NSString* kind) {
        return [self indexPathsForVisibleSupplementaryElementsOfKind:kind];
    };
}
- (UICollectionView* (^)(NSIndexPath*, UICollectionViewScrollPosition, BOOL))lx_scrollToItemAtIndexPathScrollPositionAnimated {
    return ^(NSIndexPath* index, UICollectionViewScrollPosition position, BOOL animated) {
        [self scrollToItemAtIndexPath:index atScrollPosition:position animated:animated];
        return self;
    };
}
- (UICollectionView* (^)(NSIndexSet*))lx_insertSections {
    return ^(NSIndexSet* set) {
        [self insertSections:set];
        return self;
    };
}
- (UICollectionView* (^)(NSIndexSet*))lx_deleteSections {
    return ^(NSIndexSet* set) {
        [self deleteSections:set];
        return self;
    };
}
- (UICollectionView* (^)(NSIndexSet*))lx_reloadSections {
    return ^(NSIndexSet* set) {
        [self reloadSections:set];
        return self;
    };
}
- (UICollectionView* (^)(NSInteger, NSInteger))lx_moveSectionToSection {
    return ^(NSInteger from, NSInteger to) {
        [self moveSection:from toSection:to];
        return self;
    };
}
- (UICollectionView* (^)(NSArray<NSIndexPath*>*))lx_insertItemsAtIndexPaths {
    return ^(NSArray<NSIndexPath*>* indexes) {
        [self insertItemsAtIndexPaths:indexes];
        return self;
    };
}
- (UICollectionView* (^)(NSArray<NSIndexPath*>*))lx_deleteItemsAtIndexPaths {
    return ^(NSArray<NSIndexPath*>* indexes) {
        [self deleteItemsAtIndexPaths:indexes];
        return self;
    };
}
- (UICollectionView* (^)(NSArray<NSIndexPath*>*))lx_reloadItemsAtIndexPaths {
    return ^(NSArray<NSIndexPath*>* indexes) {
        [self reloadItemsAtIndexPaths:indexes];
        return self;
    };
}
- (UICollectionView* (^)(NSIndexPath*, NSIndexPath*))lx_moveItemAtIndexPathToIndexPath {
    return ^(NSIndexPath* from, NSIndexPath* to) {
        [self moveItemAtIndexPath:from toIndexPath:to];
        return self;
    };
}
- (UICollectionView* (^)(dispatch_block_t, LXAnimationBOOLCompletion))lx_performBatchUpdatesCompletion {
    return ^(dispatch_block_t block, LXAnimationBOOLCompletion com) {
        [self performBatchUpdates:block completion:com];
        return self;
    };
}
- (BOOL (^)(NSIndexPath*))lx_beginInteractiveMovementForItemAtIndexPath API_AVAILABLE(ios(9_0)) {
    return ^(NSIndexPath* value) {
        return [self beginInteractiveMovementForItemAtIndexPath:value];
    };
}
- (UICollectionView* (^)(CGPoint))lx_updateInteractiveMovementTargetPosition API_AVAILABLE(ios(9_0)) {
    return ^(CGPoint value) {
        [self updateInteractiveMovementTargetPosition:value];
        return self;
    };
}
- (UICollectionView* (^)(void))lx_endInteractiveMovement API_AVAILABLE(ios(9_0)) {
    return ^() {
        [self endInteractiveMovement];
        return self;
    };
}
- (UICollectionView* (^)(void))lx_cancelInteractiveMovement API_AVAILABLE(ios(9_0)) {
    return ^() {
        [self endInteractiveMovement];
        return self;
    };
}
- (UICollectionView* (^)(BOOL))lx_remembersLastFocusedIndexPath API_AVAILABLE(ios(9_0)) {
    return ^(BOOL value) {
        self.remembersLastFocusedIndexPath = value;
        return self;
    };
}

@end
