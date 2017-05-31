//
//  YTBaseCell.m
//  cloudMessage
//
//  Created by iMac mini on 2016/11/15.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import "YTChatBaseCell.h"
#import "global.h"

@interface YTChatBaseCell()


@end

#define MinumHeightOfCell 74  //44+30(30表示背景比文字高30)

//CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width-2*55-4*10;
#define availableWidth [[UIScreen mainScreen] bounds].size.width - 2*(44+10) - 30 - 10

//#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

@implementation YTChatBaseCell

//global var
NSLayoutAttribute layoutAttribute;
CGFloat           layoutConstraint;
NSLayoutAttribute backlayoutAttribute;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

/*
 * 功能：初始化基本视图组件、也就是在tableViewcell上绘制头像、信息发送时间、聊天背景、信息条、是否发送失败按钮。
 */
-(void)createView
{
    self.backgroundColor = [UIColor clearColor];
    
    self.iconHeaderButton                  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.iconHeaderButton setImage:[UIImage imageNamed:@"DefaultHead"] forState:UIControlStateNormal];
    [self.iconHeaderButton setUserInteractionEnabled:YES];
    self.iconHeaderButton.layer.cornerRadius  = 22.5f;
    self.iconHeaderButton.layer.borderWidth   = 1.0f;
    self.iconHeaderButton.clipsToBounds       = YES;
    self.iconHeaderButton.layer.masksToBounds = true;
    [self.contentView addSubview:self.iconHeaderButton];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.backgroundImageView setUserInteractionEnabled:YES];  //可交互
    //self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReceiverTextNodeBkg"] highlightedImage:[UIImage imageNamed:@"ReceiverTextNodeBkgHL"]];
    self.backgroundImageView.layer.cornerRadius  = 5.0;
    self.backgroundImageView.layer.masksToBounds = true;
    [self.contentView addSubview:self.backgroundImageView];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.timeLabel setFont:[UIFont systemFontOfSize:17]];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    
    self.indicatorView = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"share_auth_fail"];
    [self.indicatorView setBackgroundImage:image forState:UIControlStateNormal];
    self.indicatorView.hidden = true;
    [self.indicatorView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.indicatorView.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [self.contentView addSubview:self.indicatorView];

    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.messageLabel setUserInteractionEnabled:false];
    [self.messageLabel setNumberOfLines:0];
    [self.messageLabel setFont:[UIFont systemFontOfSize:17]];
    [self.backgroundImageView addSubview:self.messageLabel];
    
    //voice need
    self.voicePlayIndicatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.voicePlayIndicatorImageView setAnimationDuration:1.0];
    [self.backgroundImageView addSubview:self.voicePlayIndicatorImageView];
    
    //video need
    self.videoIndicator = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.backgroundImageView addSubview:self.videoIndicator];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.iconHeaderButton.translatesAutoresizingMaskIntoConstraints    = false;
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false;
    self.timeLabel.translatesAutoresizingMaskIntoConstraints           = false;
    self.indicatorView.translatesAutoresizingMaskIntoConstraints       = false;
    self.messageLabel.translatesAutoresizingMaskIntoConstraints        = false;
    self.voicePlayIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false;
    self.videoIndicator.translatesAutoresizingMaskIntoConstraints      = false;
}

/*
 * 功能：根据信息设置信息显示在左边或者右边、以及是否显示时间戳、根据信息类型设置信息的高度大小等。
 * 第一步、根据信息的收发来安排信息左边显示或者右边显示。
 * 第二步、对时间元素timeLabel添加左边、右边限制，以及高度限制
 * 第三步、根据是否显示时间以及、左边或右边方式设置信息条。
 *
 */
