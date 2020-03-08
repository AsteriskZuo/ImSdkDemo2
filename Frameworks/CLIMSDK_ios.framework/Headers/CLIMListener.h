//
//  CitylifeIMSDKListener.h
//  citylife_im_sdk
//
//  Created by gavin on 2019/3/25.
//  Copyright © 2019年 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLIMCommon.h"
#import "CLIMMessage.h"

@class CLIMMessage;

/**
 * 新消息观察者
 */
@protocol CLIMMessageListener <NSObject>
@required
/**
 * 收到新消息
 * @param message 新消息
 */
-(void)receiveNewMessage:(CLIMMessage*)message API_DEPRECATED("Use -receiveNewMessageList: instead", macos(10.0,10.4), ios(2.0,2.0), watchos(2.0,2.0), tvos(9.0,9.0));

/**
 * 接收到新消息
 * 消息可能是离线消息列表、可能是在线单个消息
 * 如果是离线消息列表，则可能包含已经被撤销的消息，如果是被撤销消息则需要转换为对应提示信息（根据消息状态进行判断）
 * 如果是在线单个消息，则是新消息
 * @param messages 新消息列表
 */
- (void)receiveNewMessageList:(NSArray<CLIMMessage*>*)messages;

@end

/**
 * 网络观察者
 */
@protocol CLIMNetworkEnvListener <NSObject>
@required
/**
 * 网络状态发生变化
 * @param network 网络状态
 */
-(void)networkDidChanged:(CLIMNetworkStatus)network;
@end

/**
 * 登录结果观察者
 */
NS_CLASS_DEPRECATED(10.0,10.0, 2.0,2.0, "CLIMConnectListener is deprecated on SDK version 1.0.1.")
@protocol CLIMConnectListener <CLIMNetworkEnvListener>
@required
/**
 * 连接服务器成功
 */
-(void)didConnectToIMServer;
/**
 * 连接服务器失败
 * @param error 错误原因
 */
-(void)didFailedConnectToIMServer:(NSError *)error;
@end

/**
 * 和服务器断开观察者
 */
@protocol CLIMDisConnectListener <CLIMNetworkEnvListener>
@required
/**
 * 服务器不允许登录
 */
-(void)didDisconnectByServerForbid;
/**
 * 被踢
 */
-(void)didDisconnectByKicked;
/**
 * 用户登录退出
 */
-(void)didDisconnectByUserLogout;
/**
 * 需要刷新access
 */
-(void)didDisconnectByUpdateAccess;

@end

/**
 * 日志观察者
 */
@protocol CLIMLogListener <NSObject>
@required
/**
 * 监听SDK日志
 */
-(void)sdkLogOutput:(NSString*)logContent;
@end

@protocol CLIMConversationListener <NSObject>
@required
/**
 * 初始化完成
 * @param convs 会话列表
 */
- (void)didInit:(NSArray<CLIMConversationData*>*)convs;
/**
 * 增加会话对象
 * @param conv 会话对象
 */
- (void)didAddConversation:(CLIMConversationData*)conv;
/**
 * 会话对象更新
 * @param conv 会话对象
 * @param type 更新类型 0.会话对象更新 0x1.名字更新 0x2.时间戳更新 0x4.快照 0x8.未读数 0x10.置顶 ...
 */
- (void)didUpdateConversation:(CLIMConversationData*)conv updateType:(int)type;
/**
 * 会话对象删除
 * @param convId 会话对象id
 * @param convType 会话对象类型
 */
- (void)didDeleteConversation:(NSString*)convId type:(CLIMConversationType)convType;
/**
 * 会话刷新（离线消息）
 * @param convs 会话列表
 */
- (void)didRefresh:(NSArray<CLIMConversationData*>*)convs;

@end

@protocol CLIMConnectStatusListener <NSObject>

@required

/**
 * 当前连接状态
 * @param status 状态
 */
- (void)didConnectStatus:(CLIMUserConnectStatus)status;

@end


@protocol CLIMUploadFileProgressListener <NSObject>
@required
/**
 * 上传进度
 * 建议：使用系统通知方式进行调用，至少是切换到主线程
 * @param convId 会话对象id
 * @param convType 会话对象类型
 * @param msgId 消息id
 * @param uuid 文件id
 * @param currentSize 当前上传大小
 * @param totalSize 总大小
 */
- (void)progress:(NSString*)convId convType:(CLIMConversationType)convType messageId:(NSString*)msgId fileId:(NSString*)uuid currentSize:(NSUInteger)currentSize totalSize:(NSUInteger)totalSize;

@end

