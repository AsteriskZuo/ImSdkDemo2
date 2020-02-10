//
//  DUIProfileCardCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/26.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUICommonCell.h"

NS_ASSUME_NONNULL_BEGIN

@class DUIProfileCardCell;
@protocol DUIProfileCardCellDelegate <NSObject>
/**
 *  点击头像的回调委托。
 *  您可以通过该委托实现点击头像显示大图的功能。
 *
 *  @param cell 被点击的头像所在的 cell，
 */
-(void) didTapOnAvatar:(DUIProfileCardCell *)cell;

@end

@interface DUIProfileCardCellData : DUICommonCellData

@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, assign) BOOL showAccessory;

@end

@interface DUIProfileCardCell : DUICommonCell

@property (nonatomic, strong) DUIProfileCardCellData* cardData;
@property (nonatomic, strong) UIImageView* avatar;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *identifier;
@property (nonatomic, strong) UILabel *signature;

@property (nonatomic, weak) id<DUIProfileCardCellDelegate> delegate;

- (void)fillWithData:(DUIProfileCardCellData *)data;

@end

NS_ASSUME_NONNULL_END
