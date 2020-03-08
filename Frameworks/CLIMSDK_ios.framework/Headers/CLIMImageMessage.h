//
//  CLIMImageMessage.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/4/25.
//  Copyright © 2019 yu.zuo. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CLIMMessage.h"


NS_ASSUME_NONNULL_BEGIN

/**
 *  图片对象
 */
@interface CLIMImage : NSObject
/**
 * 图片对象id
 * 建议使用 generateUUID 方法获取
 */
@property(nonatomic, strong) NSString * imageId;
/**
 *  图片类型
 */
@property(nonatomic, assign) CLIM_IMAGE_TYPE type;
/**
 *  图片大小
 */
@property(nonatomic, assign) NSUInteger size;
/**
 *  图片宽度
 */
@property(nonatomic, assign) int width;
/**
 *  图片高度
 */
@property(nonatomic, assign) int height;
/**
 *  下载URL
 */
@property(nonatomic, strong) NSString * url;

/**
 *  获取图片
 *  下载的数据需要由SDK缓存，通过 getLocalPath 获取文件目录
 *  每次调用 getImage 都会从服务端重新下载数据。
 *  建议通过图片的 uuid 作为 key 进行图片文件的存储。
 *  @param localPath 本地路径，如果为空则使用默认路径，请使用 getLocalPath 获取路径
 *  @param succ 成功回调，返回图片数据
 *  @param fail 失败回调，返回错误码和错误描述
 */
- (void)getImage:(nullable NSString*)localPath succ:(CLIMSuccess)succ fail:(CLIMFail)fail;

/**
 *  获取图片（有进度回调）
 *  下载的数据需要由SDK缓存，通过 getLocalPath 获取文件目录
 *  每次调用 getImage 都会从服务端重新下载数据。
 *  建议通过图片的 uuid 作为 key 进行图片文件的存储。
 *  @param localPath 本地路径，如果为空则使用默认路径，请使用 getLocalPath 获取路径
 *  @param progress 图片下载进度
 *  @param succ 成功回调，返回图片数据
 *  @param fail 失败回调，返回错误码和错误描述
 */
- (void)getImage:(nullable NSString*)localPath progress:(CLIMProgress)progress succ:(CLIMSuccess)succ fail:(CLIMFail)fail;

/**
 * 获取下载图片的本地文件路径
 * 使用 getImage 下载的文件在该位置
 * 接收的消息使用（包括漫游、其它设备同账号发送的消息）
 * @return 本地文件路径
 */
- (NSString*)getLocalPath;

@end

/**
 * 图片类型消息
 * 图片消息发送：
 *  先设置图片压缩等级，如果是原图发送则，不需要压缩处理，否则进行压缩
 *  上传到服务器之后，发送图片消息
 * 图片消息接收：
 *  收到图片消息之后，进行异步下载，根据格式进行解析加载
 */
@interface CLIMImageMessage : CLIMMessage

/**
 * 语音对象id 构造的时候已经设置完成
 */
@property(nonatomic, strong) NSString* imageId;

/**
 * 图片本地路径
 * 1.如果是发送消息:由App指定
 * 2.如果是接收消息:为空
 */
@property(nonatomic, strong, nullable) NSString* localPath;

/**
 *  所有类型图片，只读，发送的时候不用关注
 *  接收的时候这个字段会保存图片的所有规格
 *  目前最多包含三种规格：原图、大图、缩略图，每种规格保存在一个 CLIMImage 对象中
 */
@property(nonatomic, strong) NSArray<CLIMImage*>* imageList;

/**
 *  图片压缩等级，详见 CLIM_IMAGE_COMPRESS_TYPE（仅对 jpg 格式有效）
 */
@property(nonatomic, assign) CLIM_IMAGE_COMPRESS_TYPE level;

/**
 *  图片格式，详见 CLIM_IMAGE_FORMAT
 */
@property(nonatomic, assign) CLIM_IMAGE_FORMAT format;

/**
 * 额外信息：可选
 */
@property(nonatomic, copy, nullable) NSString* extra;

/**
 * 创建CLIMImage对象
 * @param type 图片类型
 */
- (CLIMImage*)createImage:(CLIM_IMAGE_TYPE)type;

/**
 * 获取下载图片的本地文件路径
 * 使用 getImage 下载的文件在该位置
 * 接收的消息使用（包括漫游、其它设备同账号发送的消息）
 * @param type 图片类型
 * @return 本地文件路径
 */
- (NSString*)getLocalPath:(CLIM_IMAGE_TYPE)type;

/**
 * 根据本地文件路径获取后缀
 * 前提：localPath
 * @return 返回文件格式，可能未知类型
 */
- (CLIM_IMAGE_FORMAT)getImageSuffix;

@end


NS_ASSUME_NONNULL_END
