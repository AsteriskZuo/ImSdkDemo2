//
//  DUIConversationCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/27.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUICommonCell.h"
#import "DCommon.h"

@class DUIUnreadView;

NS_ASSUME_NONNULL_BEGIN

/**
* 【模块名称】会话单元数据源（DUIConversationCellData）
*
* 【功能说明】存放会话单元所需的一系列信息和数据。
*  会话单元数据源包含以下信息与数据：
*  1、会话 ID。
*  2、会话类型。
*  3、头像 URL 与头像图片。
*  4、会话标题与信息概览（副标题）。
*  5、会话时间（最新一条消息的收/发时间）。
*  6、会话未读计数。
*  7、会话置顶标识。
*  数据源中还包含了部分的业务逻辑，如获取并生成消息概览（subTitle），更新会话信息（群消息或用户消息更新）等逻辑。
*/
@interface DUIConversationCellData : DUICommonCellData

/**
 *  会话 ID，用于唯一标识一个会话。
 *  我们通过此 ID 从服务器拉取会话相关的资料，包括 TIMConversation 对象与群组/用户资料。
 */
@property (nonatomic, strong) NSString *convId;

/**
 *  会话类型。
 *TIM_C2C 类型
 *TIM_GROUP 群聊 类型
 *TIM_SYSTEM 系统消息
 */
@property (nonatomic, assign) CLIMConversationType convType;

/**
 *  头像 URL
 */
@property NSURL *avatarUrl;

/**
 *  头像图片，通过头像 URL 获取。
 */
@property UIImage *avatarImage;

/**
 *  会话标题
 *  当该会话为1对1好友会话时，标题为好友的备注，若对应好友没有备注的话，则显示好友 ID。
 *  当该会话为群聊时，标题为群名称。
 */
@property NSString *title;

/**
 *  会话消息概览（下标题）
 *  概览负责显示对应会话最新一条消息的内容/类型。
 *  当最新的消息为文本消息/系统消息时，概览的内容为消息的文本内容。
 *  当最新的消息为多媒体消息时，概览的内容为对应的多媒体形式，如：“动画表情” / “[文件]” / “[语音]” / “[图片]” / “[视频]” 等。
 *  若当前会话有草稿时，概览内容为：“[草稿]XXXXX”，XXXXX为草稿内容。
 */
@property (nonatomic, strong) NSString *subTitle;

/**
 *  最新消息时间
 *  记录会话中最新消息的接收/发送时间。
 */
@property (nonatomic, strong) NSDate *time;

/**
 *  当前会话的未读计数。用于在消息列表界面进行未读提醒。
 */
@property (nonatomic, assign) int unRead;

/**
 *  会话置顶位
 *  YES：会话置顶；NO：会话未置顶。
 */
@property BOOL isOnTop;

@end


/**
* 【模块名称】消息列表会话单元（DUIConversationCell）
*
* 【功能说明】在消息列表界面中，显示单个会话的预览信息。
*  会话单元所展示的会话信息包括：
*  1、头像信息（用户头像/群头像）
*  2、会话标题（用户昵称/群名称）
*  3、会话消息概览（展示最新的一条的消息内容）
*  4、未读消息数（若有未读消息的话）
*  5、会话时间（最新消息的收到/发出时间）
*/
@interface DUIConversationCell : DUICommonCell

/**
 *  头像视图。
 *  当该会话为1对1好友会话时，头像视图为用户头像。
 *  当该会话为群聊时，头像视图为群头像。
 */
@property (nonatomic, strong) UIImageView *headImageView;

/**
 *  会话标题
 *  当该会话为1对1好友会话时，标题为好友的备注，若对应好友没有备注的话，则显示好友 ID。
 *  当该会话为群聊时，标题为群名称。
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  会话消息概览（下标题）
 *  概览负责显示对应会话最新一条消息的内容/类型。
 *  当最新的消息为文本消息/系统消息时，概览的内容为消息的文本内容。
 *  当最新的消息为多媒体消息时，概览的内容为对应的多媒体形式，如：“动画表情” / “[文件]” / “[语音]” / “[图片]” / “[视频]” 等。
 *  若当前会话有草稿时，概览内容为：“[草稿]XXXXX”，XXXXX为草稿内容。
 */
@property (nonatomic, strong) UILabel *subTitleLabel;

/**
 *  时间标签
 *  负责在会话单元中显示最新消息的接收/发送时间。
 *  对于当天的消息，以 “HH：MM”的格式显示时间。
 *  对于非当天的消息，则显示消息收/发当天为星期几。
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 *  未读视图
 *  如果当前会话有消息未读的话，则在会话单元右侧显示红底白字的原型图标来展示未读数量。
 */
@property (nonatomic, strong) DUIUnreadView *unReadView;

/**
 *  会话消息数据源
 *  存储会话单元所需的一系列信息与数据。包含会话头像、会话类型（1对1/群组）、会话标题、未读计数等等。
 *  数据源还会负责部分数据的获取与处理。
 *  数据源的详细信息请参考 \Section\Conversation\Cell\TUIConversationCellData.h
 */
@property (atomic, strong) DUIConversationCellData *convData;

/**
 *  填充数据
 *  根据传入的数据源，对会话单元中的各个属性进行赋值。
 *  本函数中还包含了一些会话单元的初始化操作。
 */
- (void)fillWithData:(DUIConversationCellData *)convData;

@end

NS_ASSUME_NONNULL_END
