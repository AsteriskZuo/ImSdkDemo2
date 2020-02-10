//
//  GroupProfileController.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/8.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "GroupProfileController.h"
#import "Common.h"
#import "DHeader.h"
#import "DUITextCell.h"
#import "DUIProfileCardCell.h"
#import "DUIButtonCell.h"
#import "DUISwitchCell.h"
#import "DUIGroupMemberCell.h"


static NSString* s_DUIProfileCardCell_ReuseId = @"DUIProfileCardCell_ReuseId";
static NSString* s_DUITextCell_ReuseId = @"DUITextCell_ReuseId";
static NSString* s_DUIButtonCell_ReuseId = @"DUIButtonCell_ReuseId";
static NSString* s_DUISwitchCell_ReuseId = @"DUISwitchCell_ReuseId";
static NSString* s_DUIGroupMembersCell_ReuseId = @"DUIGroupMembersCell_ReuseId";

@interface GroupProfileController () <DUIProfileCardCellDelegate, DUIGroupMembersCellDelegate>

@property (nonatomic, strong) NSMutableArray<NSMutableArray*>* dataList;

@end

@implementation GroupProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupViews];
    [self setupData];
}

- (void)setupViews
{
    self.title = @"详细资料";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = TGroupInfoController_Background_Color;
    
    //加入此行，会让反馈更加灵敏
    self.tableView.delaysContentTouches = NO;
    
    [self.tableView registerClass:[DUIProfileCardCell class] forCellReuseIdentifier:s_DUIProfileCardCell_ReuseId];
    [self.tableView registerClass:[DUITextCell class] forCellReuseIdentifier:s_DUITextCell_ReuseId];
    [self.tableView registerClass:[DUIButtonCell class] forCellReuseIdentifier:s_DUIButtonCell_ReuseId];
    [self.tableView registerClass:[DUISwitchCell class] forCellReuseIdentifier:s_DUISwitchCell_ReuseId];
    [self.tableView registerClass:[DUIGroupMembersCell class] forCellReuseIdentifier:s_DUIGroupMembersCell_ReuseId];
}

- (void)setupData
{
    _dataList = @[].mutableCopy;
    
    {
        DUIProfileCardCellData* data = [[DUIProfileCardCellData alloc] init];
        data.avatarImage = [UIImage imageNamed:TUIKitResource(@"default_group")];
        data.identifier = @"group1";
        data.name = @"群组1";
        data.showAccessory = YES;
        data.signature = @"签名";
        NSMutableArray* array = @[].mutableCopy;
        [array addObject:data];
        [_dataList addObject:array];
    }
    {
        NSMutableArray* array = @[].mutableCopy;
        DUITextCellData* data = [[DUITextCellData alloc] init];
        data.key = @"群成员";
        data.value = @"2人";
        data.showAccessory = true;
        data.cselector = @selector(onGroupMembers:);
        [array addObject:data];
        DUIGroupMembersCellData* data2 = [[DUIGroupMembersCellData alloc] init];
        {
            NSMutableArray* array = @[].mutableCopy;
            DUIGroupMemberCellData* d1 = [[DUIGroupMemberCellData alloc] init];
            d1.avatar = [UIImage imageNamed:TUIKitResource(@"default_head")];
            d1.identifier = @"zhangsan";
            d1.name = @"张三";
            [array addObject:d1];
            DUIGroupMemberCellData* d2 = [[DUIGroupMemberCellData alloc] init];
            d2.avatar = [UIImage imageNamed:TUIKitResource(@"default_head")];
            d2.identifier = @"lisi";
            d2.name = @"李四";
            [array addObject:d2];
            DUIGroupMemberCellData* d3 = [[DUIGroupMemberCellData alloc] init];
            d3.avatar = [UIImage imageNamed:TUIKitResource(@"default_head")];
            d3.identifier = @"lisi";
            d3.name = @"李四";
            [array addObject:d3];
            DUIGroupMemberCellData* d4 = [[DUIGroupMemberCellData alloc] init];
            d4.avatar = [UIImage imageNamed:TUIKitResource(@"default_head")];
            d4.identifier = @"lisi";
            d4.name = @"李四";
            [array addObject:d4];
            DUIGroupMemberCellData* d5 = [[DUIGroupMemberCellData alloc] init];
            d5.avatar = [UIImage imageNamed:TUIKitResource(@"default_head")];
            d5.identifier = @"lisi";
            d5.name = @"李四";
            [array addObject:d5];
            DUIGroupMemberCellData* d6 = [[DUIGroupMemberCellData alloc] init];
            d6.avatar = [UIImage imageNamed:TUIKitResource(@"default_head")];
            d6.identifier = @"lisi";
            d6.name = @"李四";
            [array addObject:d6];
            data2.members = array;
        }
        [array addObject:data2];
        [_dataList addObject:array];
    }
    {
        NSMutableArray* array = @[].mutableCopy;
        DUITextCellData* data = [[DUITextCellData alloc] init];
        data.key = @"群类型";
        data.value = @"讨论组";
        data.showAccessory = NO;
        [array addObject:data];
        DUITextCellData* data2 = [[DUITextCellData alloc] init];
        data2.key = @"加群方式";
        data2.value = @"邀请加入";
        data2.showAccessory = NO;
        [array addObject:data2];
        [_dataList addObject:array];
    }
    {
        NSMutableArray* array = @[].mutableCopy;
        DUITextCellData* data = [[DUITextCellData alloc] init];
        data.key = @"我的群昵称";
        data.value = @"";
        data.showAccessory = YES;
        [array addObject:data];
        DUISwitchCellData* data2 = [[DUISwitchCellData alloc] init];
        data2.on = NO;
        data2.title = @"置顶聊天";
        data2.cSwitchSelector = @selector(onTop:);
        [array addObject:data2];
        [_dataList addObject:array];
    }
    {
        NSMutableArray* array = @[].mutableCopy;
        DUIButtonCellData* data = [[DUIButtonCellData alloc] init];
        data.title = @"删除并退出";
        data.cButtonSelector = @selector(onQuitAndDelete:);
        data.style = ButtonRedText;
        [array addObject:data];
        [_dataList addObject:array];
    }
}

