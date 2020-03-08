//
//  DUIMessageCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/7.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DUICommonCell.h"

NS_ASSUME_NONNULL_BEGIN

@class CLIMMessage;
@class DUIMessageCellLayout;

typedef void (^DDownloadProgress)(NSInteger curSize, NSInteger totalSize);
typedef void (^DDownloadResponse)(int code, NSString *desc, NSString *path);

/**
 *  消息状态枚举
 */
typedef NS_ENUM(NSUInteger, DMsgStatus) {
    Msg_Status_Init, //消息创建
    Msg_Status_Sending, //消息发送中
    Msg_Status_Sending_2, //消息发送中_2，推荐使用
    Msg_Status_Succ, //消息发送成功
    Msg_Status_Fail, //消息发送失败
};

/**
 *  消息方向枚举
 *  消息方向影响气泡图标、气泡位置等 UI 风格。
 */
typedef NS_ENUM(NSUInteger, DMsgDirection) {
    MsgDirectionIncoming, //消息接收
    MsgDirectionOutgoing, //消息发送
};

/**
* 【模块名称】TUIMessageCellData
* 【功能说明】聊天消息单元数据源，配合消息控制器实现消息收发的业务逻辑。
*  用于存储消息管理与逻辑实现所需要的各类数据与信息。包括消息状态、消息发送者 ID 与头像等一系列数据。
*  同时信息数据单元整合并调用了 IM SDK，能够通过 SDK 提供的接口实现消息的业务逻辑。
*  数据源帮助实现了 MVVM 架构，使数据与 UI 进一步解耦，同时使 UI 层更加细化、可定制化。
*/
@interface DUIMessageCellData : DUICommonCellData

/**
 *  信息发送者 ID
 */
@property (nonatomic, strong) NSString *identifier;

/**
 *  信息发送者头像 url
 */
@property (nonatomic, strong) NSURL *avatarUrl;

/**
 *  信息发送者头像图像
 */
@property (nonatomic, strong) UIImage *avatarImage;

/**
 *  信息发送者昵称
 *  昵称与 ID 不一定相同，在聊天界面默认展示昵称。
 */
@property (nonatomic, strong) NSString *name;

/**
 *  名称展示 flag
 *  好友聊天时，默认不在消息中展示昵称。
 *  群组聊天时，对于群组内其他用户发送的信息，展示昵称。
 *  YES：展示昵称；NO：不展示昵称。
 */
@property (nonatomic, assign) BOOL showName;

/**
 *  消息方向
 *  消息方向影响气泡图标、气泡位置等 UI 风格。
 *  MsgDirectionIncoming 消息接收
 *  MsgDirectionOutgoing 消息发送
 */
@property (nonatomic, assign) DMsgDirection direction;

/**
 *  消息状态
 *  Msg_Status_Init 消息创建
 *  Msg_Status_Sending 消息发送中
 *  Msg_Status_Sending_2 消息发送中_2，推荐使用
 *  Msg_Status_Succ 消息发送成功
 *  Msg_Status_Fail 消息发送失败
 */
@property (nonatomic, assign) DMsgStatus status;

/**
 *  内层消息
 *  IM SDK 提供的消息对象。内含各种获取消息信息的成员函数，包括获取优先级、获取元素索引、获取离线消息配置信息等。
 *  详细信息请参考 TXIMSDK_iOS\Frameworks\ImSDK.framework\Headers\TIMMessage.h
 */
@property (nonatomic, strong) CLIMMessage *innerMessage;

/**
 *  昵称字体
 *  当需要显示昵称时，从该变量设置/获取昵称字体。
 */
@property UIFont *nameFont;

/**
 *  昵称颜色
 *  当需要显示昵称时，从该变量设置/获取昵称颜色。
 */
@property UIColor *nameColor;

/**
 *  发送时昵称颜色
 *  当需要显示昵称，且消息 direction 为 MsgDirectionOutgoing 时使用。
 */
@property (nonatomic, class) UIColor *outgoingNameColor;

/**
 *  发送时昵称字体
 *  当需要显示昵称，且消息 direction 为 MsgDirectionOutgoing 时使用。
 */
@property (nonatomic, class) UIFont *outgoingNameFont;

/**
 *  接收时昵称颜色
 *  当需要显示昵称，且消息 direction 为 MsgDirectionIncoming 时使用
 */
@property (nonatomic, class) UIColor *incommingNameColor;

/**
 *  接收时昵称字体
 *  当需要显示昵称，且消息 direction 为 MsgDirectionIncoming 时使用
 */
