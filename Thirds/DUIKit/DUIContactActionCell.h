//
//  DUIContactActionCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/1.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUICommonCell.h"
#import "DUIUnreadView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DUIContactActionCellData : DUICommonCellData

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, assign) NSInteger redNum;

@end

@interface DUIContactActionCell : DUICommonCell

@property (nonatomic, strong) DUIContactActionCellData* contactData;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) DUIUnreadView *unReadView;

@end

NS_ASSUME_NONNULL_END
