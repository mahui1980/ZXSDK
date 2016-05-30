/************************************************
 *fileName:     ACUIUtil.h
 *description:  UI处理
 *function detail:UI处理
 *delegate:
 *Created by:Chilly Zhong
 *Created date:12-1-10
 *Modified by:Joson Ma on 2013-2-23
 *Copyright 2011-2013 AdChina. All rights reserved.
 ************************************************/

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <MessageUI/MessageUI.h>

#define showActionAlert(title,msg,del,cancelTitle,otherTitle)			[[[[UIAlertView alloc] initWithTitle:title message:msg delegate:del cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil] autorelease] show]

#define getFormatString(fmt, ...)    [NSString stringWithFormat:fmt, __VA_ARGS__]

@interface ACUIUtil : NSObject
//判断view是否有显示
+(BOOL)ADCHINAViewIsVisible:(UIView *)view;

+(BOOL)ADCHINAViewIsDescendantOfKeyWindow:(UIView *)view;
//根据image和view的size返回适用的size
+ (CGRect)getContentRectWithImageSize:(CGSize)imgSize viewSize:(CGSize)viewSize;
//根据image和view的size返回适用的scale
+ (CGFloat)getScaleFactorWithImageSize:(CGSize)imgSize viewSize:(CGSize)viewSize;
//发送短信
+ (void)showInAppSmsInViewController:(UIViewController *)viewController delegate:(id<MFMessageComposeViewControllerDelegate>)msgDelegate sms:(NSString *)content to:(NSString *)address;


+(CGSize)screenSizeIncludingStatusBar:(BOOL)includeStatusBar;
+ (CGRect)absoluteFrameForView:(UIView*)view;
//新建color
+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha;

+(CGRect)getFrameByOrientation:(UIInterfaceOrientation)ori withWeb:(UIWebView *)theWebView;

+(CGRect)fullScreenFrameNoIncludeStatusBar;
@end
