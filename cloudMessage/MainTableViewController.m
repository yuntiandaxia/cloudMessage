//
//  MainTableViewController.m
//  cloudMessage
//
//  Created by iMac mini on 2016/11/6.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import "MainTableViewController.h"

#import "mainTableViewCell.h"
#import "YTChat.h"
#import "YTSessionViewController.h"
#import "YTMenu.h"
#import "YTQRCodeReaderViewController.h"
#import "global.h"

#define statusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define navBarHeight    self.navigationController.navigationBar.frame.size.height

@interface MainTableViewController ()<YTQRCodeReaderDelegate>

@property (nonatomic , strong) NSMutableArray *items;

@end

@implementation MainTableViewController

-(NSMutableArray *)userListArray{
    if (!_userListArray) {
        _userListArray = [NSMutableArray new];
    }
    return _userListArray;
}

@synthesize YTSearchBar = _YTSearchBar;

@synthesize items = _items;

#define cellIdentifier @"identifier"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSArray *array = [[NSArray alloc]initWithObjects:@"A",@"AA",@"B",@"CC",@"dd",@"GG",@"MM",nil];
    //self.userListArray = array;
    
    [self loadSampleData:20];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //rgister the cell to tell the system preparing to reuse it.
    //[self.tableView registerClass: [mainTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillAppear) name:YTMenuWillAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidAppear) name:YTMenuDidAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillDisappear) name:YTMenuWillDisappearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidDisappear) name:YTMenuDidDisappearNotification object:nil];
    
    //设置搜索栏。
    [_YTSearchBar setBarStyle:UIBarStyleDefault];
    [_YTSearchBar setTintColor:[UIColor colorWithRed:0.12 green:0.74 blue:0.13 alpha:1.00]];
    [_YTSearchBar setBackgroundImage:[UIImage imageNamed:@""] forBarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault]; //这个函数比较复杂，关键是参数要输入对。
    [_YTSearchBar setShowsBookmarkButton:YES];
    [_YTSearchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    [_YTSearchBar setDelegate:self];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [_YTSearchBar becomeFirstResponder];
    //NSLog(@"start to seearch!");
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_YTSearchBar becomeFirstResponder];
    //NSLog(@"start to seearch!");
}

-(void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    [_YTSearchBar becomeFirstResponder];
    //NSLog(@"start to seearch!");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)menuWillAppear {
    //NSLog(@"menu will appear");
}

- (void)menuDidAppear {
    //NSLog(@"menu did appear");
}

- (void)menuWillDisappear {
    //NSLog(@"menu will disappear");
}

- (void)menuDidDisappear {
    //NSLog(@"menu did disappear");
}

-(void)loadSampleData:(int)nCount{
    NSArray *xings = @[@"赵",@"钱",@"松",@"李",@"周",@"吴",@"郑",@"王",@"冯",@"陈",@"祝",@"卫",@"江",@"沈",@"韩",@"杨",@"何"];
    NSArray *ming1 = @[@"中",@"国",@"梦",@"春",@"江",@"连",@"水",@"潮",@"海",@"平",@"海",@"上",@"明",@"月",@"共",@"潮",@"升"];
    NSArray *ming2 = @[@"云",@"自",@"飘",@"零",@"水",@"自",@"流",@"天",@"泉",@"直",@"通",@"九",@"州",@"游",@"少",@"年",@"凌"];
    for (int i=0; i < (int)nCount; i++) {
        NSString *name = xings[arc4random_uniform((int)xings.count)];
        NSString *ming = ming1[arc4random_uniform((int)ming1.count)];
        name = [name stringByAppendingString:ming];
        if (arc4random_uniform(10)<7) {
            NSString *mingAdd = ming2[arc4random_uniform((int)ming2.count)];
            name = [name stringByAppendingString:mingAdd];
        }
        
        NSDateFormatter *nsTime=[[NSDateFormatter alloc] init];
        //[nsTime setDateStyle:NSDateFormatterShortStyle];
        [nsTime setDateFormat:@"MM/dd HH:mm"];          //MM/dd HH:mm:ss @"YYYY-MM-DD HH:mm"
        NSString *date = [nsTime stringFromDate:[NSDate date]];
        
        YTChat *tableInfo = [YTChat new];
        tableInfo.titleText = name;
        tableInfo.headerImageName = [NSString stringWithFormat:@"%d.jpg",i];
        tableInfo.strText   = [NSString stringWithFormat:@"%2d_I am detailtext",i];
        tableInfo.timeText  = date;//[NSString stringWithFormat:@"%2@",[NSDate date]];
        
        [self.userListArray addObject:tableInfo]; //这里必须使用self,使用_userListArray无法添加数据。
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    //static NSString *identifier = @"cellidentifier";
    mainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        //cell = [[mainTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    YTChat *tableInfo = self.userListArray[indexPath.row];
    
    cell.headerImage.image = [UIImage imageNamed:tableInfo.headerImageName];
    cell.titleLabel.text   = tableInfo.titleText; //[self.list objectAtIndex:row];
    cell.strTextLabel.text = tableInfo.strText; //@"Detail Information";
    cell.timeLabel.text    = tableInfo.timeText;
    
    //UIImage *highLighedImage = [UIImage imageNamed:@"tabbar_contactsHL"];
    //cell.headerImage.highlightedImage = highLighedImage;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}

//设置滑动时显示多个按钮
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath){
        //1.更新数据
        
        //2.更新UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }];
    
    UITableViewRowAction *flagUnReader = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"标志未读" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath){
        //1.更新数据
        
        //2.更新UI
        [tableView reloadData];
    }];
    flagUnReader.backgroundColor = [UIColor grayColor];
    return @[deleteAction,flagUnReader];
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showSessions"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //sessionTableViewController *destViewController = segue.destinationViewController;
        //destViewController
    }
}

