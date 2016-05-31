//
//  ViewController.h
//  EncryptTTT
//
//  Created by admin on 16/5/17.
//  Copyright © 2016年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base64Util.h"
#import "ZXAdRequestView.h"
@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableview;
@end

