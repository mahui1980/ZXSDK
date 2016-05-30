/************************************************
 *fileName:     ACWebBrowserToolBar.m
 *description:  6.0新功能根据新接口展示下载app
 *function detail:展示下载app
 *delegate:
 *Created by:Chilly Zhong
 *Created date:12-7-9.
 *modify by:Joson Ma on 2013-3-4
 *Copyright 2011-2013 AdChina. All rights reserved.
 ************************************************/

#import "ACWebBrowserToolBar.h"

@implementation ACWebBrowserToolBar
@synthesize isDrawn;

- (void)drawRect:(CGRect)rect
{
    if (!isDrawn) {
        UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"adchina_toolbar.png"]];
        backImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);//self.bounds;
        backImageView.contentMode = UIViewContentModeScaleToFill;
        backImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self insertSubview:backImageView atIndex:0];
        isDrawn = YES;
    }
}

@end
