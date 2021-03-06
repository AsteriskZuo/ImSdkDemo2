//
//  DUIImageMessageCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/3/1.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  图像类别枚举
 */
typedef NS_ENUM(NSInteger, DUIImageType)
{
    TImage_Type_Thumb, //缩略图
    TImage_Type_Large, //大图
    TImage_Type_Origin, //原图
};

/**
 *  TUIIamgeItem
 *  TUI 图像项目，包含图像的各种信息。
 */
@interface DUIImageItem : NSObject

/**
 *  图片 ID，内部标识，可用于外部缓存key
 */
@property (nonatomic, strong) NSString *uuid;

/**
 *  图像 url
 */
@property (nonatomic, strong) NSString *url;

/**
 *  图像大小（在UI上的显示大小）
 */
@property (nonatomic, assign) CGSize size;

/**
 *  图像类别
 *  TImage_Type_Thumb：缩略图
 *  TImage_Type_Large：大图
 *  TImage_Type_Origin：原图
 */
@property (nonatomic, assign) DUIImageType type;

@end

/**
* 【模块名称】TUIImageMessageCellData
* 【功能说明】用于实现聊天窗口中的图片气泡，包括图片消息发送进度的展示也在其中。
*  同时，该模块已经支持“缩略图”、“大图”和“原图”三种不同的类型，并已经处理好了在合适的情况下展示相应图片类型的业务逻辑：
*  1. 缩略图 - 默认在聊天窗口中看到的是缩略图，体积较小省流量
*  2. 大图 - 如果用户点开之后，看到的是分辨率更好的大图
*  3. 原图 - 如果发送方选择发送原图，那么接收者会看到“原图”按钮，点击下载到原尺寸的图片
*  数据源帮助实现了 MVVM 架构，使数据与 UI 进一步解耦，同时使 UI 层更加细化、可定制化。
*/
@interface DUIImageMessageCellData : DUIMessageCellData

/**
 *  图像缩略图
 */
@property (nonatomic, strong) UIImage *thumbImage;

/**
 *  图像原图
 */
@property (nonatomic, strong) UIImage *originImage;

/**
 *  图像大图
 */
@property (nonatomic, strong) UIImage *largeImage;

/**
 *  图像路径
 *
 *  @note path 由程序默认维护，您可以通过引入 THeader.h 并引用 TUIKit_Image_Path 来直接获取Demo存储路径
 *  @note 如果您有进一步的个性化需求，也可使用其他路径
 */
@property (nonatomic, strong) NSString *path;

/**
 *  图像长度（大小）
 */
@property (nonatomic, assign) NSInteger length;

/**
 *  图像项目集
 *
 *  @note items中通常存放三个imageItem，分别为 thumb（缩略图）、origin（原图）、large（大图），方便根据根据需求灵活获取图像
 *
 */
@property (nonatomic, strong) NSMutableArray *items;

/**
 *  缩略图加载进度
 */
@property (nonatomic, assign) NSUInteger thumbProgress;

/**
 *  原图加载进度
 */
@property (nonatomic, assign) NSUInteger originProgress;

/**
 *  大图加载进度
 */
@property (nonatomic, assign) NSUInteger largeProgress;

/**
 *  上传（发送）进度
 */
@property (nonatomic, assign) NSUInteger uploadProgress;

/**
 *  获取图像
 *  本函数整合调用了 IM SDK，通过 SDK 提供的接口在线获取图像。
 *  1、下载前会判断图像是否在本地，若不在本地，则在本地直接获取图像。
 *  2、当图像不在本地时，通过 IM SDK 中 TIMImage 提供的 getImage 接口在线获取。
 *  3-1、下载进度百分比则通过接口回调的 progress（代码块）参数进行更新。
 *  3-2、代码块具有 curSize 和 totalSize 两个参数，由回调函数维护 curSize，然后通过 curSize * 100 / totalSize 计算出当前进度百分比。
 *  4-1、图像消息中存放的格式为 DIMElem，图片列表需通过 DIMElem.imageList 获取，在 imalgelist 中，包含了原图、大图与缩略图，可通过 imageType 进一步获取。
 *  4-2、通过 SDK 接口获取的图像为二进制文件，需先进行解码，转换为 CGIamge 进行解码操作后包装为 UIImage 才可使用。
 *  5、下载成功后，会生成图像 path 并存储下来。
 */
- (void)downloadImage:(DUIImageType)type;

/**
 *  解码图像，并将图像赋值到对应类型的变量（缩略图、大图或者原图）中。
 *
 *  @param type 图像类型
 */
- (void)decodeImage:(DUIImageType)type;


/**
 *  获取图像路径
 *  同时传入 isExist 指针，能够同时改变 isExist 标识。成功获取图像 path 后，isExist 赋值为 YES，否则赋值为 NO。
 *
 *  @param type 图像类型
 *  @param isExist 是否在本地存在
 *
 *  @return 返回路径的字符串形式。
 */
- (NSString *)getImagePath:(DUIImageType)type isExist:(BOOL *)isExist;

@end


/**
* 【模块名称】TUIImageMessageCell
* 【功能说明】用于实现聊天窗口中的图片气泡，包括图片消息发送进度的展示也在其中。
*  同时，该模块已经支持“缩略图”、“大图”和“原图”三种不同的类型，并已经处理好了在合适的情况下展示相应图片类型的业务逻辑：
*  1. 缩略图 - 默认在聊天窗口中看到的是缩略图，体积较小省流量
*  2. 大图 - 如果用户点开之后，看到的是分辨率更好的大图
*  3. 原图 - 如果发送方选择发送原图，那么接收者会看到“原图”按钮，点击下载到原尺寸的图片
*  其中，三类不同清晰度的视图存储在属性 imageData 中。详细信息请参考 Section\Chat\CellData\TUIIamgeMessageCellData.h
*/
@interface DUIImageMessageCell : DUIMessageCell

/**
 *  缩略图
 *  用于在消息单元内展示的小图，默认优先展示缩略图，省流量。
 */
@property (nonatomic, strong) UIImageView *thumb;

/**
 *  下载进度标签
 *  图像的下载进度标签，用于向用户展示当前图片的获取进度，优化交互体验。
 */
@property (nonatomic, strong) UILabel *progress;

/**
 *  图像消息单元消息源
 *  imageData 中存放了图像路径，图像原图、大图、缩略图，以及三种图像对应的下载进度、上传进度等各种图像消息单元所需信息。
 *  详细信息请参考 Section\Chat\CellData\TUIIamgeMessageCellData.h
 */
@property (nonatomic, strong) DUIImageMessageCellData *imageData;

/**
 *  填充数据
 *  根据 data 设置图像消息的数据。
 *
 *  @param data 填充数据需要的数据源
 */
- (void)fillWithData:(DUIImageMessageCellData *)data;

@end

NS_ASSUME_NONNULL_END
