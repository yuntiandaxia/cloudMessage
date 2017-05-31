//
//  YTContactsTableViewController.m
//  cloudMessage
//
//  Created by iMac mini on 2017/2/25.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import "YTContactsTableViewController.h"
#import "YTTableViewCell.h"
#import "global.h"
#import "YTUserInfo.h"

@interface YTContactsTableViewController ()<UISearchBarDelegate>

@property (nonatomic,strong) UISearchController *searchController;

@property (nonatomic,strong) NSMutableArray     *sectionArray;

@property (nonatomic,strong) NSMutableArray     *sectionTitlesArray;

@end


#define contactsCount 30
static NSString *identifier = @"YTContacts";

@implementation YTContactsTableViewController

- (NSMutableArray *)contactsInfo
{
    if (!_contactsInfo) {
        _contactsInfo = [NSMutableArray new];
    }
    return _contactsInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.searchController = [[UISearchController alloc] initWithSearchResultsController:[UISearchController new]];
    //self.searchController.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    
    UISearchBar *bar = _YTSearchBar; //self.searchController.searchBar;
    bar.barStyle     = UIBarStyleDefault;
    bar.translucent  = YES;
    bar.barTintColor = UIColorFromHex(0xF8F8F8);
    bar.tintColor    = UIColorFromHex(0x00BE0C);
    
    UIImageView *view = [[[bar.subviews objectAtIndex:0] subviews] firstObject];
    view.layer.borderColor = UIColorFromHex(0xF8F8F8).CGColor;
    view.layer.borderWidth = 1;
    
    bar.layer.borderColor  = [UIColor redColor].CGColor;
    
    bar.showsBookmarkButton = YES;
    [bar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    bar.delegate = self;
    
    CGRect rect = bar.frame;
    rect.size.height = 44;
    bar.frame = rect;
    
    self.tableView.tableHeaderView = bar;
    
    self.tableView.rowHeight = 44;
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.tableView.sectionHeaderHeight = 25;
    
    [self.tableView registerClass:[YTTableViewCell class] forCellReuseIdentifier:identifier];
    
    [self createContactsInfo:80];
}

-(void)createContactsInfo:(NSInteger)count{
    NSArray *xings = @[@"啊",@"蓓",@"楚",@"独",@"恩",@"费",@"郭",@"何",@"ii",@"姬",@"柯",@"勒",@"梅",@"奈",@"区",@"邳",
                       @"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王",@"冯",@"陈",@"楚",@"卫",@"蒋",@"沈",@"韩",@"杨"];
    NSArray *ming1 = @[@"大",@"美",@"帅",@"应",@"超",@"海",@"江",@"湖",@"春",@"夏",@"秋",@"冬",@"上",@"左",@"有",@"纯"];
    NSArray *ming2 = @[@"强",@"好",@"领",@"亮",@"超",@"华",@"奎",@"海",@"工",@"青",@"红",@"潮",@"兵",@"垂",@"刚",@"山"];
    
    for (int i=0; i<count; i++) {
        NSString *name = xings[arc4random_uniform((int)xings.count)];
        NSString *ming = ming1[arc4random_uniform((int)ming1.count)];
        name = [name stringByAppendingString:ming];
        if (arc4random_uniform(10) > 3) {
            NSString *ming = ming2[arc4random_uniform((int)ming2.count)];
            name = [name stringByAppendingString:ming];
        }
        YTUserInfo *userInfo = [YTUserInfo new];
        userInfo.userName    = name;
        userInfo.headerImageName = [NSString stringWithFormat:@"%d.jpg",i%20];
        //NSLog(@"%@",userInfo.userName);
        [self.contactsInfo addObject:userInfo];
    }
    [self setupTableSection];
}

-(void)setupTableSection{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //初始化数组newSectionArray
    NSInteger numberOfSections =  [[collation sectionTitles] count];
    NSMutableArray *newSectionArray = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc] init]];
    }
    
    //把所有联系人信息放入newSectionArray中
    for (YTUserInfo *userInfo in self.contactsInfo) {
        NSUInteger sectionIndex = [collation sectionForObject:userInfo collationStringSelector:@selector(userName)];
        [newSectionArray[sectionIndex] addObject:userInfo];
        //NSLog(@"%@",userInfo.userName);
    }
    
    //对联系人进行排序
    for (NSUInteger index = 0; index < numberOfSections; index++) {
        NSMutableArray *userForSection = newSectionArray[index];
        NSArray *sortedUserForSection  = [collation sortedArrayFromArray:userForSection collationStringSelector:@selector(userName)];
        newSectionArray[index] = sortedUserForSection;
        //NSLog(@"%@",newSectionArray[index]);
    }
    
    NSMutableArray *temp    = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    //把newSectionArray的排序给sectionTitlesArray。
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr,NSUInteger idx,BOOL *stop){
        if (arr.count == 0) {
            [temp addObject:arr];
        }else{
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];
    
    //添加操作的cell名称和图片。
    NSMutableArray *operationModels = [NSMutableArray new];
    NSArray *dicts = @[@{@"name" : @"新的朋友", @"imageName" : @"Contacts_FriendNotify"},
                       @{@"name" : @"群聊", @"imageName" : @"Contacts_friendGroup"},
                       @{@"name" : @"标签",@"imageName" : @"Contacts_Tag"},
                       @{@"name" : @"公众号",@"imageName" : @"Contacts_friend_offical"}];
    for (NSDictionary *dict in dicts) {
        YTUserInfo *userInfo = [YTUserInfo new];
        userInfo.userName    = dict[@"name"];
        userInfo.headerImageName = dict[@"imageName"];
        [operationModels addObject:userInfo];
    }
    
    //插入到最前面
    [newSectionArray insertObject:operationModels atIndex:0];
    //[self.sectionTitlesArray insertObject:@"🔍" atIndex:0];
    [self.sectionTitlesArray insertObject:@"" atIndex:0];
    
    self.sectionArray = [NSMutableArray new];
    self.sectionArray = newSectionArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[YTTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    YTUserInfo *userInfo = self.sectionArray[indexPath.section][indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:userInfo.headerImageName];
    cell.textLabel.text  = userInfo.userName;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionTitlesArray objectAtIndex:section];
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionTitlesArray;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击进入个人详细页面。
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

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
}

-(void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    //点击语音按钮后处理的事件。
}

@end
















