//
//  YTChatModel.h
//  cloudMessage
//
//  Created by iMac mini on 2016/11/21.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger{
    YTMessageTypeSendToOthers,
    YTMessageTypeSendToMe
}YTMessageType;

@interface YTChatModel : NSObject

@property (nonatomic,assign) YTMessageType messageType;

@end
