//
//  DUIPendencyCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/29.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIPendencyCell.h"
#import "DHeader.h"
#import "MMLayout/UIView+MMLayout.h"


@implementation DUIPendencyCellData

//- (instancetype)initWithPendency:(TIMFriendPendencyItem *)args {
//    self = [super init];
//
//    _identifier = args.identifier;
//    _title = args.identifier;
//    if (args.addSource) {
//        _addSource = [NSString stringWithFormat:@"来源: %@", [args.addSource substringFromIndex:@"AddSource_Type_".length]];
//    }
//    _addWording = args.addWording;
//    _isAccepted = NO;
//
//    return self;
//}

- (BOOL)isEqual:(DUIPendencyCellData *)object
{
    return [self.identifier isEqual:object.identifier];
}

- (void)agree
{
//    TIMFriendResponse *rsp = TIMFriendResponse.new;
//    rsp.identifier = _identifier;
//    rsp.responseType = TIM_FRIEND_RESPONSE_AGREE_AND_ADD;
//    [[TIMFriendshipManager sharedInstance] doResponse:rsp succ:^(TIMFriendResult *result) {
//        [THelper makeToast:@"已发送"];
//    } fail:^(int code, NSString *msg) {
//        [THelper makeToastError:code msg:msg];
//    }];
}

- (void)reject
{
//    TIMFriendResponse *rsp = TIMFriendResponse.new;
//    rsp.identifier = _identifier;;
//    rsp.responseType = TIM_FRIEND_RESPONSE_REJECT;
//    [[TIMFriendshipManager sharedInstance] doResponse:rsp succ:^(TIMFriendResult *result) {
//        [THelper makeToast:@"已发送"];
//    } fail:^(int code, NSString *msg) {
//        [THelper makeToastError:code msg:msg];
//    }];
}

@end

@implementation DUIPendencyCell

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

    self.avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TUIKitResource(@"default_head")]];
    [self.contentView addSubview:self.avatarView];
    self.avatarView.mm_width(70).mm_height(70).mm__centerY(43).mm_left(12);

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor darkTextColor];
    self.titleLabel.mm_left(self.avatarView.mm_maxX+12).mm_top(14).mm_height(20).mm_width(120);

    self.addSourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.addSourceLabel];
    self.addSourceLabel.textColor = [UIColor lightGrayColor];
    self.addSourceLabel.font = [UIFont systemFontOfSize:15];
    self.addSourceLabel.mm_left(self.titleLabel.mm_x).mm_top(self.titleLabel.mm_maxY+6).mm_height(15).mm_width(120);

    self.addWordingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.addWordingLabel];
    self.addWordingLabel.textColor = [UIColor lightGrayColor];
    self.addWordingLabel.font = [UIFont systemFontOfSize:15];
    self.addWordingLabel.mm_left(self.addSourceLabel.mm_x).mm_top(self.addSourceLabel.mm_maxY+6).mm_height(15).mm_width(120);

    self.agreeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.accessoryView = self.agreeButton;
    [self.agreeButton addTarget:self action:@selector(agreeClick) forControlEvents:UIControlEventTouchUpInside];

    return self;
}

- (void)fillWithData:(DUIPendencyCellData *)pendencyData
{
    [super fillWithData:pendencyData];

    self.pendencyData = pendencyData;

    self.titleLabel.text = pendencyData.title;
    self.addSourceLabel.text = pendencyData.addSource;
    self.addWordingLabel.text = pendencyData.addWording;

    if (pendencyData.isAccepted) {
        [self.agreeButton setTitle:@"已同意" forState:UIControlStateNormal];
        self.agreeButton.enabled = NO;
        [self.agreeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.agreeButton.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        [self.agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        self.agreeButton.enabled = YES;
        [self.agreeButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.agreeButton.layer.borderColor = [UIColor grayColor].CGColor;
        self.agreeButton.layer.borderWidth = 1;
    }
    self.agreeButton.mm_sizeToFit().mm_width(self.agreeButton.mm_w+20);
}

- (void)agreeClick
{
    if (self.pendencyData.cbuttonSelector) {
        UIViewController *vc = self.mm_viewController;
        if ([vc respondsToSelector:self.pendencyData.cbuttonSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [vc performSelector:self.pendencyData.cbuttonSelector withObject:self];
#pragma clang diagnostic pop
        }
    }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ((touch.view == self.agreeButton)) {
        return NO;
    }
    return YES;
}

@end
