//
//  VideoViewController.h
//  cloudMessage
//
//  Created by iMac mini on 2017/3/13.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface YTVideoModel : NSObject

@property (nonatomic,strong,readonly)  NSURL *url;

-(instancetype)initWithUrl:(NSURL *)url;

@end


@interface YTVideoViewController : UIViewController

//-(instancetype)initWithVideoUrl:(NSArray<YTVideoModel *> *)videourl;
-(instancetype)initWithVideoUrl:(NSURL *)videourl;

@end














































