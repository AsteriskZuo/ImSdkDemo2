//
//  FriendProfileController.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "FriendProfileController.h"
#import "DUITextCell.h"
#import "DUIButtonCell.h"
#import "DUISwitchCell.h"
#import "DUIProfileCardCell.h"
#import "DCommon.h"
#import "DHeader.h"
#import "Common.h"

#import "DServiceManager.h"


static NSString* s_DUITextCell_ReuseId = @"DUITextCell_ReuseId";
static NSString* s_DUIButtonCell_ReuseId = @"DUIButtonCell_ReuseId";
static NSString* s_DUISwitchCell_ReuseId = @"DUISwitchCell_ReuseId";
static NSString* s_DUIProfileCardCell_ReuseId = @"DUIProfileCardCell_ReuseId";

@interface FriendProfileController () <DUIProfileCardCellDelegate>

@property (nonatomic, strong) NSArray<NSArray*>* dataList;

@end

@implementation FriendProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupViews];
    
    [self.tableView registerClass:[DUITextCell class] forCellReuseIdentifier:s_DUITextCell_ReuseId];
    [self.tableView registerClass:[DUIButtonCell class] forCellReuseIdentifier:s_DUIButtonCell_ReuseId];
    [self.tableView registerClass:[DUISwitchCell class] forCellReuseIdentifier:s_DUISwitchCell_ReuseId];
    [self.tableView registerClass:[DUIProfileCardCell class] forCellReuseIdentifier:s_DUIProfileCardCell_ReuseId];
    
    self.title = @"详细资料";
}

- (void)setupViews
{
    NSMutableArray* list = [[NSMutableArray alloc] init];
    [list addObject:({
        NSMutableArray* inlist = [[NSMutableArray alloc] init];
        [inlist addObject:({
            DUIProfileCardCellData* data = [[DUIProfileCardCellData alloc] init];
            data.avatarImage = [UIImage imageNamed:TUIKitResource(@"default_head")];
            data.identifier = @"zhangsan";
            data.name = @"张三";
            data.showAccessory = true;
            data.signature = @"煮酒论英雄";
            data;
        })];
        inlist;
    })];
    [list addObject:({
        NSMutableArray* inlist = [[NSMutableArray alloc] init];
        [inlist addObject:({
            DUITextCellData* data = [[DUITextCellData alloc] init];
            data.key = @"备注名";
            data.value = @"无";
            data.showAccessory = YES;
            data;
        })];
        [inlist addObject:({
            DUISwitchCellData* data = [[DUISwitchCellData alloc] init];
            data.title = @"加入黑名单";
            data.on = NO;
            data.cSwitchSelector = @selector(onBlackList:);
            data;
        })];
        inlist;
    })];
    [list addObject:({
//        NSMutableArray* inlist = [@[] mutableCopy];
        NSMutableArray* inlist = @[].mutableCopy;
        [inlist addObject:({
            DUITextCellData* data = [[DUITextCellData alloc] init];
            data.key = @"所在地";
            data.value = @"未设置";
            data.showAccessory = NO;
            data;
        })];
        [inlist addObject:({
            DUITextCellData* data = [[DUITextCellData alloc] init];
            data.key = @"生日";
            data.value = @"未设置";
            data.showAccessory = NO;
            data;
        })];
        inlist;
    })];
    [list addObject:({
        NSMutableArray* inlist = [[NSMutableArray alloc] init];
        [inlist addObject:({
            DUISwitchCellData* data = [[DUISwitchCellData alloc] init];
            data.title = @"置顶聊天";
            data.on = NO;
            data.cSwitchSelector = @selector(onTop:);
            data;
        })];
        inlist;
    })];
    [list addObject:({
        NSMutableArray* inlist = [[NSMutableArray alloc] init];
        [inlist addObject:({
            DUIButtonCellData* data = [[DUIButtonCellData alloc] init];
            data.title = @"发送消息";
            data.cButtonSelector = @selector(onSendMessage:);
            data.style = ButtonBlue;
            data;
        })];
        [inlist addObject:({
            DUIButtonCellData* data = [[DUIButtonCellData alloc] init];
            data.title = @"删除好友";
            data.cButtonSelector = @selector(onDeleteFriend:);
            data.style = ButtonRedText;
            data;
        })];
        inlist;
    })];
    
    _dataList = list;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView reloadData];
    
}

- (void)onBlackList:(DUISwitchCell*)sender
{
    NSLog(@"%s", __func__);
}

- (void)onTop:(DUISwitchCell*)sender
{
    NSLog(@"%s", __func__);
}

- (void)onSendMessage:(DUIButtonCell*)sender
{
    NSLog(@"%s", __func__);
}

- (void)onDeleteFriend:(DUIButtonCell*)sender
{
    NSLog(@"%s", __func__);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject* data = _dataList[indexPath.section][indexPath.row];
    if ([data isKindOfClass:[DUIProfileCardCellData class]]) {
        DUIProfileCardCell* cell = [self.tableView dequeueReusableCellWithIdentifier:s_DUIProfileCardCell_ReuseId forIndexPath:indexPath];
        cell.delegate = self;
        [cell fillWithData:(DUIProfileCardCellData*)data];
        return cell;
    } else if ([data isKindOfClass:[DUISwitchCellData class]]) {
        DUISwitchCell* cell = [self.tableView dequeueReusableCellWithIdentifier:s_DUISwitchCell_ReuseId forIndexPath:indexPath];
        [cell fillWithData:(DUISwitchCellData*)data];
        return cell;
    } else if ([data isKindOfClass:[DUITextCellData class]]) {
        DUITextCell* cell = [self.tableView dequeueReusableCellWithIdentifier:s_DUITextCell_ReuseId forIndexPath:indexPath];
        [cell fillWithData:(DUITextCellData*)data];
        return cell;
    } else if ([data isKindOfClass:[DUIButtonCellData class]]) {
        DUIButtonCell* cell = [self.tableView dequeueReusableCellWithIdentifier:s_DUIButtonCell_ReuseId forIndexPath:indexPath];
        [cell fillWithData:(DUIButtonCellData*)data];
        return cell;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    DUICommonCell* data = _dataList[indexPath.section][indexPath.row];
    if ([data isKindOfClass:[DUIProfileCardCellData class]]) {
        return [DUIProfileCardCell getHeight];
    } else if ([data isKindOfClass:[DUISwitchCellData class]]) {
        return [DUISwitchCell getHeight];
    } else if ([data isKindOfClass:[DUITextCellData class]]) {
        return [DUITextCell getHeight];
    } else if ([data isKindOfClass:[DUIButtonCellData class]]) {
        return [DUIButtonCell getHeight];
    } else {
        return [DUICommonCell getHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView* headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"test111111"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 30)];
        headerView.backgroundColor = [UIColor redColor];
        UILabel* label = [[UILabel alloc] initWithFrame:headerView.frame];
        label.backgroundColor = [UIColor purpleColor];
        [headerView.contentView addSubview:label];
    }
    return headerView;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - DUIProfileCardCellDelegate

-(void) didTapOnAvatar:(DUIProfileCardCell *)cell
{
    
}

@end
