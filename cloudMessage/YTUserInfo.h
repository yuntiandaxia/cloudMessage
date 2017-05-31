//
//  userInfo.h
//  cloudMessage
//
//  Created by iMac mini on 2016/11/26.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "chat.h"
#import "YTChatMessage.h"

@interface YTUserInfo : NSObject

@property (nonatomic,strong) NSString    *userName;            //用户名字
@property (nonatomic,strong) NSString    *headerImageName;     //头像名字
//@property (nonatomic,strong) chat        *chatTableviewMessage;//tableviewCell中可显示的信息
@property (nonatomic,strong) YTChatMessage *sessionMessage;      //会话需要的元素，包括文字、图片、视频、音频、以及时间等元素

//-(id)init:(NSString *)userName (NSString *)imageName (chat *)tableMessage (chatMessage)sessionMessage;

@end
