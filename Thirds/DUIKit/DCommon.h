//
//  DCommon.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/27.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 会话类型：
 *      C2C     双人聊天
 *      GROUP   群聊
 */
typedef NS_ENUM(NSInteger, DIMConversationType) {
    /**
     *  C2C 类型
     */
    TIM_C2C              = 1,

    /**
     *  群聊 类型
     */
    TIM_GROUP            = 2,

    /**
     *  系统消息
     */
    TIM_SYSTEM           = 3,
};


/**
 * 日志级别
 */
typedef NS_ENUM(NSInteger, DIMLogLevel) {
    /**
     *  不输出任何 sdk log
     */
    TIM_LOG_NONE                = 0,
    /**
     *  输出 DEBUG，INFO，WARNING，ERROR 级别的 log
     */
    TIM_LOG_DEBUG               = 3,
    /**
     *  输出 INFO，WARNING，ERROR 级别的 log
     */
    TIM_LOG_INFO                = 4,
    /**
     *  输出 WARNING，ERROR 级别的 log
     */
    TIM_LOG_WARN                = 5,
    /**
     *  输出 ERROR 级别的 log
     */
    TIM_LOG_ERROR               = 6,
};


/**
 *  消息状态
 */
typedef NS_ENUM(NSInteger, DIMMessageStatus){
    /**
     *  消息发送中
     */
    TIM_MSG_STATUS_SENDING              = 1,
    /**
     *  消息发送成功
     */
    TIM_MSG_STATUS_SEND_SUCC            = 2,
    /**
     *  消息发送失败
     */
    TIM_MSG_STATUS_SEND_FAIL            = 3,
    /**
     *  消息被删除
     */
    TIM_MSG_STATUS_HAS_DELETED          = 4,
    /**
     *  导入到本地的消息
     */
    TIM_MSG_STATUS_LOCAL_STORED         = 5,
    /**
     *  被撤销的消息
     */
    TIM_MSG_STATUS_LOCAL_REVOKED        = 6,
};
