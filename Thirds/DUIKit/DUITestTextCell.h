//
//  DUITestTextCell.h
//  ImSdkDemo
//
//  Created by yu.zuo on 2020/1/13.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DCommonTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DUITestTextCellData : DCommonCellData

@property (nonatomic, strong) NSString* test;

@end

@interface DUITestTextCell : DCommonTableViewCell

@property (nonatomic, strong) UILabel* testLabel;
@property (nonatomic, strong) DUITestTextCellData* testTextData;

@end

NS_ASSUME_NONNULL_END
