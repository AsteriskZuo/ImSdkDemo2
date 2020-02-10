//
//  SettingController.m
//  ImSdkDemo
//
//  Created by yu.zuo on 2020/1/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "SettingController.h"
#import "DHeader.h"
#import "DUIButtonCell.h"
#import "DUITestTextCell.h"
#import "DUIProfileCardCell.h"
#import "Common.h"
#import "AppDelegate.h"

static NSString* s_DUIButtonCell_ReuseId = @"DUIButtonCell_ReuseId";
static NSString* s_DUITestTextCell_ReuseId = @"DUITestTextCell_ReuseId";
static NSString* s_DUIProfileCardCell_ReuseId = @"DUIProfileCardCell_ReuseId";

@interface SettingController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    [self setViews];
    
    //如果不加这一行代码，依然可以实现点击反馈，但反馈会有轻微延迟，体验不好。
//    self.tableView.delaysContentTouches = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setViews
{
    self.title = @"我";
//    self.parentViewController.title = @"我";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = TSettingController_Background_Color;
    
    [self.tableView registerClass:[DUIButtonCell class] forCellReuseIdentifier:s_DUIButtonCell_ReuseId];
    [self.tableView registerClass:[DUITestTextCell class] forCellReuseIdentifier:s_DUITestTextCell_ReuseId];
    [self.tableView registerClass:[DUIProfileCardCell class] forCellReuseIdentifier:s_DUIProfileCardCell_ReuseId];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setData];
}

- (void)setData
{
    self.data = [[NSMutableArray alloc] init];
    
    DUIProfileCardCellData* accountData = [[DUIProfileCardCellData alloc] init];
    accountData.avatarImage = [UIImage imageNamed:TUIKitResource(@"default_head")];
    accountData.name = @"name";
    accountData.identifier = @"identifier";
    accountData.signature = @"煮酒论英雄";
    accountData.showAccessory = true;
    [self.data addObject:@[accountData]];
    
    DUIButtonCellData* buttonData = [[DUIButtonCellData alloc] init];
    buttonData.title = @"退出登录";
    buttonData.style = ButtonRedText;
    buttonData.cButtonSelector = @selector(logout:);
    [self.data addObject:@[buttonData]];
    
//    DUITestTextCellData* testTextData = [[DUITestTextCellData alloc] init];
//    testTextData.test = @"test";
//    testTextData.ava = [UIImage imageNamed:TUIKitResource(@"default_head")];
//    [self.data addObject:@[testTextData]];
    
    [self.tableView reloadData];
}

- (void)logout:(DUIButtonCell*)sender
{
    UIViewController* controller = [((AppDelegate *)[UIApplication sharedApplication].delegate) getLoginController];
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor blueColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *array = self.data[section];
    NSLog(@"section:%ld, count:%lu", (long)section, (unsigned long)array.count);
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heigth = [DUICommonCell getHeight];
    if (0 == indexPath.section) {
        heigth = [DUIProfileCardCell getHeight];
    } else if (1 == indexPath.section) {
        heigth = [DUIButtonCell getHeight];
    } else {
        
    }
    
    NSLog(@"height:%f", heigth);
    return heigth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = self.data[indexPath.section];
    NSObject *data = array[indexPath.row];
    if([data isKindOfClass:[DUIButtonCellData class]]){
        
        DUIButtonCell* cell = nil;
        if (false) {
            cell = [tableView dequeueReusableCellWithIdentifier:s_DUIButtonCell_ReuseId forIndexPath:indexPath];
        }
        
        if (true) {
            cell = [tableView dequeueReusableCellWithIdentifier:TButtonCell_ReuseId];
            if(!cell){
                cell = [[DUIButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TButtonCell_ReuseId];
            }
        }
        
        [cell fillWithData:(DUIButtonCellData *)data];
        return cell;
    } else if ([data isKindOfClass:[DUITestTextCellData class]]) {
        DUITestTextCell* cell = [tableView dequeueReusableCellWithIdentifier:s_DUITestTextCell_ReuseId forIndexPath:indexPath];
        [cell fillWithData:(DUITestTextCellData*)data];
        return cell;
    } else if ([data isKindOfClass:[DUIProfileCardCellData class]]) {
        DUIProfileCardCell* cell = [tableView dequeueReusableCellWithIdentifier:s_DUIProfileCardCell_ReuseId forIndexPath:indexPath];
        [cell fillWithData:(DUIProfileCardCellData*)data];
        return cell;
    } else {
        NSLog(@"test");
    }
    return nil;
}


@end
