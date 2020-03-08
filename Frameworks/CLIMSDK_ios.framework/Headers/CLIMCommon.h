//
//  CLIMCommon.h
//  citylife_im_sdk
//
//  Created by gavin on 2019/3/25.
//  Copyright © 2019年 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLIMSendMessageResult;
@class CLIMOpConversationResult;
@class CLIMMessage;

#pragma mark - 常量定义

#define CLIM_MESSAGE_STRING_TYPE_NONE @"CL:None"
#define CLIM_MESSAGE_STRING_TYPE_CUSTOM @"CL:Cus"
#define CLIM_MESSAGE_STRING_TYPE_TEXT @"CL:Text"
#define CLIM_MESSAGE_STRING_TYPE_IMAGE @"CL:Image"
#define CLIM_MESSAGE_STRING_TYPE_VOICE @"CL:Voice"
#define CLIM_MESSAGE_STRING_TYPE_VIDEO @"CL:Video"
#define CLIM_MESSAGE_STRING_TYPE_LOCATION @"CL:Loc"
#define CLIM_MESSAGE_STRING_TYPE_FILE @"CL:File"
#define CLIM_MESSAGE_STRING_TYPE_ORDER_NOTIFY @"CL:OdNtf"
#define CLIM_MESSAGE_STRING_TYPE_BIT_EMOTION @"CL:BIEmotion"
#define CLIM_MESSAGE_STRING_TYPE_LIB_EMOTION @"CL:Emotion"

#define CLIM_MESSAGE_SAVE_TYPE_ON @"online"
#define CLIM_MESSAGE_SAVE_TYPE_OFF @"offline"

#define CLIM_MESSAGE_FILE_TYPE_IMAGE @"image"
#define CLIM_MESSAGE_FILE_TYPE_VOICE @"voice"
#define CLIM_MESSAGE_FILE_TYPE_FILE @"file"



#define CLIM_MESSAGE_ATTRIBUTE_TEXT_CONTENT @"text"
#define CLIM_MESSAGE_ATTRIBUTE_TEXT_EXTRA @"extra"

#define CLIM_MESSAGE_ATTRIBUTE_LOC_LATITUDE @"latitude"
#define CLIM_MESSAGE_ATTRIBUTE_LOC_LONGITUDE @"longitude"
#define CLIM_MESSAGE_ATTRIBUTE_LOC_DESCRIPTION @"description"

#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_ID @"id"
#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_PATH @"path"
#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_LEVEL @"level"
#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_FORMAT @"format"
#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_EXTRA @"extra"
#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_TYPE @"type"
#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_SIZE @"size"
#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_HEIGHT @"height"
#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_WIDTH @"width"
#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_URL @"url"
#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_ORIGIN @"org"
#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_BIG @"big"
#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_THUMB @"thumb"
#define CLIM_MESSAGE_ATTRIBUTE_IMAGE_LIST @"imagelist"

#define CLIM_MESSAGE_ATTRIBUTE_VOICE_ID @"id"
#define CLIM_MESSAGE_ATTRIBUTE_VOICE_PATH @"path"
#define CLIM_MESSAGE_ATTRIBUTE_VOICE_URL @"url"
#define CLIM_MESSAGE_ATTRIBUTE_VOICE_DATA @"data"
#define CLIM_MESSAGE_ATTRIBUTE_VOICE_LENGTH @"length"
#define CLIM_MESSAGE_ATTRIBUTE_VOICE_EXTRA @"extra"
#define CLIM_MESSAGE_ATTRIBUTE_VOICE_SUFFIX @"suffix"

#define CLIM_MESSAGE_ATTRIBUTE_VIDEO_ID @"id"
#define CLIM_MESSAGE_ATTRIBUTE_VIDEO_URL @"url"
#define CLIM_MESSAGE_ATTRIBUTE_VIDEO_COVER_URL @"cover_url"
#define CLIM_MESSAGE_ATTRIBUTE_VIDEO_LENGTH @"length"
#define CLIM_MESSAGE_ATTRIBUTE_VIDEO_EXTRA @"extra"

#define CLIM_MESSAGE_ATTRIBUTE_CUSTOM_TYPE @"type"
#define CLIM_MESSAGE_ATTRIBUTE_CUSTOM_DATA @"data"

#define CLIM_MESSAGE_ATTRIBUTE_FILE_ID @"id"
#define CLIM_MESSAGE_ATTRIBUTE_FILE_URL @"url"
#define CLIM_MESSAGE_ATTRIBUTE_FILE_SIZE @"size"
#define CLIM_MESSAGE_ATTRIBUTE_FILE_EXTRA @"extra"

