//
//  TYRecordIndicatorView.m
//  cloudMessage
//
//  Created by iMac mini on 2016/12/24.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import "YTRecordIndicatorView.h"

#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

NSArray *array;// = [[NSArray alloc] init];

@implementation YTRecordIndicatorView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font          = [UIFont systemFontOfSize:13.0];
        self.textLabel.text          = @"手指上划，取消发送";
        self.textLabel.textColor     = [UIColor blackColor];
        
        //_images = [UIImage imageNamed:@"record_animate_01"]; //record_animate_01
        array = [NSArray arrayWithObjects:[UIImage imageNamed:@"record_animate_01"],
                 [UIImage imageNamed:@"record_animate_02"],
                 [UIImage imageNamed:@"record_animate_03"],
                 [UIImage imageNamed:@"record_animate_04"],
                 [UIImage imageNamed:@"record_animate_05"],
                 [UIImage imageNamed:@"record_animate_06"],
                 [UIImage imageNamed:@"record_animate_07"],
                 [UIImage imageNamed:@"record_animate_08"],
                 [UIImage imageNamed:@"record_animate_09"],
                 nil];
        
        //
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.image = [array objectAtIndex:0];
        
        //设置背景颜色
        self.backgroundColor = UIColorFromHex(0x365560);
        
        //增加毛玻璃特效 UIVisualEffect
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualView.frame   = self.bounds;
        visualView.layer.cornerRadius  = 10.0;
        self.layer.cornerRadius        = 10.0;  //二者保持一致
        visualView.layer.masksToBounds = true;
        
        [self addSubview:visualView];
        [self addSubview:self.imageView];
        [self addSubview:self.textLabel];
    }
    return self;
}

-(void)layoutSubviews{
    self.imageView.translatesAutoresizingMaskIntoConstraints = false;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    //使得_imageView的X、Y位置高15 与UIView相比
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-15]];
    
    //限制_textLabel的位置在_imageView 下面，宽度与UIView 相等
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    self.translatesAutoresizingMaskIntoConstraints = true;
}


-(void)showText:(NSString *)text textColor:(UIColor *)textColor{
    self.textLabel.textColor = [UIColor blackColor];
    if (textColor != [UIColor blackColor]) {
        self.textLabel.textColor = textColor;
    }
    self.textLabel.text = text;
}

-(void)showMetraLevel:(NSUInteger)level{
    if (level > array.count) {
        return;
    }
    //使用多线程初始化UI。
    [self performSelectorOnMainThread:@selector(showIndicatorImage:) withObject:[NSNumber numberWithInteger:level] waitUntilDone:false];
}

-(void)updateLevelMetra:(CGFloat)levelMetra{
    //NSLog(@"开始播放动画吗？");
    levelMetra += -15;
    if (levelMetra > -20) {
        [self showMetraLevel:8];
    }else if (levelMetra > -25) {
        [self showMetraLevel:7];
    }else if (levelMetra > -30) {
        [self showMetraLevel:6];
    }else if (levelMetra > -35) {
        [self showMetraLevel:5];
    }else if (levelMetra > -40) {
        [self showMetraLevel:4];
    }else if (levelMetra > -45) {
        [self showMetraLevel:3];
    }else if (levelMetra > -50) {
        [self showMetraLevel:2];
    }else if (levelMetra > -55) {
        [self showMetraLevel:1];
    }else if (levelMetra > -55) {
        [self showMetraLevel:0];
    }
}

-(void)showIndicatorImage:(NSNumber *)level{
    self.imageView.image = [array objectAtIndex:level.intValue];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end






























































