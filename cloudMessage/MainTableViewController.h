//
//  MainTableViewController.h
//  cloudMessage
//
//  Created by iMac mini on 2016/11/6.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (strong,nonatomic) NSMutableArray *userListArray;   //用于存放用户信息。

@property (weak, nonatomic) IBOutlet UISearchBar *YTSearchBar;

@property (weak,nonatomic) NSMutableArray *searchResultsArray; //用于显示搜索结果。

@end
