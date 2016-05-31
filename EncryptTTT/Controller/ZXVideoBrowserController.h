/************************************************
 *fileName:     ACVideoBrowserController.h
 *description:  banner和full screen跳出的video controller
 *function detail:banner和full screen跳出的video controller
 *Created by:Chilly Zhong
 *Created date:12-2-15
 *modify by:Joson Ma on 2013-3-4
 *Copyright 2011-2013 AdChina. All rights reserved.
 ************************************************/

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class ZXVideoBrowserController;
@protocol ZXVideoBrowserDelegate<NSObject>

@optional
-(void)didFinishBrowsingVideo:(ZXVideoBrowserController *) videoBrowserController;

@end

@interface ZXVideoBrowserController : UIViewController {

}

@property (nonatomic, retain) NSString *videoUrl;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, assign) UIViewController *parentViewControllerForVideo;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, weak) id<ZXVideoBrowserDelegate> delegate;

+ (ZXVideoBrowserController *)sharedVideoBrowserController;
//播放视频
- (void)loadVideoWithUrl:(NSString *)url;
- (void)addCloseButton;
@end
@protocol ACVideoBrowserDelegate <NSObject>
//视频播放结束
-(void)didFinishBrowsingVideo:(ZXVideoBrowserController *) videoBrowserController;
@end