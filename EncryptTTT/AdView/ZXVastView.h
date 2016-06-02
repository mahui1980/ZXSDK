//
//  ZXVastView.h
//  EncryptTTT
//
//  Created by admin on 16/6/1.
//  Copyright © 2016年 DS. All rights reserved.
//
#import <AVFoundation/AVAudioSession.h>
#import "ZXVideoView.h"
#import "ZXVastModel.h"
@interface ZXVastView : ZXVideoView<AVAudioSessionDelegate,NSXMLParserDelegate>


@property (nonatomic, copy) NSString *curElementName;
@property (nonatomic, strong) NSDictionary *curDict;
@property (nonatomic, strong) ZXVastModel *vastModel;

+(ZXVastView *)createAdViewByAid:(NSString *)strAid Clid:(NSString *)strClid delegate:(id)delegate frame:(CGRect)rect;



@end
