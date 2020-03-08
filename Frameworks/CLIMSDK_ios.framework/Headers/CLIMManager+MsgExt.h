//
//  CLIMManager+MsgExt.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/9/18.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLIMManager.h"
#import "CLIMCommon.h"

NS_ASSUME_NONNULL_BEGIN

@class CLIMMessage;

@interface CLIMManager (MsgExt)

/**
 * 获取会话列表
 * @return 返回会话对象列表
 */
- (NSArray<CLIMConversation*>*)getConversationList;

/**
 *  删除会话
 *  @param type 个人、群组、系统（只有一个）
 *  @param receiver 用户、群组
 *  @param succ  成功时回调，并且通过CLIMConversationListener通知，succ可以为nil
 *  @param fail  失败时回调
 *  @return 0.成功
 */
- (int)deleteConversation:(CLIMConversationType)type receiver:(NSString*)receiver succ:(nullable CLIMOpConversationSuccess)succ fail:(nullable CLIMFail)fail;;

/**
 *  删除会话和消息
 *  @param type 个人、群组、系统（只有一个）
 *  @param receiver 用户、群组
 *  @param succ  成功时回调，并且通过CLIMConversationListener通知，succ可以为nil
 *  @param fail  失败时回调
 *  @return 0.成功
 */
- (int)deleteConversationAndMessages:(CLIMConversationType)type receiver:(NSString*)receiver succ:(nullable CLIMOpConversationSuccess)succ fail:(nullable CLIMFail)fail;;

/**
 *  获取会话数量
 *  @return 会话数量
 */
- (int)conversationCount;

@end

NS_ASSUME_NONNULL_END
