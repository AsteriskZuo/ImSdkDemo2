//
//  CitylifeIMSDK.h
//  citylife_im_sdk
//
//  Created by gavin on 2019/3/25.
//  Copyright © 2019年 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLIMListener.h"
#import "CLIMCommon.h"

@class CLIMMessage;
@class CLIMConfig;

NS_CLASS_DEPRECATED(10.0,10.0, 2.0,2.0, "CLIMPlatform is deprecated on SDK version 1.0.1. Use CLIMManager instead.")
@interface CLIMPlatform : NSObject
/** 当前用户ID */
@property(nonatomic,readonly)NSString *user;
/** 消息监听着 */
@property(nonatomic,weak)id<CLIMMessageListener> recvMsgListener;
/** 连接监听着 */
@property(nonatomic,weak)id<CLIMDisConnectListener> disConnectListener;
/** 连接监听着 */
@property(nonatomic,weak)id<CLIMConnectListener> connectListener;
/**
 * 单例
 * @return sdk实例
 */
+(instancetype)sharedPlatform;

/**
 * 初始化sdk
 * @param config sdk配置信息
 * @param recvMsgListener 消息监听者
 * @param disConnectListener 连接监听者
 */
- (void)initWithConfig:(CLIMConfig *)config recvMsgListener:(id<CLIMMessageListener>)recvMsgListener disConnectListener:(id<CLIMDisConnectListener>)disConnectListener;

/*
 * 卸载sdk
 */
-(void)uninit;


/**
 * 连接服务器，必须在初始化之后连接
 * @param token 登录token
 * @param connectListener 连接监听器
 */
-(void)connect:(NSString*)token connectListener:(id<CLIMConnectListener>)connectListener;

/**
 * 发送消息
 * @param message 消息
 * @param success 成功
 * @param failed 失败
 */
-(void)sendMessage:(CLIMMessage*)message success:(CLIMSendMessageSuccess)success failed:(CLIMSendMessageFail)failed;

/**
 * 保存发送的消息（异步消息需要使用）
 * @param message 发送的消息对象
 */
-(bool)saveSendedMessage:(CLIMMessage*)message result:(NSString*)reason;

/**
 * 异步消息发送失败修改状态
 * @param timestamp 发送消息的本地时间戳
 */
-(void)sendedMessageStateToFail:(NSString*)id idtype:(int)idtype timestamp:(long long)timestamp;

/**
 * 登录退出
 */
-(void)logout;
 /**
  * 当前用户状态
  */
-(CLIMUserConnectStatus)currentStatus;

/*
 * 检测sdk日志
 */
- (void)setSdkLogListener:(id<CLIMLogListener>)logListener;

/*
 * 更新ip和port 仅内部使用
 * @param op 操作类型：0.connect 1.only update
 */
- (void)updateAccess:(int)op;

/**
 * 获取appkey
 * @return 返回appkey
 */
- (NSString*)getAppKey;

/**
 * 获取获取navi域名
 * @param handler 返回navi域名和是否采用SSL
 */
- (void)getNaviDomain:(void(^)(NSString* domain, BOOL enableSSL))handler;

/**
 * 设置获取navi域名
 * @param domain 获取token的域名
 * @param enableSSL 是否启用SSL
 */
- (void)setNaviDomain:(NSString*)domain enableSSL:(BOOL)enableSSL;

/**
 *
 */
- (void)setPushToken:(NSString*)pushtoken;

@end

NS_CLASS_DEPRECATED(10.0,10.0, 2.0,2.0, "CLIMPlatformHelper is deprecated on SDK version 1.0.1. Use CLIMUtils instead.")
@interface CLIMPlatformHelper : NSObject

/**
 * 生成消息UUID 16位
 * @param timestamp 毫秒级时间戳
 * @param targetId 消息接收者id
 * @param targetType 消息接收者type
 */
+(NSString*)generateMessageIdWithTimestamp:(long long)timestamp targetId:(NSString*)targetId targetType:(int)targetType;

/**
 * 获取当前毫秒级时间戳
 */
+(long long)getCurrentTimestamp;

@end
