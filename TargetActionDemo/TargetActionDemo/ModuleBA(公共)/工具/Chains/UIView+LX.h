//
//  UIView+LX.h
//  test
//
//  Created by 天边的星星 on 2019/4/26.
//  Copyright © 2019 starxin. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///动画完成回调：参数只有BOOL类型
typedef void (^LXAnimationBOOLCompletion)(BOOL);


@interface UIView (chain)

#pragma mark --- frame 相关属性
///如果@property在分类里面使用只会自动声明get,set方法,不会实现,并且不会帮你生成成员属性
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

#pragma mark --- chain methods
- (UIView* (^)(CGFloat))lx_x;
- (UIView* (^)(CGFloat))lx_y;
- (UIView* (^)(CGFloat))lx_width;
- (UIView* (^)(CGFloat))lx_height;
- (UIView* (^)(CGSize ))lx_size;
- (UIView* (^)(CGPoint))lx_center;
- (UIView* (^)(CGFloat))lx_centerX;
- (UIView* (^)(CGFloat))lx_centerY;
- (UIView* (^)(CGPoint))lx_origin;
- (UIView* (^)(CGFloat))lx_bottom;
- (UIView* (^)(CGFloat))lx_right;

/**
 设置尺寸，
 @return UIView
 */
- (UIView* (^)(CGRect ))lx_frame;
- (UIView* (^)(CGRect ))lx_bounds;
- (UIView* (^)(CGFloat))lx_alpha;

- (UIView* (^)(BOOL))lx_clipsToBounds;
- (UIView* (^)(BOOL))lx_opaque;
- (UIView* (^)(BOOL))lx_hidden;

- (UIView* (^)(UIColor*))lx_backgroundColor;

- (UIView* (^)(CGAffineTransform))lx_transform;
- (UIView* (^)(UIViewContentMode))lx_contentMode;

- (CGPoint (^)(CGPoint, UIView*))lx_convertPointToView;
- (CGPoint (^)(CGPoint, UIView*))lx_convertPointFromView;
- (CGRect  (^)(CGRect,  UIView*))lx_convertRectToView;
- (CGRect  (^)(CGRect,  UIView*))lx_convertRectFromView;

- (CGSize  (^)(CGSize))lx_sizeThatFits;
- (UIView* (^)(void  ))lx_sizeToFit;
- (void    (^)(void  ))lx_removeFromSuperview;

- (UIView* (^)(UIView*,   NSInteger))lx_insertSubviewAtIndex;
- (UIView* (^)(NSInteger, NSInteger))lx_exchangeSubviewWithIndex;
- (UIView* (^)(UIView*,     UIView*))lx_insertSubviewBelowSubview;
- (UIView* (^)(UIView*,     UIView*))lx_insertSubviewAboveSubview;

- (UIView* (^)(UIView*))lx_addSubview;
- (UIView* (^)(UIView*))lx_bringSubViewToFront;
- (UIView* (^)(UIView*))lx_sendSubviewToBack;

- (BOOL    (^)(UIView*))lx_isDescendantOfView;
- (UIView* (^)(void   ))lx_setNeedsLayout;
- (UIView* (^)(void   ))lx_layoutIfNeeded;

- (UIView* (^)(UIEdgeInsets))lx_layoutMargins;

- (UIView* (^)(void    ))lx_setNeedsDisplay;
- (UIView* (^)(CGRect  ))lx_setNeedsDisplayInRect;
- (UIView* (^)(UIView* ))lx_maskView;
- (UIView* (^)(UIColor*))lx_tintColor;

#pragma mark --- animations
+ (void (^)(NSString*, void* _Nullable ))lx_beginAnimationIDInContext;
+ (void (^)(void))lx_commitAnimations;
+ (void (^)(id _Nullable  ))lx_setAnimationDelegate;
+ (void (^)(SEL _Nullable ))lx_setAnimationWillStartSelector;
+ (void (^)(SEL _Nullable ))lx_setAnimationDidStopSelector;
+ (void (^)(NSTimeInterval))lx_setAnimationDuration;
+ (void (^)(NSTimeInterval))lx_setAnimationDelay;

+ (void (^)(NSDate*))lx_setAnimationStartDate;
+ (void (^)(UIViewAnimationCurve))lx_setAnimationCurve;

