//
//  DUICommonCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/12.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DUICommonCellData : NSObject

@property (nonatomic, strong) NSString* reuseId;
@property (nonatomic, assign) SEL cselector;

- (CGFloat)heightOfWidth:(CGFloat)width;

@end

@interface DUICommonCell : UITableViewCell

@property (nonatomic, strong, readonly) DUICommonCellData* data;
@property (nonatomic, strong) UIColor *colorWhenTouched;
@property (nonatomic, assign) BOOL changeColorWhenTouched;

- (void)fillWithData:(DUICommonCellData *)data;

+ (CGFloat)getHeight;

@end

NS_ASSUME_NONNULL_END
