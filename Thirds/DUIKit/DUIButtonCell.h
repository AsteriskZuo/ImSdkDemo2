//
//  DUIButtonCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/12.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUICommonCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ButtonDefault,
    ButtonGreen,
    ButtonWhite,
    ButtonRedText,
    ButtonBlue,
} DUIButtonStyle;

@interface DUIButtonCellData : DUICommonCellData

@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) SEL cButtonSelector;
@property (nonatomic, assign) DUIButtonStyle style;

@end

@interface DUIButtonCell : DUICommonCell

@property (nonatomic, strong) UIButton* button;
@property (nonatomic, readonly) DUIButtonCellData* buttonData;

@end

NS_ASSUME_NONNULL_END
