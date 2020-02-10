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
