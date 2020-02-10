//
//  DUIConversationCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/27.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIConversationCell.h"
#import "DHeader.h"
#import "DUIUnreadView.h"
#import "MMLayout/UIView+MMLayout.h"
#import "NSDate+TUIKIT.h"

@implementation DUIConversationCellData

- (BOOL)isEqual:(DUIConversationCellData *)object
{
    return [self.convId isEqual:object.convId];
}

@end

@implementation DUIConversationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self updateLayout];
    }
    return self;
}

- (void)setupViews
{
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    _headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
    [self addSubview:_headImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.layer.masksToBounds = YES;
    [self addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    _subTitleLabel.layer.masksToBounds = YES;
    _subTitleLabel.font = [UIFont systemFontOfSize:14];
    _subTitleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_subTitleLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.layer.masksToBounds = YES;
    [self addSubview:_timeLabel];
    
    _unReadView = [[DUIUnreadView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self addSubview:_unReadView];
    
    [self setSeparatorInset:UIEdgeInsetsMake(0, TConversationCell_Margin, 0, 0)];

    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    //[self setSelectionStyle:UITableViewCellSelectionStyleDefault];
}

- (void)updateLayout
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];   
    
    CGFloat height = [DUIConversationCell getHeight];
    self.mm_h = height;
    CGFloat imgHeight = height-2*(TConversationCell_Margin);
    
    self.headImageView.mm_width(imgHeight).mm_height(imgHeight).mm_left(TConversationCell_Margin + 3).mm_top(TConversationCell_Margin);
    self.timeLabel.mm_sizeToFit().mm_top(TConversationCell_Margin_Text).mm_right(TConversationCell_Margin + 4);
    self.titleLabel.mm_sizeToFitThan(120, 30).mm_top(TConversationCell_Margin_Text - 5).mm_left(self.headImageView.mm_maxX+TConversationCell_Margin);
    self.unReadView.mm_right(TConversationCell_Margin + 4).mm_bottom(TConversationCell_Margin - 1);
    self.subTitleLabel.mm_sizeToFit().mm_left(self.titleLabel.mm_x).mm_bottom(TConversationCell_Margin_Text).mm_flexToRight(self.mm_w-self.unReadView.mm_x);
}

- (void)fillWithData:(DUIConversationCellData *)convData
{
    [super fillWithData:convData];
    self.convData = convData;
    
    [self.headImageView setImage:convData.avatarImage];
    self.titleLabel.text = convData.title;
    self.subTitleLabel.text = convData.subTitle;
    self.timeLabel.text = [convData.time tk_messageString];
    [self.unReadView setNum:convData.unRead];
}

+ (CGFloat)getHeight
{
    return TConversationCell_Height;
}

@end
