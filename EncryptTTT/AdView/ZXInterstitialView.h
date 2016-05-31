//
//  ZXInterstitialView.h
//  EncryptTTT
//
//  Created by mahui on 16/5/30.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "ZXWebView.h"

@interface ZXInterstitialView : ZXWebView


@property (nonatomic, strong) UIButton *closeButton;

+(ZXInterstitialView *)createAdViewByAid:(NSString *)strAid Clid:(NSString *)strClid delegate:(id)delegate frame:(CGRect)rect;
@end
