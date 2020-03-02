//
//  DUIImagePreviewController.h
//  ImSdkDemo
//
//  Created by zuoyu on 2020/3/2.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DUIImageMessageCellData;

@interface DUIImagePreviewScrollView : UIScrollView

@property (nonatomic, strong) UIImageView * imageView;

@end

@interface DUIImagePreviewController : UIViewController

@property (nonatomic, strong) DUIImageMessageCellData* data;

@end

NS_ASSUME_NONNULL_END
