//
//  Base64Util.h
//  EncryptTTT
//
//  Created by admin on 16/5/17.
//  Copyright © 2016年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Base64Util : NSObject

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

+(NSString *)md5Code:(NSString *)signString;
@end
