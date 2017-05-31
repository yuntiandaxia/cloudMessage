//
//  YTAVPlayView.m
//  cloudMessage
//
//  Created by iMac mini on 2017/3/13.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import "YTAVPlayView.h"

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
@end

@interface YTAVPlayView()
{
    AVPlayerLayer *_playerlayer;
}
@end

@implementation YTAVPlayView

-(instancetype)initWithMoviePlayerLayer:(AVPlayerLayer *)playerLayer frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _playerlayer = playerLayer;
        playerLayer.backgroundColor =  [UIColor blackColor].CGColor;
        _playerlayer.videoGravity   = AVLayerVideoGravityResizeAspect;
        _playerlayer.contentsScale  = [UIScreen mainScreen].scale;
        [self.layer addSublayer:_playerlayer];
    }
    return self;
}

-(void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    
    _playerlayer.bounds   = self.layer.bounds;
    _playerlayer.position = self.layer.position;
}


//+(UIImage *)imageWithColor:(UIColor *)color
+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(UIImage *)resizeImage:(UIImage *)image{
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return image;
}


@end

























































