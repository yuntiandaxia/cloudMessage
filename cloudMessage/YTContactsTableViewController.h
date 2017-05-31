//
//  YTContactsTableViewController.h
//  cloudMessage
//
//  Created by iMac mini on 2017/2/25.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTContactsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISearchBar *YTSearchBar;

@property (strong,nonatomic) NSMutableArray *contactsInfo;

//@property (weak, nonatomic) IBOutlet UITableViewCell *YTTableViewCell;

@end
