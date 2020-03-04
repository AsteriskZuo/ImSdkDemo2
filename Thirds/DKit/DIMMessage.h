//
//  DIMMessage.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/9.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCommon.h"
#import "DIMConversation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  消息 Elem 基类
 */
@interface DIMElem : NSObject
@end


/**
 *  文本消息 Elem
 */
@interface TIMTextElem : DIMElem
/**
 *  消息文本
 */
@property(nonatomic,strong) NSString * text;
@end


/**
 *  图片
 */
@interface DIMImage : NSObject
/**
 *  图片 ID，内部标识，可用于外部缓存key
 */
@property(nonatomic,strong) NSString * uuid;
/**
 *  图片类型
 */
@property(nonatomic,assign) DIM_IMAGE_TYPE type;
/**
 *  图片大小
 */
@property(nonatomic,assign) int size;
/**
 *  图片宽度
 */
@property(nonatomic,assign) int width;
/**
 *  图片高度
 */
@property(nonatomic,assign) int height;
/**
 *  下载URL
 */
@property(nonatomic, strong) NSString * url;

/**
 *  获取图片
 *
 *  下载的数据需要由开发者缓存，IM SDK 每次调用 getImage 都会从服务端重新下载数据。建议通过图片的 uuid 作为 key 进行图片文件的存储。
 *
 *  @param path 图片保存路径
 *  @param succ 成功回调，返回图片数据
 *  @param fail 失败回调，返回错误码和错误描述
 */
- (void)getImage:(NSString*)path succ:(DIMSucc)succ fail:(DIMFail)fail;

/**
 *  获取图片（有进度回调）
 *
 *  下载的数据需要由开发者缓存，IM SDK 每次调用 getImage 都会从服务端重新下载数据。建议通过图片的 uuid 作为 key 进行图片文件的存储。
 *
 *  @param path 图片保存路径
 *  @param progress 图片下载进度
 *  @param succ 成功回调，返回图片数据
 *  @param fail 失败回调，返回错误码和错误描述
 */
- (void)getImage:(NSString*)path progress:(DIMProgress)progress succ:(DIMSucc)succ fail:(DIMFail)fail;

@end

/**
 *  图片消息Elem
 */
@interface DIMImageElem : DIMElem

/**
 *  要发送的图片路径
 */
@property(nonatomic,strong) NSString * path;

/**
 *  所有类型图片，只读，发送的时候不用关注，接收的时候这个字段会保存图片的所有规格，目前最多包含三种规格：原图、大图、缩略图，每种规格保存在一个 TIMImage 对象中
 */
@property(nonatomic,strong) NSArray * imageList;

/**
 * 上传时任务 ID，可用来查询上传进度（已废弃，请在 TIMUploadProgressListener 监听上传进度）
 */
@property(nonatomic,assign) uint32_t taskId DEPRECATED_ATTRIBUTE;

/**
 *  图片压缩等级，详见 TIM_IMAGE_COMPRESS_TYPE（仅对 jpg 格式有效）
 */
@property(nonatomic,assign) DIM_IMAGE_COMPRESS_TYPE level;

/**
 *  图片格式，详见 TIM_IMAGE_FORMAT
 */
@property(nonatomic,assign) DIM_IMAGE_FORMAT format;

@end




/**
 *  语音消息Elem
 *
 *  1. 一条消息只能有一个语音 Elem，添加多条语音 Elem 时，AddElem 函数返回错误 1，添加不生效。
 *  2. 语音和文件 Elem 不一定会按照添加时的顺序获取，建议逐个判断 Elem 类型展示，而且语音和文件 Elem 也不保证按照发送的 Elem 顺序排序。
 *
 */
@interface DIMSoundElem : DIMElem
/**
 *  上传时任务 ID，可用来查询上传进度（已废弃，请在 TIMUploadProgressListener 监听上传进度）
 */
@property(nonatomic,assign) uint32_t taskId DEPRECATED_ATTRIBUTE;
/**
 *  上传时，语音文件的路径，接收时使用 getSound 获得数据
 */
@property(nonatomic,strong) NSString * path;
/**
 *  语音消息内部 ID
 */
@property(nonatomic,strong) NSString * uuid;
/**
 *  语音数据大小
 */
@property(nonatomic,assign) int dataSize;
/**
 *  语音长度（秒），发送消息时设置
 */
