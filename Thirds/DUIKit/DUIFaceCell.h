//
//  DUIFaceCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/15.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DUIFaceCellData : NSObject

/**
 *  表情名称。
 */
@property (nonatomic, strong) NSString *name;

/**
 *  表情在本地缓存的存储路径。
 */
@property (nonatomic, strong) NSString *path;

@end

@interface DUIFaceCell : UICollectionViewCell

/**
 *  表情图像
 *  表情所对应的Image图像。
 */
@property (nonatomic, strong) UIImageView *face;

/**
 *  设置表情单元的数据
 *
 *  @param data 需要设置的数据源。
 */
- (void)setData:(DUIFaceCellData *)data;

@end

NS_ASSUME_NONNULL_END
