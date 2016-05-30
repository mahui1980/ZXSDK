/************************************************
 *fileName:     ACVideoBrowserController.m
 *description:  banner和full screen跳出的video controller
 *function detail:banner和full screen跳出的video controller
 *delegate: 
 *Created by:Chilly Zhong
 *Created date:12-2-15
 *modify by:Joson Ma on 2013-3-4
 *Copyright 2011-2013 AdChina. All rights reserved.
 ************************************************/
#import "ACVideoBrowserController.h"
#import "ACUIUtil.h"

@implementation ACVideoBrowserController
@synthesize videoUrl;
@synthesize moviePlayer;
@synthesize parentViewControllerForVideo;
@synthesize delegate;

static ACVideoBrowserController *_videoBrowserController = nil;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
	self.delegate = nil;
	self.moviePlayer = nil;
	self.videoUrl = nil;
    self.closeButton = nil;
    
}

+ (ACVideoBrowserController *)sharedVideoBrowserController {
    if (!_videoBrowserController) {
        _videoBrowserController = [[ACVideoBrowserController alloc] init];
    }
    return _videoBrowserController;
}

- (void)closeVideo:(id)sender {
//	if ([self.parentViewControllerForVideo isKindOfClass:[UINavigationController class]]) {
//        [(UINavigationController *)self.parentViewControllerForVideo popViewControllerAnimated:YES];
//    } else {
//        [self.parentViewControllerForVideo dismissModalViewControllerAnimated:YES];
//    }
    
    if ([self.delegate respondsToSelector:@selector(didFinishBrowsingVideo:)]) {
        [self.delegate didFinishBrowsingVideo:self];
    }
}

- (void)removeMoviePlayer
{	
	if (self.moviePlayer) {
		[moviePlayer stop];
		self.moviePlayer = nil;
	}
}
//MPMovieMediaTypesAvailableNotification
- (void)loadVideoWithUrl:(NSString *)url {
    if (url == nil || [url isEqualToString:@""]) {
        [self closeVideo:nil];
    }
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url]];
	self.moviePlayer = player;
    [player prepareToPlay];
    // Set Controls and autoPlay
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    [moviePlayer setMovieSourceType:MPMovieSourceTypeStreaming];
    [player setContentURL:[NSURL URLWithString:url]];
    moviePlayer.shouldAutoplay = YES;
    
    // Add Movie View
    moviePlayer.view.frame = self.view.bounds;
    moviePlayer.view.autoresizingMask = 
    UIViewAutoresizingFlexibleTopMargin | 
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin | 
    UIViewAutoresizingFlexibleRightMargin;
    self.view.backgroundColor = [UIColor blackColor];
	moviePlayer.view.backgroundColor = [UIColor whiteColor];
	// Add Finish Observer
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(playBackFinished:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:nil];
	[self.moviePlayer view].backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:moviePlayer.view];
    

}

- (void)playBackFinished:(NSNotification *)notification {
	[self closeVideo:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self removeMoviePlayer];
	self.videoUrl = nil;
    self.delegate = nil;
	
//	if (self.delegate) {
//        [delegate didFinishBrowsingVideo];
//    }
}

- (void)addCloseButton {
	// Add Close Button
	self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.self.closeButton.frame = CGRectMake(CGRectGetMaxX(self.view.bounds) - 25, CGRectGetMinY(self.view.bounds), 25, 25);
    self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
	[self.closeButton setBackgroundImage:[UIImage imageNamed:@"adchina_closeButton.png"] forState:UIControlStateNormal];
	[self.closeButton addTarget:self action:@selector(closeVideo:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.closeButton];
}

- (void)viewDidLoad {
	
	self.view.backgroundColor =  [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.5];
	self.view.frame = [ACUIUtil fullScreenFrameNoIncludeStatusBar];
	[self loadVideoWithUrl:self.videoUrl];
	
	if ([self.parentViewControllerForVideo isKindOfClass:[UINavigationController class]]) {
		
		// Get superViewController from NavigationController
		UIViewController *superViewController = nil;
		for (int i = 0; i < [self.navigationController.viewControllers count]; i++) {
			if ([self.navigationController.viewControllers objectAtIndex:i] == self && i > 0) {
				superViewController = [self.navigationController.viewControllers objectAtIndex:i-1];
				break;
			}
		}
	}
    [self addCloseButton];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	if ([(UIViewController *)self.parentViewControllerForVideo respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)]) {
		return [(UIViewController *)self.parentViewControllerForVideo shouldAutorotateToInterfaceOrientation:interfaceOrientation];
	}
    return (interfaceOrientation == UIInterfaceOrientationPortrait);

}
- (BOOL)shouldAutorotate
{
//    if ([(UIViewController *)self.parentViewControllerForVideo respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)]) {
//		return [(UIViewController *)self.parentViewControllerForVideo shouldAutorotate];
//	}
    
    return YES;
}


@end
