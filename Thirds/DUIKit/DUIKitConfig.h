//
//  DUIKitConfig.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/15.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

/** 腾讯云 TUIKitConfig
 *
 *
 *  本类依赖于腾讯云 IM SDK 实现
 *  TUIKit 中的组件在实现 UI 功能的同时，调用 IM SDK 相应的接口实现 IM 相关逻辑和数据的处理
 *  您可以在TUIKit的基础上做一些个性化拓展，即可轻松接入IM SDK
 *
 *  TUIKitConfig 实现了配置文件的默认初始化，您可以根据您的需求在此更改默认配置，或通过此类修改配置
 *  配置文件包括表情、默认图标等等
 *
 *  需要注意的是 TUIKit 里面的表情包都是有版权限制的，请在上线的时候替换成自己的表情包，否则会面临法律风险
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "TUIFaceView.h"
//#import "TUIInputMoreCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DUIKitAvatarType) {
    TAvatarTypeNone,             /*矩形直角头像*/
    TAvatarTypeRounded,          /*圆形头像*/
    TAvatarTypeRadiusCorner,     /*圆角头像*/
};


@class DUIFaceGroup;


@interface DUIKitConfig : NSObject

/**
 * 表情列表（需要注意的是 TUIKit 里面的表情包都是有版权限制的，请在上线的时候替换成自己的表情包，否则会面临法律风险）
 */
@property (nonatomic, strong) NSArray<DUIFaceGroup *> *faceGroups;
/**
 *  头像类型
 */
@property (nonatomic, assign) DUIKitAvatarType avatarType;
/**
 *  头像圆角大小
 */
@property (nonatomic, assign) CGFloat avatarCornerRadius;
/**
 *  默认头像图片
 */
@property (nonatomic, strong) UIImage *defaultAvatarImage;
/**
 *  默认群组头像图片
 */
@property (nonatomic, strong) UIImage *defaultGroupAvatarImage;

+ (DUIKitConfig *)defaultConfig;

@end

NS_ASSUME_NONNULL_END
