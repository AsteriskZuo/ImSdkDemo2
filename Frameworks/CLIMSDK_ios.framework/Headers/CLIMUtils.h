//
//  CLIMUtils.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/9/18.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 工具类
 */
@interface CLIMUtils : NSObject

/**
 * 生成消息UUID 16位
 * @param timestamp 毫秒级时间戳
 * @param targetId 消息接收者id
 * @param targetType 消息接收者type
 */
+ (NSString*)generateMessageIdWithTimestamp:(long long)timestamp targetId:(NSString*)targetId targetType:(int)targetType;

/**
 * 获取当前毫秒级时间戳
 */
+ (long long)getCurrentTimestamp;

/**
 * 生成普通UUID 32位
 */
+ (NSString*)generateUUID;

@end

NS_ASSUME_NONNULL_END
