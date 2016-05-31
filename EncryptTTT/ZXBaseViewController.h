//
//  ZXBaseViewController.h
//  EncryptTTT
//
//  Created by admin on 16/5/31.
//  Copyright © 2016年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXAdBaseView.h"
@interface ZXBaseViewController : UIViewController<ZXAdBaseViewDelegate>

@property (nonatomic, strong) UITextField *txtAID;
@property (nonatomic, strong) UITextField *txtCLID;
@end