#define CLIM_MESSAGE_ATTRIBUTE_BIEMOTION_ID @"id"

#define CLIM_MESSAGE_ATTRIBUTE_LIB_EMOTION_ID @"id"
#define CLIM_MESSAGE_ATTRIBUTE_LIB_EMOTION_PARENT_ID @"parent_id"
#define CLIM_MESSAGE_ATTRIBUTE_LIB_EMOTION_EXTRA @"extra"

#define CLIM_MESSAGE_ATTRIBUTE_ORDER_NOTIFY_ID @"id"
#define CLIM_MESSAGE_ATTRIBUTE_ORDER_NOTIFY_TYPE @"type"
#define CLIM_MESSAGE_ATTRIBUTE_ORDER_NOTIFY_EXTRA @"extra"


#define CLIM_MESSAGE_IMAGE_LARGE_SIZE 720
#define CLIM_MESSAGE_IMAGE_THUMB_SIZE 300




#define clim_weakify(object) autoreleasepool {} __weak typeof(object) weak##object = object
#define clim_strongify(object) autoreleasepool {} __strong typeof(weak##object) object = weak##object


#pragma mark - 枚举定义

/**
 * 枚举注释举例
 */
typedef enum : NSUInteger {
    MyEnumValueA, /**< 行尾注解. */
    MyEnumValueB, /*!< 行尾注解. */
    MyEnumValueC, //!< 行尾注解.
    MyEnumValueD, ///< 行尾注解.
} MyEnum;

/**
 * SDK级别的用户连接状态
 */
typedef  NS_ENUM(NSInteger, CLIMUserConnectStatus){
    CLIMUserConnectStatusConnecting = 1,///< 正在连接
    CLIMUserConnectStatusConnected = 2,///< 已连接
    CLIMUserConnectStatusDisconnecting = 3,///< 正在断开
    CLIMUserConnectStatusDisconnected = 4,///< 已断开
};

/**
 * 用户操作状态
 */
typedef NS_ENUM(NSInteger, CLIMUserOperationStatus) {
    CLIMUserOperationStatusLogin = 1,///< 登录操作
    CLIMUserOperationStatusLogout = 2,///< 登出操作
};


/**
 * 消息状态
 */
typedef NS_ENUM(int, CLIMMessageStatus) {
    CLIMMessageStatusInit = 0,///< 消息初始化状态 例如：草稿
    CLIMMessageStatusSending = 1,///< 消息发送中
    CLIMMessageStatusSendSuccess = 2,///< 消息发送成功
    CLIMMessageStatusSendFailed = 3,///< 消息发送失败
    CLIMMessageStatusHasDeleted = 4,///< 消息已经删除
    CLIMMessageStatusHasRevoked = 5,///< 消息已经撤消
};


/**
 * 会话类型
 */
typedef NS_ENUM(int, CLIMConversationType) {
    CLIMConversationTypeNone = 0,///< 未知类型
    CLIMConversationTypePerson = 1,///< 个人
    CLIMConversationTypeGroup = 2,///< 群组
    CLIMConversationTypeSystem = 3///< 系统
};
/**
 * 与服务器断开连接的情况
 */
typedef NS_ENUM(NSInteger,CLIMServerDisconnectCode)  {
    CLIMServerDisconnectUserLogout = 0,///< 用户退出
    CLIMServerDisconnectNetworkChanged,///< 网络改变
    CLIMServerDisconnectServerError,///< 服务器出错
    CLIMServerDisconnectUnknown///< 未知错误
};

/**
 * 网络连接状态
 */
typedef NS_ENUM(NSInteger,CLIMNetworkStatus){
    CLIMNetworkStatusWifi = 0,///< wifi上网
    CLIMNetworkStatusViaWWAN,///< 蜂窝上网
    CLIMNetworkStatusNone,///< 未知
};

/**
 *  图片压缩选项
 */
typedef NS_ENUM(NSInteger, CLIM_IMAGE_COMPRESS_TYPE){
    CLIM_IMAGE_COMPRESS_ORIGIN              = 0x00,
    CLIM_IMAGE_COMPRESS_HIGH                = 0x01,
    CLIM_IMAGE_COMPRESS_LOW                 = 0x02,
};

/**
 *  图片类型
 */
typedef NS_ENUM(NSInteger, CLIM_IMAGE_TYPE){
    CLIM_IMAGE_TYPE_ORIGIN              = 0x01,
    CLIM_IMAGE_TYPE_THUMB               = 0x02,
    CLIM_IMAGE_TYPE_LARGE               = 0x04,
};

