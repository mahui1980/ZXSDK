//
//  BannerViewController.m
//  EncryptTTT
//
//  Created by admin on 16/5/31.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "BannerViewController.h"
#import "ZXBannerView.h"
@interface BannerViewController ()

@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtAID.text = @"36";
    self.txtCLID.text = @"F42564A103BB485EC81B5939E5C3F318";
    self.title = @"BANNER";
}


-(void)submit {

    ZXBannerView *adView = [ZXBannerView createAdViewByAid:self.txtAID.text Clid:self.txtCLID.text delegate:self frame:CGRectMake(0, self.view.bounds.size.height-self.view.bounds.size.width/6.4, self.view.bounds.size.width,self.view.bounds.size.width/6.4)];
    [self.view addSubview:adView];
    adView.delegate = self;
}

-(void)didOpenLangingPage {
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)didCloseLangingPage {
    [self.navigationController setNavigationBarHidden:NO];
}
@end
