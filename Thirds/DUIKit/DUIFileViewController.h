//
//  DUIFileViewController.h
//  ImSdkDemo
//
//  Created by zuoyu on 2020/3/4.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DUIFileMessageCellData;

@interface DUIFileViewController : UIViewController

@property (nonatomic, strong, readwrite) DUIFileMessageCellData* data;

@end

NS_ASSUME_NONNULL_END
