//
//  ACMraidWebView.h
//  AdChinaSDK_NARC
//
//  Created by MAP-AdChina on 10/22/13.
//  Copyright (c) 2013 AdChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACMraidWebView : UIWebView
- (void)disableScrolling;
- (void)disableSelection;
- (void)scrollToTop;
-(UIScrollView* )getScrollView;
-(void)scaleWebView:(float) fScale;
@end
