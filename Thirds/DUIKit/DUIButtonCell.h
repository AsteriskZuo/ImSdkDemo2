//
//  DUIButtonCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/12.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DCommonTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ButtonGreen,
    ButtonWhite,
    ButtonRedText,
    ButtonBule,
} DUIButtonStyle;

@interface DUIButtonCellData : DCommonCellData

@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) SEL cButtonSelector;
@property (nonatomic, assign) DUIButtonStyle style;

@end

@interface DUIButtonCell : DCommonTableViewCell

@property (nonatomic, strong) UIButton* button;
@property (nonatomic, readonly) DUIButtonCellData* buttonData;

@end

NS_ASSUME_NONNULL_END
