//
//  DCommon.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/27.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CLIMSDK_ios/CLIMSDK_ios.h>


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


/**
 *  图片类型
 */
typedef NS_ENUM(NSInteger, DIM_IMAGE_TYPE){
    /**
     *  原图
     */
    TIM_IMAGE_TYPE_ORIGIN              = 0x01,
    /**
     *  缩略图
     */
    TIM_IMAGE_TYPE_THUMB               = 0x02,
    /**
     *  大图
     */
    TIM_IMAGE_TYPE_LARGE               = 0x04,
};

/**
 *  图片格式
 */
typedef NS_ENUM(NSInteger, DIM_IMAGE_FORMAT){
    /**
     *  JPG 格式
     */
    TIM_IMAGE_FORMAT_JPG            = 0x1,
    /**
     *  GIF 格式
     */
    TIM_IMAGE_FORMAT_GIF            = 0x2,
    /**
     *  PNG 格式
     */
    TIM_IMAGE_FORMAT_PNG            = 0x3,
    /**
     *  BMP 格式
     */
    TIM_IMAGE_FORMAT_BMP            = 0x4,
    /**
     *  未知格式
     */
    TIM_IMAGE_FORMAT_UNKNOWN        = 0xff,
};

/**
 *  图片压缩选项
 */
typedef NS_ENUM(NSInteger, DIM_IMAGE_COMPRESS_TYPE){
    /**
     *  原图(不压缩）
     */
    TIM_IMAGE_COMPRESS_ORIGIN              = 0x00,
    /**
     *  高压缩率：图片较小，默认值
     */
    TIM_IMAGE_COMPRESS_HIGH                = 0x01,
    /**
     *  低压缩：高清图发送(图片较大)
     */
    TIM_IMAGE_COMPRESS_LOW                 = 0x02,
};



/**
 *  一般操作成功回调
 */
typedef void (^DIMSucc)(void);

/**
 *  操作失败回调
 *
 *  @param code 错误码
 *  @param msg  错误描述，配合错误码使用，如果问题建议打印信息定位
 */
typedef void (^DIMFail)(int code, NSString * msg);

/**
 *  进度毁掉
 *
 *  @param curSize 已下载大小
 *  @param totalSize  总大小
 */
typedef void (^DIMProgress)(NSInteger curSize, NSInteger totalSize);
