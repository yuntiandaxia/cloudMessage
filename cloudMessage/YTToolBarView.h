//
//  toolBarView.h
//  cloudMessage
//
//  Created by iMac mini on 2016/12/14.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTToolBarView : UIView

@property (nonatomic,strong) UITextView *textView;      //

@property (nonatomic,strong) UIButton   *voiceButton;   //

@property (nonatomic,strong) UIButton   *emotionButton; //

@property (nonatomic,strong) UIButton   *moreButton;    //

@property (nonatomic,strong) UIButton   *recordButton;  //

//MARK:-action
//-(void)init:(UIViewController*)target voiceSelector:(NSObject *)selector1 recordSelector:(NSObject *)selector2
//emotionSelector:(NSObject *)selector3 moreSelector:(NSObject *)selector4;

-(void)showRecordButton:(BOOL)show;

-(void)showEmotion:(BOOL)show;

-(void)showMore:(BOOL)show;

@end























































