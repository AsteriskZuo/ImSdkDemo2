//
//  DUINavigationIndicatorView.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/28.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUINavigationIndicatorView.h"
#import "DHeader.h"

@interface DUINavigationIndicatorView ()

@property UIActivityIndicatorView* indicator;

@end

@implementation DUINavigationIndicatorView

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
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)setupViews
{
    _title = [[UILabel alloc] init];
    _title.textColor = [UIColor blackColor];
    _title.font = [UIFont boldSystemFontOfSize:17];
    _title.backgroundColor = [UIColor clearColor];
    [self addSubview:_title];

    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, indicator_radius * 2, indicator_radius * 2)];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self addSubview:_indicator];
    self.opaque = NO;
    self.backgroundColor = [UIColor brownColor];
}

- (void)updateLayout
{
    CGSize _titleSize = [_title sizeThatFits:CGSizeMake(Screen_Width, NavBar_Height)];
    _title.frame = CGRectMake(0, 0, _titleSize.width, _titleSize.height);
//    _title.center = CGPointMake(0, 0);
    _indicator.center = CGPointMake(_title.frame.origin.x + _title.frame.size.width + indicator_radius + TNaviBarIndicatorView_Margin, _title.frame.origin.y + _title.frame.size.height / 2);
    
    if (_indicator.hidden) {
        self.frame = CGRectMake(0, 0
        , _title.frame.size.width
        , _title.frame.size.height > _indicator.frame.size.height ? _title.frame.size.height : _indicator.frame.size.height);
    } else {
        self.frame = CGRectMake(0, 0
        , _title.frame.size.width + _indicator.frame.size.width + TNaviBarIndicatorView_Margin
        , _title.frame.size.height > _indicator.frame.size.height ? _title.frame.size.height : _indicator.frame.size.height);
    }
    
//    NSLog(@"\n%s: title:%f,%f,%f,%f;\n indicator:%f,%f,%f,%f;\n self:%f,%f,%f,%f"
//          , __FUNCTION__
//          , _title.frame.origin.x, _title.frame.origin.y, _title.frame.size.width, _title.frame.size.height
//          , _indicator.frame.origin.x, _indicator.frame.origin.y, _indicator.frame.size.width, _indicator.frame.size.height
//          , self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setLabel:(NSString *)title
{
    _title.text = title;
    [self updateLayout];
}

- (void)startAnimating
{
    [_indicator startAnimating];
}
- (void)stopAnimating
{
    [_indicator stopAnimating];
}

@end
