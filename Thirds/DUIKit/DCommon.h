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
