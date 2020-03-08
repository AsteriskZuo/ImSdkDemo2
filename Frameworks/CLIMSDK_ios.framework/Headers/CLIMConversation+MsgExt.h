//
//  CLIMConversation+MsgExt.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/9/17.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#import "CLIMConversation.h"
#import "CLIMCommon.h"

@class CLIMMessage;
@class CLIMMessageDraft;

NS_ASSUME_NONNULL_BEGIN

@interface CLIMConversation (MsgExt)

/**
 *  获取会话漫游消息(获取更早的消息)
 *
 *  1. 登录后可以获取漫游消息，单聊和群聊消息免费漫游7天
 *  2. 如果本地消息全部都是连续的，则不会通过网络获取，如果本地消息不连续，会通过网络获取断层消息。
 *  3. 对于图片、语音等资源类消息，消息体只会包含描述信息，需要通过额外的接口下载数据，详情请参考xxx文档。
 *
 *  @param count 获取数量
 *  @param last  上次最后一条消息，如果 last 为 nil，从最新的消息开始读取
 *  @param succ  成功时回调
 *  @param fail  失败时回调
 *  @return 0：本次操作成功；1：本次操作失败
 */
- (int)getMessage:(int)count last:(nullable CLIMMessage*)last succ:(CLIMGetMessageSuccess)succ fail:(CLIMGetMessageFail)fail;

/**
 *  向前获取会话漫游消息（获取更新的消息）
 *
 *  调用方式和 getMessage 一样，区别是 getMessage 获取的是时间更老的消息，主要用于下拉 Tableview 刷新消息数据，getMessageForward 获取的是时间更新的消息，主要用于上拉 Tableview 刷新消息数据。
 *
 *  @param count 获取数量
 *  @param last  上次最后一条消息，如果 last 为 nil，从最新的消息开始读取
 *  @param succ  成功时回调
 *  @param fail  失败时回调
 *  @return 0：本次操作成功；1：本次操作失败
 */
- (int)getMessageForward:(int)count last:(nullable CLIMMessage*)last succ:(CLIMGetMessageSuccess)succ fail:(CLIMGetMessageFail)fail;

/**
 *  获取本地消息(获取更早的消息)
 *  可能存在断层，断层消息可能由其他设备接收到了。
 *
 *  @param count 获取数量
 *  @param last  上次最后一条消息，如果 last 为 nil，从最新的消息开始读取
 *  @param succ  成功时回调，如果为空则没有符合要求的消息了
 *  @param fail  失败时回调
 *  @return 0：本次操作成功；1：本次操作失败
 */
- (int)getLocalMessage:(int)count last:(nullable CLIMMessage*)last succ:(CLIMGetMessageSuccess)succ fail:(CLIMGetMessageFail)fail;

/**
 *  撤回消息
 *
 *  1. 仅 C2C 和 GROUP 会话有效、onlineMessage 无效。
 *  2. 同时更新会话列表最后一条消息显示。
 *  3. 撤销原理：被撤销消息标记为撤销
 *  4. 撤销是同步操作，需要先通知服务器，服务器收到通知之后，返回同意，再执行本地操作。
 *
 *  @param msg   被撤回的消息
 *  @param succ  成功时回调
 *  @param fail  失败时回调
 *  @return 0.本次操作成功；1.本次操作失败
 */
- (int)revokeMessage:(CLIMMessage*)msg succ:(CLIMSuccess)succ fail:(CLIMFail)fail;

/**
 *  删除本地会话指定的消息
 *
 *  1.删除原理：被删除消息标记为删除
 *  2.删除是本地操作，服务器并不知情
 *  3.风险：当支持漫游操作，本地消息已删除，重新拉取的话删除的消息可能再次显示。可以做成同步消息这样就不会出现这个风险。
 *
 *  @param msg  删除的消息
 *  @param succ  成功时回调
 *  @param fail  失败时回调
 *
 *  @return 0 本次操作成功
 */
- (int)deleteLocalMessage:(CLIMMessage*)msg succ:(CLIMSuccess)succ fail:(CLIMFail)fail;

/**
 *  删除本地会话全部消息
 *
 *  1.删除原理：被删除消息标记为删除
 *  2.删除是本地操作，服务器并不知情
 *  3.风险：当支持漫游操作，本地消息已删除，重新拉取的话删除的消息可能再次显示。可以做成同步消息这样就不会出现这个风险。
 *
 *  @param succ  成功时回调
 *  @param fail  失败时回调
 *
 *  @return 0 本次操作成功
 */
- (int)deleteLocalMessage:(CLIMSuccess)succ fail:(CLIMFail)fail;

/**
 *  设置已读消息
 *
 *  1.已读是同步操作，先通知服务器，收到同意后，再标记当前会话已读
 *  2.一般地，打开会话后全部已读、关闭会话前全部已读
 *  3.一般地，在当前会话中收到的消息发送已读上报（不包括同步的、和发送的消息）
 *
 *  @param readed 从这条消息开始全部已读 nil表示从最新的消息开始全部已读
 *  @param succ  成功时回调
 *  @param fail  失败时回调
 *  @return 0 表示成功
 */
- (int)setReadMessage:(nullable CLIMMessage*)readed succ:(CLIMSuccess)succ fail:(CLIMFail)fail;

/**
 *  获取会话的未读计数
 *  @return 返回未读计数
 */
- (int)getUnReadMessageNum;

/**
 *  获取最后一条消息
 *  @return 最后一条消息
 */
- (CLIMMessage*)getLastMessage;

/**
 *  设置会话草稿
 *  通常一个会话只有一个草稿
 *  @param draft 草稿内容
 *  @return 0：成功；1：失败
 */
- (int)setDraft:(CLIMMessageDraft*)draft;

/**
 *  获取会话草稿
 *  @return 草稿内容，没有草稿返回 nil
 */
- (CLIMMessageDraft*)getDraft;

@end

NS_ASSUME_NONNULL_END
