/************************************************
 *fileName:     ACStringUtil.m
 *description:  File处理
 *function detail:File处理
 *delegate:
 *Created by:Chilly Zhong
 *Created date:12-1-4
 *Modified by:Joson Ma on 2013-1-23
 *Copyright 2011-2013 AdChina. All rights reserved.
 ************************************************/
#include <sys/xattr.h>
#import "ACFileUtil.h"


#define kAdChinaPath                @".ZXAdView"
#define kCookiePath                 @".ZXAdView/Cookie"
#define kCachesPath                 @".ZXAdView/Caches"
#define kMonitorsPath               @".ZXAdView/Monitors"

#define kFlashCookieFileFormat      @".ZXAdView/Cookie/fc_%@.log"	// fc_adspaceid.log
#define kCacheIndexFileName         @".ZXAdView/Caches/index.plist"
#define kCacheFileFormat            @"%@.%@"						// datetime.suffix

#define kDateFormat					@"yyyy-MM-dd-HH-mm-ss-SSS"

#define kAdchinaMraid               @"mraid.js"
#define kTestFileName               @"ZXAdView-ios-test.plist"  //test.plist

@implementation ACFileUtil

#pragma -
#pragma Path



+ (NSString *)documentPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
	return documentsDirectory;
}

+ (NSString *)documentPathAppendName:(NSString *)name
{
	return [[self documentPath] stringByAppendingPathComponent:name];
}

+ (BOOL)addSkipBackupAttribute {
    
    NSString *adchinaPath = [self documentPathAppendName:kAdChinaPath];
    const char* filePath = [adchinaPath fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

+ (NSString *)cachePath
{
	return [self documentPathAppendName:kCachesPath];
}

+ (NSString *)cachePathAppendName:(NSString *)name
{
	return [[self cachePath] stringByAppendingPathComponent:name];
}

+ (BOOL)createDirectory:(NSString *)name
{
	return [[NSFileManager defaultManager] createDirectoryAtPath:[self documentPathAppendName:name]
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:nil];
}

+ (BOOL)fileExists:(NSString *)name
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self documentPathAppendName:name]];
}

#pragma -
#pragma Save
+ (BOOL)saveData:(NSData *)data toFile:(NSString *)name
{
    @synchronized([ACFileUtil class]) {
        return [data writeToFile:[self documentPathAppendName:name] atomically:YES];
    }
}

+ (BOOL)saveString:(NSString *)string toFile:(NSString *)name
{
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	return [self saveData:data toFile:name];
}

+ (BOOL)saveDictionary:(NSDictionary *)dictionary toFile:(NSString *)name
{
    @synchronized([ACFileUtil class]) {
        return [dictionary writeToFile:[self documentPathAppendName:name] atomically:YES];
    }
}

#pragma -
#pragma Get
+ (NSData *)getDataInFile:(NSString *)name
{
    return [NSData dataWithContentsOfFile:[self documentPathAppendName:name]];
}

+ (NSString *)getStringInFile:(NSString *)name
{
    return [NSString stringWithContentsOfFile:[self documentPathAppendName:name] encoding:NSUTF8StringEncoding error:nil];
}

+ (NSDictionary *)getDictionaryInFile:(NSString *)name
{
    return [NSDictionary dictionaryWithContentsOfFile:[self documentPathAppendName:name]];
}

#pragma -
#pragma Flash Cookie
+ (BOOL)saveFlashCookie:(NSString *)fc forAdSpaceId:(NSString *)adSpaceId
{
    if ([fc length] > 0) {
        [self createDirectory:kCookiePath];
        return [self saveString:fc toFile:[NSString stringWithFormat:kFlashCookieFileFormat, adSpaceId]];
    }
    return NO;
}

+ (NSString *)getFlashCookieForAdSpaceId:(NSString *)adSpaceId
{
    NSString *fc = [self getStringInFile:[NSString stringWithFormat:kFlashCookieFileFormat, adSpaceId]];
    if ([fc length] == 0) {
        return @"";
    }
    return fc;
}

#pragma -
#pragma Cache
+ (BOOL)addCacheIndexWithUrl:(NSString *)url fileName:(NSString *)name
{
    NSMutableDictionary *dictCacheIndex = [self fileExists:kCacheIndexFileName]? 
    [NSMutableDictionary dictionaryWithDictionary:[self getDictionaryInFile:kCacheIndexFileName]] : [NSMutableDictionary dictionary];
    [dictCacheIndex setObject:name forKey:url];
    return [self saveDictionary:dictCacheIndex toFile:kCacheIndexFileName];
}

+ (BOOL)saveAdData:(NSData *)adData withUrl:(NSString *)adUrl
{
    [self createDirectory:kCachesPath];
    
    // Create image file name with date time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    
    // fileName = dateString + suffix
    NSString *suffix = [[[adUrl lastPathComponent] componentsSeparatedByString:@"."] lastObject];
    NSString *fileName = [NSString stringWithFormat:kCacheFileFormat, dateString, suffix];
    
    // Add cached image to index file, key:imgUrl value:time.suffix
    [self addCacheIndexWithUrl:adUrl fileName:fileName];
    
    return [self saveData:adData toFile:[kCachesPath stringByAppendingPathComponent:fileName]];
}
//删mraid.js
+(BOOL)deleteMraidData {
    //删mraid
    
    [self createDirectory:kCachesPath];
    @try {
        [[NSFileManager defaultManager] removeItemAtPath:[self cachePathAppendName:kAdchinaMraid] error:nil];
    }
    @catch (NSException *e) {
//        [ACSingle logEvent:[e description] ofType:ACChinaSDKDebugModeDetail func:__FUNCTION__ line:__LINE__];
    }
    @finally{
        
    }
    return YES;
}

