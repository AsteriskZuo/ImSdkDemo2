//
//  DUIUnreadView.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/27.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DUIUnreadView : UIView

@property (nonatomic, strong) UILabel* unreadLabel;

- (void)setNum:(NSInteger)num;

@end

NS_ASSUME_NONNULL_END
