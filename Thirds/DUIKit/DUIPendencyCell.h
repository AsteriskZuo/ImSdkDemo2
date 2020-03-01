//
//  DUIPendencyCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/29.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUICommonCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DUIPendencyCellData : DUICommonCellData

@property (nonatomic, strong, readwrite) NSString *identifier;
@property (nonatomic, strong, readwrite) NSURL *avatarUrl;
@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSString *addSource;
@property (nonatomic, strong, readwrite) NSString *addWording;
@property (nonatomic, assign, readwrite) BOOL isAccepted;
@property (nonatomic, assign, readwrite) SEL cbuttonSelector;

- (void)agree;
- (void)reject;

@end

@interface DUIPendencyCell : DUICommonCell

@property UIImageView *avatarView;
@property UILabel *titleLabel;
@property UILabel *addSourceLabel;
@property UILabel *addWordingLabel;
@property UIButton *agreeButton;

@property (nonatomic) DUIPendencyCellData *pendencyData;

- (void)fillWithData:(DUIPendencyCellData *)pendencyData;

@end

NS_ASSUME_NONNULL_END
