//
//  ZXBannerView.m
//  EncryptTTT
//
//  Created by mahui on 16/5/30.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "ZXBannerView.h"
#import "ZXAnimationController.h"
@implementation ZXBannerView

+(ZXBannerView *)createAdViewByAid:(NSString *)strAid Clid:(NSString *)strClid delegate:(id)delegate frame:(CGRect)rect {
    ZXBannerView *bView = [[ZXBannerView alloc] initAdViewByAid:strAid Clid:strClid delegate:delegate frame:rect];
    return bView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [super webViewDidFinishLoad:webView];
    [self startRefreshTimerWithDelay:60];
    
    if(webView==self.webView){
        [ZXAnimationController commitAnimationForView:self mask:AnimationMaskRandom];
    }
}

- (Boolean)timerTicked {
    Boolean bReturn = [super timerTicked];
    if (bReturn) {
        [self requestAd];
    }
    return bReturn;
}
@end
