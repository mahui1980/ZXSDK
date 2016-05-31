//
//  ViewController.m
//  EncryptTTT
//
//  Created by admin on 16/5/17.
//  Copyright © 2016年 DS. All rights reserved.
//

#define ENCRYPT_SAVE_KEY        @"ENCRYPT_SAVE_KEY"

#import "ViewController.h"


#import "BannerViewController.h"
#import "FullViewController.h"
#import "InterstitialViewController.h"
#import "VideoViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZXDEMO";
    
    [self.view addSubview:self.tableview];
//    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 200,50)];
//    [b setBackgroundColor:[UIColor redColor]];
//    [b setTitle:@"BANNER" forState:UIControlStateNormal];
//    [b addTarget:self action:@selector(createBannerView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:b];
//    
//    b = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 200,50)];
//    [b setBackgroundColor:[UIColor redColor]];
//    [b setTitle:@"FULL" forState:UIControlStateNormal];
//    [b addTarget:self action:@selector(createFullView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:b];
//    
//    b = [[UIButton alloc] initWithFrame:CGRectMake(100, 250, 200,50)];
//    [b setBackgroundColor:[UIColor redColor]];
//    [b setTitle:@"INTERSTITIAL" forState:UIControlStateNormal];
//    [b addTarget:self action:@selector(createInterstitialView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:b];
//    
//    
//    b = [[UIButton alloc] initWithFrame:CGRectMake(100, 350, 200,50)];
//    [b setBackgroundColor:[UIColor redColor]];
//    [b setTitle:@"VIDEO" forState:UIControlStateNormal];
//    [b addTarget:self action:@selector(createVideoView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:b];
//    
//    [self.view addSubview:self.tableview];
}

-(UITableView *)tableview {
    if (_tableview == nil) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"baseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"BANNER";
            break;
        case 1:
            cell.textLabel.text = @"全屏";
            break;
        case 2:
            cell.textLabel.text = @"插屏";
            break;
        case 3:
            cell.textLabel.text = @"视频";
            break;
        case 4:
            cell.textLabel.text = @"VAST";
            break;
            
        default:
            break;
    }
    
    return cell;


}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            BannerViewController *v = [[BannerViewController alloc] init];
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
        case 1:{
            FullViewController *v = [[FullViewController alloc] init];
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
        case 2:{
            InterstitialViewController *v = [[InterstitialViewController alloc] init];
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
        case 3:{
            VideoViewController *v = [[VideoViewController alloc] init];
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
        case 4:
            
            break;
            
        default:
            break;
    }
}
//
//
//-(void)createBannerView {
//
//    ZXBannerView *adView = [ZXBannerView createAdViewByAid:@"36" Clid:@"F42564A103BB485EC81B5939E5C3F318" delegate:self frame:CGRectMake(0, 250, self.view.bounds.size.width,self.view.bounds.size.width/6.4)];
//    [self.view addSubview:adView];
//    
//    adView.delegate = self;
//}
//
//-(void)createFullView {
//    
//    ZXFullScreenView *adView = [ZXFullScreenView createAdViewByAid:@"37" Clid:@"F42564A103BB485EC81B5939E5C3F318" delegate:self frame:CGRectMake(0, 250, self.view.bounds.size.width,self.view.bounds.size.width/6.4)];
//    [self.view addSubview:adView];
//    
//    adView.delegate = self;
//}
//
//-(void)createInterstitialView {
//    
//    ZXInterstitialView *adView = [ZXInterstitialView createAdViewByAid:@"38" Clid:@"F42564A103BB485EC81B5939E5C3F318" delegate:self frame:CGRectMake(0, 250, self.view.bounds.size.width,self.view.bounds.size.width/6.4)];
//    [self.view addSubview:adView];
//    
//    adView.delegate = self;
//}
//
//-(void)createVideoView {
//    
//    ZXInterstitialView *adView = [ZXInterstitialView createAdViewByAid:@"39" Clid:@"F42564A103BB485EC81B5939E5C3F318" delegate:self frame:CGRectMake(0, 250, self.view.bounds.size.width,self.view.bounds.size.width/6.4)];
//    [self.view addSubview:adView];
//    
//    adView.delegate = self;
//}

@end
