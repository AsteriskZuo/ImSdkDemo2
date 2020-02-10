//
//  DUIContactCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/1.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUICommonCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DUIContactCellData : DUICommonCellData

@property (nonatomic, strong) UIImage* avatar;
@property (nonatomic, strong) NSString* title;

@end

@interface DUIContactCell : DUICommonCell

- (void)fillWithData:(DUIContactCellData *)data;

@property (nonatomic, strong) UIImageView* avatarView;
@property (nonatomic, strong) UILabel* titleView;

@end

NS_ASSUME_NONNULL_END
