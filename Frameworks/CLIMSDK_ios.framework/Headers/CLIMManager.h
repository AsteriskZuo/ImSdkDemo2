//
//  CLIMManager.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/9/17.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLIMListener.h"
#import "CLIMCommon.h"
#import "CLIMConfig.h"
#import "CLIMFileManager.h"

@class CLIMConfig;
@class CLIMListenerConfig;
@class CLIMConversation;

NS_ASSUME_NONNULL_BEGIN

/*
 ###############################################################################
 #######################    CITYLIFE IM-SDK iOS            #####################
 #######################    SDK MANAGER OBJECT             #####################
 #######################    VERSION: 1.0.1                 #####################
 #######################    UPDATE DATE: 2019.09.16        #####################
 ###############################################################################
 */

@interface CLIMManager : NSObject

/*
 ###############################################################################
 #######################    INIT PARTITION                 #####################
 ###############################################################################
 */

/**
 * SDK管理器单实例
 * CLIMPlatform将作废
 * @return 返回单实例
 */
+ (CLIMManager*)sharedInstance;

/**
 * 初始化SDK
 * @param config 参数配置等信息
 * @return 0.成功 1.失败
 */
- (int)initSdk:(CLIMGlobalConfig*)config;

/**
 * 获取全局配置信息
 * @return 返回配置信息
 */
- (CLIMGlobalConfig*)getGlobalConfig;

/*
 * 卸载sdk
 */
- (void)uninitSdk;

/*
 ###############################################################################
 #######################    LOGIN PARTITION                #####################
 ###############################################################################
 */

/**
 * 登录到服务器
 * @param info 登录相关信息
 * @param success 成功
 * @param fail 失败
 * @return 0.操作成功
 */
- (int)login:(CLIMLoginParam*)info succ:(CLIMLoginSuccess)success fail:(CLIMLoginFail)fail;

/**
 * 当前用户退出登录
 */
- (void)logout;

/**
 * 获取当前用户id
 * @return id
 */
- (NSString*)getUserId;

/**
 * 获取当前用户状态
 * @return 用户当前状态
 */
- (CLIMUserConnectStatus)getUserStatus;

/*
 ###############################################################################
 #######################    CONVERSATION PARTITION         #####################
 ###############################################################################
 */

/**
 * 获取会话
 *
 * 1.收到新消息会自动创建会话对象
 * 2.发送消息（无论成功）自动创建会话对象
 * 3.暂时：会话不做服务器同步操作 2019.09.20
 * 4.会话变更请关注CLIMConversationListener对象
 *
 * @param type 个人、群组、系统
 * @param receiver 会话id
 * @return 会话对象
 */
- (CLIMConversation*)getConversation:(CLIMConversationType)type receiver:(NSString*)receiver;

/**
 * 会话是否存在
 * @return YES存在 NO不存在
 */
- (BOOL)conversationIsExist:(CLIMConversationType)type receiver:(NSString*)receiver;

/*
 ###############################################################################
 #######################    APNS PARTITION                 #####################
 ###############################################################################
 */

/**
 * 设置推送信息
 * 请登陆前或者登陆后调用，不要登陆中调用
 * @param config 具体推送相关信息
 * @return 0.设置成功 1.失败
 */
- (int)setPushInfo:(CLIMTokenParam*)config succ:(CLIMSuccess)succ fail:(CLIMFail)fail;

/**
 * 设置推送信息
 * 请登陆前或者登陆后调用，不要登陆中调用
 * @param config 具体推送相关信息
 * @return 0.设置成功 1.失败
 */
- (int)setAPNSInfo:(CLIMAPNSConfig*)config succ:(CLIMSuccess)succ fail:(CLIMFail)fail;

/**
 * 进入后台通知
 * App进入后台时调用此函数
 * @param param 后台需要的参数
 * @param success 成功
 * @param fail 失败
 * @return 0.操作完成 1.操作失败
 */
- (int)doBackground:(CLIMBackgroundParam*)param succ:(nullable CLIMSuccess)success fail:(nullable CLIMFail)fail;

/**
 * 进入前台通知
 * App进入前台时调用此函数
 * @param success 成功
 * @param fail 失败
 * @return 0.操作完成 1.操作失败
 */
- (int)doForeground:(nullable CLIMSuccess)success fail:(nullable CLIMFail)fail;

/*
 ###############################################################################
 #######################    UTIL PARTITION                 #####################
 ###############################################################################
 */

/**
 * 是否包含敏感词
 * @return YES包含 NO不包含
 */
- (BOOL)containSensitiveWord:(NSString*)content;

/*
 ###############################################################################
 #######################    DEBUG PARTITION                #####################
 ###############################################################################
 */

/**
 * 获取SDK版本号
 * 当前版本: 1.0.1
 * 1.0.0: 首次发布SDK
 * 1.0.1: 废弃接口对象CLIMPlatform
 * ...
 */
- (NSString*)getSdkVersion;

/**
 * 获取SDK内部版本号
 * 例如: 1.0.1.1.20190916
 */
- (NSString*)getSdkInternalVersion;

/**
 * 获取cpp SDK版本号
 */
- (NSString*)getCppSdkVersion;

/**
 * 设置日志相关信息
 */
- (int)setLogInfo:(CLIMLogConfig*)info;

/**
 * 清空本地所有聊天记录
 * @param clearAllFiles 删除所有文件。 YES 需要重新登录 NO 不清空文件
 * @return 0.成功
 */
- (int)clearAllMessage:(BOOL)clearAllFiles;

/**
 * app准备好了
 */
- (void)AppReady;


@end

NS_ASSUME_NONNULL_END