/**
 *  图片格式
 */
typedef NS_ENUM(NSInteger, CLIM_IMAGE_FORMAT){
    CLIM_IMAGE_FORMAT_JPG            = 0x1,
    CLIM_IMAGE_FORMAT_GIF            = 0x2,
    CLIM_IMAGE_FORMAT_PNG            = 0x3,
    CLIM_IMAGE_FORMAT_BMP            = 0x4,
    CLIM_IMAGE_FORMAT_UNKNOWN        = 0xff,
};

/**
 * 订单通知类型
 */
typedef NS_ENUM(NSInteger, CLIM_ORDER_NOTIFY_TYPE) {
    CLIM_ORDER_NOTIFY_TYPE_REVERSE,///< 保留
    CLIM_ORDER_NOTIFY_TYPE_USER_PLACE_ORDER,///< 用户下单
    CLIM_ORDER_NOTIFY_TYPE_MERCHANT_ACCEPT_ORDER,///< 商户接受订单
    CLIM_ORDER_NOTIFY_TYPE_MERCHANT_REFUSE_ORDER,///< 商户拒绝订单
    CLIM_ORDER_NOTIFY_TYPE_USER_CANCEL_ORDER,///< 用户取消订单
    CLIM_ORDER_NOTIFY_TYPE_MERCHANT_CANCEL_ORDER,///< 商户取消订单
    CLIM_ORDER_NOTIFY_TYPE_REFUND_FINISH,///< 退款完成通知
    CLIM_ORDER_NOTIFY_TYPE_COMPLETE_ORDER,///< 订单完成通知
};

/**
 * 文件服务器类别
 */
typedef NS_ENUM(int, CLIMFileServerType) {
    CLIMFileServerTypeNone = 0,///< 未知类型
    CLIMFileServerTypeALiCloud = 1,///< 阿里云
    CLIMFileServerTypeTencentCloud = 2,///< 腾讯云
    CLIMFileServerTypeBaiduCloud = 3///< 百度云
};





#pragma mark - block 回调

/**
 * 操作成功回调
 */
typedef void(^CLIMSuccess)(void);

/**
 * 操作失败回调
 * @param message 失败原因字符串
 * @param code 失败原因代码
 */
typedef void(^CLIMFail)(int code, NSString *message);

/**
 *  进度回调
 *  @param curSize 已下载大小
 *  @param totalSize  总大小
 */
typedef void (^CLIMProgress)(NSInteger curSize, NSInteger totalSize);

/**
 * 登录成功回调
 */
typedef void(^CLIMLoginSuccess)(void);

/**
 * 登录失败回调
 * @param message 失败原因字符串
 * @param code 失败原因代码
 */
typedef void(^CLIMLoginFail)(int code, NSString *message);

/**
 * 发送消息成功回调
 * @param message 完整消息
 */
typedef void(^CLIMSendMessageSuccess)(CLIMSendMessageResult* message);

/**
 * 发送消息失败回调
 * @param message 失败原因字符串
 * @param code 失败原因代码
 */
typedef void(^CLIMSendMessageFail)(int code, NSString *message);

/**
 *  获取消息成功回调
 *  @param msgs 消息列表
 */
typedef void (^CLIMGetMessageSuccess)(NSArray* msgs);

/**
 *  获取消息失败回调
 * @param message 失败原因字符串
 * @param code 失败原因代码
 */
typedef void (^CLIMGetMessageFail)(int code, NSString *message);

/**
 *  获取消息成功回调
 *  @param conv 会话对象
 */
typedef void (^CLIMOpConversationSuccess)(CLIMOpConversationResult* conv);


#pragma mark - 基本类型

/**
 * 进入后台需要传递给服务器的参数
 */
@interface CLIMBackgroundParam : NSObject

/** 总未读数 */
@property(nonatomic, assign) int unreadCount;

@end

/**
 * 会话数据
 * 一般地，底层发送通知给App使用
 */
@interface CLIMConversationData : NSObject

@property(nonatomic,copy) NSString* convId;

@property(nonatomic,assign) CLIMConversationType convType;

//@property(nonatomic,copy) NSString* convName;

@property(nonatomic,assign) long long timestamp;

@property(nonatomic,assign) NSInteger unreadCount;

@property(nonatomic,strong) CLIMMessage* lastMessage;

//@property(nonatomic,assign) BOOL isTop;

@end


/**
 * common information
 */
@interface CLIMCommonInfo : NSObject
	
@property(nonatomic, strong) NSString* userId;
	
@property(nonatomic, strong) NSString* cppSdkVersion;
	
@end
