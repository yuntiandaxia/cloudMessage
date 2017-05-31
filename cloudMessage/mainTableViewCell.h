//
//  mainTableViewCell.h
//  cloudMessage
//
//  Created by iMac mini on 2016/11/9.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *strTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
