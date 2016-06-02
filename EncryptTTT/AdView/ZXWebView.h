
#import "ZXAdRequestView.h"
#import "ZXWapBrowserController.h"
#import "ZXVideoBrowserController.h"
#import "ZXMraidWebView.h"
@interface ZXWebView : ZXAdRequestView <UIWebViewDelegate>

@property Boolean bSendTracking;
@property Boolean bProximityMonitoringEnabled;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) ZXMraidWebView *webView;
-(void) addWebView;
@end
