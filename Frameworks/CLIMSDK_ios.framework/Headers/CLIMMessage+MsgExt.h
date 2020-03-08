//
//  CLIMMessage+MsgExt.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/9/17.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#import <CLIMSDK_ios/CLIMSDK_ios.h>
#import "CLIMMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLIMMessage (MsgExt)

@end

@interface CLIMMessageDraft : NSObject

/**
 * 设置草稿消息
 * @param message 消息
 * @return 0.成功；1.失败
 */
- (int)setMessage:(CLIMMessage*)message;

/**
 * 获取草稿消息
 * @return 返回草稿消息
 */
- (CLIMMessage*)getMessage;

/**
 *  设置自定义数据
 *  @param userData 自定义数据
 *  @return 0.成功；1.失败
 */
- (int)setUserData:(NSData*)userData;

/**
 *  获取自定义数据
 *  @return 自定义数据
 */
- (NSData*)getUserData;

/**
 * 设置草稿时间戳
 * @param timestamp 时间戳
 */
- (int)setTimestamp:(NSDate*)timestamp;

/**
 *  获取草稿时间戳
 *  @return 时间戳
 */
- (NSDate*)timestamp;

@end

NS_ASSUME_NONNULL_END
