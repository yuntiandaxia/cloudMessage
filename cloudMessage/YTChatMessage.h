//
//  chatMessage.h
//  cloudMessage
//
//  Created by iMac mini on 2016/11/22.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef enum : NSUInteger{
    YTMessageMediaTypeText     = 0,
    YTMessageMediaTypePhoto    = 1,
    YTMessageMediaTypeVoice    = 2,
    YTMessageMediaTypeVideo    = 3,
    YTMessageMediaTypeEmotion  = 4,
    YTMessageMediaTypeLocation = 5
}YTMessageMediaType;

typedef enum : NSUInteger{
    YTMessageSendToOthers = 0,
    YTMessageSendToMe     = 1
}YTMessageModel;

@interface YTChatMessage : NSObject

@property (nonatomic,assign) YTMessageMediaType messageType;   //信息类型{text...video}

@property (nonatomic,assign) YTMessageModel messageModel; //信息左右模式

@property (nonatomic,copy) NSString   *strText;           //文本信息

@property (nonatomic,strong) UIImage  *photoMessage;      //图片消息
@property (nonatomic,copy)   NSString *thumbanailUrl;     //预览路径
@property (nonatomic,copy)   NSString *originPhotoUrl;    //原始路径

@property (nonatomic,copy) NSString   *voicePath;         //音频消息
@property (nonatomic,copy) NSURL      *voiceUrl;
@property (nonatomic,copy) NSNumber   *voiceDuration;

@property (nonatomic,strong) UIImage  *videoConvertPhoto; //视频消息
@property (nonatomic,copy)   NSString *videoPath;
@property (nonatomic,copy)   NSURL    *videoUrl;

@property (nonatomic,copy)   NSString *emotionPath;       //表情消息

@property (nonatomic,strong) UIImage  *localPositionPhoto;//地图消息
@property (nonatomic,copy)   NSString *geolocations;
@property (nonatomic,strong) CLLocation *location;

@property (nonatomic,copy) NSDate     *timestamp;        //发送日期

@property (nonatomic,copy) UIImage    *iconName;         //头像显示
@property (nonatomic,copy) NSString   *iconUrl;

@property (nonatomic,copy) NSString   *sender;           //发送者

//
@property (nonatomic,assign) BOOL shouldShowTimestamp;   //是否显示日期

@property (nonatomic,assign) BOOL shouldShowUserName;

@property (nonatomic,assign) BOOL isSendSuccess;         //是否发送成功

@property (nonatomic,assign) BOOL sended;

@property (nonatomic,assign) BOOL isRead;

/*
 * 功能：初始化文本消息
 * @param text   发送的目标文本
 * @param sender 发送者的名字
 * @param date   发送的时间
 *
 * @return 返回Message model对象
 */
-(instancetype)initWithText:(NSString *)text sender:(NSString *)sender timestamp:(NSDate *)timestamp;

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
-(instancetype)initWithPhoto:(UIImage  *)photo
                thumbnailUrl:(NSString *)thumbailUrl
              originPhotoUrl:(NSString *)originPhotoUrl
                      sender:(NSString *)sender
                   timestamp:(NSDate   *)timestamp;

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
-(instancetype)initWithVideoConvertPhoto:(UIImage *)videoConvertPhoto
                               videoPath:(NSString *)videoPath
                                videoUrl:(NSString *)videoUrl
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp;

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
-(instancetype)initWithVoicePath:(NSString *)voicePath
                        voiceUrl:(NSString *)voiceUrl
                   voiceDuration:(NSNumber *)voiceDuration
                          sender:(NSString *)sender
                       timestamp:(NSDate   *)timestamp
                          isRead:(BOOL      )isRead;

/*
 *  功能：初始化gif表情类型的消息
 *
 *  @param emotionPath 表情的路径
 *  @param sender      发送者
 *  @param timestamp   发送时间
 *
 *  @return 返回Message model 对象
 */
-(instancetype)initWithEmotionPath:(NSString *)emotionPath
                            sender:(NSString *)sender
                         timestamp:(NSDate   *)timestamp;


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
-(instancetype)initWithLocalPositionPhoto:(UIImage    *)localPositionPhoto
                             geolocations:(NSString   *)geolocations
                                 location:(CLLocation *)location
                                   sender:(NSString   *)sender
                                timestamp:(NSDate     *)timestamp;



@end

//@class chatMessage;



































