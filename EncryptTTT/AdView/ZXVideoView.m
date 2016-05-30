//
//  ZXVideoView.m
//  EncryptTTT
//
//  Created by mahui on 16/5/30.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "ZXVideoView.h"

@implementation ZXVideoView

+(ZXVideoView *)createAdViewByAid:(NSString *)strAid Clid:(NSString *)strClid delegate:(id)delegate frame:(CGRect)rect {
    ZXVideoView *adView = [[ZXVideoView alloc] initAdViewByAid:strAid Clid:strClid delegate:delegate frame:rect];
    [[AVAudioSession sharedInstance] setDelegate: self];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    adView.autoPlay = YES;
    adView.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin;
    
    return adView;
}

-(void)addCloseButton{
    // Add Close Button
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 25, CGRectGetMinY(self.bounds), 25, 25);
    self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.closeButton addTarget:self action:@selector(closeVideoView) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"adchina_closeButton.png"] forState:UIControlStateNormal];
    [self addSubview:self.closeButton];
}

-(void)showData:(NSString *)dataPath {
    [self playVideoWithFile:dataPath];
    
}

#pragma mark - 视频操作控制
#pragma mark -----------------------------------work flow---------------------------------------
/*视频播放*/
- (void)playBackChanged:(NSNotification *)notification
{
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:{

            
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playBackFinished:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:nil];
            break;
        }
        case MPMoviePlaybackStateInterrupted:{
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self removeMoviePlayer];
            self.hidden = YES;
            break;
        }
        default:
            break;
    }
}




/*视频播放结束*/
- (void)playBackFinished:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.adModel sendTracking:@"21"];
    [self.adModel sendTracking:@"23"];
    [self removeMoviePlayer];
    self.hidden = YES;
    
    
}
- (void)closeVideoView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeMoviePlayer];
    [self.adModel sendTracking:@"20"];
    self.hidden = YES;
}
/*删除player播放*/
- (void)removeMoviePlayer
{
    if (self.moviePlayer) {
        [self.moviePlayer stop];
        self.moviePlayer = nil;
    }
}
/*播放本地文件*/
- (void)playVideoWithFile:(NSString *)videoPath {
    
    // Create Movie Player Controller
    [self removeMoviePlayer];
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPath]];
    self.moviePlayer = player;
    [self.adModel sendTracking:@"22"];
    
    // Set Controls and autoPlay
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    self.moviePlayer.shouldAutoplay = self.autoPlay;
    
    // Add Movie View
    self.moviePlayer.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.moviePlayer.view.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleWidth|
    UIViewAutoresizingFlexibleHeight;
    [self addCloseButton];
    [self insertSubview:self.moviePlayer.view belowSubview:self.closeButton];
    
    // Add Playback Listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackChanged:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    [self startPlaying];
    
}
/*开始播放*/
- (void)startPlaying
{
    if (self) {
        self.autoPlay = YES;
    }
    
    if (self.moviePlayer &&
        self.moviePlayer.playbackState != MPMoviePlaybackStatePlaying &&
        [self.subviews containsObject:self.moviePlayer.view])
    {
        [self.moviePlayer play];
    }
}
/*停止播放*/
- (void)stopPlaying
{
    if (self.moviePlayer &&
        self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
    {
        [self.moviePlayer stop];
    }
}
/*停止播放*/
- (void)showWapBrowser
{
    if ([self.adModel getLandingPag]) {
        [self showWebViewWithUrl:[self.adModel getLandingPag]];
        [self.adModel sendTracking:@"11"];
    }
    if (self.moviePlayer) {
        [self.moviePlayer pause];
    }
    
}
/*ACWapBrowserDelegate 代理 读取WEB结束*/
- (void)didFinishBrowsingWapSite {
    [super didFinishBrowsingWapSite];
    if (self.moviePlayer) {
        [self.moviePlayer play];
    }
    
}



- (void)resumeStoppedRefreshTimer
{
    [super resumeStoppedRefreshTimer];
    if (self.moviePlayer) {
        [self.moviePlayer play];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self showWapBrowser];
    
}



@end
