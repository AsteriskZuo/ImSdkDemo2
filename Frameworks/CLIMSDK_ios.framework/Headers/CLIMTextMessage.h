//
//  CLTextMessage.h
//  citylife_im_sdk
//
//  Created by gavin on 2019/3/25.
//  Copyright © 2019年 yu.zuo. All rights reserved.
//

#import "CLIMMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLIMTextMessage : CLIMMessage

/**
 * 消息内容
 */
@property(nonatomic, strong) NSString* content;

/**
 * 个性化内容：例如：此条消息的字体大小、字体颜色等
 */
@property (nonatomic, strong, nullable) NSString* extra;

@end

NS_ASSUME_NONNULL_END
