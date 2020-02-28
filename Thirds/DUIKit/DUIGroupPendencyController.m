//
//  DUIGroupPendencyController.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/27.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIGroupPendencyController.h"
#import "DUIGroupPendencyCell.h"
#import "DUIGroupPendencyViewModel.h"
#import "DFriendProfileControllerServiceProtocol.h"
#import "DServiceManager.h"

@interface DUIGroupPendencyController ()

@end

@implementation DUIGroupPendencyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[DUIGroupPendencyCell class] forCellReuseIdentifier:@"PendencyCell"];
    self.tableView.tableFooterView = [UIView new];
    self.title = @"群申请";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUIGroupPendencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PendencyCell" forIndexPath:indexPath];
    DUIGroupPendencyCellData *data = self.viewModel.dataList[indexPath.row];
    data.cselector = @selector(cellClick:);
    data.cbuttonSelector = @selector(btnClick:);
    [cell fillWithData:data];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self.tableView beginUpdates];
        DUIGroupPendencyCellData *data = self.viewModel.dataList[indexPath.row];
        [self.viewModel removeData:data];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (void)btnClick:(DUIGroupPendencyCell *)cell
{
    [self.viewModel acceptData:cell.pendencyData];
    [self.tableView reloadData];
}

- (void)cellClick:(DUIGroupPendencyCell *)cell
{
    //TODO:待实现
    NSArray<id>* objects = [[DServiceManager shareInstance] createObject:@protocol(DFriendProfileControllerServiceProtocol)];
    for (id object in objects) {
        if ([object isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:(UIViewController *)object animated:YES];
            break;
        }
    }
}

@end