@property(nonatomic,assign) int second;

/**
 *  获取语音的 URL 下载地址
 *
 *  @param urlCallBack 获取 URL 地址回调
 */
-(void)getUrl:(void (^)(NSString * url))urlCallBack;

/**
 *  获取语音数据到指定路径的文件中
 *
 *  getSound 接口每次都会从服务端下载，如需缓存或者存储，开发者可根据 uuid 作为 key 进行外部存储，ImSDK 并不会存储资源文件。
 *
 *  @param path 语音保存路径
 *  @param succ 成功回调
 *  @param fail 失败回调，返回错误码和错误描述
 */
- (void)getSound:(NSString*)path succ:(DIMSucc)succ fail:(DIMFail)fail;

/**
 *  获取语音数据到指定路径的文件中（有进度回调）
 *
 *  getSound 接口每次都会从服务端下载，如需缓存或者存储，开发者可根据 uuid 作为 key 进行外部存储，ImSDK 并不会存储资源文件。
 *
 *  @param path 语音保存路径
 *  @param progress 语音下载进度
 *  @param succ 成功回调
 *  @param fail 失败回调，返回错误码和错误描述
 */
- (void)getSound:(NSString*)path progress:(DIMProgress)progress succ:(DIMSucc)succ fail:(DIMFail)fail;

@end




/**
 *  文件消息Elem
 */
@interface DIMFileElem : DIMElem
/**
 *  上传时任务 ID，可用来查询上传进度（已废弃，请在 TIMUploadProgressListener 监听上传进度）
 */
@property(nonatomic,assign) uint32_t taskId DEPRECATED_ATTRIBUTE;
/**
 *  上传时，文件的路径（设置 path 时，优先上传文件）
 */
@property(nonatomic,strong) NSString * path;
/**
 *  文件内部 ID
 */
@property(nonatomic,strong) NSString * uuid;
/**
 *  文件大小
 */
@property(nonatomic,assign) int fileSize;
/**
 *  文件显示名，发消息时设置
 */
@property(nonatomic,strong) NSString * filename;

/**
 *  获取文件的 URL 下载地址
 *
 *  @param urlCallBack 获取 URL 地址回调
 */
-(void)getUrl:(void (^)(NSString * url))urlCallBack;

/**
 *  获取文件数据到指定路径的文件中
 *
 *  getFile 接口每次都会从服务端下载，如需缓存或者存储，开发者可根据 uuid 作为 key 进行外部存储，ImSDK 并不会存储资源文件。
 *
 *  @param path 文件保存路径
 *  @param succ 成功回调，返回数据
 *  @param fail 失败回调，返回错误码和错误描述
 */
- (void)getFile:(NSString*)path succ:(DIMSucc)succ fail:(DIMFail)fail;

/**
 *  获取文件数据到指定路径的文件中（有进度回调）
 *
 *  getFile 接口每次都会从服务端下载，如需缓存或者存储，开发者可根据 uuid 作为 key 进行外部存储，ImSDK 并不会存储资源文件。
 *
 *  @param path 文件保存路径
 *  @param progress 文件下载进度
 *  @param succ 成功回调，返回数据
 *  @param fail 失败回调，返回错误码和错误描述
 */
- (void)getFile:(NSString*)path progress:(DIMProgress)progress succ:(DIMSucc)succ fail:(DIMFail)fail;

@end





/**
 *  表情消息类型
 *
 *  1. 表情消息由 TIMFaceElem 定义，SDK 并不提供表情包，如果开发者有表情包，可使用 index 存储表情在表情包中的索引，由用户自定义，或者直接使用 data 存储表情二进制信息以及字符串 key，都由用户自定义，SDK 内部只做透传。
 *  2. index 和 data 只需要传入一个即可，ImSDK 只是透传这两个数据。
 *
 */
@interface DIMFaceElem : DIMElem

/**
 *  表情索引，用户自定义
 */
@property(nonatomic, assign) int index;
/**
 *  额外数据，用户自定义
 */
@property(nonatomic,strong) NSData * data;

@end


@interface DIMMessage : NSObject

/**
 *  1.1 增加 Elem
 *
 *  @param elem elem 结构
 *
 *  @return 0：表示成功；1：禁止添加 Elem（文件或语音多于两个 Elem）；2：未知 Elem
 */
