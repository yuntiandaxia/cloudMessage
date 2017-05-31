//
//  mainTableViewCell.m
//  cloudMessage
//
//  Created by iMac mini on 2016/11/9.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import "mainTableViewCell.h"

@implementation mainTableViewCell

@synthesize headerImage  = _headerImage;
@synthesize timeLabel    = _timeLabel;
@synthesize titleLabel   = _titleLabel;
@synthesize strTextLabel = _strTextLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImage.layer.cornerRadius = 22.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
