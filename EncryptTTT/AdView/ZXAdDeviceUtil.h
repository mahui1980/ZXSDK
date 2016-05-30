//
//  DeviceUtil.h
//  EncryptTTT
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXAdDeviceUtil : NSObject


+(NSString*)getDeviceType;
+(NSString *)getOS;
+(NSString *)getSize;
+(NSString *)getNetWorkState;
//+(NSString*)urlEncodedString:(NSString *)string;
@end