+ (void (^)(float))lx_setAnimationRepeatCount;
+ (void (^)(BOOL ))lx_setAnimationRepeatAutoreverses;
+ (void (^)(BOOL ))lx_setAnimationBeginsFromCurrentState;
+ (void (^)(BOOL ))lx_setAnimationsEnabled;
+ (void (^)(UIViewAnimationTransition, UIView*, BOOL))lx_setAnimationTransitionForViewWithCache;
+ (void (^)(dispatch_block_t))lx_performWithoutAnimationInActions;

+ (void (^)(NSTimeInterval, NSTimeInterval, UIViewAnimationOptions, dispatch_block_t, LXAnimationBOOLCompletion))lx_animateWithDurationDelayOptionsAnimationsCompletion;

+ (void (^)(NSTimeInterval, dispatch_block_t, LXAnimationBOOLCompletion))lx_animateWithDurationAnimationsCompletion;

+ (void (^)(NSTimeInterval, dispatch_block_t))lx_animateWithDurationAnimations;

+ (void (^)(NSTimeInterval, NSTimeInterval, CGFloat, CGFloat, UIViewAnimationOptions, dispatch_block_t, LXAnimationBOOLCompletion))lx_animateWithDurationDelayDampVelocityOptionsAnimationsCompletion;

+ (void (^)(UIView*, NSTimeInterval, UIViewAnimationOptions, dispatch_block_t, LXAnimationBOOLCompletion))lx_transitionWithViewDurationOptionsAnimationsCompletion;

+ (void (^)(UIView*, UIView*, NSTimeInterval dura, UIViewAnimationOptions opt, LXAnimationBOOLCompletion))lx_transitionFromViewToViewDurationOptionsCompletion;

+ (void (^)(UISystemAnimation, NSArray<UIView*>*, UIViewAnimationOptions, dispatch_block_t, LXAnimationBOOLCompletion))lx_performSystemAnimationOnViewsOptionsAnimationsCompletion;

+ (void (^)(NSTimeInterval, NSTimeInterval, UIViewKeyframeAnimationOptions, dispatch_block_t, LXAnimationBOOLCompletion))lx_animateKeyframesWithDurationDelayOptionsAnimationsCompletion;

+ (void (^)(double, double, dispatch_block_t))lx_addKeyframeWithRelativeStartTimeDurationAnimations;

#pragma mark --- gesture
- (UIView* (^)(UIGestureRecognizer*))lx_addGestureRecognizer;
- (UIView* (^)(UIGestureRecognizer*))lx_removeGestureRecognizer;

- (CGSize (^)(CGSize))lx_systemLayoutSizeFittingSize;
- (CGSize (^)(CGSize, UILayoutPriority, UILayoutPriority))lx_systemLayoutSizeFittingSizeHorizonPriorityVerticalPriority;

- (UIView* (^)(BOOL))lx_snapshotViewAfterScreenUpdates;
- (UIView* (^)(CGRect, BOOL, UIEdgeInsets))lx_resizableSnapshotViewFromRectAfterUpdatesCapInsets;


@end

@interface UILabel (chain)

- (UILabel* (^)(NSString*))lx_text;
- (UILabel* (^)(UIFont*  ))lx_font;
- (UILabel* (^)(UIColor* ))lx_textColor;
- (UILabel* (^)(UIColor* ))lx_highlightedTextColor;

- (UILabel* (^)(UIColor*))lx_shadowColor;
- (UILabel* (^)(CGSize  ))lx_shadowOffset;

- (UILabel* (^)(NSTextAlignment))lx_textAlignment;
- (UILabel* (^)(NSLineBreakMode))lx_lineBreakMode;
- (UILabel* (^)(NSAttributedString*))lx_attributedText;

- (UILabel* (^)(BOOL))lx_highlighted;
- (UILabel* (^)(BOOL))lx_userInteractionEnabled;
- (UILabel* (^)(BOOL))lx_enabled;
- (UILabel* (^)(BOOL))lx_adjustsFontSizeToFitWidth;
- (UILabel* (^)(BOOL))lx_adjustsLetterSpacingToFitWidth;

- (UILabel* (^)(NSInteger))lx_numberOfLines;
- (UILabel* (^)(CGFloat  ))lx_preferredMaxLayoutWidth;
- (UILabel* (^)(CGFloat  ))lx_minimumFontSize;
- (UILabel* (^)(NSInteger))lx_tag;
- (UILabel* (^)(CGFloat  ))lx_alpha;

- (UILabel* (^)(BOOL))lx_clipsToBounds;
- (UILabel* (^)(BOOL))lx_opaque;
- (UILabel* (^)(BOOL))lx_hidden;

- (UILabel* (^)(UIViewContentMode))lx_contentMode;