-(void)setMessage:(YTChatMessage *)message
{
    UIImage *backImage    = nil;
    UIImage *hightedImage = nil;
    
    int model = message.messageModel;//(random())%2;
    if (model == YTMessageTypeSendToMe) {
        backImage    = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
        hightedImage = [UIImage imageNamed:@"ReceiverTextNodeBkgHL"];
        self.messageLabel.textColor = [UIColor blackColor];
        layoutAttribute     = NSLayoutAttributeLeft;
        backlayoutAttribute = NSLayoutAttributeRight;
        layoutConstraint    = 10;
    }else{
        backImage    = [UIImage imageNamed:@"SenderTextNodeBkg"];
        hightedImage = [UIImage imageNamed:@"SenderTextNodeBkgHL"];
        self.messageLabel.textColor = [UIColor blackColor];
        layoutAttribute     = NSLayoutAttributeRight;
        backlayoutAttribute = NSLayoutAttributeLeft;
        layoutConstraint    = -10;
    }
    // 拉伸图片 参数1 代表从左侧到指定像素禁止拉伸，该像素之后拉伸，参数2 代表从上面到指定像素禁止拉伸，该像素以下就拉伸
    backImage = [backImage stretchableImageWithLeftCapWidth:backImage.size.width/2 topCapHeight:backImage.size.height/2];
    hightedImage = [hightedImage stretchableImageWithLeftCapWidth:hightedImage.size.width/2 topCapHeight:hightedImage.size.height/2];
    self.backgroundImageView.image            = backImage;
    self.backgroundImageView.highlightedImage = hightedImage;
    //设置头像
    [self.iconHeaderButton setImage:message.iconName forState:UIControlStateNormal];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
    
    //有时间戳显示和没有时间戳显示的限制。
    _iconConstraintNotime   = [NSLayoutConstraint constraintWithItem:_iconHeaderButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeTop multiplier:1 constant:10];
    _iconConstraintWithTime= [NSLayoutConstraint constraintWithItem:_iconHeaderButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_timeLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
    [self.contentView addConstraint:_iconConstraintWithTime];
    
    if (message.shouldShowTimestamp == 0) {
        [self.contentView removeConstraint:_iconConstraintNotime];
        
        NSDate *date             = [NSDate date];//获取当前时间
        NSDateFormatter *format1 = [[NSDateFormatter alloc]init];
        [format1 setDateFormat:@"MM/dd HH:mm:ss"];//yyyy/MM/dd HH:mm:ss
        NSString *str1=[format1 stringFromDate:date];
        self.timeLabel.text = str1;//@"2016/11/29/...";
    }else{
        [self.contentView removeConstraint:_iconConstraintWithTime];
        [self.contentView addConstraint:_iconConstraintNotime];
    }
    
    //对头像iconImageView添加左边(右边)、宽度44限制、高度44限制
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconHeaderButton attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:layoutAttribute multiplier:1 constant:layoutConstraint]];
    [_iconHeaderButton addConstraint:[NSLayoutConstraint constraintWithItem:_iconHeaderButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    [_iconHeaderButton addConstraint:[NSLayoutConstraint constraintWithItem:_iconHeaderButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
    //对背景backgroundImageView添加添加左边(右边)限制、高度和头像平齐，其他不做限制
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundImageView attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:_iconHeaderButton attribute:backlayoutAttribute multiplier:1 constant:layoutConstraint]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_iconHeaderButton attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    //对发送是否成功的标志indicator做宽度17、高度17、Y位置为跟背景图片一样 - 5、左边和背景的右边靠齐
    [_indicatorView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem: nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:17]];
    [_indicatorView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem: nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:17]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem: _backgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem: _backgroundImageView attribute:backlayoutAttribute multiplier:1 constant:0]];
    
    self.indicatorView.hidden = message.isSendSuccess;
    
    NSUInteger Type = (NSUInteger)message.messageType;
    switch (Type) {
        case YTMessageMediaTypeText:
            [self setTextMessage:message];
            break;
        case YTMessageMediaTypePhoto:
            [self setPhotoMessage:message];
            break;
        case YTMessageMediaTypeVoice:
            [self setVoiceMessage:message];
            break;
        case YTMessageMediaTypeVideo:
            [self setVideoMessage:message];
            break;
        default:
            break;
    }
}

/*
 * 功能：设置文本消息，主要是根据文本的长度计算出messageLabel的长度，再根据messageLabel长度和高度计算出信息背景的长度和高度。
 *
 */
-(void)setTextMessage:(YTChatMessage *)message{
    self.messageLabel.text = message.strText ;//@"你好，很高兴认识你,你好，很高兴认识你,你好，很高兴认识你"; //message.strText;
    
    //计算出最大宽度
    [self.messageLabel setPreferredMaxLayoutWidth:availableWidth];
    
    if(self.messageLabel.text != NULL){
        //使得背景图的宽度等于messageLabel的宽度+30，x位置重合，Y位置重合，最大自由宽度210，文字高度比背景低30，
        [self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.messageLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:30]];
        [self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-5]];
        [self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-5]];
        [self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeHeight multiplier:1 constant:-30]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeBottom multiplier:1 constant:-5]];
    }
}

/*
 * 功能：设置图片消息，主要是固定图片的大小，只显示缩略图。
 *
 */
-(void)setPhotoMessage:(YTChatMessage *)message{
    
    //背景重新设置？
    self.backgroundImageView.image = message.photoMessage; //[UIImage imageNamed:@"0.jpg"];//

    //将背景设置成固定大小。
    [self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:120]];
    [self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:140]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-5]];
}

/*
 * 功能：设置音频消息，这里还需要再次确定播放声音动画的左右。背景的左右上面已经确定。
 *
 */
