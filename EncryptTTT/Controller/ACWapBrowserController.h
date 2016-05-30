/************************************************
 *fileName:     ACWebBrowserToolBar.m
 *description:  web view controller,网页页面控制controller
 *function detail:(1)web控制
 *                (2)方向控制
 *                (3)toolbar控制
 *
 *delegate: UIWebViewDelegate
 *
 *Created by:Chilly Zhong
 *Created date:12-1-15
 *modify by:Joson Ma on 2013-3-4
 *Copyright 2011-2013 AdChina. All rights reserved.
 ************************************************/
#import <UIKit/UIKit.h>
#import "ACWebBrowserToolBar.h"

@protocol ACWapBrowserDelegate;

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

@interface ACWapBrowserController : UIViewController <UIWebViewDelegate>
{
    UIWebView *webView;
    UINavigationBar *navBar;
    ACWebBrowserToolBar *toolBar;
//    BOOL isWebViewLoaded;
    UIInterfaceOrientation _orientation;
    
}

+ (ACWapBrowserController *)sharedWapBrowserController;
+ (void)clearOldWapBrowser;
- (void)setOpaqueForWebView:(BOOL)isOpaque;

@property (nonatomic, retain) id<ACWapBrowserDelegate,UIWebViewDelegate> delegate;
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

@protocol ACWapBrowserDelegate <NSObject>
//读取WEB结束
- (void)didFinishBrowsingWapSite;

@end