
#import "ZXAnimationController.h"

#define kTotalAnimNumber        6

#define kAnimRushDuration1      0.5
#define kAnimRushDuration2      0.25
#define kAnimRushDuration3      0.125
#define kAnimRushDuration4      0.0625

#define kAnimFlipDuration       1.5

#define kAnimDropDuration1      0.25
#define kAnimDropDuration2      0.125
#define kAnimDropDuration3      0.125
#define kAnimDropDuration4      0.15
#define kAnimDropDuration5      0.15

#define kAnimAlertDuration1     0.5
#define kAnimAlertDuration2     0.25
#define kAnimAlertDuration3     0.125
#define kAnimAlertDuration4     0.0625

#define kAnimAlphaDuration      1


@implementation ZXAnimationController

#pragma mark -
#pragma mark Animation Methods
+ (void)moveView:(UIView *)view to:(CGRect)toFrame duration:(NSTimeInterval)duration
{
	[UIView beginAnimations:@"Move" context:nil];
	[UIView setAnimationDuration:duration];
	view.frame = toFrame;
	[UIView commitAnimations];
}

+ (void)scaleView:(UIView *)view to:(CGFloat)toScale duration:(NSTimeInterval)duration
{
	[UIView beginAnimations:@"Scale" context:nil];
	[UIView setAnimationDuration:duration];
	view.transform = CGAffineTransformMakeScale(toScale, toScale);
	[UIView commitAnimations];
}

+ (void)changeAlphaForView:(UIView *)view to:(CGFloat)toAlpha duration:(NSTimeInterval)duration
{
	[UIView beginAnimations:@"Alpha" context:nil];
	[UIView setAnimationDuration:duration];
	view.alpha = toAlpha;
	[UIView commitAnimations];
}

#pragma mark ===Rush And Break===

+ (void)RushAndBreak1ForView:(UIView *)adView
{	
	CGRect fromFrame = adView.frame;
	fromFrame.origin.x += adView.frame.size.width;		// move right adWidth
	adView.frame = fromFrame;
	
	CGRect toFrame = fromFrame;
	toFrame.origin.x -= adView.frame.size.width+40;		// move to -40
	
	[self moveView:adView to:toFrame duration:kAnimRushDuration1];
}

+ (void)RushAndBreak2ForView:(UIView *)adView
{
	CGRect toFrame = adView.frame;
	toFrame.origin.x += 60;                                 // move to +20
	
	[self moveView:adView to:toFrame duration:kAnimRushDuration2];
}

+ (void)RushAndBreak3ForView:(UIView *)adView
{
	CGRect toFrame = adView.frame;
	toFrame.origin.x -= 30;                                 // move to -10
	
	[self moveView:adView to:toFrame duration:kAnimRushDuration3];
}

+ (void)RushAndBreak4ForView:(UIView *)adView
{
	CGRect toFrame = adView.frame;
	toFrame.origin.x += 10;                                 // move to 0
	
	[self moveView:adView to:toFrame duration:kAnimRushDuration4];
}

#pragma mark ===Flip===
+ (void)FlipFromRightForView:(UIView *)adView {
	[UIView beginAnimations:@"Flip" context:nil];	
	[UIView setAnimationDuration:kAnimFlipDuration];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:adView cache:YES];
	[UIView commitAnimations];
}

+ (void)FlipFromLeftForView:(UIView *)adView {
	[UIView beginAnimations:@"Flip" context:nil];	
	[UIView setAnimationDuration:kAnimFlipDuration];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:adView cache:YES];
	[UIView commitAnimations];
}

#pragma mark ===DropDown===
+ (void)DropDown1ForView:(UIView *)adView {
	
	CGRect fromFrame = adView.frame;
	fromFrame.origin.y -= adView.frame.size.height;		// move up adHeight
	adView.frame = fromFrame;
	
	CGRect toFrame = fromFrame;
	toFrame.origin.y += adView.frame.size.height;		// move down adHeight
	
	[self moveView:adView to:toFrame duration:kAnimDropDuration1];
}

