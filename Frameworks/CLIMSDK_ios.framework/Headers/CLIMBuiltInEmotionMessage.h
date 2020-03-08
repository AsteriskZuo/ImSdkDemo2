//
//  CLIMBuiltInEmotionMessage.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/5/6.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#ifndef CLIMBuiltInEmotionMessage_h
#define CLIMBuiltInEmotionMessage_h

#import <Foundation/Foundation.h>
#import "CLIMMessage.h"

/**
 * 系统自带表情库表情
 * 用户无法进行添加、删除和修改
 */
@interface CLIMBuiltInEmotionMessage : CLIMMessage

@property (nonatomic, assign) NSInteger index;

@end

#endif /* CLIMBuiltInEmotionMessage_h */
