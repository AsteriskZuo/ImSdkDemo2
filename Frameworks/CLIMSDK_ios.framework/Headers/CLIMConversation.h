//
//  CLIMConversation.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/9/17.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLIMCommon.h"

@class CLIMMessage;

NS_ASSUME_NONNULL_BEGIN

@interface CLIMConversation : NSObject

/**
 * 初始化会话对象
 * @param receiver 对象
 * @param receiverType 对象类型
 * @return 返回对象本身
 */
- (instancetype)initWithId:(NSString*)receiver type:(CLIMConversationType)receiverType;

/**
 * 发送消息: 离线消息: 本地保存、服务器保存、服务器推送
 * 1.文本等同步消息，直接发送给服务器；
 * 2.图片等异步消息，先发送到资源服务器，发送成功后，再发送给服务器；
 * 3.发送结果通过回调返回给用户
 *
 * 发送普通消息
 * @param msg 消息
 * @param success 成功
 * @param fail 失败
 * @return 0.操作完成 1.操作失败
 */
-(int)sendMessage:(CLIMMessage*)msg success:(CLIMSendMessageSuccess)success failed:(CLIMSendMessageFail)fail;

/**
 * 发送消息: 在线消息: 本地不保存、服务器不保存、服务器不推送
 * 1.消息客户端和服务器都不做存储
 * 2.消息无法回显，例如：重新打开会话消息不在
 * 3.消息不做未读已读处理
 * 4.典型应用场景：
 *      1.发送用户输入状态：正在输入中。
 *      2.通知类消息
 * 5.回调接口预留，暂时没有 success=nil 和 failed=nil,即可 //2019.09.16
 *
 * 发送在线消息
 * @param msg 消息
 * @param success 成功
 * @param fail 失败
 * @return 0.操作完成 1.操作失败
 */
-(int)sendOnlineMessage:(CLIMMessage*)msg success:(nullable CLIMSendMessageSuccess)success failed:(nullable CLIMSendMessageFail)fail;

/**
 *  获取会话人，单聊为对方账号，群聊为群组Id
 *  @return 会话人Id
 */
- (NSString*)getReceiver;

/**
 *  获取会话类型
 *  @return 会话类型
 */
- (CLIMConversationType)getReceiverType;

@end

@interface CLIMOpConversationResult : NSObject

@property(nonatomic,copy) NSString* receiver;
@property(nonatomic,assign) CLIMConversationType receiverType;

@end

NS_ASSUME_NONNULL_END
