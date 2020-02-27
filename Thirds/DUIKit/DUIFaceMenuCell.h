//
//  DUIFaceMenuCell.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/22.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
* 【模块名称】TMenuCellData
* 【功能说明】用于存放 MenuCell 的图像路径、选择状态位等 MenuCell 所需的信息与数据。
*/
@interface DUIFaceMenuCellData : NSObject

/**
 *  分组单元中分组缩略图的存取路径
 */
@property (nonatomic, strong) NSString *path;

/**
 *  选择标志位
 *  根据选择状态不同显示不同的图标状态
 */
@property (nonatomic, assign) BOOL isSelected;

@end

/**
* 【模块名称】TUIMenuCell
* 【功能说明】存放表情菜单的图像，并在表情菜单视图中作为显示单元，同时也是响应用户交互的基本单元。
*/
@interface DUIFaceMenuCell : UICollectionViewCell

/**
 *  菜单图像视图
 */
@property (nonatomic, strong) UIImageView *menu;

/**
 *  设置数据，包含设置表情图标、设置 frame 大小、根据 isSelected 设置背景颜色等。
 *
 *  @param data 需要设置的数据（TMenuCellData）
 */
- (void)setData:(DUIFaceMenuCellData *)data;

@end

NS_ASSUME_NONNULL_END
