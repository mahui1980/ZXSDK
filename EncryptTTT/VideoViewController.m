//
//  VideoViewController.m
//  EncryptTTT
//
//  Created by admin on 16/5/31.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "VideoViewController.h"
#import "ZXVideoView.h"
@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtAID.text = @"39";
    self.txtCLID.text = @"F42564A103BB485EC81B5939E5C3F318";
    self.title = @"视屏";
}


-(void)submit {
    
    ZXVideoView *adView = [ZXVideoView createAdViewByAid:self.txtAID.text Clid:self.txtCLID.text delegate:self frame:CGRectMake(self.view.bounds.size.width/8, 100, self.view.bounds.size.width/4*3,self.view.bounds.size.width/3*2)];
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
