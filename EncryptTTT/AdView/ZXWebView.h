
#import "ZXAdRequestView.h"
#import "ZXWapBrowserController.h"
#import "ZXVideoBrowserController.h"
#import "ZXMraidWebView.h"
@interface ZXWebView : ZXAdRequestView <UIWebViewDelegate>

@property Boolean bSendTracking;
@property Boolean bProximityMonitoringEnabled;
@property (nonatomic, strong) NSMutableSet *setMonitorWeb;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) ZXMraidWebView *webView;
-(void) addWebView;
-(void)smsContent:(NSString *)strSmsContent toPhoneNumber:(NSString *)strSmsPhoneNumber;
-(void)callPhoneNumber:(NSString *)strPhoneNumber;
- (void)resizeWebPage;
-(void) addActivityView;
-(void)showData:(NSString *)dataPath;
@end
