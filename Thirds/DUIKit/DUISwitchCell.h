//
//  DUISwitchCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUICommonCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DUISwitchCellData : DUICommonCellData

@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) BOOL on;
@property (nonatomic, assign) SEL cSwitchSelector;

@end

@interface DUISwitchCell : DUICommonCell

@property (nonatomic, strong) UILabel* titleView;
@property (nonatomic, strong) UISwitch* switchView;

@end

NS_ASSUME_NONNULL_END
