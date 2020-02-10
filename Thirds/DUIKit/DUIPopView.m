//
//  DUIPopView.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/30.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIPopView.h"
#import "DHeader.h"

@implementation DUIPopViewCellData

@end

@interface DUIPopViewCell ()

@property (nonatomic, strong) DUIPopViewCellData* data;

@end

@implementation DUIPopViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    CGFloat headHeight = TPopCell_Height - 2 * TPopCell_Padding;
    self.imageViewCell = [[UIImageView alloc] initWithFrame:CGRectMake(TPopCell_Padding, TPopCell_Padding, headHeight, headHeight)];
    self.imageViewCell.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageViewCell];
    
    CGFloat titleWidth = self.frame.size.width - 2 * TPopCell_Padding - TPopCell_Margin - self.imageViewCell.frame.size.width;
    self.nameView = [[UILabel alloc] initWithFrame:CGRectMake(self.imageViewCell.frame.origin.x + self.imageViewCell.frame.size.width + TPopCell_Margin, TPopCell_Padding, titleWidth, headHeight)];
    self.nameView.font = [UIFont systemFontOfSize:15];
    self.nameView.textColor = [UIColor blackColor];
    [self addSubview:self.nameView];
    
    [self setSeparatorInset:UIEdgeInsetsMake(0, TPopCell_Padding, 0, 0)];
}

+ (CGFloat)getHeight
{
    return TPopCell_Height;
}

- (void)fillWithData:(DUIPopViewCellData*)data;
{
    _data = data;
    [self.imageViewCell setImage:data.image];
    self.nameView.text = data.name;
}

@end

@interface DUIPopView () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<DUIPopViewCellData* >* list;
@property (nonatomic, strong) UITableView* tableView;

@end

@implementation DUIPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    CGSize arrowSize = TPopView_Arrow_Size;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + arrowSize.height, self.frame.size.width, self.frame.size.height - arrowSize.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
//    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.scrollEnabled = NO;
    _tableView.layer.cornerRadius = 5;
    [self addSubview:_tableView];
    
//    NSLog(@"tableview:%f,%f", _tableView.frame.size.width, _tableView.frame.size.height);
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = TPopView_Background_Color;
}

- (void)onTap:(UITapGestureRecognizer*)sender
{
    [self hide];
}

- (void)hide
{
    self.alpha = 1;
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        __strong typeof(self) ss = ws;
        ss.alpha = 0;
    } completion:^(BOOL finished){
        __strong typeof(self) ss = ws;
        if ([ss superview]) {
            [ss removeFromSuperview];
        }
    }];
}

- (void)setData:(NSArray<DUIPopViewCellData* >* )data
{
    _list = data;
    [_tableView reloadData];
}

- (void)showInWindow:(UIWindow *)window
{
    [window addSubview:self];
    __weak typeof(self) ws = self;
    self.alpha = 0;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        __strong typeof(ws) ss = ws;
        ss.alpha = 1;
    } completion:nil];
}

- (void)drawRect:(CGRect)rect {
    [[UIColor whiteColor] set];

    CGSize arrowSize = TPopView_Arrow_Size;
    UIBezierPath *arrowPath = [[UIBezierPath alloc] init];
    [arrowPath moveToPoint:_arrowPoint];
    [arrowPath addLineToPoint:CGPointMake(_arrowPoint.x + arrowSize.width * 0.5, _arrowPoint.y + arrowSize.height)];
    [arrowPath addLineToPoint:CGPointMake(_arrowPoint.x - arrowSize.width * 0.5, _arrowPoint.y + arrowSize.height)];
    [arrowPath closePath];
    [arrowPath fill];
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUIPopViewCell* cell = [tableView dequeueReusableCellWithIdentifier:TPopCell_ReuseId];
    if (!cell) {
        cell = [[DUIPopViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TPopCell_ReuseId];
    }
    [cell fillWithData:_list[indexPath.row]];
    if(indexPath.row == _list.count - 1){
        cell.separatorInset = UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0);
    }
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DUIPopViewCell getHeight];
}

#pragma mark - gesture recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%s, class=%@", __FUNCTION__, NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
        return NO;
     }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press
{
    NSLog(@"%s, class=%@", __FUNCTION__, NSStringFromClass([press.responder class]));
    if ([NSStringFromClass([press.responder class]) isEqualToString:@"UITableViewCellContentView"]){
        return NO;
     }
    return YES;
}

@end
