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
#import "CLIMNotificationDispatch.h"

#import <CLIMSDK_ios/CLIMSDK_ios.h>


@interface DConversationListViewModel ()

@end

@implementation DConversationListViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _conversationList = @[].mutableCopy;
        [self setupNotification];
    }
    return self;
}

- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInit:) name:CLIMConversationListNotification_didInit object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddConversation:) name:CLIMConversationListNotification_didAddConversation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateConversation:) name:CLIMConversationListNotification_didUpdateConversation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteConversation:) name:CLIMConversationListNotification_didDeleteConversation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRefresh:) name:CLIMConversationListNotification_didRefresh object:nil];
}

- (void)removeData:(DUIConversationCellData *)data
{
    
}

- (void)loadConversation
{
    NSMutableArray<DUIConversationCellData* >* conversationList = [[NSMutableArray alloc] init];
    
    DUIConversationCellData* d1 = [[DUIConversationCellData alloc] init];
    d1.convId = @"zhangsan";
    d1.convType = CLIMConversationTypePerson;
    d1.avatarImage = [UIImage imageNamed:TUIKitResource(@"default_head")];
    d1.title = d1.convId;
    d1.subTitle = @"你好";
    d1.time = [NSDate date];
    d1.unRead = 1;
    d1.isOnTop = NO;
    
    DUIConversationCellData* d2 = [[DUIConversationCellData alloc] init];
    d2.convId = @"lisi";
    d2.convType = CLIMConversationTypePerson;
    d2.avatarImage = [UIImage imageNamed:TUIKitResource(@"default_head")];
    d2.title = d2.convId;
    d2.subTitle = @"个人聊天";
    d2.time = [NSDate date];
    d2.unRead = 2;
    d2.isOnTop = true;
    
    DUIConversationCellData* g1 = [[DUIConversationCellData alloc] init];
    g1.convId = @"qunzu1";
    g1.convType = CLIMConversationTypeGroup;
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


#pragma mark - notification

- (void)didInit:(NSNotification* )notification
{
    [self resetConversationList];
    [self addConversationList:notification.object];
}

- (void)didAddConversation:(NSNotification* )notification
{
    [self addConversation:notification.object];
}

- (void)didUpdateConversation:(NSNotification* )notification
{
    NSDictionary* params = notification.object;
    if (!params) {
        return;
    }
    CLIMConversationData* conv = [params objectForKey:@"conv"];
    if (!conv) {
        return;
    }
    for (DUIConversationCellData* convData in _conversationList) {
        if ([convData.convId isEqualToString:conv.convId]
            && convData.convType == conv.convType) {
            convData.convId = conv.convId;
            convData.convType = conv.convType;
            convData.avatarImage = [UIImage imageNamed:TUIKitResource(CLIMConversationTypePerson == convData.convType ? @"default_head" : @"default_group")];
            convData.title = conv.convId;
            convData.subTitle = [self getSubTitle:conv];
            convData.time = [NSDate dateWithTimeIntervalSinceNow:conv.timestamp];
            convData.unRead = conv.unreadCount;
            convData.isOnTop = NO;//暂时不支持
            break;
        }
    }
}

- (void)didDeleteConversation:(NSNotification* )notification
{
    NSDictionary* params = notification.object;
    if (!params) {
        return;
    }
    CLIMConversationData* conv = [params objectForKey:@"conv"];
    if (!conv) {
        return;
    }
    for (DUIConversationCellData* convData in _conversationList) {
        if ([convData.convId isEqualToString:conv.convId]
            && convData.convType == conv.convType) {
            [_conversationList removeObject:convData];
            break;
        }
    }
}

- (void)didRefresh:(NSNotification* )notification
{
    [self addConversationList:notification.object];
}

#pragma mark - private method

- (NSString*)getSubTitle:(CLIMConversationData* )conv
{
    NSString* ret = nil;
    if ([conv.lastMessage isKindOfClass:[CLIMTextMessage class]]) {
        ret = ((CLIMTextMessage*)(conv.lastMessage)).content;
    } else if ([conv.lastMessage isKindOfClass:[CLIMImageMessage class]]) {
        ret = [NSString stringWithUTF8String:"[image]"];
    } else if ([conv.lastMessage isKindOfClass:[CLIMVoiceMessage class]]) {
        ret = [NSString stringWithUTF8String:"[voice]"];
    } else if ([conv.lastMessage isKindOfClass:[CLIMFileMessage class]]) {
        ret = [NSString stringWithUTF8String:"[file]"];
    } else {
        ret = @"";
    }
    return ret;
}

- (void)resetConversationList
{
    [_conversationList removeAllObjects];
}

- (void)addConversationList:(NSArray<CLIMConversationData*>*)convlist
{
    for (CLIMConversationData* conv in convlist) {
        [self addConversation:conv];
    }
}

- (void)addConversation:(CLIMConversationData*)conv
{
    DUIConversationCellData* convData = [[DUIConversationCellData alloc] init];
    convData.convId = conv.convId;
    convData.convType = conv.convType;
    convData.avatarImage = [UIImage imageNamed:TUIKitResource(CLIMConversationTypePerson == convData.convType ? @"default_head" : @"default_group")];
    convData.title = conv.convId;
    convData.subTitle = [self getSubTitle:conv];
    convData.time = [NSDate dateWithTimeIntervalSinceNow:conv.timestamp];
    convData.unRead = conv.unreadCount;
    convData.isOnTop = NO;//暂时不支持
    [_conversationList addObject:convData];
}

@end
