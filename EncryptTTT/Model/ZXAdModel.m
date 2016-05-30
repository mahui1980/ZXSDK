//
//  ZXAdModel.m
//  EncryptTTT
//
//  Created by mahui on 16/5/29.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "ZXAdModel.h"
#import "AFNetworking.h"
#import "NSDictionary+URL.h"
@implementation ZXAdModel


+(ZXAdModel *)modelWithDict:(NSDictionary *)dict{
    ZXAdModel *model = [[ZXAdModel alloc] init];
    model.adStatus = [dict objectForKey:@"status"];
    model.adErrcode = [dict objectForKey:@"errcode"];
    model.adType = [dict objectForKey:@"type"];
    NSArray *arrCreative = [dict objectForKey:@"creative"];
    if ([arrCreative isKindOfClass:[NSArray class]]) {
        for (int i = 0; i<arrCreative.count; i++) {
            NSDictionary *dictCreative = [arrCreative objectAtIndex:i];
            if ([dictCreative isKindOfClass:[NSDictionary class]]) {
                if ([dictCreative objectForKey:@"type"]) {
                    model.strType  = [dictCreative objectForKey:@"type"];
                }
                if ([dictCreative objectForKey:@"w"]) {
                    if ([[dictCreative objectForKey:@"w"] isKindOfClass:[NSString class]]) {
                        model.strW  = [dictCreative objectForKey:@"w"];
                    } else {
                        
                        model.strW  = [[dictCreative objectForKey:@"w"] stringValue];
                    }
                    
                }
                if ([dictCreative objectForKey:@"h"]) {
                    model.strH  = [dictCreative objectForKey:@"h"];
                    if ([[dictCreative objectForKey:@"h"] isKindOfClass:[NSString class]]) {
                        model.strH  = [dictCreative objectForKey:@"h"];
                    } else {
                        model.strH  = [[dictCreative objectForKey:@"h"] stringValue];
                    }
                }

                if ([dictCreative objectForKey:@"duration"]) {
                    model.strDuration = [dictCreative objectForKey:@"duration"];
                }
                if ([dictCreative objectForKey:@"url"]) {
                    model.strUrl  = [dictCreative objectForKey:@"url"];
                }
                
                if ([dictCreative objectForKey:@"action"]) {
                    model.arrAction = [dictCreative objectForKey:@"action"];
                }
                
                if ([dictCreative objectForKey:@"tracking"]) {
                    model.arrTracking = [dictCreative objectForKey:@"tracking"];
                }
            }
        }
        
    }
    return model;
}


-(NSString *)getLandingPag {
    if (self.arrAction) {
        for (int i = 0; i<self.arrAction.count; i++) {
            NSDictionary *dict = [self.arrAction objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                if ([[[dict objectForKey:@"et"] stringValue] isEqualToString:@"11"] && [dict objectForKey:@"eu"]) {
                    return [dict objectForKey:@"eu"];
                }
            }
        }
    }
    return nil;
}



-(NSArray *)getTrackingArray:(NSString *)strET {
    NSMutableArray *arrReturn = [NSMutableArray array];
    if (self.arrTracking) {
        for (int i = 0; i<self.arrTracking.count; i++) {
            NSDictionary *dict = [self.arrTracking objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                if ([[[dict objectForKey:@"et"] stringValue] isEqualToString:strET] && [dict objectForKey:@"tku"]) {
                    [arrReturn addObjectsFromArray:[dict objectForKey:@"tku"]];
                }
            }
        }
    }
    return arrReturn;
}


-(void)sendTracking:(NSString *)strET {
    NSArray *arrTrack = [self getTrackingArray:strET];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    
    for (int i = 0; i< arrTrack.count; i++) {
        
        NSString *url = [arrTrack objectAtIndex:i];
        NSString *encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager GET:encodedUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
            
        }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            
            
        }];
    }
    

}

@end
