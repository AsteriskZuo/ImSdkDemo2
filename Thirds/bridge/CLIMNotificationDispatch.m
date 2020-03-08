//
//  CLIMNotificationDispatch.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/3/8.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "CLIMNotificationDispatch.h"

@implementation CLIMNotificationDispatch

@end


@implementation CLIMDisconnectNotification

static CLIMDisconnectNotification* s_CLIMDisconnectNotification_instance = nil;

+ (nonnull instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_CLIMDisconnectNotification_instance = [[CLIMDisconnectNotification alloc] init];
    });
    return s_CLIMDisconnectNotification_instance;
}

-(void)didDisconnectByServerForbid
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CLIMDisconnectNotification_didDisconnectByServerForbid object:nil];
}

-(void)didDisconnectByKicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CLIMDisconnectNotification_didDisconnectByKicked object:nil];
}

-(void)didDisconnectByUserLogout
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CLIMDisconnectNotification_didDisconnectByUserLogout object:nil];
}

-(void)didDisconnectByUpdateAccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CLIMDisconnectNotification_didDisconnectByUpdateAccess object:nil];
}

- (void)networkDidChanged:(CLIMNetworkStatus)network
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CLIMDisconnectNotification_networkDidChanged object:[NSNumber numberWithInteger:network]];
}

@end



@implementation CLIMReceiverMessageNotification

static CLIMReceiverMessageNotification* s_CLIMReceiverMessageNotification_instance;

+ (nonnull instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_CLIMReceiverMessageNotification_instance = [[CLIMReceiverMessageNotification alloc] init];
    });
    return s_CLIMReceiverMessageNotification_instance;
}

- (void)receiveNewMessageList:(NSArray<__kindof CLIMMessage* >* )messages
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CLIMReceiverMessageNotification_receiveNewMessageList object:messages];
}

- (void)receiveNewMessage:(CLIMMessage *)message
{
    //deprecated
}


@end




@implementation CLIMConversationListNotification

static CLIMConversationListNotification* s_CLIMConversationListNotification_instance;

+ (nonnull instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_CLIMConversationListNotification_instance = [[CLIMConversationListNotification alloc] init];
    });
    return s_CLIMConversationListNotification_instance;
}

- (void)didInit:(NSArray<CLIMConversationData*>*)convs
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CLIMConversationListNotification_didInit object:convs];
}

- (void)didAddConversation:(CLIMConversationData*)conv
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CLIMConversationListNotification_didAddConversation object:conv];
}

- (void)didUpdateConversation:(CLIMConversationData*)conv updateType:(int)type
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:@[conv, @(type)] forKeys:@[@"conv", @"type"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:CLIMConversationListNotification_didUpdateConversation object:dict];
}

- (void)didDeleteConversation:(NSString*)convId type:(CLIMConversationType)convType
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:@[convId, @(convType)] forKeys:@[@"convId", @"convType"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:CLIMConversationListNotification_didDeleteConversation object:dict];
}

- (void)didRefresh:(NSArray<CLIMConversationData*>*)convs
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CLIMConversationListNotification_didRefresh object:convs];
}

@end




@implementation CLIMUploadFileProgressNotification

static CLIMUploadFileProgressNotification* s_CLIMUploadFileProgressNotification_instance;

+ (nonnull instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_CLIMUploadFileProgressNotification_instance = [[CLIMUploadFileProgressNotification alloc] init];
    });
    return s_CLIMUploadFileProgressNotification_instance;
}

- (void)progress:(NSString *)convId convType:(CLIMConversationType)convType messageId:(NSString *)msgId fileId:(NSString *)uuid currentSize:(NSUInteger)currentSize totalSize:(NSUInteger)totalSize
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:@[convId, @(convType), msgId, uuid, @(currentSize), @(totalSize)] forKeys:@[@"convId", @"convType", @"msgId", @"uuid", @"currentSize", @"totalSize"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:CLIMUploadFileProgressNotification_progress object:dict];
}

@end
