//
//  ZXVastView.m
//  EncryptTTT
//
//  Created by admin on 16/6/1.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "ZXVastView.h"
#import "AFNetworking.h"
#import "NSDictionary+URL.h"

@implementation ZXVastView


+(ZXVastView *)createAdViewByAid:(NSString *)strAid delegate:(id)delegate frame:(CGRect)rect {
    ZXVastView *adView = [[ZXVastView alloc] initAdViewByAid:strAid Clid:nil delegate:delegate frame:rect];
    [[AVAudioSession sharedInstance] setDelegate: self];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    adView.autoPlay = YES;
    adView.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin;
    [adView addCloseButton];
    return adView;


}


-(void)addCloseButton{
    // Add Close Button
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 50, CGRectGetMinY(self.bounds), 45, 25);
    self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.closeButton addTarget:self action:@selector(closeVideoView) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setBackgroundColor:[UIColor clearColor]];
    [self.closeButton setTitle:@"跳过" forState:UIControlStateNormal];
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

    [self removeMoviePlayer];
    self.hidden = YES;
    
    
}
- (void)closeVideoView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeMoviePlayer];
    
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
    [self.vastModel sendImpression];
    
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
    if (self.vastModel.currentCreative.currentMediaFile.adURL) {
        [self showWebViewWithUrl:self.vastModel.currentCreative.adClickThrough];
        [self.vastModel.currentCreative sendClickTracking];
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


-(void)requestAd {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/xml",@"text/xml",@"text/javascript",@"text/html",@"text/plain",nil];
    NSString *encodedUrl = [[NSString stringWithFormat:@"%@%@",ZX_AD_SDK_VAST_URL,self.strAId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    [manager GET:encodedUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSXMLParser *xmlParser = (NSXMLParser *) responseObject;
        xmlParser.delegate = self;
        self.vastModel = [[ZXVastModel alloc] init];
        BOOL flag = [xmlParser parse]; //开始解析
        if(flag) {
            [self loadData:self.vastModel.currentCreative.currentMediaFile.adURL];
        }else{
            NSLog(@"失败");
        }
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        
        [self performSelector:@selector(requestAd) withObject:nil afterDelay:5];
    }];
    
    
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {


}

//当解析器对象遇到xml的开始标记时，调用这个方法。
//获得结点头的值
//解析到一个开始tag，开始tag中可能会有properpies，例如<book catalog="Programming">
//所有的属性都存储在attributeDict中
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    self.curDict = attributeDict;
    self.curElementName = elementName;
    
    if ([elementName isEqualToString:@"MediaFile"]) {
        self.vastModel.currentCreative.currentMediaFile = [[ZXVastMediaFile alloc] init];
        self.vastModel.currentCreative.currentMediaFile.adType = [attributeDict objectForKey:@"type"];
        self.vastModel.currentCreative.currentMediaFile.adWidth = [attributeDict objectForKey:@"width"];
        self.vastModel.currentCreative.currentMediaFile.adHeight = [attributeDict objectForKey:@"height"];
        self.vastModel.currentCreative.currentMediaFile.adDelivery = [attributeDict objectForKey:@"delivery"];
        [self.vastModel.currentCreative.arrMediaFiles addObject:self.vastModel.currentCreative.currentMediaFile];
    } else if ([elementName isEqualToString:@"Creative"]) {
        self.vastModel.currentCreative = [[ZXVastCreative alloc] init];
        [self.vastModel.arrCreatives addObject:self.vastModel.currentCreative];
    }
}

//当解析器找到开始标记和结束标记之间的字符时，调用这个方法。
//解析器，从两个结点之间读取具体内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //记录所取得的文字列
    NSLog(@"foundCharacters string :%@",string);
    
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    NSLog(@"foundCDATA cData:%@",[NSString stringWithUTF8String:[CDATABlock bytes]]);
    if ([self.curElementName isEqualToString:@"AdSystem"]) {
        self.vastModel.AdSystem = [NSString stringWithUTF8String:[CDATABlock bytes]];
    } else if ([self.curElementName isEqualToString:@"AdTitle"]) {
        self.vastModel.AdTitle = [NSString stringWithUTF8String:[CDATABlock bytes]];
    } else if ([self.curElementName isEqualToString:@"Duration"]) {
        self.vastModel.currentCreative.adDuration = [NSString stringWithUTF8String:[CDATABlock bytes]];
    } else if ([self.curElementName isEqualToString:@"MediaFile"]) {
        self.vastModel.currentCreative.currentMediaFile.adURL = [NSString stringWithUTF8String:[CDATABlock bytes]];
    } else if ([self.curElementName isEqualToString:@"ClickThrough"]) {
        self.vastModel.currentCreative.adClickThrough = [NSString stringWithUTF8String:[CDATABlock bytes]];
    } else if ([self.curElementName isEqualToString:@"ClickTracking"]) {
        [self.vastModel.currentCreative.arrClickTracking addObject:[NSString stringWithUTF8String:[CDATABlock bytes]]];
    }
}


//当解析器对象遇到xml的结束标记时，调用这个方法。
//获取结点结尾的值，此处为一Tag的完成
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"didEndElement elementName :%@",elementName);
    NSLog(@"didEndElement qName :%@",qName);
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}
@end
