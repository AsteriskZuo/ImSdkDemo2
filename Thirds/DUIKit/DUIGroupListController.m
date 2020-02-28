//
//  DUIGroupListController.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/1.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIGroupListController.h"
#import "DUIContactActionCell.h"
#import "DUIContactCell.h"
#import "DHeader.h"


#import "DFriendProfileControllerServiceProtocol.h"
#import "DServiceManager.h"

#import "MMLayout/UIView+MMLayout.h"


static NSString* s_DUIContactActionCell_reuseId = @"DUIContactActionCell_reuseId";
static NSString* s_DUIContactCell_reuseId = @"DUIContactCell_reuseId";
static NSString* s_UITableViewHeaderFooterView_reuseId = @"UITableViewHeaderFooterView_reuseId";

@interface DUIGroupListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DContactListViewModel* groupList;

@end

@implementation DUIGroupListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)setupViews
{
//    self.hidesBottomBarWhenPushed = NO;
    self.title = @"群组列表";
    //ref: https://www.cnblogs.com/mukekeheart/p/8191170.html
//    self.navigationItem.leftBarButtonItem.title = @"test";
    
    _groupList = [[DContactListViewModel alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
    
    [_tableView setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 58, 0, 0);
    
    [_tableView registerClass:[DUIContactCell class] forCellReuseIdentifier:s_DUIContactCell_reuseId];
    [_tableView registerClass:[DUIContactActionCell class] forCellReuseIdentifier:s_DUIContactActionCell_reuseId];
    
    [self test];
    
}

- (void)reloadData
{
    [_groupList loadContacts];
}

- (void)onSendMessage:(DUIContactCell*)sender
{
    NSLog(@"%s", __func__);
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _groupList.groupList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* atoz = _groupList.groupList[section];
    NSArray* list = _groupList.dataDict[atoz];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUIContactCell* cell = [_tableView dequeueReusableCellWithIdentifier:s_DUIContactCell_reuseId];
    NSString* atoz = _groupList.groupList[indexPath.section];
    NSArray<DUIContactCellData *> * list = _groupList.dataDict[atoz];
    DUIContactCellData* data = list[indexPath.row];
    data.cselector = @selector(onSendMessage:);
    [cell fillWithData:data];
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [NSMutableArray arrayWithObject:@""];
    [array addObjectsFromArray:_groupList.groupList];
    return array;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DUIContactCell getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
#define TEXT_TAG 1
    static NSString *headerViewId = @"ContactDrawerView";
    UITableViewHeaderFooterView *headerView = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!headerView)
    {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:s_UITableViewHeaderFooterView_reuseId];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.tag = TEXT_TAG;
        textLabel.font = [UIFont systemFontOfSize:16];
        textLabel.textColor = RGB(0x80, 0x80, 0x80);
        [headerView addSubview:textLabel];
        textLabel.mm_fill().mm_left(12);
        textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    UILabel *label = [headerView viewWithTag:TEXT_TAG];
    label.text = _groupList.groupList[section];

    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}


- (void)test
{
    [_groupList loadContacts];
    [_tableView reloadData];
}

@end
