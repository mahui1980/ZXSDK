//
//  ZXAdBaseView.m
//  EncryptTTT
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 DS. All rights reserved.
//


#import "ZXAdBaseView.h"
#import "ZXAdDeviceUtil.h"
#import "ACFileUtil.h"
#import "Base64Util.h"
#import "ACWebView.h"

#import <AdSupport/ASIdentifierManager.h>
static NSString* AdViewUserAgent = nil;

@interface ZXAdBaseView ()<UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSString *strAId;
@property (nonatomic, copy) NSString *strClid;

@end

@implementation ZXAdBaseView




-(ZXAdBaseView *)initAdViewByAid:(NSString *)strAid Clid:(NSString *)strClid delegate:(id)delegate frame:(CGRect)rect {
    
    self = [self initWithFrame:rect];
    self.adBrowserOpen = NO;
    if (AdViewUserAgent == nil) {
        UIWebView* wv = [[UIWebView alloc] initWithFrame:CGRectZero];
        AdViewUserAgent = [[wv stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"] copy];
    }
    
    if (self) {
        self.autoresizesSubviews = YES;
        self.strAId = strAid;
        self.strClid = strClid;
    }
    [self performSelector:@selector(requestAd) withObject:nil afterDelay:0.2];
    return self;
    
}


-(void)requestAd{
    
}

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (AdViewUserAgent == nil) {
        UIWebView* wv = [[UIWebView alloc] initWithFrame:CGRectZero];
        AdViewUserAgent = [[wv stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"] copy];
    }
    
    if (self) {
        self.autoresizesSubviews = YES;

    }
    return self;
}

-(void)clickAdView{
    if ([self.adModel getLandingPag]) {
        [self showWebViewWithUrl:[self.adModel getLandingPag]];
        [self.adModel sendTracking:@"11"];
    }
    
    
    
}


-(void)addClickGestureRecognizer {
    if (self.tapGesture) {
        [self removeGestureRecognizer:self.tapGesture];
    }
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAdView)];
    self.tapGesture.delegate = self;
    [self addGestureRecognizer:self.tapGesture];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

-(NSMutableDictionary *)createParam {
    
    NSMutableDictionary *dicTemp = [NSMutableDictionary dictionary];
    [dicTemp setObject:self.strAId forKey:@"aid"];
    [dicTemp setObject:@"Apple" forKey:@"bn"];
    [dicTemp setObject:[ZXAdDeviceUtil getDeviceType] forKey:@"mn"];
    [dicTemp setObject:[ZXAdDeviceUtil getOS] forKey:@"os"];
    [dicTemp setObject:[ZXAdDeviceUtil getSize] forKey:@"rs"];
    [dicTemp setObject:[ZXAdDeviceUtil getNetWorkState] forKey:@"net"];
    [dicTemp setObject:AdViewUserAgent forKey:@"ua"];
    [dicTemp setObject:[NSString stringWithFormat:@"%d",(int)self.bounds.size.width] forKey:@"aw"];
    [dicTemp setObject:[NSString stringWithFormat:@"%d",(int)self.bounds.size.height] forKey:@"ah"];
    [dicTemp setObject:@"json" forKey:@"fmt"];
    [dicTemp setObject:@"0" forKey:@"rm"];
    [dicTemp setObject:@"15" forKey:@"mnd"];
    [dicTemp setObject:@"60" forKey:@"mxd"];
    NSString *strTS = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000];
    [dicTemp setObject:strTS forKey:@"ts"];
    [dicTemp setObject:ZX_AD_SDK_VERSION forKey:@"ver"];
    NSString *adfaId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *adfvId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *strVK = [NSString stringWithFormat:@"%@|%@|%@",self.strClid,adfvId,strTS];
    [dicTemp setObject:adfvId forKey:@"idfv"];
    if(adfaId!=nil && (![adfaId isEqualToString:@""])){
        [dicTemp setObject:adfaId forKey:@"idfa"];
        [dicTemp setObject:@"idfa" forKey:@"ut"];
        strVK = [NSString stringWithFormat:@"%@|%@|%@",self.strClid,adfaId,strTS];
    } else {
        [dicTemp setObject:@"" forKey:@"idfa"];
        [dicTemp setObject:@"idfv" forKey:@"ut"];
        strVK = [NSString stringWithFormat:@"%@|%@|%@",self.strClid,adfvId,strTS];
    }
        
    [dicTemp setObject:@"1" forKey:@"lt"];
    [dicTemp setObject:self.strClid forKey:@"clid"];
    [dicTemp setObject:@"gzip" forKey:@"Accept-Encoding"];
    
    
    NSLog(strVK,nil);
    NSString *strMD5=[Base64Util md5Code:strVK];
    NSLog(strMD5,nil);
    NSString *strBase64=[Base64Util encodeBase64String:strMD5];
    NSLog(strBase64,nil);
    [dicTemp setObject:strMD5 forKey:@"vk"];
    
    return dicTemp;
}



#pragma mark -banner显示计时器控制
#pragma mark -----------------------------------Refresh Cycle---------------------------------------
/************************************************
 *method:       stopRefreshTimer
 *description:  停止计时器
 *param detail:
 *warning:
 *return:
 ************************************************/
- (void)stopRefreshTimer {
    if (self.refreshTimer != nil) {
        [self.refreshTimer performSelectorOnMainThread:@selector(invalidate) withObject:nil waitUntilDone:YES];
        self.refreshTimer = nil;
    }
}
/************************************************
 *method:       resumeStoppedRefreshTimer
 *description:  重新计时器
 *param detail:
 *warning:
 *return:
 ************************************************/
- (void)resumeStoppedRefreshTimer
{
    if (self.nRefresh > 0 && ![self adBrowserOpen] ) {
        [self startRefreshTimerWithDelay:self.nRefresh];
    }
}
/************************************************
 *method:       startRefreshTimerWithDelay:shouldFire:
 *description:  重新计时，并判断是否重新刷新广告
 *param detail:(1)delay 延迟时间
 *warning:
 *return:
 ************************************************/
- (void)startRefreshTimerWithDelay:(int)delay
{
    [self stopRefreshTimer];
    if (delay == -1) {
        return;
    }
    
    self.nRefresh = delay;
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(timerTicked)
                                                       userInfo:nil
                                                        repeats:YES];
}
/************************************************
 *method:       timerTicked:
 *description:  倒计时方法
 当(1)不显示广告时(2)倒计时<=0
 则申请刷新广告
 *param detail: timer 计时器
 *warning:      timeLeftForImp  计秒int
 *return:
 ************************************************/
