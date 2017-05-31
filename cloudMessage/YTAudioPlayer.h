//
//  YTAudioPlayer.h
//  cloudMessage
//
//  Created by iMac mini on 2017/3/10.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YTChatMessage.h"

@interface YTAudioPlayer : NSObject<AVAudioPlayerDelegate>

//-(instancetype)init;

-(void)startPlaying:(YTChatMessage *)message;

-(void)stopPlaying;

@end
