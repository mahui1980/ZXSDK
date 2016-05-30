/************************************************
 *fileName:     ACStringUtil.h
 *description:  File处理
 *function detail:File处理
 *delegate:
 *Created by:Chilly Zhong
 *Created date:12-1-4
 *Modified by:Joson Ma on 2013-1-23
 *Copyright 2011-2013 AdChina. All rights reserved.
 ************************************************/

#import <Foundation/Foundation.h>

@interface ACFileUtil : NSObject
//cache路径
+ (NSString *)cachePath;
//本地路径
+ (NSString *)documentPath;
//为本地文件添加属性
+ (BOOL)addSkipBackupAttribute;
//保存flash cache
+ (BOOL)saveFlashCookie:(NSString *)fc forAdSpaceId:(NSString *)adSpaceId;
//根据广告位读取本地的缓存flash cache file
+ (NSString *)getFlashCookieForAdSpaceId:(NSString *)adSpaceId;
//存储广告信息
+ (BOOL)saveAdData:(NSData *)adData withUrl:(NSString *)adUrl;
//存储网络监控失败信息
+ (BOOL)saveMonitorsData:(NSDictionary *)dict;
//删除一条监控失败信息
+ (BOOL)removeMonitorFile:(NSString *)strName;
//读取全部网络监控失败信息
+ (NSArray *)getMonitorsArray;
//读取一条网络监控失败信息
+ (NSMutableDictionary *)getMonitorsFile:(NSString *)strFile;

//根据url得到本地cache对应文件的保存路径
+ (NSString *)getSavedAdPathWithUrl:(NSString *)adUrl;
//得到本地cache保存路径
+ (NSURL *)getCachesUrl;
//清除本地超7天的缓存文件
+ (void)deleteExpiredFiles;
//存储mraid.js
+ (BOOL)saveMraidData:(NSData *)adData;
+(BOOL)deleteMraidData;
//读取配置文件
+(NSDictionary *)loadTestFile;
@end
