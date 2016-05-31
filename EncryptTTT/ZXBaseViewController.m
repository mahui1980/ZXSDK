//
//  ZXBaseViewController.m
//  EncryptTTT
//
//  Created by admin on 16/5/31.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXBaseViewController ()

@end

@implementation ZXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createInputField];
}

-(void)createInputField {
    self.txtAID = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 45)];
    self.txtAID.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.txtAID.layer.borderColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1].CGColor;
    self.txtAID.font = [UIFont systemFontOfSize:14];
    self.txtAID.layer.borderWidth = 1;
    self.txtAID.layer.cornerRadius = 5;
    self.txtAID.returnKeyType = UIReturnKeyNext;
    self.txtAID.placeholder = @"输入AID";
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -1 , 50, 45)];
    nameLabel.text = @"  AID:";
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    self.txtAID.leftView=nameLabel;
    self.txtAID.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.txtAID];

    self.txtCLID = [[UITextField alloc]initWithFrame:CGRectMake(20, 170, self.view.bounds.size.width - 40, 45)];
    self.txtCLID.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.txtCLID.layer.borderColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1].CGColor;
    self.txtCLID.font = [UIFont systemFontOfSize:14];
    self.txtCLID.layer.borderWidth = 1;
    self.txtCLID.layer.cornerRadius = 5;
    self.txtCLID.returnKeyType = UIReturnKeyNext;
    self.txtCLID.placeholder = @"输入CLID";
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -1 , 50, 45)];
    nameLabel.text = @"  CLID:";
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    self.txtCLID.leftView=nameLabel;
    self.txtCLID.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.txtCLID];
    
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setBackgroundColor:[UIColor redColor]];
    [btnSubmit setTitle:@"登录" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    btnSubmit.center = self.view.center;
    [self.view addSubview:btnSubmit];
}

-(void)submit {

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.txtAID resignFirstResponder];
    [self.txtCLID resignFirstResponder];
}



@end