- (Boolean)timerTicked {
    Boolean bReturn = NO;
    
    if ([ACUIUtil ADCHINAViewIsDescendantOfKeyWindow:self.superview]) {
        self.nRefresh--;
    }
    
    if (self.nRefresh <= 0) {
        if ([ACUIUtil ADCHINAViewIsVisible:self]) {
            [self stopRefreshTimer];
            bReturn = YES;
        }
    }
    return bReturn;
}





- (void)showWebViewWithUrl:(NSString *)url {
    if ([self.delegate isKindOfClass:[UIViewController class]]) {
        
        [ACWapBrowserController clearOldWapBrowser];
        ACWapBrowserController *browserViewController = [ACWapBrowserController sharedWapBrowserController];
        browserViewController.delegate = self;
        browserViewController.wapSiteUrl = url;
        
        [(UIViewController *)self.delegate presentViewController:[ACWapBrowserController sharedWapBrowserController] animated:YES completion:^{
            self.adBrowserOpen = YES;
            [self stopRefreshTimer];
        }];
    }
    

}

- (void)didFinishBrowsingWapSite {
    [[ACWapBrowserController sharedWapBrowserController] dismissViewControllerAnimated:YES completion:nil];
    self.adBrowserOpen = NO;
    [self resumeStoppedRefreshTimer];
}

/************************************************
 *method:       showVideoBrowserWithUrl
 *description:  展示video
 *param detail: url
 *warning:
 *return:
 ************************************************/
