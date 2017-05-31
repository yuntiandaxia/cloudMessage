//
//  YTShareMoreView.m
//  cloudMessage
//
//  Created by iMac mini on 2017/3/18.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import "YTShareMoreView.h"
#import "global.h"
#import "YTUIButton.h"

@interface YTShareMoreView()<UIScrollViewDelegate>

@property (strong,nonatomic) NSArray       *titleName;
@property (strong,nonatomic) NSArray       *pictureName;
@property (strong,nonatomic) UIScrollView  *scrollView;
@property (strong,nonatomic) UIPageControl *pageCtrl;

@end

@implementation YTShareMoreView

NSInteger shareCount = 10;
NSInteger marginW    = 30;
NSInteger marginH    = 20;
NSInteger buttonH    = 59;

//-(instancetype)initWithFrame:(CGRect)frame
-(id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor =UIColorFromHex(0xF4F4F6);
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 30)];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setDelegate:self];
        
        //
        self.pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height, self.bounds.size.width, 30)];
        [self.pageCtrl setPageIndicatorTintColor:[UIColor groupTableViewBackgroundColor]];
        [self.pageCtrl setCurrentPageIndicatorTintColor:[UIColor redColor]];
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageCtrl];
        
        self.pageCtrl.numberOfPages = (shareCount%8 == 0)?shareCount/8 : shareCount/8 + 1;
        self.pageCtrl.currentPage   = 0;
        
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * self.pageCtrl.numberOfPages, self.bounds.size.height/2);
        
        CGFloat marginX = (self.bounds.size.width - 2*marginW - 4*buttonH)/3;
        
        //获得标题
        self.titleName = [NSArray arrayWithObjects:@"照片",@"拍摄",@"视频聊天",@"位置",
                          @"红包",@"转账",@"个人名片",@"语音输入",@"收藏",@"卡券",
                          nil];
        
        //获得图片
        self.pictureName = [NSArray arrayWithObjects:[UIImage imageNamed:@"sharemore_pic"],
                            [UIImage imageNamed:@"sharemore_video"],
                            [UIImage imageNamed:@"sharemore_videovoip"],
                            [UIImage imageNamed:@"sharemore_location"],  //4
                            [UIImage imageNamed:@"barbuttonicon_Luckymoney"],
                            [UIImage imageNamed:@"sharemorePay"],
                            [UIImage imageNamed:@"sharemore_friendcard"],
                            [UIImage imageNamed:@"sharemore_voiceinput"], //8
                            [UIImage imageNamed:@"sharemore_myfav"],
                            [UIImage imageNamed:@"sharemore_wallet"],
                            nil];
        
        for (int i=0; i < shareCount; i++)
        {
            NSInteger row    = i/4;
            NSInteger column = i%4;
            NSInteger j=0;
            if (i>=8 && i < 16) {
                j = i/8;
                row -= (j+1);
            }
            
            CGFloat buttonX = marginW + (buttonH + marginX)*column;
            CGFloat buttonY = marginH + (buttonH + marginH)*row;
            
            //button.frame = CGRectMake(buttonX + j*self.bounds.size.width, buttonY, buttonH, buttonH);
            YTUIButton *button = [[YTUIButton alloc] initWithFrame:CGRectMake(buttonX + j*self.bounds.size.width, buttonY, buttonH, buttonH)];
            //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i+1;
            
            //image and title
            UIImage  *image = [self.pictureName objectAtIndex:i];
            NSString *title = [self.titleName objectAtIndex:i];
            
            [button setImage:image forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[UIImage imageNamed:@"sharemore_otherDown"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"sharemore_otherDown_HL"] forState:UIControlStateHighlighted];
            
            self.target = target;
            self.action = action;
            
            [button addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
            
            [self.scrollView addSubview:button];
        }//for
    }
    return self;
}

-(void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger offset = self.scrollView.contentOffset.x / self.bounds.size.width;
    if (offset > 0.5) {
        self.pageCtrl.currentPage = offset + 0.5;
    }else{
        self.pageCtrl.currentPage = offset;
    }
}

@end
























































