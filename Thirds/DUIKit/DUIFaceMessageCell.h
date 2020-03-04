//
//  DUIFaceMessageCell.h
//  ImSdkDemo
//
//  Created by zuoyu on 2020/3/4.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
* 【模块名称】TUIFaceMessageCellData
* 【功能说明】表情消息单元数据源。
*  表情消息单元，即显示动画表情时所使用并展示的消息单元。
*  表情消息单元数据源，则是为表情消息单元的显示提供一系列所需数据的类。
*  数据源帮助实现了 MVVM 架构，使数据与 UI 进一步解耦，同时使 UI 层更加细化、可定制化。
*/
@interface DUIFaceMessageCellData : DUIMessageCellData

/**
 *  表情分组索引
 *  即表情所在分组的下标，用于定位表情所在表情组。
 */
@property (nonatomic, assign) NSInteger groupIndex;

/**
 *  表情所在路径
 */
@property (nonatomic, strong) NSString *path;

/**
 *  表情名称
 */
@property (nonatomic, strong) NSString *faceName;


@end





/**
* 【模块名称】TUIFaceMessageCell
* 【功能说明】表情消息单元。
*  表情消息单元，即显示动画表情时所使用并展示的消息单元。
*  默认情况下，在消息列表中看到的“[动画消息]”，即为表情消息单元所承载并展示的消息。
*/
@interface DUIFaceMessageCell : DUIMessageCell

/**
 *  表情图像视图
 *  存放[动画表情]所对应的图像资源。
 */
@property (nonatomic, strong) UIImageView *face;

/**
 *  表情单元数据源
 *  faceData 中存放了表情所在的分组信息、存储路径以及表情名称。
 */
@property (nonatomic, strong) DUIFaceMessageCellData *faceData;

/**
 *  填充数据
 *  根据 data 设置表情消息的数据。
 *
 *  @param  data    填充数据需要的数据源
 */
- (void)fillWithData:(DUIFaceMessageCellData *)data;

@end

NS_ASSUME_NONNULL_END
