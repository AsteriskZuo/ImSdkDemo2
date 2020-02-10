//
//  DUINavigationIndicatorView.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/28.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DUINavigationIndicatorView : UIView

@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong, readonly) UIActivityIndicatorView* indicator;

- (void)setLabel:(NSString *)title;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