//第二种方法
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    YTSessionViewController *destViewController = [YTSessionViewController new];
    destViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: destViewController animated:YES];
}

#pragma mark - PopMenu

- (IBAction)showMenu1FromNavigationBarItem:(id)sender {
    //NSLog(@"触发了按钮点击事件");
    // 通过NavigationBarItem显示Menu
    if (sender == self.navigationItem.rightBarButtonItem) {
        //[YTMenu setTintColor:[UIColor colorWithRed:0.118 green:0.573 blue:0.820 alpha:1]];
        [YTMenu setTintColor:UIColorFromHex(0x4d4d4d)];
        [YTMenu setMenuItemMarginY:4]; //cell的高度。
        //[YTMenu setArrowSize:80];       //箭头高度
        //UIBarButtonItem *btn = sender;
        [YTMenu setSelectedColor:[UIColor redColor]];
        if ([YTMenu isShow]){
            [YTMenu dismissMenu];
        } else{
            [YTMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50,statusBarHeight+navBarHeight+5 , 44, 0) menuItems:self.items selected:^(NSInteger index, YTMenuItem *item){
                //NSLog(@"%@",item);
                
                if (item.tag == 102) {
                    //进入扫一扫页面
                    [self enterYTQRCodeController];
                }else if (item.tag == 101 ) {
                    //进入添加朋友页面[weakSelf addContactForGroup];
                }
            }];
        }
    }
}

#pragma mark - setter/getter
- (NSMutableArray *)items {
    if (!_items) {
        
        // set title
        YTMenuItem *menuTitle = [YTMenuItem menuTitle:@"Menu" WithIcon:nil];
        menuTitle.foreColor = [UIColor whiteColor];
        menuTitle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
        
        //set logout button
        YTMenuItem *logoutItem = [YTMenuItem menuItem:@"退出" image:nil target:self action:@selector(logout:)];
        logoutItem.foreColor = [UIColor redColor];
        logoutItem.alignment = NSTextAlignmentCenter;
        
        //set item
        _items = [@[//menuTitle,
                    [YTMenuItem menuItem:@"发起群聊"
                                   image:[UIImage imageNamed:@"groupChat"]
                                     tag:100
                                userInfo:@{@"title":@"Menu"}],
                    [YTMenuItem menuItem:@"添加朋友"
                                   image:[UIImage imageNamed:@"addFriends"]
                                     tag:101
                                userInfo:@{@"title":@"Menu"}],
                    [YTMenuItem menuItem:@"扫一扫"
                                   image:[UIImage imageNamed:@"ScanQRCode"]
                                     tag:102
                                userInfo:@{@"title":@"Menu"}],
                    [YTMenuItem menuItem:@"收付款"
                                   image:[UIImage imageNamed:@"payfor"]
                                     tag:103
                                userInfo:@{@"title":@"Menu"}],
                    //logoutItem
                    ] mutableCopy];
    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}

- (void)logout:(id)sender {
    NSLog(@"logout");
}

#pragma
#pragma mark - QRCodeReader Delegate Methods
#pragma
-(void)enterYTQRCodeController{
    MainTableViewController *vc = [MainTableViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    
    YTQRCodeReaderViewController *reader = [YTQRCodeReaderViewController new];
    reader.delegate = self;
    
    __weak typeof (self) wSelf = self;
    [reader setCompletionWithBlock:^(NSString *resultAsString){
        [wSelf.navigationController popViewControllerAnimated:YES];
        [[[UIAlertView alloc] initWithTitle:@"" message:resultAsString delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    }];
    
    [self.navigationController pushViewController:reader animated:YES];
}

- (void)reader:(YTQRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)readerDidCancel:(YTQRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end












































