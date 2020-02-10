//
//  DUITestTextCell.h
//  ImSdkDemo
//
//  Created by yu.zuo on 2020/1/13.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUICommonCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DUITestTextCellData : DUICommonCellData

@property (nonatomic, strong) NSString* test;
@property (nonatomic, strong) UIImage* ava;

@end

@interface DUITestTextCell : DUICommonCell

@property (nonatomic, strong) UILabel* testLabel;
@property (nonatomic, strong) UIImageView* avaView;
@property (nonatomic, strong) DUITestTextCellData* testTextData;

@end

NS_ASSUME_NONNULL_END
