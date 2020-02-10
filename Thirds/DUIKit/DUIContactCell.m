//
//  DUIContactCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/1.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIContactCell.h"
#import "MMLayout/UIView+MMLayout.h"

@implementation DUIContactCellData

@end



@interface DUIContactCell ()

@property (nonatomic, strong) DUIContactCellData* contactData;

@end

@implementation DUIContactCell

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
    [self addSubview:_avatarView];
    
    _titleView = [[UILabel alloc] init];
    [self addSubview:_titleView];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self updateLayout];
}

- (void)fillWithData:(DUIContactCellData *)data
{
    [super fillWithData:data];
    _contactData = data;
    [_avatarView setImage:data.avatar];
    _titleView.text = data.title;
    
    [self updateLayout];
}

- (void)updateLayout
{
    _avatarView.mm_width(34).mm_height(34).mm__centerY(28).mm_left(12);
    _titleView.mm_sizeToFit().mm_height(20).mm_left(_avatarView.mm_maxX + 12).mm__centerY(_avatarView.mm_centerY);
//    _titleView.mm_sizeToFit().mm_left(_avatarView.mm_maxX + 12).mm_height(20).mm__centerY(_avatarView.mm_centerY).mm_flexToRight(0);
    NSLog(@"%s, %f,%f,%f,%f,%f", __func__, _titleView.frame.origin.x, _titleView.frame.origin.y, _titleView.frame.size.width, _titleView.frame.size.height, _titleView.mm_centerY);
}

+ (CGFloat)getHeight
{
    return 56;
}

@end
