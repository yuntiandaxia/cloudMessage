//
//  TYRecordIndicatorView.h
//  cloudMessage
//
//  Created by iMac mini on 2016/12/24.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTRecordIndicatorView : UIView

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel     *textLabel;

@property (nonatomic,strong) UIImage     *images;

//
-(void)showText:(NSString *)text textColor:(UIColor *)textColor;

-(void)updateLevelMetra:(CGFloat)levelMetra;

-(void)showMetraLevel:(NSUInteger)level;

-(void)showIndicatorImage:(NSNumber *)level;

@end








































