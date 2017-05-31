//
//  YTShareMoreView.h
//  cloudMessage
//
//  Created by iMac mini on 2017/3/18.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum NSInteger{
    YTMoreButtonPicture = 1,
    YTMoreButtonTakePhoto,
    YTMoreButtonVideoChat,
    YTMoreButtonLocation,  //4
    YTMoreButtonLuckMoney,
    YTMoreButtonShareMoney,
    YTMoreButtonPersonCard,
    YTMoreButtonVoiceInput,
    YTMoreButtonStore,
    YTMoreButtonCardQuan
}YTMoreButtonType;


@interface YTShareMoreView : UIView

@property(nonatomic,assign) id  target;  //定义属性
@property(nonatomic,assign) SEL action;

//@property (strong,nonatomic) ;

-(id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;//初始化方法

//-(instancetype)initWithFrame:(CGRect)frame;

-(void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end






