+ (void)DropDown2ForView:(UIView *)adView {
	
	CGRect toFrame = adView.frame;
	toFrame.origin.y -= 20;                                 // move down 20
	
	[self moveView:adView to:toFrame duration:kAnimDropDuration2];
}

+ (void)DropDown3ForView:(UIView *)adView {
	
	CGRect toFrame = adView.frame;
	toFrame.origin.y += 20;                                 // move up 20
	
	[self moveView:adView to:toFrame duration:kAnimDropDuration3];
}

+ (void)DropDown4ForView:(UIView *)adView
{
	CGRect toFrame = adView.frame;
	toFrame.origin.y -= 5;									// move down 5
	
	[self moveView:adView to:toFrame duration:kAnimDropDuration4];
}

+ (void)DropDown5ForView:(UIView *)adView
{
	CGRect toFrame = adView.frame;
	toFrame.origin.y += 5;									// move up 5
	
	[self moveView:adView to:toFrame duration:kAnimDropDuration5];
}

#pragma mark ===Alert===
+ (void)Alert1ForView:(UIView *)adView 
{
	adView.transform = CGAffineTransformMakeScale(0.7, 0.7);
	
	[self scaleView:adView to:1.2 duration:kAnimAlertDuration1];
}

+ (void)Alert2ForView:(UIView *)adView 
{
	[self scaleView:adView to:0.9 duration:kAnimAlertDuration2];
}

+ (void)Alert3ForView:(UIView *)adView 
{
	[self scaleView:adView to:1.1 duration:kAnimAlertDuration3];
}

+ (void)Alert4ForView:(UIView *)adView 
{
	[self scaleView:adView to:1.0 duration:kAnimAlertDuration4];
}

#pragma mark ===Change Alpha===
+ (void)ChangeAlpha1ForView:(UIView *)adView 
{
	adView.alpha = 1.0;
	
	[self changeAlphaForView:adView to:0.5 duration:kAnimAlphaDuration];
}

+ (void)ChangeAlpha2ForView:(UIView *)adView  
{
	[self changeAlphaForView:adView to:1.0 duration:kAnimAlphaDuration];
}

+ (void)ChangeAlpha3ForView:(UIView *)adView  
{
	[self changeAlphaForView:adView to:0.5 duration:kAnimAlphaDuration];
}

+ (void)ChangeAlpha4ForView:(UIView *)adView  
{
	[self changeAlphaForView:adView to:1.0 duration:kAnimAlphaDuration];
}

