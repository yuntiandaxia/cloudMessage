//
//  YTBaseCell.h
//  cloudMessage
//
//  Created by iMac mini on 2016/11/15.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "YTChatModel.h"
#import "YTChatMessage.h"

//@protocol YTBaseCellDelegate <NSObject>
//
//-(UIImage *)resizeImage:(UIImage *)argc;
//
//@end

@interface YTChatBaseCell : UITableViewCell

//@property (nonatomic,strong) YTChatModel *model;

@property (nonatomic,strong) UIButton    *iconHeaderButton;
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UILabel     *timeLabel;
@property (nonatomic,strong) UIButton    *indicatorView;
@property (nonatomic,strong) UILabel     *messageLabel;

//voice Message
@property (nonatomic,strong) UIImageView *voicePlayIndicatorImageView;

//video Message
@property (nonatomic,strong) UIImageView *videoIndicator;

@property (nonatomic,strong) NSLayoutConstraint *iconConstraintNotime;
@property (nonatomic,strong) NSLayoutConstraint *iconConstraintWithTime;


-(void)setMessage:(YTChatMessage *)message;

-(CGFloat)getMessageHeight:(YTChatMessage *)message;
//-(UIImage *)resizeImage:(UIImage *)argc;

//播放语音动画
-(void)setSelected:(BOOL)selected animated:(BOOL)animated;

-(void)stopAnimation;

-(void)beginAnimation;

@end





























































