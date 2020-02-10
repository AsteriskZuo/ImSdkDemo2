//
//  DUIButtonCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/12.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIButtonCell.h"
#import "DHeader.h"
#import "MMLayout/UIView+MMLayout.h"

@implementation DUIButtonCellData

@end

@interface DUIButtonCell()

@property DUIButtonCellData* buttonData;

@end

@implementation DUIButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupViews];
        self.changeColorWhenTouched = YES;
    }
    return self;
}

- (void)setupViews
{
    self.backgroundColor = [UIColor clearColor];

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button.titleLabel setFont:[UIFont systemFontOfSize:18]];
    self.button.layer.cornerRadius = 5;
    [self.button.layer setMasksToBounds:YES];
    [self.button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    self.button.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.3].CGColor;
    self.button.layer.borderWidth = 1;

    
//    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.contentView addSubview:self.button];

    [self setSeparatorInset:UIEdgeInsetsMake(0, Screen_Width, 0, 0)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.changeColorWhenTouched = YES;
}

- (void)onClick:(UIButton *)sender
{
    if (self.buttonData.cButtonSelector) {
        UIViewController *vc = self.mm_viewController;
        if ([vc respondsToSelector:self.buttonData.cButtonSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [vc performSelector:self.buttonData.cButtonSelector withObject:self];
#pragma clang diagnostic pop
        }
    }
}

- (void)fillWithData:(DUIButtonCellData *)data
{
    [super fillWithData:data];
    self.buttonData = data;
    [self.button setTitle:data.title forState:UIControlStateNormal];



    switch (data.style) {
        case ButtonGreen: {
            [self.button.titleLabel setTextColor:[UIColor whiteColor]];
            [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.button.backgroundColor = RGB(28, 185, 31);
            //对于背景色为绿色的按钮，高亮颜色比原本略深（原本的5/6）。由于无法直接设置高亮时的背景色，所以高亮背景色的变化通过生成并设置纯色图片来实现。
            [self.button setBackgroundImage:[self imageWithColor:RGB(23, 154, 26)] forState:UIControlStateHighlighted];
        }
            break;
        case ButtonWhite: {
            [self.button.titleLabel setTextColor:[UIColor blackColor]];
            [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.button.backgroundColor = [UIColor whiteColor];
            //对于原本白色背景色的按钮，高亮颜色保持和白色 cell 统一。由于无法直接设置高亮时的背景色，所以高亮背景色的变化通过生成并设置纯色图片来实现。
            [self.button setBackgroundImage:[self imageWithColor:self.colorWhenTouched] forState:UIControlStateHighlighted];
        }
            break;
        case ButtonRedText: {
            [self.button.titleLabel setTextColor:[UIColor redColor]];
            [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            self.button.backgroundColor = [UIColor whiteColor];
            //对于原本白色背景色的按钮，高亮颜色保持和白色 cell 统一。由于无法直接设置高亮时的背景色，所以高亮背景色的变化通过生成并设置纯色图片来实现。
            [self.button setBackgroundImage:[self imageWithColor:self.colorWhenTouched] forState:UIControlStateHighlighted];
            
//            [self.button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];//右移20像素
//            [self.button setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];//右移20像素
//            [self.button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];//右移20像素
//            [self.button setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, -20)];//没有效果

            break;
        }
        case ButtonBlue:{
            [self.button.titleLabel setTextColor:[UIColor whiteColor]];
            [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.button.backgroundColor = RGB(30, 144, 255);
            //对于背景色为蓝色的按钮，高亮颜色比原本略深（原本的5/6）。由于无法直接设置高亮时的背景色，所以高亮背景色的变化通过生成并设置纯色图片来实现。
            [self.button setBackgroundImage:[self imageWithColor:RGB(25, 120, 213)] forState:UIControlStateHighlighted];
        }
            break;
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.button.mm_width(Screen_Width - 2 * TButtonCell_Margin)
    .mm_height(self.mm_h - TButtonCell_Margin)
    .mm_top(0)
    .mm_left(TButtonCell_Margin);
    
//    NSLog(@"button:%f, %f, %f, %f", self.button.frame.size.height, self.button.frame.size.width, self.button.frame.origin.x, self.button.frame.origin.y);
}

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    if (subview != self.contentView) {
        [subview removeFromSuperview];
    }
}

//本函数实现了生成纯色背景的功能，从而配合 setBackgroundImage: forState: 来实现高亮时纯色按钮的点击反馈。
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (CGFloat)getHeight
{
    return 60;
}


@end
