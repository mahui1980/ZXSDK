//
//  ZXAdRequestView.m
//  EncryptTTT
//
//  Created by mahui on 16/5/29.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "ZXAdRequestView.h"
#import "AFNetworking.h"
#import "NSDictionary+URL.h"
#import "ACFileUtil.h"
@implementation ZXAdRequestView



-(void)requestAd {
    
    
    
    NSDictionary *userInfo = [self createParam];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if ([userInfo objectForKey:@"vk"]) {
        [manager.requestSerializer setValue:[userInfo objectForKey:@"vk"] forHTTPHeaderField:@"vk"];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    NSString *encodedUrl = [ZX_AD_SDK_MAD_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    NSLog(@"endurl====%@?%@",encodedUrl,[dict URLQueryString]);
    
    [manager GET:encodedUrl parameters:dict success:^(AFHTTPRequestOperation *operation,id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"resultObject  ========%@",responseObject);
            self.adModel = [ZXAdModel modelWithDict:responseObject];
            if ([self.adModel.adStatus isEqualToString:@"success"]) {
                [self loadData:self.adModel.strUrl];
            }
            
        });
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        
        [self performSelector:@selector(requestAd) withObject:nil afterDelay:5];
    }];

    
    
}


-(void)loadData:(NSString *)strURL{
    NSString *dataPath = [ACFileUtil getSavedAdPathWithUrl:strURL];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    if (data != nil) {
        [self showData:dataPath];
    } else {
        
        [self downloadData:strURL withPath:dataPath];
    }

}

-(void)downloadData:(NSString *)strURL withPath:(NSString *)dataPath{
    
    
//    NSString *savedPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",strURL]];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"GET" URLString:strURL parameters:nil error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ACFileUtil saveAdData:responseObject withUrl:strURL];
        NSString *dataPath = [ACFileUtil getSavedAdPathWithUrl:strURL];
        [self showData:dataPath];
        NSLog(@"下载成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self performSelector:@selector(requestAd) withObject:nil afterDelay:5];
        NSLog(@"下载失败");
        
    }];
    
    [operation start];

}

-(void)showData:(NSString *)dataPath {

    
    

}
@end