- (void)showVideoBrowserWithUrl:(NSString *)url {
    ACVideoBrowserController *browserViewController = [ACVideoBrowserController sharedVideoBrowserController];
    browserViewController.delegate = self;
    browserViewController.videoUrl = url;
    [(UIViewController *)self.delegate presentViewController:browserViewController animated:YES completion:^{
        self.adBrowserOpen = YES;
        [self stopRefreshTimer];
    }];
}

-(void)didFinishBrowsingVideo:(ACVideoBrowserController *) videoBrowserController{
    [[ACVideoBrowserController sharedVideoBrowserController]  dismissViewControllerAnimated:YES completion:nil];
    [self resumeStoppedRefreshTimer];
}


- (NSString *)getGifHtmlStringWithContentSize:(CGSize)contentSize imgPath:(NSString *)imgPath webView:(UIWebView *)theWebView
{
    int viewWidth = theWebView.frame.size.width;
    int viewHeight = theWebView.frame.size.height;
    
    float imgWidth = contentSize.width;
    float imgHeight = contentSize.height;
    
    float fHeight = theWebView.frame.size.height;
    float fWidth = theWebView.frame.size.width;
    if (viewWidth/imgWidth > viewHeight/imgHeight) {     //太宽
        fHeight = theWebView.frame.size.height;
        fWidth = fHeight*imgWidth/imgHeight;
        //        fAdjustTemp = fHeiht/imgHeight;
    } else {                                            //太高
        fWidth = theWebView.frame.size.width;
        fHeight = fWidth*imgHeight/imgWidth;
    
    }
    
    return [NSString stringWithFormat:
            @"<html>\
            <head>\
            <meta name=\"viewport\" content=\"width=%.0f, maximum-scale=10, minimum-scale=0.1, user-scalable=NO\" />\
            <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>\
            <style>html,body{width:100%%;height:100%%}html{display:table}body{display:table-cell;vertical-align:middle;text-align:center}*{margin:0;padding:0}</style>\
            </head>\
            <body>\
            <img  id='img' width='%.0f' height='%.0f' src='%@'></img>\
            </body>\
            </html>",
            fWidth,
            fWidth,
            fHeight,
            [imgPath lastPathComponent]];
}

#pragma mark -读取h5
#pragma mark --------------------------------------------------------------------------
/************************************************
 *method:       showBannerImageWithFile:
 *description:  Show Banner:根据文件路径显示banner的gifwebView
 *param detail: imgPath 文件路径
 *warning:      以html的方式显示image(1)如果是gif文件直接通过html显示(2)如果不是图片显示空白
 *return:
 ************************************************/
- (Boolean)showImageWithFile:(NSString *)imgPath inWebView:(UIWebView *)theWebView
{
    float fWidth = theWebView.bounds.size.width;
    float fheight = theWebView.bounds.size.height;
    fWidth = [self.adModel.strW floatValue];
    fheight =[self.adModel.strH floatValue];
    
    CGSize size = CGSizeMake(fWidth, fheight);
    NSString *htmlString = [self getGifHtmlStringWithContentSize:size imgPath:imgPath  webView:theWebView];
    [theWebView loadHTMLString:htmlString baseURL:[ACFileUtil getCachesUrl]];
 
    return YES;
}
/************************************************
 *method:       showHtml5BannerWithUrl:
 *description:  根据文url显示html
 *param detail: url
 *warning:
 *return:
 ************************************************/
- (Boolean)showHtml5WithUrl:(NSString *)strPath inWebView:(UIWebView *)theWebView baseURL:(NSString *)strURL{
    
    NSData *data = [NSData dataWithContentsOfFile:strPath];
    NSString *strHTML = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (strHTML==nil || [strHTML isEqualToString:@""]) {
        return NO;
    }
    
    theWebView.hidden = NO;
    theWebView.userInteractionEnabled = YES;
    theWebView.multipleTouchEnabled = YES;
    theWebView.dataDetectorTypes = UIDataDetectorTypeLink;
    [theWebView loadHTMLString:strHTML baseURL:[NSURL URLWithString:strURL]];
    return YES;
}
@end
