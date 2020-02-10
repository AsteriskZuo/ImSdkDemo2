//
//  DUIGroupMembersCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/8.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUICommonCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DUIGroupMemberCellData : NSObject

/**
 *  群成员 ID
 */
@property (nonatomic, strong) NSString *identifier;
/**
 *  成员的群昵称。
 *  此处有别与成员 ID，成员 ID 为成员的唯一标识符，而同一个用户可以在不同的群中使用不同的群昵称。
 */
@property (nonatomic, strong) NSString *name;
/**
 *  群成员头像
 */
@property (nonatomic, strong) UIImage *avatar;
/**
 *  成员标签，作为不同状态的标识符。
 *  tag = 1，该成员可以添加，待添加进群。可以理解为未进群且为邀请者联系人的用户 tag 赋值为1。
 *  tag = 2，该成员可以删除，待删除出群。可以理解为已进群且可以踢出的用户（非群主、管理）tag 赋值为2。
 */
@property NSInteger tag;

@end

@interface DUIGroupMemberCell : UICollectionViewCell

/**
 *  头像视图
 *  用于在单元中显示用户的头像。
 */
@property (nonatomic, strong) UIImageView *avatarView;

/**
 *  群名称
 *  用于在单元中显示用户的群昵称。
 *  此处显示的是用户的群昵称，当用户群昵称为设置时，默认显示用户的 ID。
 */
@property (nonatomic, strong) UILabel *nameView;

- (void)fillWithData:(DUIGroupMemberCellData *)data;

+ (CGSize)getSize;

@end

@interface DUIGroupMembersCellData : NSObject

@property (nonatomic, strong) NSMutableArray<DUIGroupMemberCellData*>* members;

@end

@class DUIGroupMembersCell;
@protocol DUIGroupMembersCellDelegate <NSObject>

- (void)groupMembersCell:(DUIGroupMembersCell*)cell didSelectItemAtIndex:(NSInteger)index;

@end

@interface DUIGroupMembersCell : UITableViewCell

/**
 *  群成员模块的 CollectionView
 *  包含多个 TGroupMemberCell，默认情况下显示2行5列共10个群成员，并配合 memberFlowLayout 进行灵活统一的视图布局。
 */
@property (nonatomic, strong) UICollectionView *membersView;

/**
 *  memberCollectionView 的流水布局
 *  配合 memberCollectionView，用来维护“群成员”模块内的的布局，使成员的头像单元排布更加美观。能够设置布局方向、行间距、cell 间距等。
 */
@property (nonatomic, strong) UICollectionViewFlowLayout *membersLayout;

/**
 *  委托类，负责实现 TGroupMembersCellDelegate 协议中的委托。
 */
@property (nonatomic, weak) id<DUIGroupMembersCellDelegate> membersDelegate;

- (void)fillWithData:(DUIGroupMembersCellData *)data;

+ (CGFloat)getHeight:(DUIGroupMembersCellData *)data;


@end

NS_ASSUME_NONNULL_END
