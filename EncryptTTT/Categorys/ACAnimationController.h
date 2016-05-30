/************************************************
 *fileName:     ACAnimationController.h
 *description:  添加动画
 *function detail:添加动画
 *delegate:
 *Created by:Chilly Zhong
 *Created date:12-2-15
 *modify by:Joson Ma on 2013-3-4
 *Copyright 2011-2013 AdChina. All rights reserved.
 ************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    AnimationMaskRandom				= -1,
    AnimationMaskNone				= 0,
    AnimationMaskRushAndBreak		= 1 << 0,
    AnimationMaskDropDown			= 1 << 1,
    AnimationMaskAlert				= 1 << 2,
    AnimationMaskChangeAlpha		= 1 << 3,
    AnimationMaskFlipFromRight		= 1 << 4,
    AnimationMaskFlipFromLeft		= 1 << 5
} AnimationMask;

#define kFloatAnimDuration      0.3

@interface ACAnimationController : NSObject
//得到动画掩码
+ (AnimationMask)getAnimationMaskInMask:(AnimationMask)mask;
//根据掩码为view添加动画
+ (CGFloat)commitAnimationForView:(UIView *)adView mask:(AnimationMask)mask;

// For float ad animate appear/disappear
+ (void)commitMoveUpAnimationForView:(UIView *)adView;
+ (void)commitMoveDownAnimationForView:(UIView *)adView;

+ (void)commitScaleAnimationForView:(UIView *)view;

+ (void)commitExpandAnimationForView:(UIView *)view toFrame:(CGRect)rect;
@end
