//
//  DUITestTextCell.m
//  ImSdkDemo
//
//  Created by yu.zuo on 2020/1/13.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUITestTextCell.h"
#import "DHeader.h"
#import "MMLayout/UIView+MMLayout.h"

@implementation DUITestTextCellData

@end

@implementation DUITestTextCell

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
    
    self.testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [self addSubview:self.testLabel];
    
    CGSize headSize = TPersonalCommonCell_Image_Size;
    self.avaView = [[UIImageView alloc] initWithFrame:CGRectMake(TPersonalCommonCell_Margin, TPersonalCommonCell_Margin, headSize.width, headSize.height)];
    self.avaView.contentMode = UIViewContentModeScaleAspectFit;
    self.avaView.layer.masksToBounds = YES;
    self.avaView.layer.cornerRadius = headSize.height / 2;
    [self addSubview:self.avaView];
    
    [self setSeparatorInset:UIEdgeInsetsMake(0, Screen_Width, 0, 0)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.changeColorWhenTouched = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.testLabel.mm_width(Screen_Width - 2 * TButtonCell_Margin)
    .mm_height(self.mm_h - TButtonCell_Margin)
    .mm_top(10)
    .mm_left(TButtonCell_Margin);
    
//    NSLog(@"button:%f, %f, %f, %f", self.testLabel.frame.size.height, self.testLabel.frame.size.width, self.testLabel.frame.origin.x, self.testLabel.frame.origin.y);
}

- (void)fillWithData:(DUITestTextCellData *)data
{
    [super fillWithData:data];
    self.testTextData = data;
    self.testLabel.text = data.test;
    [self.avaView setImage:data.ava];
}

+ (CGFloat)getHeight
{
    return 30;
}

@end
