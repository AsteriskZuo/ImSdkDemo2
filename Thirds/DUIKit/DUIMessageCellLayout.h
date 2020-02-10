//
//  DUIMessageCellLayout.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/7.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
*  本文件声明了5个类，分别为
*  1、DUIMessageCellLayout
*  2、TIncomingCellLayout
*  3、TOutgoingCellLayout
*  4、TIncomingVoiceCellLayout
*  5、TOutgoingVoiceCellLayout
*  其中，类2、3继承自类1。类4继承自类2。类5继承自类3。
*  本文件通过此种继承关系，达到分层细化消息单元布局的效果。
*  您可以通过本布局，修改全体消息的头像大小与位置，调整消息/昵称的字体和颜色以及气泡内边距等布局特征。
*  您可以通过修改本类的子类，达到修改某一特定消息布局的效果。
*  当您想对自定义消息添加布局时，也可声明一个继承自本布局的子类，并对子类进行修改，以针对自定义消息进行特殊 UI 布局。
*/






/**
 * 【模块名称】DUIMessageCellLayout
 * 【功能说明】消息单元布局
 *  用于实现个类消息单元（文本、语音、视频、图像、表情等）的 UI 布局。
 *  布局可以使得 UI 风格统一，且易于管理与修改。
 *  当您想对 TUIKit 中的界面布局作出调整时，您可以对此布局中的对应属性进行修改。
 */
@interface DUIMessageCellLayout : NSObject
/**
 * 消息边距
 */
@property UIEdgeInsets messageInsets;
/**
 * 气泡内部内容边距
 */
@property UIEdgeInsets bubbleInsets;
/**
 * 头像边距
 */
@property UIEdgeInsets avatarInsets;
/**
 * 头像大小
 */
@property CGSize avatarSize;

/**
 *  获取接收消息布局
 */
+ (DUIMessageCellLayout *)incommingMessageLayout;

/**
 *  设置接收消息布局
 */
+ (void)setIncommingMessageLayout:(DUIMessageCellLayout *)incommingMessageLayout;

/**
 *  获取发送消息布局
 */
+ (DUIMessageCellLayout *)outgoingMessageLayout;

/**
 *  设置发送消息布局
 */
+ (void)setOutgoingMessageLayout:(DUIMessageCellLayout *)outgoingMessageLayout;

/**
 *  获取系统消息布局
 */
+ (DUIMessageCellLayout *)systemMessageLayout;

/**
 *  设置系统消息布局
 */
+ (void)setSystemMessageLayout:(DUIMessageCellLayout *)systemMessageLayout;

/**
 *  获取文本消息（接收）布局
 */
+ (DUIMessageCellLayout *)incommingTextMessageLayout;

/**
 *  设置文本消息（接收）布局
 */
+ (void)setIncommingTextMessageLayout:(DUIMessageCellLayout *)incommingTextMessageLayout;

/**
 *  获取文本消息（发送）布局
 */
+ (DUIMessageCellLayout *)outgoingTextMessageLayout;

/**
 *  设置文本消息（发送）布局
 */
+ (void)setOutgoingTextMessageLayout:(DUIMessageCellLayout *)outgoingTextMessageLayout;
@end


/////////////////////////////////////////////////////////////////////////////////
//
//                            TUIMessageCell 的细化布局
//
/////////////////////////////////////////////////////////////////////////////////
/**
 * 【模块名称】TIncomingCellLayout
 * 【功能说明】接收单元布局
 *  用于接收消息时，消息单元的默认布局。
 */
@interface DIncommingCellLayout : DUIMessageCellLayout

@end

/**
 * 【模块名称】TOutgoingCellLayout
 * 【功能说明】发送单元布局
 *  用于发送消息时，消息单元的默认布局。
 */
@interface DOutgoingCellLayout : DUIMessageCellLayout

@end


/**
 * 【模块名称】TIncomingVoiceCellLayout
 * 【功能说明】语音接收单元布局
 *  用于接收语音消息时，消息单元的默认布局。
 */
@interface DIncommingVoiceCellLayout : DIncommingCellLayout

@end

/**
 * 【模块名称】TOutgoingVoiceCellLayout
 * 【功能说明】语音发送单元布局
 *  用于发送语音消息时，消息单元的默认布局。
 */
@interface DOutgoingVoiceCellLayout : DOutgoingCellLayout

@end












/** 腾讯云TUIKit
 * 【模块名称】TUISystemTextCellLayout
 * 【功能说明】系统消息单元布局
 *  用于实现文本消息单元，在接收状态时的布局管理。
 *  本布局继承 TUIMessagCellLayout，当您想自定义布局时，可以从本布局进行修改并使用本布局，无需从父类直接修改。
 */
@interface DUISystemMessageCellLayout : DUIMessageCellLayout

@end

/** 腾讯云TUIKit
 * 【模块名称】TUIOutgoingTextCellLayout
 * 【功能说明】文本消息单元发送布局
 *  用于实现文本消息单元，在接收状态时的布局管理。
 *  本布局继承 TOutgoingCellLayout，当您想自定义布局时，可以从本布局进行修改并使用本布局，无需从父类直接修改。
 */
@interface DUIOutgoingTextCellLayout : DOutgoingCellLayout

@end

/**
 * 【模块名称】TUIIncommingTextCellLayout
 * 【功能说明】文本消息单元接收布局
 *  用于实现文本消息单元，在接收状态时的布局管理。
 *  本布局继承 TIncomingCellLayout，当您想自定义布局时，可以从本布局进行修改并使用本布局，无需从父类直接修改。
 */
@interface DUIIncommingTextCellLayout : DIncommingCellLayout

@end


NS_ASSUME_NONNULL_END
