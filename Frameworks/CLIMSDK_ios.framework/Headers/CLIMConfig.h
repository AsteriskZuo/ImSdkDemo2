//
//  CLIMSDKInitInfo.h
//  citylife_im_sdk
//
//  Created by yu.zuo on 2019/3/22.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLIMListener.h"


NS_ASSUME_NONNULL_BEGIN

NS_CLASS_DEPRECATED(10.0,10.0, 2.0,2.0, "CLIMConfig is deprecated on SDK version 1.0.1. Use CLIMGlobalConfig instead.")
@interface CLIMConfig : NSObject

/** appkey */
@property(nonatomic,copy)NSString* appkey;
/** 用户token */
@property(nonatomic,copy)NSString* token;
/** 设备Id */
@property(nonatomic,readonly)NSString* deviceid;
/** bundle_id */
@property(nonatomic,readonly)NSString* packagename;
/** 系统类型 iO 或 Android */
@property(nonatomic,readonly)NSString* platform;
/** 系统版本 */
@property(nonatomic,readonly)NSString* osNameVersion;
/** sdk版本 */
@property(nonatomic,readonly)NSString* sdkversion;
/** 网络状态 */
@property(nonatomic,readonly)NSString *network;
/** 运营商 */
@property(nonatomic,readonly)NSString *networkSp;
/** navi域名 */
@property(nonatomic,copy)NSString *naviDomain;
/** navi域名:是否启用SSL */
@property(nonatomic,assign)BOOL naviDomainEnableSSL;
/** push token */
@property(nonatomic,copy)NSString* pushtoken;

@end


@class CLIMStorageConfig;
/**
 * 全局配置信息
 */
@interface CLIMGlobalConfig : NSObject

/** app唯一标识 */
@property(nonatomic,copy)NSString* appKey;
/** 设备Id */
@property(nonatomic,readonly)NSString* deviceId;
/** bundle_id */
@property(nonatomic,readonly)NSString* packageName;
/** 系统类型 iO 或 Android */
@property(nonatomic,readonly)NSString* platformType;
/** 系统版本 */
@property(nonatomic,readonly)NSString* osNameVersion;
/** 网络状态 */
@property(nonatomic,readonly)NSString *networkState;
/** 运营商 */
@property(nonatomic,readonly)NSString *operators;
/** 获取IM服务器的url */
@property(nonatomic,copy)NSString *naviDomain;
/** navi域名:是否启用SSL */
@property(nonatomic,assign)BOOL naviDomainEnableSSL;
/** SDK根目录 */
@property(nonatomic,copy)NSString *rootDir;
/** CPP SDK 版本 */
@property(nonatomic,copy)NSString *cppSdkVersion;


/** 消息监听对象 */
@property(nonatomic,weak) id<CLIMMessageListener> recvMsgListener;
/** 断开连接监听对象 */
@property(nonatomic,weak) id<CLIMDisConnectListener> disconnectListener;
/** 会话列表监听对象 */
@property(nonatomic,weak) id<CLIMConversationListener> convListListener;

/** 上传文件进度监听对象 */
@property(nonatomic,weak) id<CLIMUploadFileProgressListener> uploadFileProgressListener;

@end


/**
 * 移动端消息推送配置信息
 */
@interface CLIMAPNSConfig : NSObject

///是否开启推送：YES开启推送 NO关闭推送
@property(nonatomic,assign) BOOL isOpenPush;

@end

/**
 * 离线消息推送参数
 */
@interface CLIMTokenParam : NSObject

/** 推送token */
@property(nonatomic,strong) NSString* pushToken;

@end


/**
 * 日志相关设置信息
 */
@interface CLIMLogConfig : NSObject

/**
 * 输出等级
 * 不设置采用默认值 warn
 * 0.trace 1.debug 2.info 3.warn 4.err 5.critical 6.off
 */
@property(nonatomic,assign) int level;

/** 输出标记 不设置采用默认值 */
@property(nonatomic,copy) NSString* tag;

/** SDK日志输出监听对象 */
@property(nonatomic,weak) id<CLIMLogListener> listener;

@end


/**
 * 用户登录相关配置信息
 */
@interface CLIMLoginParam : NSObject

/** 用户登录凭证 */
@property(nonatomic,copy)NSString* imToken;

@end

/**
 * 文件服务器配置信息
 */
@interface CLIMFileServerConfig : NSObject

/**
 * 服务器类别
 */
@property(nonatomic, assign) CLIMFileServerType type;

/**
 * 详细信息
 */
@property(nonatomic, strong) NSDictionary* params;


@end


NS_ASSUME_NONNULL_END