@property (nonatomic, class) UIFont *incommingNameFont;

/**
 *  消息单元布局
 *  包括消息边距、气泡内边距、头像边距、头像大小等 UI 布局。
 *  详细信息请参考 Section\Chat\CellLayout\TUIMessageCellLayout.h
 */
@property DUIMessageCellLayout *cellLayout;

/**
* 是否显示已读回执
*/
@property (nonatomic, assign) BOOL showReadReceipt;
/**
 *  内容大小
 *  返回一个气泡内容的视图大小。
 */
- (CGSize)contentSize;

/**
 *  根据消息方向（收/发）初始化消息单元
 *  除了基本消息的初始化外，还包括根据方向设置方向变量、昵称字体等。
 *  同时为子类提供可继承的行为。
 *
 *  @param direction 消息方向。MsgDirectionIncoming：消息接收；MsgDirectionOutgoing：消息发送。
 */
- (instancetype)initWithDirection:(DMsgDirection)direction;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                              TMessageCellDelegate
//
/////////////////////////////////////////////////////////////////////////////////


@class DUIMessageCell;
@protocol DUIMessageCellDelegate <NSObject>

/**
 *  长按消息回调
 *  您可以通过该回调实现：在被长按的消息上方弹出删除、撤回（消息发送者长按自己消息时）等二级操作。
 *
 *  @param cell 委托者，消息单元
 */
- (void)onLongPressMessage:(DUIMessageCell *)cell;

/**
 *  重发消息点击回调。
 *  在您点击重发图像（retryView）时执行的回调。
 *  您可以通过该回调实现：对相应的消息单元对应的消息进行重发。
 *
 *  @param cell 委托者，消息单元
 */
- (void)onRetryMessage:(DUIMessageCell *)cell;

/**
 *  点击消息回调
 *  通常情况下：点击声音消息 - 播放；点击文件消息 - 打开文件；点击图片消息 - 展示大图；点击视频消息 - 播放视频。
 *  通常情况仅对函数实现提供参考作用，您可以根据需求个性化实现该委托函数。
 *
 *  @param cell 委托者，消息单元
 */
- (void)onSelectMessage:(DUIMessageCell *)cell;

/**
 *  点击消息单元中消息头像的回调
 *  您可以通过该回调实现：响应用户点击，跳转到相应用户的详细信息界面。
 *
 *  @param cell 委托者，消息单元
 */
- (void)onSelectMessageAvatar:(DUIMessageCell *)cell;
@end


/////////////////////////////////////////////////////////////////////////////////
//
//                              TUIMessageCell
//
/////////////////////////////////////////////////////////////////////////////////

/**
 * 【模块名称】TUIMessageCell
 * 【功能说明】用于实现聊天窗口中的消息单元。
 *  消息单元类存储了消息相关的各类信息，比如：发送者头像、发送者昵称、消息内容（支持文本、图片、视频等各种格式）等。
 *  消息单元能够相应用户的多种交互动作。
 *  同时，消息单元作为多种细化消息的父类，提供了各类消息单元属性与行为的基本模板。
 */
@interface DUIMessageCell : DUICommonCell

/**
 *  头像视图
 */
@property (nonatomic, strong) UIImageView *avatarView;

/**
 *  昵称标签
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 *  容器视图。
 *  包裹了 MesageCell 的各类视图，作为 MessageCell 的“底”，方便进行视图管理与布局。
 */
@property (nonatomic, strong) UIView *container;

/**
 *  活动指示器。
 *  在消息发送中提供转圈图标，表明消息正在发送。
 */
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

/**
 *  重发视图。
 *  在发送失败后显示，点击该视图可以触发 onRetryMessage: 回调。
 */
@property (nonatomic, strong) UIImageView *retryView;

/**
 * 已读回执标签
 * 发送的消息显示 （同步发送的消息显示）
 */
@property (nonatomic, strong) UILabel *readReceiptLabel;

/**
 *  信息数据类。
 *  存储了该massageCell中所需的信息。包括发送者 ID，发送者头像、信息发送状态、信息气泡图标等。
 *  messageData 详细信息请参考：Section\Chat\CellData\TUIMessageCellData.h
 */
@property (nonatomic, readonly) DUIMessageCellData *messageData;

/**
 *  协议委托
 *  负责实现 TMessageCellDelegate 协议中的功能。
 */
@property (nonatomic, weak) id<DUIMessageCellDelegate> delegate;

/**
 *  单元填充函数
 *  根据data填充消息单元
 *
 *  @param  data 填充数据源
 */
