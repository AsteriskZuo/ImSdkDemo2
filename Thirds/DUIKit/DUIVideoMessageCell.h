//
//  DUIVideoMessageCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/3/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 【模块名称】TUIVideoItem
 * 【功能说明】视频项目
 *  存放在 TUIVideoMessageCellData中
 *  包含视频的通用识别码、视频类型、视频大小以及视频长度。
 */
@interface DUIVideoItem : NSObject

/**
 *  视频消息内部 ID，不用设置，通过 SDK 拉取的视频实例中获取。
 */
@property (nonatomic, strong) NSString *uuid;

/**
 *  视频类型，即后缀格式，发送消息时设置。比如“mp4”。
 */
@property (nonatomic, strong) NSString *type;

/**
 *  视频体积大小，无需设置，通过 SDK 拉取的实例中获取。
 */
@property (nonatomic, assign) NSInteger length;

/**
 *  视频时长
 */
@property (nonatomic, assign) NSInteger duration;
@end

/////////////////////////////////////////////////////////////////////////////////
//
//                            TUISnapshotItem
//
/////////////////////////////////////////////////////////////////////////////////

/**
 * 【模块名称】TUISnapshotItem
 * 【功能说明】视频封面
 *  用于在消息单元中显示视频的封面。
 */
@interface DUISnapshotItem : NSObject

/**
 *  图片 ID，内部标识，可用于外部缓存key
 */
@property (nonatomic, strong) NSString *uuid;

/**
 *  封面图片 类型，即缩略图。
 */
@property (nonatomic, strong) NSString *type;

/**
 *  封面在 UI 上的大小。
 */
@property (nonatomic, assign) CGSize size;

/**
 *  封面数据大小。
 */
@property (nonatomic, assign) NSInteger length;
@end

/**
* 【模块名称】TUIVideoMessageCellData
* 【功能说明】视频消息单元数据源。
*  视频消息单元，即包含了视频的消息单元。
*  视频消息单元数据源包含了视频消息单元所需的一系列消息和数据。
*  同时，本消息单元整合调用了 IM SDK，通过 SDK 提供的接口进行视频的在线获取。
*  本类配合消息控制器实现了视频消息的播放等业务逻辑。
*  数据源帮助实现了 MVVM 架构，使数据与 UI 进一步解耦，同时使 UI 层更加细化、可定制化。
*/
@interface DUIVideoMessageCellData : DUIMessageCellData

/**
 *  缩略图图像
 */
@property (nonatomic, strong) UIImage *thumbImage;

/**
 *  视频路径
 *  用于视频在本地的存取
 */
@property (nonatomic, strong) NSString *videoPath;

/**
 *  快照路径
 *  用于快照在本地的存取。
 */
@property (nonatomic, strong) NSString *snapshotPath;

/**
 *  视频消息的视频项目
 */
@property (nonatomic, strong) DUIVideoItem *videoItem;

/**
 *  视频消息的快照项目
 */
@property (nonatomic, strong) DUISnapshotItem *snapshotItem;

/**
 *  上传进度
 */
@property (nonatomic, assign) NSUInteger uploadProgress;

/**
 *  缩略图获取进度
 */
@property (nonatomic, assign) NSUInteger thumbProgress;

/**
 *  视频获取进度
 */
@property (nonatomic, assign) NSUInteger videoProgress;

/**
 *  获取视频封面
 *  本函数整合调用了 IM SDK，通过 SDK 提供的接口在线获取封面。
 *  1、下载前会判断封面是否在本地，若不在本地，则在本地直接获取封面文件。
 *  2、当封面不在本地时，通过 IM SDK 中 TIMSnapshot 类提供的 getImage 接口在线获取。
 *  3-1、下载进度百分比则通过接口回调的 progress（代码块）参数进行更新。
 *  3-2、代码块具有 curSize 和 totalSize 两个参数，由回调函数维护 curSize，然后通过 curSize * 100 / totalSize 计算出当前进度百分比。
 *  4-1、视频消息中存放的格式为 IMVideoElem，您可以通过 IMVideoElem.snapshot 获取封面实例。
 *  4-2、通过 SDK 接口获取的图像为二进制文件，需先进行解码，转换为 CGIamge 进行解码操作后包装为 UIImage 才可使用。
 *  5、下载成功后，会生成封面 path 并存储下来。
 */
- (void)downloadThumb;

/**
 *  获取视频
 *  本函数整合调用了 IM SDK，通过 SDK 提供的接口在线获取视频。
 *  1、下载前会判断视频是否在本地，若不在本地，则在本地直接获取视频文件。
 *  2、当视频不在本地时，通过 IM SDK 中 TIMVideo 类提供的 getVideo 接口在线获取。
 *  3-1、下载进度百分比则通过接口回调的 progress（代码块）参数进行更新。
 *  3-2、代码块具有 curSize 和 totalSize 两个参数，由回调函数维护 curSize，然后通过 curSize * 100 / totalSize 计算出当前进度百分比。
 *  4、视频消息中存放的格式为 IMVideoElem，该类实例无法通过播放器直接播放，您可以通过 IMVideoElem.video 获取视频实例。
 *  5、下载成功后，会生成视频 path 并存储下来。
 */
- (void)downloadVideo;

/**
 *  判断视频是否在本地存在
 *
 *  @return YES：视频存在于本地；NO：视频在本地不存在。
 */
- (BOOL)isVideoExist;

@end

/**
* 【模块名称】TUIVideoMessageCell
* 【功能说明】视频消息单元
*  视频消息单元，提供了视频消息的缩略图提取与显示，并能够将视频长度、视频下载/上传进度展现出来。
*  同时消息单元内整合了视频消息的网络获取与本地获取（如果本地缓存中存在的话）。
*  是您能够方便的在 UI 界面展示并播放视频消息。
*/
@interface DUIVideoMessageCell : DUIMessageCell

/**
 *  视频缩略图
 *  在未播放时展示视频的缩略图，方便用户不播放视频就能了解视频大致信息。
 */
@property (nonatomic, strong) UIImageView *thumb;

/**
 *  视频时长标签
 *  在聊天视图的消息单元内展示视频时长，方便用户不播放视频就能了解视频大致信息。
 */
@property (nonatomic, strong) UILabel *duration;

/**
 *  播放图标
 *  即在 UI 中显示的“箭头图标”。
 */
@property (nonatomic, strong) UIImageView *play;

/**
 *  视频进度标签
 *  根据当前视频的下载/上传状态，展示视频下载/上传进度。
 */
@property (nonatomic, strong) UILabel *progress;
//@property (nonatomic, strong) UIActivityIndicatorView *videoIndicator;

/**
 *  视频消息单元数据源
 *  数据源存放了视频的类型、时长、大小、识别码、缩略图、进度数值等一系列视频消息所需信息。
 *  详细信息请参考 Section\Chat\CellData\TUIVideoMessageCellData.h
 */
@property DUIVideoMessageCellData *videoData;

/**
 *  填充数据
 *  根据 data 设置视频消息的数据。
 *
 *  @param data 填充数据需要的数据源
 */
- (void)fillWithData:(DUIVideoMessageCellData *)data;

@end

NS_ASSUME_NONNULL_END
