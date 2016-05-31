//
//  ACWebView.m
//  AdChinaSDK_NARC
//
//  Created by AdChina on 13-7-23.
//  Copyright (c) 2013年 AdChina. All rights reserved.
//

#import <math.h>
#import "ZXWebView.h"

#import <AVFoundation/AVFoundation.h>

@implementation ZXWebView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.setMonitorWeb = [NSMutableSet set];
        [self addWebView];
        [self addActivityView];
        _bSendTracking = NO;
    }
    return self;
}

// Add Activity View
-(void) addActivityView {
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actView.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    actView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    actView.hidesWhenStopped = YES;
    self.activityView = actView;
    [self addSubview:actView];
    
}
// Add web View
-(void) addWebView{
    if(!self.webView) {
        // Add gifWebView
        ZXMraidWebView *gifView = [[ZXMraidWebView alloc] initWithFrame:self.bounds];
        gifView.backgroundColor = [UIColor clearColor];
        gifView.opaque = NO;
        gifView.userInteractionEnabled = YES;
        gifView.scalesPageToFit = NO;
        gifView.contentMode = UIViewContentModeCenter;
        [gifView getScrollView].scrollEnabled = NO;
        
        [gifView disableScrolling];
        self.webView = gifView;
        self.webView.delegate = self;
        [self addSubview:self.webView];
        
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    NSString *scheme = url.scheme;
    if ([scheme isEqualToString:@"about"]) {
        NSString* query = request.URL.resourceSpecifier;
        if ([query isEqualToString:@"blank"]) {
            return NO;
        }
    }
    
    NSString *requestString = [[request URL] absoluteString];
    
	NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 2 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"zxadview"])
	{

		
		NSString *cmd = (NSString *)[components objectAtIndex:1];
		NSString *param = [(NSString *)[components objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		if ([cmd isEqualToString:@"adclick"]) {
            if (param== nil || [param isEqualToString:@""]) {
                [self showWebViewWithUrl:[self.adModel getLandingPag]];
            } else {
                [self showWebViewWithUrl:param];
            }
		} else if ([cmd isEqualToString:@"openweb"]) {
			[self showWebViewWithUrl:param];
		} else if ([cmd isEqualToString:@"closeweb"]) {
			[self didFinishBrowsingWapSite];
		} else if ([cmd isEqualToString:@"openvideo"]) {
			[self showVideoBrowserWithUrl:param];
		} else if ([cmd isEqualToString:@"openstore"]) {
            
        } else if ([cmd isEqualToString:@"call"]) {
            
        } else if ([cmd isEqualToString:@"sms"]) {
            
        } 
		return NO;
	}
	
	return YES;
}



-(void)handleStateChange:(id)sender{
    if ([[UIDevice currentDevice] proximityState] == YES) {
        for (UIWebView *webView in self.setMonitorWeb) {
            NSString* script = [NSString stringWithFormat:@"if(typeof sdkDeviceInfo !='undefined'){sdkDeviceInfo.fireEvent('deviceproximity',{type:'deviceproximity',value:%d})};",1];
            [webView stringByEvaluatingJavaScriptFromString:script];
        }
    } else {
        for (UIWebView *webView in self.setMonitorWeb) {
            NSString* script = [NSString stringWithFormat:@"if(typeof sdkDeviceInfo !='undefined'){sdkDeviceInfo.fireEvent('deviceproximity',{'type':'deviceproximity','value':'%d'})};",0];
            [webView stringByEvaluatingJavaScriptFromString:script];
        }
    }
}


-(void)setWebSize {
    
    self.webView.frame  = self.bounds;
    CGSize pageSize = CGSizeMake(320, 50);
    if (self.adModel.strW!=nil
        && ![self.adModel.strW isEqualToString:@""]
        && self.adModel.strH!=nil
        && ![self.adModel.strH isEqualToString:@""] ) {
        pageSize= CGSizeMake(self.adModel.strW.floatValue, self.adModel.strH.floatValue);
    }
    
    CGFloat imgWidth = pageSize.width;
    CGFloat imgHeight = pageSize.height;
    CGFloat viewWidth = self.webView.bounds.size.width;
    CGFloat viewHeight = self.webView.bounds.size.height;
    float fWidth=0.0;
    float fHeiht=0.0;
    float fAdjustTemp = 0.0;
    if (viewWidth/imgWidth > viewHeight/imgHeight) {     //太宽
        fHeiht = self.webView.frame.size.height;
        fWidth = fHeiht*imgWidth/imgHeight;
        fAdjustTemp = fHeiht/imgHeight;
    } else {                                            //太高
        fWidth = self.webView.frame.size.width;
        fHeiht = fWidth*imgHeight/imgWidth;
        fAdjustTemp = fWidth/imgWidth;
    }

    UIScrollView *scrollView = [self.webView getScrollView];
    [scrollView setContentOffset:CGPointZero];
    self.webView.frame = CGRectMake((self.frame.size.width-fWidth)/2, (self.frame.size.height-fHeiht)/2, fWidth, fHeiht);

}

- (void)resizeWebPage {
    CGSize pageSize = CGSizeMake(self.adModel.strW.floatValue, self.adModel.strH.floatValue);
    if (!CGSizeEqualToSize(pageSize, CGSizeZero)) {
        [self setWebSize];
    }
}



- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (self.webView == webView) {
        [self resizeWebPage];
        [self addClickGestureRecognizer];
        [self.adModel sendTracking:@"2"];
        if ((!self.bSendTracking) && self.delegate && [self.delegate respondsToSelector:@selector(didShowAdView:)]) {
            self.bSendTracking = YES;
            [self.delegate didShowAdView:self];
        }
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}

- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [self.webView scaleWebView:1.0];
    
}

#pragma mark -
#pragma mark -----------------------------------Button Controls---------------------------------------


//
///*UIAlertViewDelegate delegate method*/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // Load action url when user confirmed
	if (buttonIndex == 0) {
        
	}
}

-(void)callPhoneNumber:(NSString *)strPhoneNumber {
    NSString *urlString = [@"tel:" stringByAppendingString:strPhoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(void)smsContent:(NSString *)strSmsContent toPhoneNumber:(NSString *)strSmsPhoneNumber {

    NSString *urlString = [@"sms:" stringByAppendingString:strSmsPhoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}


-(void)showData:(NSString *)dataPath {
    if ([self.adModel.strType isEqualToString:@"img"]) {
        [self showImageWithFile:dataPath inWebView:self.webView];
    } else {
        [self showHtml5WithUrl:dataPath inWebView:self.webView baseURL:self.adModel.strUrl];
    }
    
    
    
}
@end
