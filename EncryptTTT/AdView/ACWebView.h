//
//  ACWebView.h
//  AdChinaSDK_NARC
//
//  Created by AdChina on 13-7-23.
//  Copyright (c) 2013年 AdChina. All rights reserved.
//

#import "ZXAdRequestView.h"
#import "ACWapBrowserController.h"
#import "ACVideoBrowserController.h"
#import "ACMraidWebView.h"
@interface ACWebView : ZXAdRequestView <UIWebViewDelegate>

@property Boolean bProximityMonitoringEnabled;
@property (nonatomic, strong) NSMutableSet *setMonitorWeb;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) ACMraidWebView *webView;
-(void) addWebView;
-(void)smsContent:(NSString *)strSmsContent toPhoneNumber:(NSString *)strSmsPhoneNumber;
-(void)callPhoneNumber:(NSString *)strPhoneNumber;
-(void)performButtonAction;
- (void)showWapBrowser;
- (void)resizeWebPage;
-(void) addActivityView;
-(void)showData:(NSString *)dataPath;
@end
