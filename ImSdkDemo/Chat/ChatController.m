//
//  ChatController.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/7.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "ChatController.h"
#import "DUIChatController.h"
#import "DUIUnreadView.h"
#import "DHeader.h"
#import "DUIProfileCardCell.h"
#import "DIMConversation.h"
#import "FriendProfileController.h"
#import "GroupProfileController.h"

#import "ReactiveObjC/ReactiveObjC.h"

@interface ChatController ()

@property (nonatomic, strong, readwrite) DUIChatController* chat;

@end

@implementation ChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self setupViews];
}

- (void)setupViews
{
    DIMConversation* conv = [[DIMConversation alloc] initWithConvId:_conversationData.convId convType:_conversationData.convType];
    _chat = [[DUIChatController alloc] initWithConversation:conv];
    [self addChildViewController:_chat];
    [self.view addSubview:_chat.view];
    
    _unreadView = [[DUIUnreadView alloc] init];
    [_unreadView setNum:10];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_unreadView];
    self.navigationItem.leftBarButtonItems = @[leftBarButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = YES;

    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if(_conversationData.convType == TIM_C2C){
        [rightButton setImage:[UIImage imageNamed:TUIKitResource(@"person_nav")] forState:UIControlStateNormal];
    }
    else if(_conversationData.convType == TIM_GROUP){
        [rightButton setImage:[UIImage imageNamed:TUIKitResource(@"group_nav")] forState:UIControlStateNormal];
    }
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem];
    
    RAC(self, title) = [RACObserve(_conversationData, title) distinctUntilChanged];

}

- (void)sendMessage:(DUIMessageCellData*)msg
{
    [_chat sendMessage:msg];
}

- (void)rightBarButtonClick:(UIButton*)sender
{
    if (TIM_C2C == _conversationData.convType) {
        FriendProfileController* controller = [[FriendProfileController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (TIM_GROUP == _conversationData.convType) {
        GroupProfileController* controller = [[GroupProfileController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (TIM_SYSTEM == _conversationData.convType) {
        
    } else {
        NSLog(@"%s", __func__);
    }
}

@end