- (void)onTop:(DUISwitchCell*)sender
{
    NSLog(@"%s", __func__);
}

- (void)onQuitAndDelete:(DUIButtonCell*)sender
{
    NSLog(@"%s", __func__);
}

- (void)onGroupMembers:(DUITextCell*)sender
{
    NSLog(@"%s", __func__);
}


#pragma mark - DUIGroupMembersCellDelegate

- (void)groupMembersCell:(DUIGroupMembersCell*)cell didSelectItemAtIndex:(NSInteger)index
{
    
}

#pragma mark - DUIProfileCardCellDelegate

-(void) didTapOnAvatar:(DUIProfileCardCell *)cell
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
    if ([data isKindOfClass:[DUITextCellData class]]) {
        DUITextCell* cell = [self.tableView dequeueReusableCellWithIdentifier:s_DUITextCell_ReuseId forIndexPath:indexPath];
        [cell fillWithData:(DUITextCellData*)data];
        return cell;
    } else if ([data isKindOfClass:[DUIButtonCellData class]]) {
        DUIButtonCell* cell = [self.tableView dequeueReusableCellWithIdentifier:s_DUIButtonCell_ReuseId forIndexPath:indexPath];
        [cell fillWithData:(DUIButtonCellData*)data];
        return cell;
    } else if ([data isKindOfClass:[DUISwitchCellData class]]) {
        DUISwitchCell* cell = [self.tableView dequeueReusableCellWithIdentifier:s_DUISwitchCell_ReuseId forIndexPath:indexPath];
        [cell fillWithData:(DUISwitchCellData*)data];
        return cell;
    } else if ([data isKindOfClass:[DUIProfileCardCellData class]]) {
        DUIProfileCardCell* cell = [self.tableView dequeueReusableCellWithIdentifier:s_DUIProfileCardCell_ReuseId forIndexPath:indexPath];
        cell.delegate = self;
        [cell fillWithData:(DUIProfileCardCellData*)data];
        return cell;
    } else if ([data isKindOfClass:[DUIGroupMembersCellData class]]) {
        DUIGroupMembersCell* cell = [self.tableView dequeueReusableCellWithIdentifier:s_DUIGroupMembersCell_ReuseId forIndexPath:indexPath];
        cell.membersDelegate = self;
        [cell fillWithData:(DUIGroupMembersCellData*)data];
        return cell;
    } else {
        NSLog(@"%s", __func__);
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject* data = _dataList[indexPath.section][indexPath.row];
    if ([data isKindOfClass:[DUITextCellData class]]) {
        return [DUITextCell getHeight];
    } else if ([data isKindOfClass:[DUIButtonCellData class]]) {
        return [DUIButtonCell getHeight];
    } else if ([data isKindOfClass:[DUISwitchCellData class]]) {
        return [DUISwitchCell getHeight];
    } else if ([data isKindOfClass:[DUIProfileCardCellData class]]) {
        return [DUIProfileCardCell getHeight];
    } else if ([data isKindOfClass:[DUIGroupMembersCellData class]]) {
        return [DUIGroupMembersCell getHeight:(DUIGroupMembersCellData*)data];
    } else {
        NSLog(@"%s", __func__);
    }
    return [DUICommonCell getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView* view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView_ReuseId"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] init];
        UILabel* content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        content.backgroundColor = [UIColor blueColor];
        [view addSubview:content];
    }
    return view;
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

@end
