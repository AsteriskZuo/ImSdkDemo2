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
#import "AppDelegate.h"

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
    
    [self.tableView registerClass:[DUIButtonCell class] forCellReuseIdentifier:@"buttonCell"];
    [self.tableView registerClass:[DUITestTextCell class] forCellReuseIdentifier:@"testTextCell"];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setData];
}

- (void)setData
{
    self.data = [[NSMutableArray alloc] init];
    
    DUIButtonCellData* buttonData = [[DUIButtonCellData alloc] init];
    buttonData.title = @"退出登录";
    buttonData.style = ButtonRedText;
    buttonData.cButtonSelector = @selector(logout:);
    [self.data addObject:@[buttonData]];
    
//    DUITestTextCellData* testTextData = [[DUITestTextCellData alloc] init];
//    testTextData.test = @"test";
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"section:%ld", (long)section);
    NSMutableArray *array = self.data[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = _data[indexPath.section];
    DCommonCellData *data = array[indexPath.row];

    return [data heightOfWidth:Screen_Width];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = self.data[indexPath.section];
    NSObject *data = array[indexPath.row];
    if([data isKindOfClass:[DUIButtonCellData class]]){
        
        DUIButtonCell* cell = nil;
        if (true) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        }
        
        if (false) {
            cell = [tableView dequeueReusableCellWithIdentifier:TButtonCell_ReuseId];
            if(!cell){
                cell = [[DUIButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TButtonCell_ReuseId];
            }
        }
        
        [cell fillWithData:(DUIButtonCellData *)data];
        return cell;
    } else if ([data isKindOfClass:[DUITestTextCellData class]]) {
        DUITestTextCell* cell = [tableView dequeueReusableCellWithIdentifier:@"testTextCell" forIndexPath:indexPath];
        [cell fillWithData:(DUITestTextCellData*)data];
        return cell;
    } else {
        NSLog(@"test");
    }
    return nil;
}


@end
