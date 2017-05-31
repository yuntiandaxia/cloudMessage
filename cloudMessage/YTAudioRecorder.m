//
//  AudioRecorder.m
//  cloudMessage
//
//  Created by iMac mini on 2017/1/1.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import "YTAudioRecorder.h"

@implementation YTAudioRecorder

YTRecordIndicatorView *recordIndicatorView;

double startTime;
double endTime;

-(instancetype)initWithPath:(NSString *)fileName{
    self = [super init];
    
    //获取目录路径
    NSArray  *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *southPath = [paths objectAtIndex:0];
    
    NSURL *filePath = [NSURL fileURLWithPath:[southPath stringByAppendingPathComponent:fileName]];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    [recordSettings setObject:[NSNumber numberWithBool:false] forKey:AVLinearPCMIsFloatKey];         //
    [recordSettings setObject:[NSNumber numberWithBool:false] forKey:AVLinearPCMIsBigEndianKey];     //
    [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];            //采样位
    [recordSettings setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];  //ID
    [recordSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];              //通道的数目,1单声道,2立体声
    [recordSettings setObject:[NSNumber numberWithInt:16000] forKey:AVSampleRateKey];                //采样率
    [recordSettings setObject:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
    
    NSError *error = nil;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:filePath settings:recordSettings error:&error];
    self.recorder.delegate = self;
    [self.recorder setMeteringEnabled:YES];
    
    //self.operationQueue
    self.operationQueue = [[NSOperationQueue alloc] init];
    
    return self;
}

//-(void)startRecord:
-(void)startRecord:(YTRecordIndicatorView *)recordView
{
    recordIndicatorView = [[YTRecordIndicatorView alloc] init];
    recordIndicatorView = recordView;
    //NSLog(@"开始录音！");
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    startTime = [[NSNumber numberWithDouble:time] longLongValue];
    [self performSelector:@selector(readyStartRecord) withObject:self afterDelay:0.5];
}

-(void)readyStartRecord{
    //NSLog(@"开始录音1!");
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //setCategory:(NSString *)category error:(NSError **)outError
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error]; //设置录音
    [audioSession setActive:YES error:&error];
    [self.recorder record];
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    [operation addExecutionBlock:^{
        [self updateMeters];
    }];
    [self.operationQueue addOperation:operation];
}

-(void)updateMeters{
    do {
        //NSLog(@"循环播放录音动画！");
        [self.recorder updateMeters];
        self.timeInterval = [NSNumber numberWithDouble:self.recorder.currentTime];
        float averagePower = [self.recorder averagePowerForChannel:0];
        
        //
        //delegate?.audioRecorderUpdateMetra(averagePower)
        //[self.delegate audioRecorderUpdateMetra:averagePower];
        //NSLog(@"%@   %f", self.timeInterval, averagePower);
        if (recordIndicatorView != nil) {
            [recordIndicatorView updateLevelMetra:averagePower];
        }
        
        [NSThread sleepForTimeInterval:0.2];
    } while ([self.recorder isRecording]);
    //NSLog(@"循环播放录音动画完毕！");
}

//MARK:-stop
-(void)stopRecord{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    endTime = [[NSNumber numberWithDouble:time] longLongValue];
    self.timeInterval = nil;
    if ((endTime - startTime) < 0.5) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(readyStopRecord) object:self];
    }else{
        self.timeInterval = [NSNumber numberWithDouble:self.recorder.currentTime];
        if ([self.timeInterval intValue] < 1) {
            [self performSelector:@selector(readyStopRecord) withObject:self afterDelay:0.4];
        }else{
            [self readyStopRecord];
        }
    }
    //NSLog(@"%@",self.timeInterval);
}

-(void)readyStopRecord{
    [self.recorder stop];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [audioSession setActive:false withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
}


//MARK:-audio delegate
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"%@",[error localizedDescription]);
}

//MARK:
//-(void)audioRecorderUpdateMetra:(float)metra{
//    //[YTRecordIndicatorView updateLevelMetra:rand()%8];
//}

@end

































































