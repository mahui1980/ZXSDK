//
//  ZXVastModel.m
//  EncryptTTT
//
//  Created by admin on 16/6/2.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "ZXVastModel.h"
#import "AFNetworking.h"


@implementation ZXVastModel


-(id)init {

    self = [super init];
    if (self) {
        self.arrImpression = [NSMutableArray array];
        self.arrCreatives = [NSMutableArray array];
    }
    return self;
}

+(ZXVastModel *)modelWithDict:(NSDictionary *)dict {

    ZXVastModel *model = [[ZXVastModel alloc] init];
    
    return model;

}


-(void)sendImpression {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",nil];
    
    for (int i = 0; i< self.arrImpression.count; i++) {
        
        NSString *url = [self.arrImpression objectAtIndex:i];
        NSString *encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager GET:encodedUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
            
        }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            
            
        }];
    }
    
}


@end

@implementation ZXVastCreative

-(id)init {
    
    self = [super init];
    if (self) {
        self.arrClickTracking = [NSMutableArray array];
        self.arrMediaFiles = [NSMutableArray array];
    }
    return self;
}

-(void)sendClickTracking {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",nil];
    
    for (int i = 0; i< self.arrClickTracking.count; i++) {
        
        NSString *url = [self.arrClickTracking objectAtIndex:i];
        NSString *encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager GET:encodedUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
            
        }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            
            
        }];
    }
    
}

@end

@implementation ZXVastMediaFile



@end