//存储mraid.js
+ (BOOL)saveMraidData:(NSData *)adData
{
    [self createDirectory:kCachesPath];
    @try {
        [self saveData:adData toFile:[kCachesPath stringByAppendingPathComponent:kAdchinaMraid]];
    }
    @catch (NSException *e) {
//        [ACSingle logEvent:[e description] ofType:ACChinaSDKDebugModeDetail func:__FUNCTION__ line:__LINE__];
    }
    @finally{
        
    }
    
}

//存储网络监控失败信息
+ (BOOL)saveMonitorsData:(NSDictionary *)dict
{
    [self createDirectory:kMonitorsPath];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *strName = [NSString stringWithFormat:@"%@.plist",dateString,nil];
    strName = [kMonitorsPath stringByAppendingPathComponent:strName];
    return [self saveDictionary:dict toFile:strName];
}
//删除一条网络监控失败信息
+ (BOOL)removeMonitorFile:(NSString *)strFile {
    if ((nil == strFile) || [strFile isEqualToString:@""]) {
        return NO;
    }
    NSString *strMonitor = [self documentPathAppendName:kMonitorsPath];
    NSString *strName = [strMonitor stringByAppendingPathComponent:strFile];
    Boolean bReturn = [[NSFileManager defaultManager] removeItemAtPath:strName error:nil];
    return bReturn;
}
//读取全部网络监控失败信息
+ (NSArray *)getMonitorsArray{
    NSString *strPath = [self documentPathAppendName:kMonitorsPath];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:strPath error:nil];
    return array;
}
//取一条网络监控失败信息
+ (NSMutableDictionary *)getMonitorsFile:(NSString *)strFile{
//    NSString *strMonitor = [self documentPathAppendName:kMonitorsPath];
    NSMutableDictionary *returnDict = nil;
    NSString *strName = [kMonitorsPath stringByAppendingPathComponent:strFile];
    @synchronized(self) {
        returnDict = [NSMutableDictionary dictionaryWithDictionary:[self getDictionaryInFile:strName]];        
    }
    return returnDict;
}

+ (NSString *)getSavedAdPathWithUrl:(NSString *)adUrl
{
    NSDictionary *dictCacheIndex = [self getDictionaryInFile:kCacheIndexFileName];
    return [self cachePathAppendName:[dictCacheIndex objectForKey:adUrl]];
}

+ (NSURL *)getCachesUrl
{
    return [NSURL fileURLWithPath:[self cachePath]];
}

+ (void)deleteExpiredFiles {
    [ACFileUtil deleteExpiredCaches];
    [ACFileUtil deleteExpiredMonitors];
}

+ (void)deleteExpiredCaches
{
    // Set cache date format
    //
   
	if ([self fileExists:kCacheIndexFileName])
	{

		NSString *fileName;		// full file name with suffix
		NSString *dateString;	// file name without siffix
		NSDate *cacheDate;		// date from dateString
		
		// Get cache index dicionary
		NSMutableDictionary *dictCacheIndex = [NSMutableDictionary dictionaryWithDictionary:
											   [self getDictionaryInFile:kCacheIndexFileName]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:kDateFormat];
		for (NSString *url in [dictCacheIndex allKeys])
		{
			// Get Cache Date in fileName
			fileName = [(NSString *)[dictCacheIndex objectForKey:url] lastPathComponent];
			dateString = [fileName substringToIndex:
						  [fileName rangeOfString:@"." options:NSBackwardsSearch].location];
			cacheDate = [dateFormatter dateFromString:dateString];
			
			if ([cacheDate timeIntervalSinceNow] < -604800) {		// 7 days old
				[[NSFileManager defaultManager] removeItemAtPath:[self cachePathAppendName:fileName] error:nil];
				[dictCacheIndex removeObjectForKey:url];
			}
		}
    
	}
}

+ (void)deleteExpiredMonitors {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    NSArray *arrtemp = [ACFileUtil getMonitorsArray];
    NSString *fileName = nil;		// full file name with suffix
    NSString *dateString = nil;	// file name without siffix
    NSDate *cacheDate = nil;		// date from dateString
    for (NSString *strFileName in arrtemp) {
        NSString *strFilePathName = [kMonitorsPath stringByAppendingPathComponent:strFileName];
        if ([self fileExists:strFilePathName])
        {
            // Get Cache Date in fileName
            fileName = [strFilePathName lastPathComponent];
            dateString = [fileName substringToIndex:[fileName rangeOfString:@"." options:NSBackwardsSearch].location];
            cacheDate = [dateFormatter dateFromString:dateString];
            if ([cacheDate timeIntervalSinceNow] < -604800) {		// 7 days old
                [[NSFileManager defaultManager] removeItemAtPath:[self documentPathAppendName:strFilePathName] error:nil];
            }
        }
    }

}

+(NSDictionary *)loadTestFile {
    NSString *testPath = [self cachePathAppendName:kTestFileName];
    if (![NSData dataWithContentsOfFile:testPath]) {
        return [NSDictionary dictionary];
    } else {
        NSDictionary *dictConfig = [NSDictionary dictionaryWithContentsOfFile:testPath];
        return dictConfig;
    }
}
@end
