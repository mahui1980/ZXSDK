//
//  InterstitialViewController.m
//  EncryptTTT
//
//  Created by admin on 16/5/31.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "InterstitialViewController.h"
#import "ZXInterstitialView.h"
@interface InterstitialViewController ()

@end

@implementation InterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtAID.text = @"38";
    self.txtCLID.text = @"F42564A103BB485EC81B5939E5C3F318";
}


-(void)submit {
    
    ZXInterstitialView *adView = [ZXInterstitialView createAdViewByAid:self.txtAID.text Clid:self.txtCLID.text delegate:self frame:CGRectMake(0, 250, self.view.bounds.size.width,self.view.bounds.size.width)];
    [self.view addSubview:adView];
    adView.delegate = self;
}
-(void)didShowAdView:(ZXAdBaseView *)adView {
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)didCloseAdView:(ZXAdBaseView *)adView {
    [self.navigationController setNavigationBarHidden:NO];
}
@end
