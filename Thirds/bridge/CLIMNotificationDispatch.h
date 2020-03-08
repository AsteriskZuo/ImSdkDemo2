//
//  CLIMNotificationDispatch.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/3/8.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CLIMSDK_ios/CLIMSDK_ios.h>

NS_ASSUME_NONNULL_BEGIN


static NSString* CLIMDisconnectNotification_didDisconnectByServerForbid = @"CLIMDisconnectNotification_didDisconnectByServerForbid";
static NSString* CLIMDisconnectNotification_didDisconnectByKicked = @"CLIMDisconnectNotification_didDisconnectByKicked";
static NSString* CLIMDisconnectNotification_didDisconnectByUserLogout = @"CLIMDisconnectNotification_didDisconnectByUserLogout";
static NSString* CLIMDisconnectNotification_didDisconnectByUpdateAccess = @"CLIMDisconnectNotification_didDisconnectByUpdateAccess";
static NSString* CLIMDisconnectNotification_networkDidChanged = @"CLIMDisconnectNotification_networkDidChanged";

static NSString* CLIMReceiverMessageNotification_receiveNewMessageList = @"CLIMReceiverMessageNotification_receiveNewMessageList";

static NSString* CLIMConversationListNotification_didInit = @"CLIMConversationListNotification_didInit";
static NSString* CLIMConversationListNotification_didAddConversation = @"CLIMConversationListNotification_didAddConversation";
static NSString* CLIMConversationListNotification_didUpdateConversation = @"CLIMConversationListNotification_didUpdateConversation";
static NSString* CLIMConversationListNotification_didDeleteConversation = @"CLIMConversationListNotification_didDeleteConversation";
static NSString* CLIMConversationListNotification_didRefresh = @"CLIMConversationListNotification_didRefresh";

static NSString* CLIMUploadFileProgressNotification_progress = @"CLIMUploadFileProgressNotification_progress";


@interface CLIMNotificationDispatch : NSObject

@end


@interface CLIMDisconnectNotification : NSObject <CLIMDisConnectListener>

+ (instancetype)sharedInstance;

@end

@interface CLIMReceiverMessageNotification : NSObject <CLIMMessageListener>

+ (instancetype)sharedInstance;

@end

@interface CLIMConversationListNotification : NSObject <CLIMConversationListener>

+ (instancetype)sharedInstance;

@end

@interface CLIMUploadFileProgressNotification : NSObject <CLIMUploadFileProgressListener>

+ (instancetype)sharedInstance;

@end


NS_ASSUME_NONNULL_END
