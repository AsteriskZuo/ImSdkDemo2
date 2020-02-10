//
//  DUITextCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUICommonCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DUITextCellData : DUICommonCellData

@property (nonatomic, strong) NSString* key;
@property (nonatomic, strong) NSString* value;
@property (nonatomic, assign) BOOL showAccessory;

@end

@interface DUITextCell : DUICommonCell

@property (nonatomic, strong) UILabel* keyView;
@property (nonatomic, strong) UILabel* valueView;

@end

NS_ASSUME_NONNULL_END
