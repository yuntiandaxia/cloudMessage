//
//  YTAVPlayView.h
//  cloudMessage
//
//  Created by iMac mini on 2017/3/13.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface YTAVPlayView : UIView

- (instancetype)initWithMoviePlayerLayer:(AVPlayerLayer *)playerLayer frame:(CGRect)frame;

@end
