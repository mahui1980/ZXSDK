//
//  ZXVideoView.h
//  EncryptTTT
//
//  Created by mahui on 16/5/30.
//  Copyright © 2016年 DS. All rights reserved.
//
#import <AVFoundation/AVAudioSession.h>
#import "ZXAdRequestView.h"

@interface ZXVideoView : ZXAdRequestView<AVAudioSessionDelegate>

@property BOOL autoPlay;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) UIButton *closeButton;
- (void)startPlaying;
- (void)stopPlaying;
- (void)closeVideoView;
+(ZXVideoView *)createAdViewByAid:(NSString *)strAid Clid:(NSString *)strClid delegate:(id)delegate frame:(CGRect)rect;
@end
