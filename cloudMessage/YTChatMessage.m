//
//  chatMessage.m
//  cloudMessage
//
//  Created by iMac mini on 2016/11/22.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import "YTChatMessage.h"

@implementation YTChatMessage

-(instancetype)initWithText:(NSString *)text sender:(NSString *)sender timestamp:(NSDate *)timestamp
{
    self = [super init];
    if (self) {
        self.strText     = text;
        self.sender      = sender;
        self.timestamp   = timestamp;
        self.messageType = YTMessageMediaTypeText;
    }
    return self;
}

/*
 *  功能：初始化图片类型的消息
 *
 *  @param photo          目标图片
 *  @param thumbnailUrl   目标图片在服务器的缩略图地址
 *  @param originPhotoUrl 目标图片在服务器的原图地址
 *  @param sender         发送者
 *  @param date           发送时间
 *
 *  @return 返回Message model 对象
 */
-(instancetype)initWithPhoto:(UIImage *)photo thumbnailUrl:(NSString *)thumbailUrl originPhotoUrl:(NSString *)originPhotoUrl sender:(NSString *)sender timestamp:(NSDate *)timestamp
{
    self = [super init];
    if (self) {
        self.photoMessage   = photo;
        self.thumbanailUrl  = thumbailUrl;
        self.originPhotoUrl = originPhotoUrl;
        self.sender         = sender;
        self.timestamp      = timestamp;
        
        self.messageType    = YTMessageMediaTypePhoto;
    }
    return self;
}

/*
 *  功能：初始化视频类型的消息
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoPath        目标视频的本地路径，如果是下载过，或者是从本地发送的时候，会存在
 *  @param videoUrl         目标视频在服务器上的地址
 *  @param sender           发送者
 *  @param date             发送时间
 *
 *  @return 返回Message model 对象
 */
-(instancetype)initWithVideoConvertPhoto:(UIImage *)videoConvertPhoto videoPath:(NSString *)videoPath videoUrl:(NSURL *)videoUrl sender:(NSString *)sender timestamp:(NSDate *)timestamp
{
    self = [super init];
    if (self) {
        self.videoConvertPhoto = videoConvertPhoto;
        self.videoPath         = videoPath;
        self.videoUrl          = videoUrl;
        self.sender            = sender;
        self.timestamp         = timestamp;
        
        self.messageType       = YTMessageMediaTypeVideo;
    }
    return self;
}

/*
 *  功能：初始化语音类型的消息
 *
 *  @param voicePath        目标语音的本地路径
 *  @param voiceUrl         目标语音在服务器的地址
 *  @param voiceDuration    目标语音的时长
 *  @param sender           发送者
 *  @param date             发送时间
 *  @param isRead           已读未读标记
 *
 *  @return 返回Message model 对象
 */
-(instancetype)initWithVoicePath:(NSString *)voicePath voiceUrl:(NSURL *)voiceUrl voiceDuration:(NSNumber *)voiceDuration sender:(NSString *)sender timestamp:(NSDate *)timestamp isRead:(BOOL)isRead
{
    self = [super init];
    if (self) {
        self.videoPath     = voicePath;
        self.voiceUrl      = voiceUrl;
        self.voiceDuration = voiceDuration;
        self.sender        = sender;
        self.timestamp     = timestamp;
        self.isRead        = isRead;
        
        self.messageType   = YTMessageMediaTypeVoice;
    }
    return self;
}

/*
 *  功能：初始化gif表情类型的消息
 *
 *  @param emotionPath 表情的路径
 *  @param sender      发送者
 *  @param timestamp   发送时间
 *
 *  @return 返回Message model 对象
 */
-(instancetype)initWithEmotionPath:(NSString *)emotionPath sender:(NSString *)sender timestamp:(NSDate *)timestamp
{
    self = [super init];
    if (self) {
        self.emotionPath = emotionPath;
        self.sender      = sender;
        self.timestamp   = timestamp;
        
        self.messageType = YTMessageMediaTypeEmotion;
    }
    return self;
}

/*
 *  功能：初始化地理位置的消息
 *
 *  @param localPositionPhoto 地理位置默认显示的图
 *  @param geolocations       地理位置的信息
 *  @param location           地理位置的经纬度
 *  @param sender             发送者
 *  @param timestamp          发送时间
 *
 *  @return 返回Message model 对象
 */
-(instancetype)initWithLocalPositionPhoto:(UIImage *)localPositionPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location sender:(NSString *)sender timestamp:(NSDate *)timestamp
{
    self = [super init];
    if (self) {
        self.localPositionPhoto = localPositionPhoto;
        self.geolocations       = geolocations;
        self.location           = location;
        self.sender             = sender;
        self.timestamp          = timestamp;
        
        self.messageType        = YTMessageMediaTypeLocation;
    }
    return self;
}

@end
































