- (int)addElem:(DIMElem*)elem;

/**
 *  1.2 获取对应索引的 Elem
 *
 *  @param index 对应索引
 *
 *  @return 返回对应 Elem
 */
- (DIMElem*)getElem:(int)index;

/**
 *  1.3 获取 Elem 数量
 *
 *  @return elem数量
 */
- (int)elemCount;

/**
 *  1.4 设置业务命令字
 *
 *  @param buzCmds 业务命令字列表
 *                 @"im_open_busi_cmd.msg_robot"：表示发送给IM机器人；
 *                 @"im_open_busi_cmd.msg_nodb"：表示不存离线；
 *                 @"im_open_busi_cmd.msg_noramble"：表示不存漫游；
 *                 @"im_open_busi_cmd.msg_nopush"：表示不实时下发给用户
 *
 *  @return 0：成功；1：buzCmds 为 nil
 */
//-(int)setBusinessCmd:(NSArray*)buzCmds;

/**
 *  1.5 消息状态
 *
 *  @return TIMMessageStatus 消息状态
 */
//- (DIMMessageStatus)status;
@property (nonatomic, assign) DIMMessageStatus status;

/**
 *  1.6 是否发送方
 *
 *  @return TRUE：表示是发送消息；FALSE：表示是接收消息
 */
//- (BOOL)isSelf;
@property (nonatomic, assign) BOOL isSelf;

/**
 *  1.7 获取消息的发送方
 *
 *  @return 发送方 identifier
 */
//- (NSString*)sender;
@property (nonatomic, strong) NSString* sender;

/**
 *  1.8 消息 ID
 *
 *  1. 当消息生成时，就已经固定，这种方式可能跟其他用户产生的消息冲突，需要再加一个时间约束，可以认为 10 分钟以内的消息可以使用 msgId 区分，需要在同一个会话内判断。
 *  2. 对于发送成功的消息或则从服务器接收到的消息，请使用 uniqueId 判断消息的全局唯一。
 *
 *  @return msgId
 *
 */
//- (NSString*)msgId;
@property (nonatomic, strong) NSString* msgId;

/**
 *  1.9 消息 uniqueId
 *
 *  对于发送成功的消息或则从服务器接收到的消息，uniqueId 能保证全局唯一，需要在同一个会话内判断。
 *
 *  @return uniqueId
 */
//- (uint64_t)uniqueId;
@property (nonatomic, assign) uint64_t uniqueId;

/**
 *  1.10 当前消息的时间戳
 *
 *  当消息还没发送成功，此时间为根据 Server 时间校准过的本地时间，发送成功后会改为准确的 Server 时间
 *
 *  @return 时间戳
 */
//- (NSDate*)timestamp;
@property (nonatomic, strong) NSDate* timestamp;

/**
 *  1.11 自己是否已读
 *
 *  注意 ChatRoom、AVChatRoom、BChatRoom 不支持未读的功能，isReaded 接口针对这些类型房间无效。
 *
 *  @return TRUE：已读；FALSE：未读
 */
//- (BOOL)isReaded;
@property (nonatomic, assign) BOOL isReaded;

/**
 *  1.12 对方是否已读（仅 C2C 消息有效）
 *
 *  @return TRUE：已读；FALSE：未读
 */
//- (BOOL)isPeerReaded;
@property (nonatomic, assign) BOOL isPeerReaded;

/**
 *  1.13 消息定位符
 *
 *  如果是自己创建的 TIMMessage，需要等到消息发送成功后才能获取到 TIMMessageLocator 里面的具体信息
 *
 *  @return locator，详情请参考 TIMComm.h 里面的 TIMMessageLocator 定义
 */
//- (TIMMessageLocator*)locator;

/**
 *  1.14 是否为 locator 对应的消息
 *
 *  @param locator 消息定位符
 *
 *  @return YES 是对应的消息
 */
//- (BOOL)respondsToLocator:(TIMMessageLocator*)locator;

/**
 *  1.15 删除消息
 *
 *  目前暂不支持 Server 消息删除，只能在本地删除，如果程序卸载重装，通过 getMessage 接口还是能拉回被删除的消息。
 *
 *  @return TRUE：成功；FALSE：失败
 */
//- (BOOL)remove;

/**
 *  1.16 获取会话
 *
 *  @return 该消息所对应会话
 */