- (void)fillWithData:(DUIMessageCellData *)data;

@end






/**
 * 【模块名称】TUIBubbleMessageCellData
 * 【功能说明】气泡消息单元数据源。
 *  气泡消息，即最常见的包含字符串与小表情的字符，大多数情况下将会是您最常见的消息单元类型。
 *  而气泡消息单元数据源（一下简称数据源），则是负责存储气泡消息单元所需的各种信息。
 *  数据源实现了一系列业务逻辑，使得数据源能够根据消息收发下的不同情况，向数据源提供正确的信息。
 *  数据源帮助实现了 MVVM 架构，使数据与 UI 进一步解耦，同时使 UI 层更加细化、可定制化。
 *  TUIFileMessageCellData 和 TUIVoiceMessageCellData 均继承于本类，实现了气泡消息的 UI 视觉。
 */
@interface DUIBubbleMessageCellData : DUIMessageCellData

/**
 *  气泡顶部 以便确定气泡位置
 *  该数值用于确定气泡位置，方便气泡内的内容进行 UI 布局。
 *  若该数值出现异常或者随意设置，会出现消息位置错位等 UI 错误。
 */
@property (nonatomic, assign, readwrite) CGFloat bubbleTop;

/**
 *  气泡图标（正常）
 *  气泡图标会根据消息是发送还是接受作出改变，数据源中已实现相关业务逻辑。您也可以根据需求进行个性化定制。
 */
@property (nonatomic, strong, readwrite) UIImage *bubble;

/**
 *  气泡图标（高亮）
 *  气泡图标会根据消息是发送还是接受作出改变，数据源中已实现相关业务逻辑。您也可以根据需求进行个性化定制。
 */
@property (nonatomic, strong, readwrite) UIImage *highlightedBubble;


/**
 *  发送气泡图标（正常）
 *  气泡的发送图标，当气泡消息单元为发送时赋值给 bubble。
 */
@property (nonatomic, strong, readwrite, class) UIImage *outgoingBubble;

/**
 *  发送气泡图标（高亮）
 *  气泡的发送图标（高亮），当气泡消息单元为发送时赋值给 highlightedBubble。
 */
@property (nonatomic, strong, readwrite, class) UIImage *outgoingHighlightedBubble;

/**
 *  接收气泡图标（正常）
 *  气泡的接收图标，当气泡消息单元为接收时赋值给 bubble。
 */
@property (nonatomic, strong, readwrite, class) UIImage *incommingBubble;

/**
 *  接收气泡图标（高亮）
 *  气泡的接收图标，当气泡消息单元为接收时赋值给 highlightedBubble。
 */
@property (nonatomic, strong, readwrite, class) UIImage *incommingHighlightedBubble;

/**
 *  发送气泡顶部
 *  用于定位发送气泡的顶部，当气泡消息单元为发送时赋值给 bubbleTop。
 */
@property (nonatomic, assign, readwrite, class) CGFloat outgoingBubbleTop;

/**
 *  接收气泡顶部
 *  用于定位接收气泡的顶部，当气泡消息单元为接收时赋值给 bubbleTop。
 */
@property (nonatomic, assign, readwrite, class) CGFloat incommingBubbleTop;

@end


/** 腾讯云 TUIKit
 * 【模块名称】TUIBubbleMessageCell
 * 【功能说明】气泡消息视图。
 *  气泡消息，即最常见的包含字符串与小表情的字符，大多数情况下将会是您最常见的消息单元类型。
 *  气泡消息负责包裹文本和小表情（如[微笑]），并将其以消息单元的形式展现出来。
 */
@interface DUIBubbleMessageCell : DUIMessageCell

/**
 *  气泡图像视图，即消息的气泡图标，在 UI 上作为气泡的背景板包裹消息信息内容。
 */
@property (nonatomic, strong, readwrite) UIImageView *bubbleView;

/**
 *  气泡单元数据源
 *  气泡单元数据源中存放了气泡的各类图标，比如接收图标（正常与高亮）、发送图标（正常与高亮）。
 *  并能根据具体的发送、接收状态选择相应的图标进行显示。
 */
@property (nonatomic, strong, readonly) DUIBubbleMessageCellData *bubbleData;

/**
 *  填充数据
 *  根据 data 设置气泡消息的数据。
 *
 *  @param data 填充数据需要的数据源
 */
- (void)fillWithData:(DUIBubbleMessageCellData *)data;
@end


NS_ASSUME_NONNULL_END
