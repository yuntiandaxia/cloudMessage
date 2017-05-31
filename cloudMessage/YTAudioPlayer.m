//
//  YTAudioPlayer.m
//  cloudMessage
//
//  Created by iMac mini on 2017/3/10.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import "YTAudioPlayer.h"



@implementation YTAudioPlayer

AVAudioPlayer *audioPlayer;// = [AVAudioPlayer new];

-(void)startPlaying:(YTChatMessage *)message{
    //NSLog(@"开始播放！");
    audioPlayer  = [[AVAudioPlayer alloc] init];
    
//    BOOL playing = audioPlayer.playing;
//    if ((audioPlayer != nil) && playing) {
//        [self stopPlaying];
//    }
    
    NSError *error = nil;
    NSData *voiceData = [[NSData alloc] initWithContentsOfURL:message.voiceUrl.filePathURL];
    audioPlayer= [[AVAudioPlayer alloc] initWithData:voiceData error:&error];
    
    audioPlayer.delegate = self;
    
    //设置扬声器
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    [audioPlayer play];
    //NSLog(@"播放完毕！");
}

-(void)stopPlaying{
    [audioPlayer stop];
}

@end






























