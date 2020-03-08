//
//  CLIMVoiceMessage.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/4/25.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#ifndef CLIMVoiceMessage_h
#define CLIMVoiceMessage_h

#import <Foundation/Foundation.h>
#import "CLIMMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 语音消息对象
 */
@interface CLIMVoiceMessage : CLIMMessage

/**
 * 语音对象id 构造的时候已经设置完成
 */
@property(nonatomic, strong) NSString* voiceId;

/**
 * 语音文件本地地址
 * 1.如果是发送消息：由App指定
 * 2.如果是接收消息：为空
 */
@property(nonatomic, strong, nullable) NSString* localPath;

/**
 * 语音时长（秒）
 * 建议不要超过60秒
 */
@property(nonatomic, assign) NSInteger voiceLength;

/**
 *  下载URL
 */
@property(nonatomic, strong) NSString * url;

/**
 * 额外信息：可选
 * 例如：语音对应的文字、语音格式等
 */
@property(nonatomic, copy, nullable) NSString* extra;

/**
 *  获取语音数据到指定路径的文件中
 *  getVoice 接口每次都会从服务端下载，如需缓存或者存储，开发者可根据 uuid 作为 key 进行外部存储，IM SDK 并不会存储资源文件。
 *  @param localPath 本地路径，如果为空则使用默认路径，请使用 getLocalPath 获取路径
 *  @param succ 成功回调
 *  @param fail 失败回调，返回错误码和错误描述
 */
- (void)getVoice:(nullable NSString*)localPath succ:(CLIMSuccess)succ fail:(CLIMFail)fail;

/**
 *  获取语音数据到指定路径的文件中（有进度回调）
 *  getVoice 接口每次都会从服务端下载，如需缓存或者存储，开发者可根据 uuid 作为 key 进行外部存储，IM SDK 并不会存储资源文件。
 *  @param localPath 本地路径，如果为空则使用默认路径，请使用 getLocalPath 获取路径
 *  @param progress 语音下载进度
 *  @param succ 成功回调
 *  @param fail 失败回调，返回错误码和错误描述
 */
- (void)getVoice:(nullable NSString*)localPath progress:(CLIMProgress)progress succ:(CLIMSuccess)succ fail:(CLIMFail)fail;

/**
 * 获取下载图片的本地文件路径
 * 使用 getVoice 下载的文件在该位置
 * 接收的消息使用（包括漫游、其它设备同账号发送的消息）
 * @return 本地文件路径
 */
- (NSString*)getLocalPath;

/**
 * 获取服务器地址
 * 前提：voiceId | localPath
 * @param sender 消息发送者，如果是自己可以为空
 * @return 服务器url
 */
-(NSString*)getServerUrl:(nullable NSString*)sender;

///**
// * 根据本地路径获取文件后缀
// * 前提：localPath
// * @return 文件后缀，可能为空
// */
//- (NSString*)getVoiceSuffix;

@end

NS_ASSUME_NONNULL_END



#endif /* CLIMVoiceMessage_h */
