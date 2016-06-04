//
//  VastViewController.m
//  EncryptTTT
//
//  Created by admin on 16/6/1.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "VastViewController.h"
#import "ZXVastView.h"
@implementation VastViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.txtAID removeFromSuperview];
    [self.txtCLID removeFromSuperview];
    
}


-(void)submit {
    
    ZXVastView *adView = [ZXVastView createAdViewByAid:@"42"  delegate:self frame:CGRectMake(self.view.bounds.size.width/8, 100, self.view.bounds.size.width/4*3,self.view.bounds.size.width/3*2)];
    [self.view addSubview:adView];
    adView.delegate = self;
}
-(void)didOpenLangingPage {
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)didCloseLangingPage {
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)didShowAdView:(ZXAdBaseView *)adView {
    NSLog(@"didShowAdView");

}

-(void)didCloseAdView:(ZXAdBaseView *)adView {
    NSLog(@"didCloseAdView");
    
}
@end
