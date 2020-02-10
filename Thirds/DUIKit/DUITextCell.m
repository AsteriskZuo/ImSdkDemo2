//
//  DUITextCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUITextCell.h"

@implementation DUITextCellData

@end

@interface DUITextCell ()

@property (nonatomic, strong) DUITextCellData* textData;

@end

@implementation DUITextCell

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
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _keyView = self.textLabel;
    _valueView = self.detailTextLabel;
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)fillWithData:(DUITextCellData *)data
{
    [super fillWithData:data];
    _textData = data;
    _keyView.text = data.key;
    _valueView.text = data.value;
    
    if (!data.showAccessory) {
        self.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

+ (CGFloat)getHeight
{
    return [super getHeight];
}

@end