@end

@interface UIButton (chain)

- (UIButton* (^)(BOOL))lx_enabled;
- (UIButton* (^)(BOOL))lx_selected;
- (UIButton* (^)(BOOL))lx_highlighted;
- (UIButton* (^)(BOOL))lx_adjustsImageWhenHighlighted;
- (UIButton* (^)(BOOL))lx_adjustsImageWhenDisabled;
- (UIButton* (^)(BOOL))lx_showsTouchWhenHighlighted;

- (UIButton* (^)(UIControlContentVerticalAlignment  ))lx_contentVerticalAlignment;
- (UIButton* (^)(UIControlContentHorizontalAlignment))lx_contentHorizontalAlignment;

- (UIButton* (^)(UIEdgeInsets))lx_contentEdgeInsets;
- (UIButton* (^)(UIEdgeInsets))lx_titleEdgeInsets;
- (UIButton* (^)(UIEdgeInsets))lx_imageEdgeInsets;

- (UIButton* (^)(UIColor* ))lx_tintColor;
- (UIButton* (^)(NSString*))lx_normalTitle;
- (UIButton* (^)(NSString*))lx_highlightedTitle;
- (UIButton* (^)(NSString*))lx_disabledTitle;
- (UIButton* (^)(NSString*))lx_selectedTitle;

- (UIButton* (^)(UIColor*))lx_normalTitleColor;
- (UIButton* (^)(UIColor*))lx_highlightedTitleColor;
- (UIButton* (^)(UIColor*))lx_disabledTitleColor;
- (UIButton* (^)(UIColor*))lx_selectedTitleColor;

- (UIButton* (^)(UIColor*))lx_normalTitleShadowColor;
- (UIButton* (^)(UIColor*))lx_highlightedTitleShadowColor;
- (UIButton* (^)(UIColor*))lx_disabledTitleShadowColor;
- (UIButton* (^)(UIColor*))lx_selectedTitleShadowColor;

- (UIButton* (^)(UIImage*))lx_normalImage;
- (UIButton* (^)(UIImage*))lx_highlightedImage;
- (UIButton* (^)(UIImage*))lx_disabledImage;
- (UIButton* (^)(UIImage*))lx_selectedImage;

- (UIButton* (^)(UIImage*))lx_normalBackgroundImage;
- (UIButton* (^)(UIImage*))lx_highlightedBackgroundImage;
- (UIButton* (^)(UIImage*))lx_disabledBackgroundImage;
- (UIButton* (^)(UIImage*))lx_selectedBackgroundImage;

- (UIButton* (^)(NSAttributedString*))lx_normalAttributedTitle;
- (UIButton* (^)(NSAttributedString*))lx_highlightedAttributedTitle;
- (UIButton* (^)(NSAttributedString*))lx_disabledAttributedTitle;
- (UIButton* (^)(NSAttributedString*))lx_selectedAttributedTitle;

- (UIButton* (^)(NSLineBreakMode  ))lx_lineBreakMode;
- (UIButton* (^)(UIViewContentMode))lx_contentMode;
+ (UIButton* (^)(UIButtonType     ))lx_buttonWithType;

- (UIButton* (^)(BOOL))lx_clipsToBounds;
- (UIButton* (^)(BOOL))lx_opaque;
- (UIButton* (^)(BOOL))lx_hidden;

- (UIButton* (^)(UIFont*))lx_font;
- (UIButton* (^)(CGFloat))lx_alpha;

- (UIButton* (^)(NSString*, UIControlState))lx_setTitleForState;
- (UIButton* (^)(UIColor*,  UIControlState))lx_setTitleColorForState;
- (UIButton* (^)(UIColor*,  UIControlState))lx_setTitleShadowColorForState;
- (UIButton* (^)(UIImage*,  UIControlState))lx_setImageForState;
- (UIButton* (^)(UIImage*,  UIControlState))lx_setBackgroundImageForState;

- (UIButton* (^)(NSAttributedString*, UIControlState))lx_setAttributedTitleForState;

- (NSString* (^)(UIControlState))lx_titleForState;
- (UIColor*  (^)(UIControlState))lx_titleColorForState;
- (UIColor*  (^)(UIControlState))lx_titleShadowColorForState;
- (UIImage*  (^)(UIControlState))lx_imageForState;
- (UIImage*  (^)(UIControlState))lx_backgroundImageForState;

- (NSAttributedString* (^)(UIControlState))lx_attributedTitleForState;

@end

@interface UITextField (chain)

