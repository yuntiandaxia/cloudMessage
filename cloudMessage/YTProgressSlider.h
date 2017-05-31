//
//  YTProgressSlider.h
//  cloudMessage
//
//  Created by iMac mini on 2017/3/18.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YTSliderDirection){
    YTSliderDirectionHorizonal  =   0,
    YTSliderDirectionVertical   =   1
};

@interface YTProgressSlider : UIControl

@property (nonatomic, assign) CGFloat minValue;//最小值
@property (nonatomic, assign) CGFloat maxValue;//最大值
@property (nonatomic, assign) CGFloat value;//滑动值
@property (nonatomic, assign) CGFloat sliderPercent;//滑动百分比
@property (nonatomic, assign) CGFloat progressPercent;//缓冲的百分比

@property (nonatomic, assign) BOOL isSliding;//是否正在滑动  如果在滑动的是偶外面监听的回调不应该设置sliderPercent progressPercent 避免绘制混乱

@property (nonatomic, assign) YTSliderDirection direction;//方向

- (id)initWithFrame:(CGRect)frame direction:(YTSliderDirection)direction;

@end
