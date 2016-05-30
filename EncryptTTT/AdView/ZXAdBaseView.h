//
//  ZXAdBaseView.h
//  EncryptTTT
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ACUIUtil.h"
#import "ZXAdModel.h"
#import "ACWapBrowserController.h"
#import "ACVideoBrowserController.h"
#import "ZXAdConstant.h"
@interface ZXAdBaseViewDelegate


-(void)didShowAdView;

@end

@interface ZXAdBaseView : UIView<ACWapBrowserDelegate>


-(ZXAdBaseView *)initAdViewByAid:(NSString *)strAid Clid:(NSString *)strClid delegate:(id)delegate frame:(CGRect)rect;


@property (nonatomic, weak) id delegate;
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
