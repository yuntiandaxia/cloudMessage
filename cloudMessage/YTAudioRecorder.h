//
//  AudioRecorder.h
//  cloudMessage
//
//  Created by iMac mini on 2017/1/1.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YTRecordIndicatorView.h"

@protocol AudioRecorderDelegate

//-(void)audioRecorderUpdateMetra:(float )metra; //没搞懂代理协议和参数传递的区别。

@end

@interface YTAudioRecorder : NSObject<AVAudioRecorderDelegate,AudioRecorderDelegate>

//id<AudioRecorderDelegate> delegate;
@property (retain,nonatomic) id<AudioRecorderDelegate> delegate;

@property (nonatomic,strong) NSDate           *audioDate;
@property (nonatomic,strong) NSOperationQueue *operationQueue;
@property (nonatomic,strong) AVAudioRecorder  *recorder;

@property (nonatomic,strong) NSNumber         *timeInterval;

//
-(instancetype)initWithPath:(NSString *)fileName;

-(void)startRecord:(YTRecordIndicatorView *)recordView;

-(void)stopRecord;


@end
