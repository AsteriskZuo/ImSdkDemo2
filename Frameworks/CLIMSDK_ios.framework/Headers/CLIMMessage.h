//
//  CLIMMessage.h
//  TestIM
//
//  Created by gavin on 2019/3/27.
//  Copyright © 2019年 gavin. All rights reserved.
//

#ifndef CLIMMessage_h
#define CLIMMessage_h

#import <Foundation/Foundation.h>
#import "CLIMCommon.h"


@class CLIMOfflinePushInfo;
@class CLIMConversation;

@protocol CLIMMessage <NSObject>

@required

/**
 * 初始化消息方法
 * 1.初始化msgId = 16位
 * 2.初始化sender = self
 * 3.初始化timestamp = 当前时间毫秒级
 * 4.初始化msgStatus = CLIMMessageStatusSending
 * 5.init默认初始化方法在发送消息的时候不建议使用
 * @param conv 会话对象
 * @return 返回消息对象
 */
- (instancetype)initWithConversation:(CLIMConversation*)conv;

/**
 * 解析原始消息数据：来自于底层(各种类型消息需要自己实现)
 * @rawContent 原始数据
 */
- (void)decodeMessage:(NSData*)rawContent;

/**
 * 转换为原始消息数据：用于底层传输（各种类型消息需要自己实现）
 * @return 返回原始数据
 */
- (NSData*)encodeMessage;

@optional

/**
 * 消息数据自动填写
 */
- (void)autoFillData;

@end


@interface CLIMMessage : NSObject <CLIMMessage>

/**
 * 消息唯一标识
 * 1.消息标识由客户端生成
 * 2.建议使用CLIMUtils对象 generateMessageIdWithTimestamp方法获取
 */
@property(nonatomic,copy)NSString *msgId;

/**
 * 消息发送者:可能是自己、可能是其它人
 */
@property(nonatomic,copy)NSString *sender;

/**
 * 消息会话对象
 */
@property(nonatomic,copy)NSString *receiver DEPRECATED_ATTRIBUTE;

/**
 * 消息会话对象类型
 */
@property(nonatomic,assign)int convType DEPRECATED_ATTRIBUTE;

/**
 * 消息类型
 * 例如:CL:Text
 */
@property(nonatomic,copy)NSString* msgTypeStr;

/**
 * 消息时间戳
 * 一般地，采用毫秒级
 * 建议使用CLIMUtils对象 getCurrentTimestamp方法
 * 如果是发送消息，为发送时间戳，发送成功会更新为服务器时间戳
 * 如果是接收消息，为服务器时间戳
 */
@property(nonatomic,assign)long long timestamp;

/**
 * 消息状态
 * 包括：发送中、发送成功、发送失败等
 */
@property(nonatomic,assign)CLIMMessageStatus msgStatus;

/** 同步保存*/
@property(nonatomic,assign)BOOL isSyncSave DEPRECATED_ATTRIBUTE;

/**
 * 是否是在线消息：在线消息不做存储、未读技术等
 */
@property(nonatomic,assign)BOOL isOnline;

/**
 * 设置离线推送消息
 * 如果不使用则使用默认内容
 * @param info 离线消息信息
 */
- (void)setOfflinePushInfo:(CLIMOfflinePushInfo*)info;

/**
 * 获取离线推送信息
 * @return 返回推送信息
 */
- (CLIMOfflinePushInfo*)getOfflinePushInfo;

/**
 * 获取离线推送消息内容
 */
- (NSString*)getPushContent NS_DEPRECATED(10_6,10_9,2_0,7_0);

/**
 * 获取离线推送消息数据
 */
- (NSData*)getPushData NS_DEPRECATED(10_6,10_9,2_0,7_0);

/**
 *  1.设置自定义整数，默认为 0
 *
 *  1.此自定义字段仅存储于本地，不会同步到 Server，用户卸载应用或则更换终端后无法获取。
 *  2.可以根据这个字段设置语音消息是否已经播放，如 customInt 的值 0 表示未播放，1 表示播放，当用户单击播放后可设置 customInt 的值为 1。
 *
 *  @param param 设置参数
 *
 *  @return YES：设置成功；NO:设置失败
 */
- (BOOL)setCustomInt:(int32_t)param;

/**
 *  1.获取 CustomInt
 *
 *  @return CustomInt
 */
- (int32_t)customInt;

/**
 *  1.设置自定义数据，默认为""
 *
 *  此自定义字段仅存储于本地，不会同步到 Server，用户卸载应用或则更换终端后无法获取。
 *
 *  @param data 设置参数
 *
 *  @return YES：设置成功；NO:设置失败
 */
- (BOOL)setCustomData:(NSData*)data;

/**
 *  1.获取 CustomData
 *
 *  @return CustomData
 */
- (NSData*)customData;

/**
 *  获取会话
 *  @return 该消息所对应会话
 */
- (CLIMConversation*)getConversation;

@end


/**
 * 消息管理器
 */
@interface CLIMMessageManager : NSObject

/**
 * 消息管理器单实例
 * @return 返回消息管理器单实例
 */
+(instancetype)sharedInstance;

/**
 * 注册消息
 * @param msgTypeStr 消息类型（例如：CL:Loc）
 * @param obj 创建对象方法
 */
-(void)registerMessage:(NSString*)msgTypeStr messageObject:(CLIMMessage*)obj;

/**
 * 取消注册消息
 * @param msgTypeStr 消息类型（例如：CL:Loc）
 */
-(void)unRegisterMessage:(NSString*)msgTypeStr;

/**
 * 取消注册消息
 * @param msgTypeStr 消息类型（例如：CL:Loc）
 * @return CLIMMessage* 消息对象（可能为空）
 */
-(CLIMMessage*)createMessageObject:(NSString*)msgTypeStr;

/**
 * 注册内置类型消息
 */
-(void)registerBuiltInMessages;

@end


@interface CLIMOfflinePushInfo : NSObject

/** 推送内容*/
@property(nonatomic,copy)NSString* pushContent;
/** 推送原始内容*/
@property(nonatomic,copy)NSData* pushData;
/** 推送标题*/
@property(nonatomic,copy)NSString* pushTitle;
/** 推送子标题*/
@property(nonatomic,copy)NSString* pushSubTitle;
/** 推送声音*/
@property(nonatomic,copy)NSString* pushSound;

@end


@interface CLIMSendMessageResult : NSObject

@property(nonatomic,copy) NSString* msgId;
@property(nonatomic,assign) long long timestamp;

@end


#endif /* CLIMMessage_h */
