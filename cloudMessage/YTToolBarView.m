//
//  toolBarView.m
//  cloudMessage
//
//  Created by iMac mini on 2016/12/14.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import "YTToolBarView.h"
#import "global.h"

@implementation YTToolBarView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = UIColorFromHex(0xF7F7F7);//0xFEFAFA
        
        self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
        [self addSubview:self.voiceButton];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
        [self.textView setFont:[UIFont systemFontOfSize:17]];
        self.textView.layer.borderColor  = UIColorFromHex(0xDADADA).CGColor; //[UIColor colorWithRed:0xDA green:0xDA blue:0xDA alpha:1.0].CGColor;
        self.textView.layer.borderWidth  = 1;
        self.textView.layer.cornerRadius = 5.0;
        self.textView.scrollsToTop       = false;
        self.textView.editable           = YES;  //可编辑
        self.textView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
        //self.textView.backgroundColor    = UIColorFromHex(0xF8FEFB);
        self.textView.returnKeyType      = UIReturnKeySend;
        [self addSubview:self.textView];
        
        self.emotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.emotionButton.tag = 1;
        [self.emotionButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
        [self addSubview:self.emotionButton];
        
        self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreButton.tag = 2;
        [self.moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [self.moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_BlackHL"] forState:UIControlStateHighlighted];
        [self addSubview:self.moreButton];
        
        self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.recordButton setTitle:@"按住  说话" forState:UIControlStateNormal];
        self.recordButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.recordButton setUserInteractionEnabled:true];                 //设置互动
        [self.recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.recordButton setBackgroundColor:UIColorFromHex(0xF6F6F6)];
        self.recordButton.layer.borderColor   = UIColorFromHex(0xDADADA).CGColor;
        self.recordButton.layer.borderWidth   = 1;
        self.recordButton.layer.cornerRadius  = 5.0;
        self.recordButton.layer.masksToBounds = true;
        self.recordButton.hidden              = true;
        [self addSubview:self.recordButton];
        
    }
    return self;
}

-(void)layoutSubviews{
    self.voiceButton.translatesAutoresizingMaskIntoConstraints   = false;
    self.textView.translatesAutoresizingMaskIntoConstraints      = false;
    self.emotionButton.translatesAutoresizingMaskIntoConstraints = false;
    self.moreButton.translatesAutoresizingMaskIntoConstraints    = false;
    self.recordButton.translatesAutoresizingMaskIntoConstraints  = false;
    
    //添加voiceButton左边、高度限制
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
    [self.voiceButton addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:35]];
    
    //添加textView左边、顶部、高度、右边限制
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.voiceButton attribute:NSLayoutAttributeRight multiplier:1 constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
    [self.textView addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:35.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.emotionButton attribute:NSLayoutAttributeLeft multiplier:1 constant:-5]];
    
    //添加emotionButton顶部、右边限制
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.emotionButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.emotionButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.moreButton attribute:NSLayoutAttributeLeft multiplier:1 constant:-5]];
    
    //添加moreButton的右边、顶部限制
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
}

-(void)showRecordButton:(BOOL)show{
    if (show) {
        self.recordButton.hidden = false;
        self.recordButton.frame  = self.textView.frame;
        
        self.textView.hidden     = true;
        [self.recordButton setTitle:@"按住  说话" forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
        
        //
        [self showEmotion:false];
        [self showMore:false];
    }else{
        self.recordButton.hidden = true;
        self.textView.hidden     = false;
        self.textView.inputView  = nil;
        [self.voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
    }
}

-(void)showEmotion:(BOOL)show{
    if (show) {
        self.emotionButton.tag = 0;
        [self.emotionButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
        
        //
        [self showRecordButton:false];
        [self showMore:false];
    }else{
        self.emotionButton.tag = 1;
        self.textView.inputView = nil;
        [self.emotionButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
    }
}

-(void)showMore:(BOOL)show{
    if (show) {
        self.moreButton.tag = 3;
        [self showRecordButton:false];
        [self showEmotion:false];
    }else{
        self.textView.inputView = nil;
        self.moreButton.tag = 2;
    }
}

@end





















































































































