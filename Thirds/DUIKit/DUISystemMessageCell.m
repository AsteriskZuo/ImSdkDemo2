//
//  DUISystemMessageCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/3/7.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUISystemMessageCell.h"
#import "DUIMessageCellLayout.h"
#import "DCommon.h"
#import "DHelper.h"
#import "DHeader.h"

#import "NSString+TUICommon.h"
#import "UIView+MMLayout.h"

@implementation DUISystemMessageCellData

- (instancetype)initWithDirection:(DMsgDirection)direction
{
    if (self = [super initWithDirection:direction]) {
        _contentFont = [UIFont systemFontOfSize:13];
        _contentColor = [UIColor colorWithRed:148.0 / 255.0
                                        green:149.0 / 255.0
                                         blue:149.0 / 255.0 alpha:1.0];
        self.cellLayout =  [DUIMessageCellLayout systemMessageLayout];
    }
    return self;
}

- (CGSize)contentSize
{
    CGSize size = [self.content textSizeIn:CGSizeMake(TSystemMessageCell_Text_Width_Max, MAXFLOAT) font:self.contentFont];
    size.height += 10;
    size.width += 16;
    return size;
}

- (CGFloat)heightOfWidth:(CGFloat)width
{
    return [self contentSize].height + 16;
}

@end

@interface DUISystemMessageCell ()

@property (nonatomic, strong, readwrite) DUISystemMessageCellData *systemData;

@end

@implementation DUISystemMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:13];
        _messageLabel.textColor = [UIColor colorWithRed:148.0 / 255.0
                                                  green:149.0 / 255.0
                                                   blue:149.0 / 255.0 alpha:1.0];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.layer.cornerRadius = 3;
        [_messageLabel.layer setMasksToBounds:YES];
        [self.container addSubview:_messageLabel];
    }
    return self;
}

- (void)fillWithData:(DUISystemMessageCellData *)data;
{
    [super fillWithData:data];
    self.systemData = data;
    //set data
    self.messageLabel.text = data.content;
    self.nameLabel.hidden = YES;
    self.avatarView.hidden = YES;
    self.retryView.hidden = YES;
    [self.indicator stopAnimating];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.container.mm_center();
    self.messageLabel.mm_fill();
}

@end
