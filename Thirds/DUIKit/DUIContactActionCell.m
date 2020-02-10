//
//  DUIContactActionCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/1.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIContactActionCell.h"
#import "MMLayout/UIView+MMLayout.h"

@implementation DUIContactActionCellData

@end

@implementation DUIContactActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _avatarView = [[UIImageView alloc] init];
//    [self addSubview:_avatarView];
    [self.contentView addSubview:_avatarView];
    
    _titleView = [[UILabel alloc] init];
//    [self addSubview:_titleView];
    [self.contentView addSubview:_titleView];
    
    _unReadView = [[DUIUnreadView alloc] init];
//    [self addSubview:_unReadView];
    [self.contentView addSubview:_unReadView];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self updateLayout];
}

- (void)updateLayout
{
    _avatarView.mm_width(34).mm_height(34).mm__centerY(28).mm_left(12);
    _titleView.mm_left(_avatarView.mm_maxX+12).mm_height(20).mm__centerY(_avatarView.mm_centerY).mm_flexToRight(0);
    if (0 == _contactData.redNum) {
        _unReadView.hidden = YES;
    } else {
        _unReadView.mm__centerY(_avatarView.mm_centerY).mm_right(self.accessoryView.mm_w);
        _unReadView.hidden = NO;
    }
}

- (void)fillWithData:(DUIContactActionCellData *)data
{
    [super fillWithData:data];
    [_avatarView setImage:data.icon];
    _titleView.text = data.title;
    [_unReadView setNum:data.redNum];
    
    [self updateLayout];
}

+ (CGFloat)getHeight
{
    return 56;
}

@end
