//
//  DUIPopView.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/30.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DUIPopViewCellData : NSObject

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) NSString* name;

@end

@interface DUIPopViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView* imageViewCell;
@property (nonatomic, strong) UILabel* nameView;

+ (CGFloat)getHeight;

- (void)fillWithData:(DUIPopViewCellData*)data;

@end

@class DUIPopView;
@protocol DUIPopViewDelegate <NSObject>

- (void)popView:(DUIPopView *)popView didSelectRowAtIndex:(NSInteger)index;

@end

@interface DUIPopView : UIView

@property (nonatomic, assign) CGPoint arrowPoint;
@property (nonatomic, weak) id<DUIPopViewDelegate> delegate;

- (void)setData:(NSArray<DUIPopViewCellData* >* )data;
- (void)showInWindow:(UIWindow *)window;

@end

NS_ASSUME_NONNULL_END
