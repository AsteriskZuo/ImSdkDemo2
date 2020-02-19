//
//  DUITextMessageCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/15.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
* 【模块名称】TUITextMessageCellData
* 【功能说明】文本消息单元数据源。
*  文本消息单元，即在多数信息收发情况下最常见的消息单元。
*  文本消息单元数据源则是为文本消息单元提供一系列所需的数据与信息。
*  数据源帮助实现了 MVVM 架构，使数据与 UI 进一步解耦，同时使 UI 层更加细化、可定制化。
*/
@interface DUITextMessageCellData : DUIBubbleMessageCellData

/**
 *  消息的文本内容
 */
@property (nonatomic, strong) NSString *content;

/**
 *  文本字体
 *  文本消息显示时的 UI 字体。
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 *  文本颜色
 *  文本消息显示时的 UI 颜色。
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  可变字符串
 *  文本消息接收到 content 字符串后，需要将字符串中可能存在的字符串表情（比如[微笑]），转为图片表情。
 *  本字符串则负责存储上述过程转换后的结果。
 */
@property (nonatomic, strong) NSAttributedString *attributedString;

/**
 *  文本内容尺寸。
 *  配合原点定位文本消息。
 */
@property (nonatomic, readonly) CGSize textSize;

/**
 *  文本内容原点。
 *  配合尺寸定位文本消息。
 */
@property (nonatomic, readonly) CGPoint textOrigin;

/**
 *  文本消息颜色（发送）
 *  在消息方向为发送时使用。
 */
@property (nonatomic, strong, class) UIColor *outgoingTextColor;

/**
 *  文本消息字体（发送）
 *  在消息方向为发送时使用。
 */
@property (nonatomic, strong, class) UIFont *outgoingTextFont;

/**
 *  文本消息颜色（接收）
 *  在消息方向为接收时使用。
 */
@property (nonatomic, class) UIColor *incommingTextColor;

/**
 *  文本消息字体（接收）
 *  在消息方向为接收时使用。
 */
@property (nonatomic, class) UIFont *incommingTextFont;


@end

/**
* 【模块名称】TUITextMessageCell
* 【功能说明】文本消息单元
*  文本消息单元，即在多数信息收发情况下最常见的消息单元。
*  文本消息单元继承自气泡消息单元（TUIBubbleMessageCell），在气泡消息单元提供的气泡视图基础上填充文本信息并显示。
*/
@interface DUITextMessageCell : DUIBubbleMessageCell

/**
 *  内容标签
 *  用于展示文本消息的内容。
 */
@property (nonatomic, strong) UILabel *content;

/**
 *  文本消息单元数据源
 *  数据源内存放了文本消息的内容信息、消息字体、消息颜色、并存放了发送、接收两种状态下的不同字体颜色。
 */
@property (nonatomic, strong, readonly) DUITextMessageCellData *textData;

/**
 *  填充数据
 *  根据 data 设置文本消息的数据。
 *
 *  @param  data    填充数据需要的数据源
 */
- (void)fillWithData:(DUITextMessageCellData *)data;

@end

NS_ASSUME_NONNULL_END
