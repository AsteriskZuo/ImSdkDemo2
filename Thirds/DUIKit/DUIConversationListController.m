//
//  DUIConversationListController.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/27.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIConversationListController.h"
#import "DConversationListViewModel.h"
#import "DUIConversationCell.h"
#import "DHeader.h"

static NSString *s_DUIConversationCell_ReuseId = @"DUIConversationCell_ReuseId";

@interface DUIConversationListController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation DUIConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    [self setupViews];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)test
{
    [_viewModel loadConversation];
    [_tableView reloadData];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
        [self viewModel];
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)setupViews
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] init];//注释会导致边际线
//    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
//    self.tableView.contentInset = UIEdgeInsetsZero;
    [self.tableView registerClass:[DUIConversationCell class] forCellReuseIdentifier:s_DUIConversationCell_ReuseId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
//    self.tableView.delaysContentTouches = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (DConversationListViewModel*)viewModel
{
    if (nil == _viewModel) {
        _viewModel = [[DConversationListViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.conversationList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)didSelectConversation:(DUIConversationCell *)cell
{
    if(_delegate && [_delegate respondsToSelector:@selector(ConversationController:didSelectConversation:)]){
        [_delegate ConversationController:self didSelectConversation:cell];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s, %ld, %ld", __FUNCTION__, (long)indexPath.section, indexPath.row);
    DUIConversationCell* cell = [tableView dequeueReusableCellWithIdentifier:s_DUIConversationCell_ReuseId];
    DUIConversationCellData* data = _viewModel.conversationList[indexPath.row];
    if (!data.cselector) {
        data.cselector =  @selector(didSelectConversation:);
    }
    [cell fillWithData:data];
    cell.changeColorWhenTouched = YES;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        DUIConversationCellData *conv = self.viewModel.conversationList[indexPath.row];
        [self.viewModel removeData:conv];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
    }
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DUIConversationCell getHeight];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
           [cell setSeparatorInset:UIEdgeInsetsMake(0, 75, 0, 0)];
        if (indexPath.row == (self.viewModel.conversationList.count - 1)) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }

    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }

    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

@end
