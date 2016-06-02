//
//  ZXVastModel.h
//  EncryptTTT
//
//  Created by admin on 16/6/2.
//  Copyright © 2016年 DS. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ZXVastMediaFile : NSObject

@property (nonatomic, copy) NSString *adType;
@property (nonatomic, copy) NSString *adDelivery;
@property (nonatomic, copy) NSString *adWidth;
@property (nonatomic, copy) NSString *adHeight;
@property (nonatomic, copy) NSString *adURL;

@end


@interface ZXVastCreative : NSObject

@property (nonatomic, copy) NSString *adDuration;
@property (nonatomic, copy) NSString *adClickThrough;
@property (nonatomic, strong) NSMutableArray *arrClickTracking;
@property (nonatomic, strong) NSMutableArray *arrMediaFiles;
@property (nonatomic, strong) ZXVastMediaFile *currentMediaFile;

-(void)sendClickTracking;
@end

@interface ZXVastModel : NSObject

@property (nonatomic, copy) NSString *AdSystem;
@property (nonatomic, copy) NSString *AdTitle;
@property (nonatomic, strong) NSMutableArray *arrImpression;
@property (nonatomic, strong) NSMutableArray *arrCreatives;
@property (nonatomic, strong) ZXVastCreative *currentCreative;
-(void)sendImpression;
+(ZXVastModel *)modelWithDict:(NSDictionary *)dict;
@end






