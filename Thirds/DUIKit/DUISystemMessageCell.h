//
//  DUISystemMessageCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/3/7.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
* 【模块名称】TUISystemMessageCellData
* 【功能说明】系统消息单元数据源。
*  存放系统消息所需要的信息与数据。
*  数据源帮助实现了 MVVM 架构，使数据与 UI 进一步解耦，同时使 UI 层更加细化、可定制化。
*/
@interface DUISystemMessageCellData : DUIMessageCellData

/**
 *  系统消息内容，例如“您撤回了一条消息。”
 */
@property (nonatomic, strong) NSString *content;

/**
 *  内容字体
 *  系统消息显示时的 UI 字体。
 */
@property (nonatomic, strong) UIFont *contentFont;

/**
 *  内容颜色
 *  系统消息显示时的 UI 颜色。
 */
@property (nonatomic, strong) UIColor *contentColor;

@end

/**
* 【模块名称】TUISystemMessageCell
* 【功能说明】系统消息单元
*  用于实现系统消息的 UI 展示。常见的系统消息内容有：撤回消息、群成员变更消息、群成立与解散消息等。
*  系统消息通常用于展示来自于 App 的通知，这类通知由系统发送，而不来自于任何用户。
*/
@interface DUISystemMessageCell : DUIMessageCell

/**
 *  系统消息标签
 *  用于展示系统消息的内容。例如：“您撤回了一条消息”。
 */
@property (nonatomic, strong, readonly) UILabel *messageLabel;

/**
 *  系统消息单元数据源
 *  消息源中存放了系统消息的内容、消息字体以及消息颜色。
 *  详细信息请参考 Section\Chat\CellData\TUISystemMessageCellData.h
 */
@property (nonatomic, strong, readonly) DUISystemMessageCellData *systemData;

/**
 *  填充数据
 *  根据 data 设置系统消息的数据
 *
 *  @param data 填充数据需要的数据源
 */
- (void)fillWithData:(DUISystemMessageCellData *)data;

@end

NS_ASSUME_NONNULL_END
