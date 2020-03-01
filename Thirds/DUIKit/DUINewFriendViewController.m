//
//  DUINewFriendViewController.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/29.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUINewFriendViewController.h"
#import "DUINewFriendViewModel.h"
#import "DUIPendencyCell.h"
#import "DFriendProfileControllerServiceProtocol.h"
#import "DServiceManager.h"

#import "MMLayout/UIView+MMLayout.h"

#import "ReactiveObjC/ReactiveObjc.h"


static NSString* s_DUIPendencyCell_reuseId = @"DUIPendencyCell_reuseId";

@interface DUINewFriendViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) UIButton *moreBtn;
@property (nonatomic, strong, readwrite) DUINewFriendViewModel *viewModel;
@end

@implementation DUINewFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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


- (void)setupViews
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[DUIPendencyCell class] forCellReuseIdentifier:s_DUIPendencyCell_reuseId];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 94, 0, 0);

    _viewModel = DUINewFriendViewModel.new;//????

    _moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _moreBtn.mm_h = 20;
    _tableView.tableFooterView = _moreBtn;

    [self.moreBtn addTarget:self action:@selector(loadNextData) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setTitle:@"加载更多数据" forState:UIControlStateNormal];
    [self.moreBtn setTitle:@"没有了" forState:UIControlStateDisabled];
    
    
    RAC(_moreBtn, hidden) = RACObserve(_viewModel, isLoading);
    RAC(_moreBtn, enabled) = RACObserve(_viewModel, hasNextData);
    @weakify(self)
    [RACObserve(_viewModel, dataList) subscribeNext:^(id  _Nullable x) {
       @strongify(self)
       [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData
{
    [_viewModel loadData];
}

- (void)loadNextData
{
    [_viewModel loadNextData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUIPendencyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:s_DUIPendencyCell_reuseId forIndexPath:indexPath];
    DUIPendencyCellData *data = self.viewModel.dataList[indexPath.row];
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self.tableView beginUpdates];
        DUIPendencyCellData *data = self.viewModel.dataList[indexPath.row];
        [self.viewModel removeData:data];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (void)btnClick:(DUIPendencyCell *)cell
{
    [self.viewModel agreeData:cell.pendencyData];
    [self.tableView reloadData];
}

- (void)cellClick:(DUIPendencyCell *)cell
{
    NSArray<id>* objects = [[DServiceManager shareInstance] createObject:@protocol(DFriendProfileControllerServiceProtocol)];
    for (id object in objects) {
        if ([object isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:(UIViewController *)object animated:YES];
            break;
        }
    }
}

@end
