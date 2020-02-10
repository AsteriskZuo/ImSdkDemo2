//
//  ContactController.m
//  ImSdkDemo
//
//  Created by yu.zuo on 2020/1/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "ContactController.h"
#import "DHeader.h"
#import "Common.h"
#import "DUIPopView.h"
#import "DUINavigationIndicatorView.h"
#import "DUIContactCell.h"

@interface ContactController () <DUIPopViewDelegate>

@property (nonatomic, strong) DUINavigationIndicatorView* indicatorView;

@end

@implementation ContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIButton* moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [moreButton setImage:[UIImage imageNamed:TUIKitResource(@"more")] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(onRightItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    _indicatorView = [[DUINavigationIndicatorView alloc] init];
//    [_indicatorView setLabel:@"通讯录"];
//    self.navigationItem.titleView = _indicatorView;
    self.title = @"通讯录";
    
    //如果不加这一行代码，依然可以实现点击反馈，但反馈会有轻微延迟，体验不好。
//    self.tableView.delaysContentTouches = NO;
}

- (void)onRightItem:(UIButton*)sender
{
    NSMutableArray<DUIPopViewCellData* >* menus = [[NSMutableArray alloc] init];
    
    DUIPopViewCellData* addFriend = [[DUIPopViewCellData alloc] init];
    addFriend.image = [UIImage imageNamed:TUIKitResource(@"new_friend")];
    addFriend.name = @"添加好友";
    
    DUIPopViewCellData* addGroup = [[DUIPopViewCellData alloc] init];
    addGroup.image = [UIImage imageNamed:TUIKitResource(@"add_group")];
    addGroup.name = @"添加群组";
    
    [menus addObject:addFriend];
    [menus addObject:addGroup];
    
    
    CGFloat height = [DUIPopViewCell getHeight] * menus.count + TPopView_Arrow_Size.height;
    CGFloat orginY = StatusBar_Height + NavBar_Height;
    CGRect viewFrame = CGRectMake(Screen_Width - 145, orginY, 135, height);
    DUIPopView* popView = [[DUIPopView alloc] initWithFrame:viewFrame];
    popView.delegate = self;
    CGRect frameInNaviView = [self.navigationController.view convertRect:sender.frame fromView:[sender superview]];
    popView.arrowPoint = CGPointMake(frameInNaviView.origin.x + frameInNaviView.size.width * 0.5, orginY);
    [popView setData:[menus copy]];
    [popView showInWindow:self.view.window];
    
    [super test];
}

#pragma mark - DUIPopViewDelegate

- (void)popView:(DUIPopView *)popView didSelectRowAtIndex:(NSInteger)index
{
    
}

@end
