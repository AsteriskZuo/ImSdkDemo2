//
//  CLIMLocationMessage.h
//  citylife_im_sdk
//
//  Created by gavin on 2019/3/25.
//  Copyright © 2019年 yu.zuo. All rights reserved.
//

#import "CLIMMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLIMLocationMessage : CLIMMessage

/**
 * 维度坐标
 */
@property(nonatomic, strong) NSString* latitude;

/**
 * 经度坐标
 */
@property(nonatomic, strong) NSString* longitude;

/**
 * 地理位置描述信息
 */
@property(nonatomic, strong, nullable) NSString* description;

@end

NS_ASSUME_NONNULL_END
