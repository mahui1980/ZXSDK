//
//  ZXFullScreenView.h
//  EncryptTTT
//
//  Created by mahui on 16/5/30.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "ZXWebView.h"

@interface ZXFullScreenView : ZXWebView

@property (nonatomic, strong) UILabel *countDownLabel;

+(ZXFullScreenView *)createAdViewByAid:(NSString *)strAid Clid:(NSString *)strClid delegate:(id)delegate frame:(CGRect)rect;
@end