- (UITextField* (^)(NSString*))lx_text;
- (UITextField* (^)(NSString*))lx_placeholder;
- (UITextField* (^)(UIColor* ))lx_textColor;
- (UITextField* (^)(UIFont*  ))lx_font;

- (UITextField* (^)(NSAttributedString*))lx_attributedText;
- (UITextField* (^)(NSAttributedString*))lx_attributedPlaceholder;
- (UITextField* (^)(NSTextAlignment    ))lx_textAlignment;
- (UITextField* (^)(UITextBorderStyle  ))lx_borderStyle;


- (UITextField* (^)(BOOL))lx_clearsOnBeginEditing;
- (UITextField* (^)(BOOL))lx_adjustsFontSizeToFitWidth;

- (UITextField* (^)(CGFloat ))lx_minimumFontSize;
- (UITextField* (^)(UIImage*))lx_background;
- (UITextField* (^)(UIImage*))lx_disabledBackground;

- (UITextField* (^)(UIView*))lx_leftView;
- (UITextField* (^)(UIView*))lx_rightView;

- (UITextField* (^)(UITextFieldViewMode))lx_clearButtonMode;
- (UITextField* (^)(UITextFieldViewMode))lx_leftViewMode;
- (UITextField* (^)(UITextFieldViewMode))lx_rightViewMode;

- (UITextField* (^)(id<UITextFieldDelegate>))lx_delegate;
- (UITextField* (^)(NSDictionary<NSAttributedStringKey,id>*))lx_typingAttributes;

@end

@interface UIControl (chain)

- (UIControl* (^)(BOOL))lx_enabled;
- (UIControl* (^)(BOOL))lx_selected;
- (UIControl* (^)(BOOL))lx_highlighted;

- (UIControl* (^)(UIControlContentVerticalAlignment  ))lx_contentVerticalAlignment;
- (UIControl* (^)(UIControlContentHorizontalAlignment))lx_contentHorizontalAlignment;

- (UIControl* (^)(id, SEL, UIControlEvents))lx_addTargetActionControlEvents;
- (UIControl* (^)(id, SEL, UIControlEvents))lx_removeTargetActionControlEvents;

- (UIControl* (^)(SEL, id, UIEvent* ))lx_sendActionToTargetForEvent;
- (UIControl* (^)(UIControlEvents   ))lx_sendActionsForControlEvents;

- (NSArray<NSString*>* (^)(id, UIControlEvents))lx_actionsForTargetControlEvent;

@end

@interface UIImageView (chain)

- (UIImageView* (^)(UIImage*))lx_initWithImage;
- (UIImageView* (^)(UIImage*))lx_image;
- (UIImageView* (^)(UIImage*))lx_highlightedImage;
- (UIImageView* (^)(BOOL    ))lx_userInteractionEnabled;
- (UIImageView* (^)(BOOL    ))lx_highlighted;

- (UIImageView* (^)(UIImage*, UIImage*))lx_initWithImageHighlightedImage;
- (UIImageView* (^)(NSArray<UIImage*>*))lx_animationImages;
- (UIImageView* (^)(NSArray<UIImage*>*))lx_highlightedAnimationImages;
- (UIImageView* (^)(NSTimeInterval    ))lx_animationDuration;

- (UIImageView* (^)(NSInteger))lx_animationRepeatCount;
- (UIImageView* (^)(UIColor* ))lx_tintColor;

- (UIImageView* (^)(void))lx_startAnimating;
- (UIImageView* (^)(void))lx_stopAnimating;

@end

@interface UITextView (chain)

- (UITextView* (^)(id<UITextViewDelegate>))lx_delegate;

- (UITextView* (^)(NSString*))lx_text;
- (UITextView* (^)(UIFont*  ))lx_font;
- (UITextView* (^)(UIColor* ))lx_textColor;
- (UITextView* (^)(NSRange  ))lx_selectedRange;
- (UITextView* (^)(NSRange  ))lx_scrollRangeToVisible;
- (UITextView* (^)(UIView*  ))lx_inputView;
- (UITextView* (^)(UIView*  ))lx_inputAccessoryView;

- (UITextView* (^)(NSTextAlignment    ))lx_textAlignment;
- (UITextView* (^)(UIDataDetectorTypes))lx_dataDetectorTypes;
- (UITextView* (^)(NSAttributedString*))lx_attributedText;

- (UITextView* (^)(NSDictionary<NSAttributedStringKey, id>*))lx_typingAttributes;
- (UITextView* (^)(NSDictionary<NSAttributedStringKey, id>*))lx_linkTextAttributes;

