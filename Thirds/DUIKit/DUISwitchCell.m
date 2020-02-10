//
//  DUISwitchCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUISwitchCell.h"
#import "MMLayout/UIView+MMLayout.h"

@implementation DUISwitchCellData

@end

@interface DUISwitchCell ()

@property (nonatomic, strong) DUISwitchCellData* switchData;

@end

@implementation DUISwitchCell

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
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _titleView = self.textLabel;
    _switchView = [[UISwitch alloc] init];
//    self.accessoryView = _switchView;
    [_switchView addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switchView];
    
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat margin = self.frame.size.height - _switchView.frame.size.height;
    _switchView.mm_right(15).mm_height(_switchView.frame.size.height - margin).mm__centerY(self.frame.size.height / 2);
}

- (void)fillWithData:(DUISwitchCellData *)data
{
    [super fillWithData:data];
    _switchData = data;
    _titleView.text = data.title;
    [_switchView setOn:data.on];
}

+ (CGFloat)getHeight
{
    return [super getHeight];
}

- (void)onSwitch:(UISwitch*)sender
{
    NSLog(@"%s", __func__);
}

@end
