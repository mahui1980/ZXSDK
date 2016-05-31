//
//  ZXInterstitialView.m
//  EncryptTTT
//
//  Created by mahui on 16/5/30.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "ZXInterstitialView.h"

@implementation ZXInterstitialView

+(ZXInterstitialView *)createAdViewByAid:(NSString *)strAid Clid:(NSString *)strClid delegate:(id)delegate frame:(CGRect)rect {
    ZXInterstitialView *adView = [[ZXInterstitialView alloc] initAdViewByAid:strAid Clid:strClid delegate:delegate frame:[UIScreen mainScreen].bounds];
    [adView addCloseButton];
    return adView;
}

-(void)addCloseButton{
    // Add Close Button
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 25, CGRectGetMinY(self.bounds)+20, 25, 25);
    self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"adchina_closeButton.png"] forState:UIControlStateNormal];
    [self addSubview:self.closeButton];
}

-(void)closeView {
    [self.adModel sendTracking:@"20"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCloseAdView:)]) {
        [self.delegate didCloseAdView:self];
    }
    [self removeFromSuperview];
    
}
@end
