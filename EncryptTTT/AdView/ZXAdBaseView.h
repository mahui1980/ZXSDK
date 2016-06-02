//
//  ZXAdBaseView.h
//  EncryptTTT
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZXUIUtil.h"
#import "ZXAdModel.h"
#import "ZXWapBrowserController.h"
#import "ZXVideoBrowserController.h"
#import "ZXAdConstant.h"
@class ZXAdBaseView;
@protocol ZXAdBaseViewDelegate<NSObject>

@optional
-(void)didShowAdView:(ZXAdBaseView *)adView;
-(void)didOpenLangingPage;
-(void)didCloseLangingPage;
-(void)didCloseAdView:(ZXAdBaseView *)adView;

@end

@interface ZXAdBaseView : UIView<ZXWapBrowserDelegate,ZXVideoBrowserDelegate>


-(ZXAdBaseView *)initAdViewByAid:(NSString *)strAid Clid:(NSString *)strClid delegate:(id)delegate frame:(CGRect)rect;


@property (nonatomic, weak) id<ZXAdBaseViewDelegate>  delegate;
@property int nRefresh;
@property (nonatomic, strong) NSTimer *refreshTimer;
@property (nonatomic, strong) UITapGestureRecognizer* tapGesture;
@property (nonatomic, strong) ZXAdModel *adModel;
@property Boolean adBrowserOpen;
-(void)requestAd;
-(NSMutableDictionary *)createParam;
- (void)showWebViewWithUrl:(NSString *)url;
- (void)showVideoBrowserWithUrl:(NSString *)url;

- (Boolean)showImageWithFile:(NSString *)imgPath inWebView:(UIWebView *)theWebView;
- (Boolean)showHtml5WithUrl:(NSString *)strPath inWebView:(UIWebView *)theWebView baseURL:(NSString *)strURL;


-(void)addClickGestureRecognizer;


- (void)startRefreshTimerWithDelay:(int)delay;
- (Boolean)timerTicked;
- (void)resumeStoppedRefreshTimer;
@end
