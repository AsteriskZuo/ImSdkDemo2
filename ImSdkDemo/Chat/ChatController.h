//
//  ChatController.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/7.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DUIConversationCell.h"

NS_ASSUME_NONNULL_BEGIN

@class DUIMessageCellData;
@class DUIUnreadView;

@interface ChatController : UIViewController

@property (nonatomic, strong) DUIConversationCellData* conversationData;
@property (nonatomic, strong) DUIUnreadView* unreadView;

- (void)sendMessage:(DUIMessageCellData*)msg;

@end

NS_ASSUME_NONNULL_END
