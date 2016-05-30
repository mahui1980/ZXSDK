//
//  ViewController.m
//  EncryptTTT
//
//  Created by admin on 16/5/17.
//  Copyright © 2016年 DS. All rights reserved.
//

#define ENCRYPT_SAVE_KEY        @"ENCRYPT_SAVE_KEY"

#import "ViewController.h"
#import "ZXAdDeviceUtil.h"
#import <Security/Security.h>

#import <CoreFoundation/CoreFoundation.h>
#import <StoreKit/StoreKit.h>
#import "ZXBannerView.h"
#import "ZXFullScreenView.h"
#import "ZXInterstitialView.h"
#import "ZXVideoView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 200,50)];
    [b setBackgroundColor:[UIColor redColor]];
    [b setTitle:@"BANNER" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(createBannerView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    b = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 200,50)];
    [b setBackgroundColor:[UIColor redColor]];
    [b setTitle:@"FULL" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(createFullView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    b = [[UIButton alloc] initWithFrame:CGRectMake(100, 250, 200,50)];
    [b setBackgroundColor:[UIColor redColor]];
    [b setTitle:@"INTERSTITIAL" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(createInterstitialView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    

}



-(void)createBannerView {

    ZXBannerView *adView = [ZXBannerView createAdViewByAid:@"36" Clid:@"F42564A103BB485EC81B5939E5C3F318" delegate:self frame:CGRectMake(0, 250, self.view.bounds.size.width,self.view.bounds.size.width/6.4)];
    [self.view addSubview:adView];
    
    adView.delegate = self;
}

-(void)createFullView {
    
    ZXFullScreenView *adView = [ZXFullScreenView createAdViewByAid:@"37" Clid:@"F42564A103BB485EC81B5939E5C3F318" delegate:self frame:CGRectMake(0, 250, self.view.bounds.size.width,self.view.bounds.size.width/6.4)];
    [self.view addSubview:adView];
    
    adView.delegate = self;
}

-(void)createInterstitialView {
    
    ZXInterstitialView *adView = [ZXInterstitialView createAdViewByAid:@"38" Clid:@"F42564A103BB485EC81B5939E5C3F318" delegate:self frame:CGRectMake(0, 250, self.view.bounds.size.width,self.view.bounds.size.width/6.4)];
    [self.view addSubview:adView];
    
    adView.delegate = self;
}

-(void)createVideoView {
    
    ZXInterstitialView *adView = [ZXInterstitialView createAdViewByAid:@"39" Clid:@"F42564A103BB485EC81B5939E5C3F318" delegate:self frame:CGRectMake(0, 250, self.view.bounds.size.width,self.view.bounds.size.width/6.4)];
    [self.view addSubview:adView];
    
    adView.delegate = self;
}

@end