//- (DIMConversation*)getConversation;
@property (nonatomic, weak) DIMConversation* conversation;

/**
 *  1.17 获取发送者昵称
 *
 *  @return  发送者昵称
 *
 */
//- (NSString *)getSenderNickname;


/**
 *  1.18 获取发送者资料
 *
 *  如果本地有发送者资料，会在 profileCallBack 回调里面立即同步返回发送者资料，如果本地没有发送者资料，SDK 内部会先向服务器拉取发送者资料，并在 profileCallBack 回调里面异步返回发送者资料。
 *
 *  @param  profileCallBack 发送者资料回调
 *
 */
//- (void)getSenderProfile:(ProfileCallBack)profileCallBack;

/**
 *  1.19 获取发送者群内资料
 *
 *  目前仅能获取字段：member，nameCard，其他的字段获取建议通过 TIMGroupManager.h -> getGroupMembersInfo 获取
 *
 *  @return 发送者群内资料，nil 表示没有获取到资料或者不是群消息
 */
//- (TIMGroupMemberInfo*)getSenderGroupMemberProfile;

/**
 *  1.20 设置消息的优先级（仅对群组消息有效）
 *
 *  对于直播场景，会有点赞和发红包功能，点赞相对优先级较低，红包消息优先级较高，具体消息内容可以使用 TIMCustomElem 进行定义，发送消息时，可设置消息优先级。
 *
 *  @param priority 优先级
 *
 *  @return TRUE 设置成功
 */
//- (BOOL)setPriority:(TIMMessagePriority)priority;

/**
 *  1.21 获取消息的优先级（仅对群组消息有效）
 *
 *  @return 优先级
 */
//- (TIMMessagePriority)getPriority;

/**
 *  1.22 设置消息离线推送配置
 *
 *  @param info 配置信息
 *
 *  @return 0 成功
 */
//- (int)setOfflinePushInfo:(TIMOfflinePushInfo*)info;

/**
 *  1.23 获取消息离线推送配置
 *
 *  @return 配置信息，没设置返回 nil
 */
//- (TIMOfflinePushInfo*)getOfflinePushInfo;

/**
 *  1.24 设置自定义整数，默认为 0
 *
 *  1.此自定义字段仅存储于本地，不会同步到 Server，用户卸载应用或则更换终端后无法获取。
 *  2.可以根据这个字段设置语音消息是否已经播放，如 customInt 的值 0 表示未播放，1 表示播放，当用户单击播放后可设置 customInt 的值为 1。
 *
 *  @param param 设置参数
 *
 *  @return TRUE：设置成功；FALSE:设置失败
 */
- (BOOL)setCustomInt:(int32_t)param;

/**
 *  1.25 获取 CustomInt
 *
 *  @return CustomInt
 */
- (int32_t)customInt;

/**
 *  1.26 设置自定义数据，默认为""
 *
 *  此自定义字段仅存储于本地，不会同步到 Server，用户卸载应用或则更换终端后无法获取。
 *
 *  @param data 设置参数
 *
 *  @return TRUE：设置成功；FALSE:设置失败
 */
//- (BOOL)setCustomData:(NSData*)data;

/**
 *  1.27 获取 CustomData
 *
 *  @return CustomData
 */
//- (NSData*)customData;

/**
 *  1.28 拷贝消息中的属性（ELem、priority、online、offlinePushInfo）
 *
 *  @param srcMsg 源消息
 *
 *  @return 0 成功
 */
//- (int)copyFrom:(TIMMessage*)srcMsg;

/**
 *  1.29 将消息导入到本地
 *
 *  只有调用这个接口，才能去修改消息的时间戳和发送方
 *
 *  @return 0：成功；1：失败
 */
//- (int)convertToImportedMsg;

/**
 *  1.30 设置消息时间戳
 *
 *  需要先将消息到导入到本地，调用 convertToImportedMsg 方法
 *
 *  @param time 时间戳
 *
 *  @return 0：成功；1：失败
 */
//- (int)setTime:(time_t)time;

/**
 *  1.31 设置消息发送方
 *
 *  需要先将消息到导入到本地，调用 convertToImportedMsg 方法
 *
 *  @param sender 发送方 identifier
 *
 *  @return 0：成功；1：失败
 */
//- (int)setSender:(NSString*)sender;

@end

NS_ASSUME_NONNULL_END
