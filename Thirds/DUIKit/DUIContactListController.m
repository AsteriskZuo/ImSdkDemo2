//
//  DUIContactListController.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/1.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIContactListController.h"
#import "DUIGroupListController.h"
#import "DUIContactActionCell.h"
#import "DUIContactCell.h"
#import "DHeader.h"
#import "Common.h"

#import "DFriendProfileControllerServiceProtocol.h"
#import "DServiceManager.h"

#import "MMLayout/UIView+MMLayout.h"


static NSString* s_DUIContactActionCell_reuseId = @"DUIContactActionCell_reuseId";
static NSString* s_DUIContactCell_reuseId = @"DUIContactCell_reuseId";
static NSString* s_UITableViewHeaderFooterView_reuseId = @"UITableViewHeaderFooterView_reuseId";

@interface DUIContactListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DContactListViewModel* contactList;
@property (nonatomic, strong) NSArray<DUIContactActionCellData *> *firstGroupData;

@end

@implementation DUIContactListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)setupViews
{
    _contactList = [[DContactListViewModel alloc] init];
    
    NSMutableArray *list = @[].mutableCopy;
    [list addObject:({
        DUIContactActionCellData *data = [[DUIContactActionCellData alloc] init];
        data.icon = [UIImage imageNamed:TUIKitResource(@"new_friend")];
        data.title = @"新的联系人";
        data.cselector = @selector(onAddNewFriend:);
        data;
    })];
    [list addObject:({
        DUIContactActionCellData *data = [[DUIContactActionCellData alloc] init];
        data.icon = [UIImage imageNamed:TUIKitResource(@"public_group")];
        data.title = @"群聊";
        data.cselector = @selector(onGroupConversation:);
        data;
    })];
    [list addObject:({
        DUIContactActionCellData *data = [[DUIContactActionCellData alloc] init];
        data.icon = [UIImage imageNamed:TUIKitResource(@"blacklist")];
        data.title = @"黑名单";
        data.cselector = @selector(onBlackList:);
        data;
    })];
    self.firstGroupData = [NSArray arrayWithArray:list];
    
    
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
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
    
}

- (void)onAddNewFriend:(DUIContactActionCell*)sender
{
    NSLog(@"%s", __func__);
}

- (void)onGroupConversation:(DUIContactActionCell*)sender
{
    NSLog(@"%s", __func__);
    DUIGroupListController* vc = [[DUIGroupListController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onBlackList:(DUIContactActionCell*)sender
{
    NSLog(@"%s", __func__);
}

- (void)reloadData
{
    [_contactList loadContacts];
}

- (void)onSelectFriend:(DUIContactCell*)sender
{
    NSLog(@"%s", __func__);
    NSArray<id>* objects = [[DServiceManager shareInstance] createObject:@protocol(DFriendProfileControllerServiceProtocol)];
    for (id object in objects) {
        if ([object isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:(UIViewController *)object animated:YES];
            break;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (0 == _contactList.groupList.count) {
        return 1;
    } else {
        return _contactList.groupList.count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return _firstGroupData.count;
    } else {
        if (0 == _contactList.groupList.count) {
            return 0;
        }
        NSString* atoz = _contactList.groupList[section - 1];
        NSArray* list = _contactList.dataDict[atoz];
        return list.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        DUIContactActionCell* cell = [_tableView dequeueReusableCellWithIdentifier:s_DUIContactActionCell_reuseId];
        DUIContactActionCellData* data = _firstGroupData[indexPath.row];
        [cell fillWithData:data];
        return cell;
    } else {
        DUIContactCell* cell = [_tableView dequeueReusableCellWithIdentifier:s_DUIContactCell_reuseId];
        NSString* atoz = _contactList.groupList[indexPath.section - 1];
        NSArray<DUIContactCellData *> * list = _contactList.dataDict[atoz];
        DUIContactCellData* data = list[indexPath.row];
        data.cselector = @selector(onSelectFriend:);
        [cell fillWithData:data];
        return cell;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [NSMutableArray arrayWithObject:@""];
    [array addObjectsFromArray:_contactList.groupList];
    return array;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return [DUIContactActionCell getHeight];
    } else {
        return [DUIContactCell getHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0;
    return 33;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return nil;
    } else {
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
        label.text = _contactList.groupList[section - 1];

        return headerView;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        if (_firstGroupData.count == indexPath.row + 1) {
//            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, Screen_Width, 0, 0)];
        }
    } else {
        
    }
}


- (void)test
{
    [_contactList loadContacts];
    [_tableView reloadData];
}

@end