#pragma mark Interface Methods
+ (AnimationMask)getAnimationMaskInMask:(AnimationMask)mask
{
    if (mask == AnimationMaskNone) {
        return AnimationMaskNone;
    }
    
    // Get allowed animation number
    NSMutableArray *allowedAnimIndexes = [NSMutableArray array];
    for (int i = 0; i < kTotalAnimNumber; i++) {
        if ( (mask >> i) & 0x1 ) {
            [allowedAnimIndexes addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    // Get random animation index
    NSUInteger animIndex = random() % [allowedAnimIndexes count];
    return (AnimationMask)(1 << [[allowedAnimIndexes objectAtIndex:animIndex] intValue]);
}

+ (CGFloat)commitAnimationForView:(UIView *)adView mask:(AnimationMask)mask
{
    AnimationMask randMask = [self getAnimationMaskInMask:mask];
    CGFloat animTime = 0;
	
    switch (randMask) {
        case AnimationMaskNone:
            break;
        case AnimationMaskRushAndBreak:
			[self RushAndBreak1ForView:adView];
			animTime += kAnimRushDuration1;
            [self performSelector:@selector(RushAndBreak2ForView:) withObject:adView 
                       afterDelay:animTime];
			animTime += kAnimRushDuration2;
            [self performSelector:@selector(RushAndBreak3ForView:) withObject:adView 
                       afterDelay:animTime];
			animTime += kAnimRushDuration3;
            [self performSelector:@selector(RushAndBreak4ForView:) withObject:adView 
                       afterDelay:animTime];
			animTime += kAnimRushDuration4;
			break;
		case AnimationMaskDropDown:
			[self DropDown1ForView:adView];
			animTime += kAnimDropDuration1;
            [self performSelector:@selector(DropDown2ForView:) withObject:adView
                       afterDelay:animTime];
			animTime += kAnimDropDuration2;
            [self performSelector:@selector(DropDown3ForView:) withObject:adView
                       afterDelay:animTime];
			animTime += kAnimDropDuration3;
            [self performSelector:@selector(DropDown4ForView:) withObject:adView
                       afterDelay:animTime];
			animTime += kAnimDropDuration4;
            [self performSelector:@selector(DropDown5ForView:) withObject:adView
                       afterDelay:animTime];
			animTime += kAnimDropDuration5;
			break;
		case AnimationMaskAlert:
			[self Alert1ForView:adView];
			animTime += kAnimAlertDuration1;
            [self performSelector:@selector(Alert2ForView:) withObject:adView
                       afterDelay:animTime];
			animTime += kAnimAlertDuration2;
            [self performSelector:@selector(Alert3ForView:) withObject:adView
                       afterDelay:animTime];
			animTime += kAnimAlertDuration3;
            [self performSelector:@selector(Alert4ForView:) withObject:adView
                       afterDelay:animTime];
			animTime += kAnimAlertDuration4;
			break;
		case AnimationMaskChangeAlpha:
			[self ChangeAlpha1ForView:adView];
			animTime += kAnimAlphaDuration;
            [self performSelector:@selector(ChangeAlpha2ForView:) withObject:adView
                       afterDelay:animTime];
			animTime += kAnimAlphaDuration;
            [self performSelector:@selector(ChangeAlpha3ForView:) withObject:adView
                       afterDelay:animTime];
			animTime += kAnimAlphaDuration;
            [self performSelector:@selector(ChangeAlpha4ForView:) withObject:adView
                       afterDelay:animTime];
			animTime += kAnimAlphaDuration;
			break;
		case AnimationMaskFlipFromRight:
			[self FlipFromRightForView:adView];
			animTime += kAnimFlipDuration;
			break;
		case AnimationMaskFlipFromLeft:
			[self FlipFromLeftForView:adView];
			animTime += kAnimFlipDuration;
			break;
        default:
            break;
    }
	return animTime;
}

+ (void)commitMoveUpAnimationForView:(UIView *)adView
{
	adView.center = CGPointMake(adView.center.x, adView.center.y+adView.frame.size.height);
	
	[UIView beginAnimations:@"Float" context:nil];
	[UIView setAnimationDuration:kFloatAnimDuration];
	adView.center = CGPointMake(adView.center.x, adView.center.y-adView.frame.size.height);
	[UIView commitAnimations];
}

+ (void)commitMoveDownAnimationForView:(UIView *)adView
{
	[UIView beginAnimations:@"Float" context:nil];
	[UIView setAnimationDuration:kFloatAnimDuration];
	adView.center = CGPointMake(adView.center.x, adView.center.y+adView.frame.size.height);
	[UIView commitAnimations];
}


+ (void)commitScaleAnimationForView:(UIView *)view {
    [UIView beginAnimations:@"scale" context:nil];
	[UIView setAnimationDuration:kFloatAnimDuration];
	view.transform = CGAffineTransformMakeScale(1, 1);
	[UIView commitAnimations];
}

+ (void)commitExpandAnimationForView:(UIView *)view toFrame:(CGRect)rect{
    [UIView beginAnimations:@"expand" context:nil];
	[UIView setAnimationDuration:kFloatAnimDuration];
	view.frame = rect;
	[UIView commitAnimations];
}
@end
