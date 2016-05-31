//
//  ZXFullScreenView.m
//  EncryptTTT
//
//  Created by mahui on 16/5/30.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "ZXFullScreenView.h"

@implementation ZXFullScreenView


+(ZXFullScreenView *)createAdViewByAid:(NSString *)strAid Clid:(NSString *)strClid delegate:(id)delegate frame:(CGRect)rect {
    ZXFullScreenView *bView = [[ZXFullScreenView alloc] initAdViewByAid:strAid Clid:strClid delegate:delegate frame:[UIScreen mainScreen].bounds];
    [bView addCountLabel];
    return bView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [super webViewDidFinishLoad:webView];
    if (self.webView == webView) {
        
            [self.activityView stopAnimating];
            [self addClickGestureRecognizer];
            if ([self.adModel.strDuration intValue] > 0) {
                [self startRefreshTimerWithDelay:[self.adModel.strDuration intValue]];
            } else {
                [self startRefreshTimerWithDelay:5];
            }
        
    }
    

}

- (Boolean)timerTicked {
    Boolean bReturn = [super timerTicked];
    
    if (self.nRefresh > 0)
    {
        self.countDownLabel.hidden = NO;
        self.countDownLabel.text = [NSString stringWithFormat:@"广告剩余 %d 秒",self.nRefresh];
    } else {
        self.countDownLabel.text = [NSString stringWithFormat:@"广告剩余 %d 秒",0];
    }
    
    if (bReturn) {
        self.countDownLabel.hidden = YES;
        [self.adModel sendTracking:@"21"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didCloseAdView:)]) {
            [self.delegate didCloseAdView:self];
        }
        [self removeFromSuperview];
        
    }
    return bReturn;
}

-(void)addCountLabel {
    // Add Count Down Label
    self.countDownLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.countDownLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.countDownLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.countDownLabel.font = [UIFont boldSystemFontOfSize:14];
    self.countDownLabel.frame = CGRectMake(self.frame.size.width-120, 20, 100, 30);
    self.countDownLabel.layer.cornerRadius = 8;
    self.countDownLabel.layer.masksToBounds = YES;
    self.countDownLabel.textAlignment = NSTextAlignmentCenter;
    self.countDownLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.countDownLabel];
    self.countDownLabel.hidden = YES;
}

@end
