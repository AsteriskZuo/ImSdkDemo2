//
//  DUIProfileCardCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/26.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIProfileCardCell.h"
#import "DHeader.h"

#import "UIView+MMLayout.h"
#import "ReactiveObjC.h"

@implementation DUIProfileCardCellData

@end

@implementation DUIProfileCardCell

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
    CGSize headSize = TPersonalCommonCell_Image_Size;
    self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(TPersonalCommonCell_Margin, TPersonalCommonCell_Margin, headSize.width, headSize.height)];
    self.avatar.contentMode = UIViewContentModeScaleAspectFit;
    //添加点击头像的手势
    UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAvatar)];
    [self.avatar addGestureRecognizer:tapAvatar];
    self.avatar.userInteractionEnabled = YES;
    
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = headSize.height / 2;
    [self addSubview:self.avatar];
    
    self.name = [[UILabel alloc] init];
    [self.name setFont:[UIFont systemFontOfSize:15]];
    [self.name setTextColor:[UIColor blackColor]];
    [self addSubview:self.name];
    
    self.identifier = [[UILabel alloc] init];
    [self.identifier setFont:[UIFont systemFontOfSize:14]];
    [self.identifier setTextColor:[UIColor grayColor]];
    [self addSubview:self.identifier];
    
    self.signature = [[UILabel alloc] init];
    [self.signature setFont:[UIFont systemFontOfSize:14]];
    [self.signature setTextColor:[UIColor grayColor]];
    [self addSubview:self.signature];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)onTapAvatar
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapOnAvatar:)])
    [self.delegate didTapOnAvatar:self];
}

- (void)fillWithData:(DUIProfileCardCellData *)data
{
    [super fillWithData:data];
    self.cardData = data;
    
    self.name.text = self.cardData.name;
    self.identifier.text = self.cardData.identifier;
    self.signature.text = self.cardData.signature;
    [self.avatar setImage:self.cardData.avatarImage];
    
    if (self.cardData.showAccessory) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    @weakify(self)
    RAC(_signature, text) = [RACObserve(data, signature) takeUntil:self.rac_prepareForReuseSignal];
    [[[RACObserve(data, identifier) takeUntil:self.rac_prepareForReuseSignal] distinctUntilChanged] subscribeNext:^(NSString *x) {
        @strongify(self)
        self.identifier.text = [@"帐号: " stringByAppendingString:data.identifier];
    }];
    
    [[[RACObserve(data, name) takeUntil:self.rac_prepareForReuseSignal] distinctUntilChanged] subscribeNext:^(NSString *x) {
        @strongify(self)
        self.name.text = x;
    }];
//    [[RACObserve(data, avatarUrl) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSURL *x) {
//        @strongify(self)
//        [self.avatar sd_setImageWithURL:x placeholderImage:self.cardData.avatarImage];
//    }];
//    
//    [[RACObserve(data, genderString) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *x) {
//        @strongify(self)
//        if([x isEqualToString:@"男"]){
//            self.genderIcon.image = [UIImage tk_imageNamed:@"male"];
//        }else if([x isEqualToString:@"女"]){
//            self.genderIcon.image = [UIImage tk_imageNamed:@"female"];
//        }else{
//            //(性别 iCon 在未设置性别时不显示)
//            self.genderIcon.image = nil;
//        }
//    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //此处解除 nameLabel 的 fit 宽度，使性别 icon 能够在短昵称情况下和 nameLabel 相邻。
    self.name.mm_sizeToFitThan(0, self.avatar.mm_h/3).mm_top(self.avatar.mm_y).mm_left(self.avatar.mm_maxX + TPersonalCommonCell_Margin);
    self.identifier.mm_sizeToFitThan(80, self.avatar.mm_h/3).mm__centerY(self.avatar.mm_centerY).mm_left(self.name.mm_x);
    self.signature.mm_sizeToFitThan(80, self.avatar.mm_h/3).mm_bottom(self.avatar.mm_b).mm_left(self.name.mm_x);
    //iCon大小 = 字体*0.9，视觉上最为自然
}

+ (CGFloat)getHeight
{
    return TPersonalCommonCell_Image_Size.height + 2 * TPersonalCommonCell_Margin;
}

@end
