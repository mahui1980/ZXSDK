//
//  DeviceUtil.m
//  EncryptTTT
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 DS. All rights reserved.
//

#import "ZXAdDeviceUtil.h"
#include <CommonCrypto/CommonDigest.h>
#import <netdb.h>
#import <QuartzCore/QuartzCore.h>
#import "sys/utsname.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@implementation ZXAdDeviceUtil


//设备型号
+(NSString*)getDeviceType{
    //    [[UIDevice currentDevice] systemVersion];
    
    //here use sys/utsname.h
    struct utsname systemInfo;
    uname(&systemInfo);
    //get the device model and the system version
    NSString *deviceString=[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM Rev A)";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    //iPod Touch
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 Wi-Fi";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 Wi-Fi + 3G (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 Wi-Fi + 3G (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 Wi-Fi (Rev A)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (Wi-Fi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 Wi-Fi";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 Wi-Fi + Cellular";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3 Wi-Fi + Cellular";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    //Simulator
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

+(NSString *)getOS {
    return  [NSString stringWithFormat:@"IOS %@", [UIDevice currentDevice].systemVersion];

}

+(NSString *)getSize {
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        size = CGSizeMake(size.height, size.width);
    }


    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat size_x = size.width * scale;
    CGFloat size_y = size.height * scale;
    NSString *strSize = [NSString stringWithFormat:@"%dx%d", (int)size_x,(int)size_y];
    return strSize;
}

+(NSString *)getNetWorkState{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    return state;
}

//+ (NSString *)urlEncodedString
//{
//    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,  (__bridge CFStringRef)self,  NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
//}
@end
