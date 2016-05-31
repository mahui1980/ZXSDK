
#import "ZXUIUtil.h"
@implementation ZXUIUtil

// Used to get scaled frame for gif image
// If view's w/h == image's w/h, scale to viewSize
// else center to y position(too wide) or center to x position (too high)   --rare case
+ (CGRect)getContentRectWithImageSize:(CGSize)imgSize viewSize:(CGSize)viewSize
{
    CGFloat imgWidth = imgSize.width;
    CGFloat imgHeight = imgSize.height;
    CGFloat viewWidth = viewSize.width;
    CGFloat viewHeight = viewSize.height;
        
    NSUInteger contentHeight;   // newImageHeight
    NSUInteger contentWidth;    // newImageWidth
    CGRect contentRect;         // result
    
    if (imgWidth/imgHeight > viewWidth/viewHeight) {        // too wide
        contentHeight = viewWidth/imgWidth*imgHeight;
        contentRect = CGRectMake(0, (viewHeight-contentHeight)/2, viewWidth, contentHeight);
    } else {                                                // too high
        contentWidth = viewHeight/imgHeight*imgWidth;
        contentRect = CGRectMake((viewWidth-contentWidth)/2, 0, contentWidth, viewHeight);
    }
    
    return contentRect;
}

-(void)setWebViewWidthAndHeight:(UIView *)webView imageSize:(CGSize)imgSize {
    CGFloat returnFloat = 1;
    CGFloat imgWidth = imgSize.width;
    CGFloat imgHeight = imgSize.height;
    CGFloat viewWidth = webView.bounds.size.width;
    CGFloat viewHeight = webView.bounds.size.height;
    
    if (imgWidth/imgHeight != viewWidth/viewHeight) {        // currect wide VS hight
        if (viewWidth/imgWidth > viewHeight/imgHeight) {
            returnFloat = viewHeight/imgHeight;
        } else {
            returnFloat = viewWidth/imgWidth;
        }
    }
}

+ (CGFloat)getScaleFactorWithImageSize:(CGSize)imgSize viewSize:(CGSize)viewSize {
    CGFloat imgWidth = imgSize.width;
    CGFloat imgHeight = imgSize.height;
    CGFloat viewWidth = viewSize.width;
    CGFloat viewHeight = viewSize.height;
    
    CGFloat comHeight = viewHeight/imgHeight;
    CGFloat comWidth = viewWidth/imgWidth;
    if (comWidth > comHeight) {        // currect wide VS hight
        return comHeight;
    } else {
        return comWidth;
    }
}

+ (void)showInAppSmsInViewController:(UIViewController *)viewController delegate:(id<MFMessageComposeViewControllerDelegate>)msgDelegate sms:(NSString *)content to:(NSString *)address
{
    MFMessageComposeViewController *msgComposer = [[MFMessageComposeViewController alloc] init];
    msgComposer.messageComposeDelegate = msgDelegate;
    msgComposer.recipients = [NSArray arrayWithObjects:address, nil];
    msgComposer.body = content;
    
    [viewController presentViewController:msgComposer
                                 animated:YES
                               completion:nil];
    
}


// In order for a view to be visible, it:
// 1) must not be hidden,
// 2) must not have an ancestor that is hidden,
// 3) must be a descendant of the key window, and
// 4) must be within the frame of the key window.
//
// Note: this function does not check whether any part of the view is obscured by another view.
+(BOOL)ADCHINAViewIsVisible:(UIView *)view
{
    if (view==nil) {
        return NO;
    }
    return (!view.hidden &&
            ![ZXUIUtil ADCHINAViewHasHiddenAncestor:view]);//&&
//            ![ACUIUtil ADCHINAViewIsDescendantOfKeyWindow:view]);// &&
//            [ACUIUtil ADCHINAViewIntersectsKeyWindow:view]);
}

+(BOOL)ADCHINAViewHasHiddenAncestor:(UIView *)view
{
    if (view==nil) {
        return NO;
    }
    UIView *ancestor = view.superview;
    while (ancestor) {
        if (ancestor.hidden) return YES;
        ancestor = ancestor.superview;
    }
    return NO;
}

+(BOOL)ADCHINAViewIsDescendantOfKeyWindow:(UIView *)view
{
    if (view==nil) {
        return NO;
    }
    UIView *ancestor = view.superview;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    while (ancestor) {
        if (ancestor == keyWindow) return YES;
        
        ancestor = ancestor.superview;
    }
    return NO;
}

