
//
//  CLIMOrderNotifyMessage.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/5/10.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#ifndef CLIMOrderNotifyMessage_h
#define CLIMOrderNotifyMessage_h

#import <Foundation/Foundation.h>
#import "CLIMMessage.h"

/**
 * 业务订单通知消息
 */
@interface CLIMOrderNotifyMessage : CLIMMessage

/**
 * orderId: 订单id
 */
@property (nonatomic, copy) NSString* orderId;

/**
 * orderType: 订单类型
 */
@property (nonatomic, assign) CLIM_ORDER_NOTIFY_TYPE orderType;

/**
 * extra: 额外信息
 */
@property (nonatomic, copy) NSString* extra;

@end


#endif /* CLIMOrderNotifyMessage_h */
