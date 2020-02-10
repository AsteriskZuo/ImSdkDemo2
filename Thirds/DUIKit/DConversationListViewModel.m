//
//  DConversationListViewModel.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/27.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DConversationListViewModel.h"
#import "DUIConversationCell.h"
#import "DHeader.h"
#import "Common.h"

@interface DConversationListViewModel ()

@end

@implementation DConversationListViewModel

- (void)removeData:(DUIConversationCellData *)data
{
    
}

- (void)loadConversation
{
    NSMutableArray<DUIConversationCellData* >* conversationList = [[NSMutableArray alloc] init];
    
    DUIConversationCellData* d1 = [[DUIConversationCellData alloc] init];
    d1.convId = @"zhangsan";
    d1.convType = TIM_C2C;
    d1.avatarImage = [UIImage imageNamed:TUIKitResource(@"default_head")];
    d1.title = d1.convId;
    d1.subTitle = @"你好";
    d1.time = [NSDate date];
    d1.unRead = 1;
    d1.isOnTop = NO;
    
    DUIConversationCellData* d2 = [[DUIConversationCellData alloc] init];
    d2.convId = @"lisi";
    d2.convType = TIM_C2C;
    d2.avatarImage = [UIImage imageNamed:TUIKitResource(@"default_head")];
    d2.title = d2.convId;
    d2.subTitle = @"个人聊天";
    d2.time = [NSDate date];
    d2.unRead = 2;
    d2.isOnTop = true;
    
    DUIConversationCellData* g1 = [[DUIConversationCellData alloc] init];
    g1.convId = @"qunzu1";
    g1.convType = TIM_GROUP;
    g1.avatarImage = [UIImage imageNamed:TUIKitResource(@"default_group")];
    g1.title = g1.convId;
    g1.subTitle = @"群组聊天";
    g1.time = [NSDate date];
    g1.unRead = 3;
    g1.isOnTop = NO;
    
    [conversationList addObject:d1];
    [conversationList addObject:d2];
    [conversationList addObject:g1];
    
    _conversationList = conversationList;
}

@end