+(BOOL)ADCHINAViewIntersectsKeyWindow:(UIView *)view
{
    if (view==nil) {
        return NO;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // We need to call convertRect:toView: on this view's superview rather than on this view itself.
    CGRect viewFrameInWindowCoordinates = [view.superview convertRect:view.frame toView:keyWindow];
    
    return CGRectIntersectsRect(viewFrameInWindowCoordinates, keyWindow.frame);
}

+(CGSize)screenSizeIncludingStatusBar:(BOOL)includeStatusBar
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect applicationBounds = [[UIScreen mainScreen] applicationFrame];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGSize screenSize = screenBounds.size;
    if (includeStatusBar)
        screenSize = applicationBounds.size;
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
        return screenSize;
    
    screenSize = CGSizeMake(screenSize.height, screenSize.width);
    return screenSize;
}

+(CGRect)fullScreenFrameNoIncludeStatusBar {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect applicationBounds = [[UIScreen mainScreen] bounds];
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
        return applicationBounds;
    
    applicationBounds = CGRectMake(applicationBounds.origin.y,applicationBounds.origin.x,applicationBounds.size.height, applicationBounds.size.width);
    return applicationBounds;
}

+ (CGRect)absoluteFrameForView:(UIView*)view
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGRect windowRect = [[[UIApplication sharedApplication] keyWindow] bounds];
    
    CGRect rectAbsolute = [view convertRect:view.bounds toView:nil];
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        windowRect = AdChinaXYWidthHeightRectSwap(windowRect);
        rectAbsolute = AdChinaXYWidthHeightRectSwap(rectAbsolute);
    }
    rectAbsolute = AdChinaFixOriginRotation(rectAbsolute, interfaceOrientation,
                                         windowRect.size.width, windowRect.size.height);
    
    return rectAbsolute;
}

// Attribution: http://stackoverflow.com/questions/6034584/iphone-correct-landscape-window-coordinates
CGRect AdChinaXYWidthHeightRectSwap(CGRect rect)
{
    CGRect newRect = CGRectZero;
    newRect.origin.x = rect.origin.y;
    newRect.origin.y = rect.origin.x;
    newRect.size.width = rect.size.height;
    newRect.size.height = rect.size.width;
    return newRect;
}

// Attribution: http://stackoverflow.com/questions/6034584/iphone-correct-landscape-window-coordinates
CGRect AdChinaFixOriginRotation(CGRect rect, UIInterfaceOrientation orientation, int parentWidth, int parentHeight)
{
    CGRect newRect = CGRectZero;
    switch(orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
            newRect = CGRectMake(parentWidth - (rect.size.width + rect.origin.x), rect.origin.y, rect.size.width, rect.size.height);
            break;
        case UIInterfaceOrientationLandscapeRight:
            newRect = CGRectMake(rect.origin.x, parentHeight - (rect.size.height + rect.origin.y), rect.size.width, rect.size.height);
            break;
        case UIInterfaceOrientationPortrait:
            newRect = rect;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            newRect = CGRectMake(parentWidth - (rect.size.width + rect.origin.x), parentHeight - (rect.size.height + rect.origin.y), rect.size.width, rect.size.height);
            break;
    }
    return newRect;
}

+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha
{
    if(hexColor == nil)
    {
        return [UIColor clearColor];
    }
    
    if([hexColor hasPrefix:@"0x"] == YES ||[hexColor hasPrefix:@"0X"] == YES )
    {
        hexColor = [hexColor substringFromIndex:2];
    }
    
    if([hexColor hasPrefix:@"#"] == YES)
    {
        hexColor = [hexColor substringFromIndex:1];
    }
    
    if([hexColor length] != 6)
    {
        return [UIColor clearColor];
    }
    
    unsigned int red,green,blue;
    
	NSRange range;
	range.length = 2;
	
	range.location = 0;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
	
	range.location = 2;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
	
	range.location = 4;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
	
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:alpha];
}

+(CGRect)getFrameByOrientation:(UIInterfaceOrientation)ori withWeb:(UIWebView *)theWebView{
    CGRect webViewFrame = theWebView.frame;
    webViewFrame.size = [ZXUIUtil screenSizeIncludingStatusBar:YES];
    if(ori == UIInterfaceOrientationLandscapeLeft || ori == UIInterfaceOrientationLandscapeRight){
        if (webViewFrame.size.width < webViewFrame.size.height) {
            CGFloat fTmep = webViewFrame.size.width;
            webViewFrame.size.width = webViewFrame.size.height;
            webViewFrame.size.height = fTmep;
        }
    } else {
        if (webViewFrame.size.width > webViewFrame.size.height) {
            CGFloat fTmep = webViewFrame.size.width;
            webViewFrame.size.width = webViewFrame.size.height;
            webViewFrame.size.height = fTmep;
        }
    }
//    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
//        webViewFrame.size.height -= 100;
//    }
    webViewFrame.origin.x=0;
    webViewFrame.origin.y=0;
    return webViewFrame;
}
@end