- (UITextView* (^)(BOOL))lx_editable;
- (UITextView* (^)(BOOL))lx_selectable;
- (UITextView* (^)(BOOL))lx_allowsEditingTextAttributes;
- (UITextView* (^)(BOOL))lx_clearsOnInsertion;

- (UITextView* (^)(CGRect, NSTextContainer*))lx_initWithFrameInTextContainer;
- (UITextView* (^)(UIEdgeInsets))lx_textContainerInset;

@end

@interface UISlider (chain)

- (UISlider* (^)(float))lx_value;
- (UISlider* (^)(float))lx_minimumValue;
- (UISlider* (^)(float))lx_maximumValue;

- (UISlider* (^)(UIImage*))lx_minimumValueImage;
- (UISlider* (^)(UIImage*))lx_maximumValueImage;
- (UISlider* (^)(UIColor*))lx_minimumTrackTintColor;
- (UISlider* (^)(UIColor*))lx_maximumTrackTintColor;
- (UISlider* (^)(UIColor*))lx_thumbTintColor;

- (UISlider* (^)(BOOL       ))lx_continuous;
- (UISlider* (^)(float, BOOL))lx_setValueAnimated;

- (UISlider* (^)(UIImage*, UIControlState))lx_setThumbImageForState;
- (UISlider* (^)(UIImage*, UIControlState))lx_setMinimumTrackImageForState;
- (UISlider* (^)(UIImage*, UIControlState))lx_setMaximumTrackImageForState;

- (UIImage* (^)(UIControlState))lx_thumbImageForState;
- (UIImage* (^)(UIControlState))lx_minimumTrackImageForState;
- (UIImage* (^)(UIControlState))lx_maximumTrackImageForState;

@end

@interface UISwitch (chain)

- (UISwitch* (^)(UIColor*  ))lx_onTintColor;
- (UISwitch* (^)(UIColor*  ))lx_tintColor;
- (UISwitch* (^)(UIColor*  ))lx_thumbTintColor;
- (UISwitch* (^)(CGRect    ))lx_initWithFrame;
- (UISwitch* (^)(BOOL      ))lx_on;
- (UISwitch* (^)(BOOL, BOOL))lx_setOnAndAnimated;

@end

@interface UICollectionView (chain)

/**
 创建UICollectionView对象，传入frame和layout
 @return UICollectionView
 */
- (UICollectionView* (^)(CGRect, UICollectionViewLayout*))lx_initWithFrameLayout;
- (UICollectionView* (^)(UICollectionViewLayout*        ))lx_collectionViewLayout;
- (UICollectionView* (^)(id<UICollectionViewDelegate>   ))lx_delegate;
- (UICollectionView* (^)(id<UICollectionViewDataSource> ))lx_dataSource;

- (UICollectionView* (^)(id<UICollectionViewDataSourcePrefetching>))lx_prefetchDataSource NS_AVAILABLE_IOS(10_0);
- (UICollectionView* (^)(id<UICollectionViewDragDelegate>))lx_dragDelegate NS_AVAILABLE_IOS(11_0);
- (UICollectionView* (^)(id<UICollectionViewDropDelegate>))lx_dropDelegate NS_AVAILABLE_IOS(11_0);

- (UICollectionView* (^)(BOOL))lx_prefetchingEnabled NS_AVAILABLE_IOS(10_0);
- (UICollectionView* (^)(BOOL))lx_dragInteractionEnabled API_AVAILABLE(ios(11.0));
- (UICollectionView* (^)(BOOL))lx_allowsSelection;
- (UICollectionView* (^)(BOOL))lx_allowsMultipleSelection;

- (UICollectionView* (^)(UICollectionViewReorderingCadence))lx_reorderingCadence API_AVAILABLE(ios(11.0));

- (UICollectionView* (^)(UIView*))lx_backgroundView;
- (UICollectionView* (^)(Class, NSString* ))lx_registerClassReuseCellIdentifier;
- (UICollectionView* (^)(UINib*, NSString*))lx_registerNibReuseCellIdentifier;
- (UICollectionView* (^)(Class, NSString*, NSString*))lx_registerClassSupplementaryViewKindReuseIdentifier;
- (UICollectionView* (^)(UINib*, NSString*, NSString*))lx_registerNibSupplementaryViewKindReuseIdentifier;

