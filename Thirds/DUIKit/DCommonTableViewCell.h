//
//  DCommonTableViewCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/12.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCommonCellData : NSObject

@property (nonatomic, strong) NSString* reuserId;
@property (nonatomic, assign) SEL cselector;

- (CGFloat)heightOfWidth:(CGFloat)width;

@end

@interface DCommonTableViewCell : UITableViewCell

@property (nonatomic, readonly) DCommonCellData* data;
@property (nonatomic, strong) UIColor *colorWhenTouched;
@property (nonatomic, assign) BOOL changeColorWhenTouched;

- (void)fillWithData:(DCommonCellData *)data;

@end

NS_ASSUME_NONNULL_END