-(void)setVoiceMessage:(YTChatMessage *)message{
    //根据左右设置动画。
    NSArray *imageArray = [NSArray new];
    int model = message.messageModel;
    if (model == YTMessageTypeSendToMe) {
        layoutAttribute     = NSLayoutAttributeLeft;
        layoutConstraint    = 15;
        imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"ReceiverVoiceNodePlaying001"],[UIImage imageNamed:@"ReceiverVoiceNodePlaying002"],[UIImage imageNamed:@"ReceiverVoiceNodePlaying003"], nil];
        self.voicePlayIndicatorImageView.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
    }else{
        layoutAttribute     = NSLayoutAttributeRight;
        layoutConstraint    = -15;
        imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"SenderVoiceNodePlaying001"],[UIImage imageNamed:@"SenderVoiceNodePlaying002"],[UIImage imageNamed:@"SenderVoiceNodePlaying003"], nil];
        self.voicePlayIndicatorImageView.image = [UIImage imageNamed:@"SenderVoiceNodePlaying"];
    }
    [self.voicePlayIndicatorImageView setAnimationImages:imageArray];
    
    //self.backgroundImageView.image = nil;
    [self.backgroundImageView addSubview:self.voicePlayIndicatorImageView];
    
    //给voicePlayIndicatorImageView添加宽度12.5、高度限制17。
    [self.voicePlayIndicatorImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.voicePlayIndicatorImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:12.5]];
    [self.voicePlayIndicatorImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.voicePlayIndicatorImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:17]];
    
    //根据 接收 或者 发送 来确定voicePlayIndicatorImageView距离背景的左边或者右边距离为15。  Y坐标低于5的距离。底部距离高于5.
    [self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.voicePlayIndicatorImageView attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:layoutAttribute multiplier:1 constant:layoutConstraint]];
    [self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.voicePlayIndicatorImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-5]];
    //[self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.voicePlayIndicatorImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-5]];
    
    //根据语音时长设置背景长度
    CGFloat margin = 2*message.voiceDuration.integerValue;
    if (margin >= availableWidth ) {
        margin = availableWidth;
    }
    [self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60 + margin]];
    
    self.indicatorView.hidden = false;
    [self.indicatorView setBackgroundImage:nil forState:UIControlStateNormal];
    [self.indicatorView setBackgroundColor:[UIColor clearColor]];
    NSString *time = [NSString stringWithFormat:@"%ld″",(long)message.voiceDuration.integerValue];
    [self.indicatorView.titleLabel setFont:[UIFont systemFontOfSize:8]];
    [self.indicatorView setTitle:time forState:UIControlStateNormal];
}

/**
 *
 */
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.voicePlayIndicatorImageView startAnimating];
    }else{
        [self.voicePlayIndicatorImageView stopAnimating];
    }
}

-(void)stopAnimation{
    if (self.voicePlayIndicatorImageView.isAnimating) {
        [self.voicePlayIndicatorImageView stopAnimating];
    }
}

-(void)beginAnimation{
    //NSLog(@"开始播放动画");
    [self.voicePlayIndicatorImageView startAnimating];
}

/*
 * 功能：设置视频消息，这里也比较复杂。
 *
 */
-(void)setVideoMessage:(YTChatMessage *)message{
    //设置背景的宽和高
    [self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:160]];
    [self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:120]];
    //设置self.contentView距离self.videoIndicator宽和高距离均为40
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.videoIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.videoIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];
    //设置self.contentView的y、x坐标与背景坐标重合？
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.videoIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.videoIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-5]];
    
    self.videoIndicator.image = [UIImage imageNamed:@"MessageVideoPlay"];
    
    AVAsset *asset = [AVAsset assetWithURL:message.videoUrl];
    AVAssetImageGenerator *imgageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    NSError *error = nil;
    CGImageRef cgImage = [imgageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:&error];
    self.backgroundImageView.image = [UIImage imageWithCGImage:cgImage];
    
    [[NSFileManager defaultManager] removeItemAtURL:message.videoUrl error:&error];
}

/*
 * 功能：根据信息类型计算出相应的cell高度。
 *
 */
-(CGFloat)getMessageHeight:(YTChatMessage *)message{
    CGFloat heightOfCell;
    NSUInteger Type = (NSUInteger)message.messageType;
    switch (Type) {
        case YTMessageMediaTypeText:
            if (message.strText != nil) {//NSStringDrawingUsesLineFragmentOrigin
                CGRect sizeOfRect = [message.strText boundingRectWithSize:CGSizeMake(availableWidth, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
                CGSize sizeOfFont = sizeOfRect.size;
                //NSLog(@"==%f",sizeOfFont.height);
                heightOfCell = sizeOfFont.height;
                if (heightOfCell < MinumHeightOfCell) {  //防止1行的时候过小
                    heightOfCell = MinumHeightOfCell;
                }else{
                    heightOfCell += 50;                  //实际上cell高度 = 文本高度+30+5*2(上下间隙)+2*5隔行间隙
                }
                if (message.shouldShowTimestamp == 0) {
                    heightOfCell += 20;                  //有时间戳显示的时候
                }
            }
            break;
        case YTMessageMediaTypePhoto:
            heightOfCell = 140+5;
            break;
        case YTMessageMediaTypeVoice:
            heightOfCell = MinumHeightOfCell+20;
            if (message.shouldShowTimestamp == 0) {
                heightOfCell += 20;                  //有时间戳显示的时候
            }
            break;
        case YTMessageMediaTypeVideo:
            heightOfCell = 145;
            heightOfCell += 20;
            break;
        default:
            break;
    }
    return heightOfCell;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}


@end





























































