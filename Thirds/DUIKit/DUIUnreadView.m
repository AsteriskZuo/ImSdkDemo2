//
//  DUIUnreadView.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/27.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIUnreadView.h"
#import "DHeader.h"

@implementation DUIUnreadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
        [self updateLayout];
    }
    return self;
}

- (void)setupViews
{
    self.unreadLabel = [[UILabel alloc] init];
    self.unreadLabel.text = @"11";
    self.unreadLabel.font = [UIFont systemFontOfSize:12];
    self.unreadLabel.textColor = [UIColor whiteColor];
    self.unreadLabel.textAlignment = NSTextAlignmentCenter;
    self.unreadLabel.layer.masksToBounds = YES;
    [self.unreadLabel sizeToFit];
    [self addSubview:self.unreadLabel];
    
    self.layer.cornerRadius = (self.unreadLabel.frame.size.height + TUnReadView_Margin_TB * 2)/2.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor redColor];
}

- (void)updateLayout
{
    [self.unreadLabel sizeToFit];
    CGFloat width = self.unreadLabel.frame.size.width + 2 * TUnReadView_Margin_LR;
    CGFloat heigth = self.unreadLabel.frame.size.height + 2 * TUnReadView_Margin_LR;
    if (width < heigth) {
        width = heigth;
    }
//    self.bounds = CGRectMake(0, 0, width, heigth);
    self.frame = CGRectMake(0, 0, width, heigth);
    self.unreadLabel.frame = CGRectMake(0, 0, width, heigth);
}

- (void)setNum:(NSInteger)num
{
    if (0 >= num) {
        self.hidden = YES;
    } else {
        NSString* unreadCount = [[NSNumber numberWithInteger:num] stringValue];
        if (num > 99) {
            unreadCount = [NSString stringWithFormat:@"99+"];
        }
        self.unreadLabel.text = unreadCount;
        self.hidden = NO;
    }
    [self updateLayout];
}

@end