- (UICollectionViewCell* (^)(NSString*, NSIndexPath*))lx_dequeueReusableCellWithReuseIdentifierIndexPath;
- (UICollectionReusableView* (^)(NSString*,NSString*, NSIndexPath*))lx_dequeueReusableSupplementaryViewKindIndexPath;


- (UICollectionView* (^)(NSIndexPath*, BOOL, UICollectionViewScrollPosition))lx_selectItemAtIndexPathAnimatedScrollPosition;
- (UICollectionView* (^)(NSIndexPath*, BOOL))lx_deselectItemAtIndexPathAnimated;
- (UICollectionView* (^)(UICollectionViewLayout*, BOOL))lx_setCollectionViewLayoutAnimated;
- (UICollectionView* (^)(UICollectionViewLayout*, BOOL, LXAnimationBOOLCompletion))lx_setCollectionViewLayoutAnimatedCompletion;

- (UICollectionViewTransitionLayout* (^)(UICollectionViewLayout*,UICollectionViewLayoutInteractiveTransitionCompletion))lx_startInteractiveTransitionToCollectionViewLayoutCompletion;

- (UICollectionView* (^)(void))lx_finishInteractiveTransition;
- (UICollectionView* (^)(void))lx_cancelInteractiveTransition;
- (UICollectionView* (^)(void))lx_reloadData;

- (NSInteger (^)(void     ))lx_numberOfSections;
- (NSInteger (^)(NSInteger))lx_numberOfItemsInSection;

- (UICollectionViewLayoutAttributes* (^)(NSIndexPath*))lx_layoutAttributesForItemAtIndexPath;
- (UICollectionViewLayoutAttributes* (^)(NSString*, NSIndexPath*))lx_layoutAttributesForSupplementaryElementKindIndexPath;

- (NSIndexPath* (^)(CGPoint))lx_indexPathForItemAtPoint;
- (NSIndexPath* (^)(UICollectionViewCell*))lx_indexPathForCell;
- (NSArray<NSIndexPath*>* (^)(void))lx_indexPathsForVisibleItems;
- (UICollectionViewCell* (^)(NSIndexPath*))lx_cellForItemAtIndexPath;
- (NSArray<UICollectionViewCell*>* (^)(void))lx_visibleCells;

- (UICollectionReusableView* (^)(NSString*, NSIndexPath*))lx_supplementaryViewForElementKindIndexPath API_AVAILABLE(ios(9_0));
- (NSArray<UICollectionReusableView*>* (^)(NSString*    ))lx_visibleSupplementaryViewsOfKind API_AVAILABLE(ios(9_0));
- (NSArray<NSIndexPath*>* (^)(NSString*))lx_indexPathsForVisibleSupplementaryElementsOfKind API_AVAILABLE(ios(9_0));

- (UICollectionView* (^)(NSIndexPath*, UICollectionViewScrollPosition, BOOL))lx_scrollToItemAtIndexPathScrollPositionAnimated;

- (UICollectionView* (^)(NSIndexSet*))lx_insertSections;
- (UICollectionView* (^)(NSIndexSet*))lx_deleteSections;
- (UICollectionView* (^)(NSIndexSet*))lx_reloadSections;

- (UICollectionView* (^)(NSInteger, NSInteger  ))lx_moveSectionToSection;
- (UICollectionView* (^)(NSArray<NSIndexPath*>*))lx_insertItemsAtIndexPaths;
- (UICollectionView* (^)(NSArray<NSIndexPath*>*))lx_deleteItemsAtIndexPaths;
- (UICollectionView* (^)(NSArray<NSIndexPath*>*))lx_reloadItemsAtIndexPaths;

- (UICollectionView* (^)(NSIndexPath*, NSIndexPath*))lx_moveItemAtIndexPathToIndexPath;

- (UICollectionView* (^)(dispatch_block_t, LXAnimationBOOLCompletion))lx_performBatchUpdatesCompletion;

- (BOOL (^)(NSIndexPath*))lx_beginInteractiveMovementForItemAtIndexPath API_AVAILABLE(ios(9_0));
- (UICollectionView* (^)(CGPoint))lx_updateInteractiveMovementTargetPosition API_AVAILABLE(ios(9_0));
- (UICollectionView* (^)(void   ))lx_endInteractiveMovement API_AVAILABLE(ios(9_0));
- (UICollectionView* (^)(void   ))lx_cancelInteractiveMovement API_AVAILABLE(ios(9_0));
- (UICollectionView* (^)(BOOL   ))lx_remembersLastFocusedIndexPath API_AVAILABLE(ios(9_0));

@end

NS_ASSUME_NONNULL_END
 
