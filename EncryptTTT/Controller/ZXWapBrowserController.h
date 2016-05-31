
#import <UIKit/UIKit.h>
#import "ZXWebBrowserToolBar.h"

@protocol ZXWapBrowserDelegate;

typedef enum {
    StateIdel,
    StateBeginLoading,
    StateStopLoading
} WapBrowserLoadingState;

typedef enum {
    // expand button or close button
    // flexible indicator
	BackItemIndex = 2,
	// flexible indicator
    NextItemIndex = 4,
	// flexible indicator
    RefreshItemIndex = 6
    // flexible indicator
    // hidden button
} ToolItemIndex;

@interface ZXWapBrowserController : UIViewController <UIWebViewDelegate>
{
    UIWebView *webView;
    UINavigationBar *navBar;
    ACWebBrowserToolBar *toolBar;
//    BOOL isWebViewLoaded;
    UIInterfaceOrientation _orientation;
    
}

+ (ZXWapBrowserController *)sharedWapBrowserController;
+ (void)clearOldWapBrowser;
- (void)setOpaqueForWebView:(BOOL)isOpaque;

@property (nonatomic, retain) id<ZXWapBrowserDelegate,UIWebViewDelegate> delegate;
//@property (nonatomic, assign) UIViewController *parentViewControllerForBrowser;
@property (nonatomic, retain) NSString *wapSiteUrl;

@property (nonatomic, retain) UIBarButtonItem *refreshItem;
@property (nonatomic, retain) UIBarButtonItem *stopItem;
@property (nonatomic, retain) UIBarButtonItem *expandItem;
@property (nonatomic, retain) UIBarButtonItem *closeItem;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *actView;
//webView读取url
- (void)loadWapSiteWithUrl:(NSString *)url;
//webView读取url
- (void)showNavItemWithTitle:(NSString *)itemTitle;
//根据读取状态重加载toolbar
- (void)reloadToolbarForState:(WapBrowserLoadingState)loadingState;

@end

@protocol ZXWapBrowserDelegate <NSObject>
//读取WEB结束
- (void)didFinishBrowsingWapSite;

@end