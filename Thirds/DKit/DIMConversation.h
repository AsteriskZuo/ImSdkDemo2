//
//  DIMConversation.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/9.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface DIMConversation : NSObject

- (instancetype)initWithConvId:(NSString*)convId convType:(CLIMConversationType)convType;

/**
 *  5.1 获取会话类型
 *
 *  @return 会话类型
 */
- (CLIMConversationType)getType;

/**
 *  5.2 获取会话 ID
 *
 *  C2C：对方账号；Group：群组Id。
 *
 *  对同一个单聊或则群聊会话，getReceiver 获取的会话 ID 都是固定的，C2C 获取的是对方账号，Group 获取的是群组 Id。
 *
 *  @return 会话人
 */
- (NSString*)getReceiver;

/**
 *  5.3 获取群名称
 *
 *  获取群名称，只有群会话有效。
 *
 *  @return 群名称
 */
- (NSString*)getGroupName;

@end

NS_ASSUME_NONNULL_END
