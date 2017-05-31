//
//  YTMenu.h
//  cloudMessage
//
//  Created by iMac mini on 2017/2/4.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTMenuItem.h"

// Menu将要显示的通知
extern NSString * const YTMenuWillAppearNotification;
// Menu已经显示的通知
extern NSString * const YTMenuDidAppearNotification;
// Menu将要隐藏的通知
extern NSString * const YTMenuWillDisappearNotification;
// Menu已经隐藏的通知
extern NSString * const YTMenuDidDisappearNotification;

typedef void(^YTMenuSelectedItem)(NSInteger index, YTMenuItem *item);

typedef enum {
    YTMenuBackgrounColorEffectSolid      = 0, //!<背景显示效果.纯色
    YTMenuBackgrounColorEffectGradient   = 1, //!<背景显示效果.渐变叠加
} YTMenuBackgrounColorEffect;

@interface YTMenu : NSObject

//method
+ (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems selected:(YTMenuSelectedItem)selectedItem;

+ (void)dismissMenu;
+ (BOOL)isShow;

// 主题色
+ (UIColor *)tintColor;
+ (void)setTintColor:(UIColor *)tintColor;

// 圆角
+ (CGFloat)cornerRadius;
+ (void)setCornerRadius:(CGFloat)cornerRadius;

// 箭头尺寸
+ (CGFloat)arrowSize;
+ (void)setArrowSize:(CGFloat)arrowSize;

// 标题字体
+ (UIFont *)titleFont;
+ (void)setTitleFont:(UIFont *)titleFont;

// 背景效果
+ (YTMenuBackgrounColorEffect)backgrounColorEffect;
+ (void)setBackgrounColorEffect:(YTMenuBackgrounColorEffect)effect;

// 是否显示阴影
+ (BOOL)hasShadow;
+ (void)setHasShadow:(BOOL)flag;

// 选中颜色
+ (UIColor*)selectedColor;
+ (void)setSelectedColor:(UIColor*)selectedColor;

// 分割线颜色
+ (UIColor*)separatorColor;
+ (void)setSeparatorColor:(UIColor*)separatorColor;

/// 菜单元素垂直方向上的边距值
+ (CGFloat)menuItemMarginY;
+ (void)setMenuItemMarginY:(CGFloat)menuItemMarginY;

@end



























































