//
//  ZXAdModel.h
//  EncryptTTT
//
//  Created by mahui on 16/5/29.
//  Copyright © 2016年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXAdModel : NSObject


@property (nonatomic, copy) NSString *adStatus;
@property (nonatomic, copy) NSString *adErrcode;
@property (nonatomic, copy) NSString *adType;

@property (nonatomic, copy) NSString *strType;
@property (nonatomic, copy) NSString *strW;
@property (nonatomic, copy) NSString *strH;
@property (nonatomic, copy) NSString *strDuration;
@property (nonatomic, copy) NSString *strUrl;
@property (nonatomic, retain) NSArray *arrAction;
@property (nonatomic, retain) NSArray *arrTracking;

+(ZXAdModel *)modelWithDict:(NSDictionary *)dict;
-(NSString *)getLandingPag;
-(void)sendTracking:(NSString *)strET;
@end
