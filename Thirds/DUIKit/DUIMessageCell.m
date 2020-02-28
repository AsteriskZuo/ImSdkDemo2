//
//  DUIMessageCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/7.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIMessageCell.h"
#import "DUIMessageCellLayout.h"
#import "DIMMessage.h"
#import "DHeader.h"
#import "MMLayout/UIView+MMLayout.h"

#import "DUIImageCache.h"


@implementation DUIMessageCellData

- (id)initWithDirection:(DMsgDirection)direction
{
    self = [super init];
    if (self) {
        _direction = direction;
        _status = Msg_Status_Init;
        _nameFont = [UIFont systemFontOfSize:13];
        _nameColor = [UIColor grayColor];
        _showReadReceipt = YES;//新 Demo 默认显示已读回执
        
        _avatarImage = [UIImage imageNamed:TUIKitResource(@"default_head")];
        
        if (direction == MsgDirectionIncoming) {
            _cellLayout = [DIncommingCellLayout new];
        } else {
            _cellLayout = [DOutgoingCellLayout new];
        }
        
    }
    return self;
}

- (CGFloat)heightOfWidth:(CGFloat)width
{
    CGFloat height = 0;


    if (self.showName)
        height += 20;

    CGSize containerSize = [self contentSize];
    height += containerSize.height;
    height += self.cellLayout.messageInsets.top + self.cellLayout.messageInsets.bottom;

    if (height < 55)
        height = 55;

    return height;
}

- (CGSize)contentSize
{
    return CGSizeZero;
}


static UIColor *sOutgoingNameColor;

+ (UIColor *)outgoingNameColor
{
    if (!sOutgoingNameColor) {
        sOutgoingNameColor = [UIColor whiteColor];
    }
    return sOutgoingNameColor;
}

+ (void)setOutgoingNameColor:(UIColor *)outgoingNameColor
{
    sOutgoingNameColor = outgoingNameColor;
}

static UIFont *sOutgoingNameFont;

+ (UIFont *)outgoingNameFont
{
    if (!sOutgoingNameFont) {
        sOutgoingNameFont = [UIFont systemFontOfSize:15];
    }
    return sOutgoingNameFont;
}

+ (void)setOutgoingNameFont:(UIFont *)outgoingNameFont
{
    sOutgoingNameFont = outgoingNameFont;
}

static UIColor *sIncommingNameColor;

+ (UIColor *)incommingNameColor
{
    if (!sIncommingNameColor) {
        sIncommingNameColor = [UIColor blackColor];
    }
    return sIncommingNameColor;
}

+ (void)setIncommingNameColor:(UIColor *)incommingNameColor
{
    sIncommingNameColor = incommingNameColor;
}

static UIFont *sIncommingNameFont;

+ (UIFont *)incommingNameFont
{
    if (!sIncommingNameFont) {
        sIncommingNameFont = [UIFont systemFontOfSize:15];
    }
    return sIncommingNameFont;
}

+ (void)setIncommingNameFont:(UIFont *)incommingNameFont
{
    sIncommingNameFont = incommingNameFont;
}

@end

@implementation DUIMessageCell

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
    self.backgroundColor = [UIColor clearColor];
    //head
    _avatarView = [[UIImageView alloc] init];
    _avatarView.contentMode = UIViewContentModeScaleAspectFit;
    _avatarView.layer.cornerRadius = 5;//default
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectMessageAvatar:)];
    [_avatarView addGestureRecognizer:tap1];
    [_avatarView setUserInteractionEnabled:YES];
    [self addSubview:_avatarView];

    //nameLabel
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.textColor = [UIColor grayColor];
    [self addSubview:_nameLabel];

    //container
    _container = [[UIView alloc] init];
    _container.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectMessage:)];
    [_container addGestureRecognizer:tap];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [_container addGestureRecognizer:longPress];
    [self addSubview:_container];
    
    //indicator
    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self addSubview:_indicator];
    
    //error
    _retryView = [[UIImageView alloc] init];
    _retryView.userInteractionEnabled = YES;
    UITapGestureRecognizer *resendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRetryMessage:)];
    [_retryView addGestureRecognizer:resendTap];
    [self addSubview:_retryView];
    
    //已读label,由于 indicator 和 error，所以默认隐藏，消息发送成功后进行显示
    _readReceiptLabel = [[UILabel alloc] init];
    _readReceiptLabel.hidden = YES;
    _readReceiptLabel.font = [UIFont systemFontOfSize:12];
    _readReceiptLabel.textColor = [UIColor grayColor];
    _readReceiptLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:_readReceiptLabel];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)onSelectMessageAvatar:(UIGestureRecognizer*)sender
{
    if ([_delegate respondsToSelector:@selector(onSelectMessageAvatar:)]) {
        [_delegate onSelectMessageAvatar:self];
    }
}

- (void)onSelectMessage:(UIGestureRecognizer*)sender
{
    if ([_delegate respondsToSelector:@selector(onSelectMessage:)]) {
        [_delegate onSelectMessage:self];
    }
}

- (void)onLongPress:(UIGestureRecognizer*)sender
{
    if([sender isKindOfClass:[UILongPressGestureRecognizer class]] &&
       sender.state == UIGestureRecognizerStateBegan){
        if(_delegate && [_delegate respondsToSelector:@selector(onLongPressMessage:)]){
            [_delegate onLongPressMessage:self];
        }
    }
}

- (void)onRetryMessage:(UIGestureRecognizer*)sender
{
    if (Msg_Status_Fail == _messageData.status) {
        if ([_delegate respondsToSelector:@selector(onRetryMessage:)]) {
            [_delegate onRetryMessage:self];
        }
    }
}

- (void)fillWithData:(DUIMessageCellData *)data
{
    [super fillWithData:data];
    _messageData = data;
    
    [_avatarView setImage:data.avatarImage];
    
    _nameLabel.text = data.name;
    _nameLabel.textColor = data.nameColor;
    _nameLabel.font = data.nameFont;
    
    
    //由于tableView的刷新策略，导致部分情况下可能会出现未读label未显示的bug。原因是因为在label显示时，内容为空。
    //label内容的变化不会引起tableView的刷新，但是hiddend状态的变化会引起tableView刷新。
    //所以未读标签选择直接赋值，而不是在发送成功时赋值。显示时机由hidden属性控制。
    self.readReceiptLabel.text = @"未读";
//    _readReceiptLabel.text = [self getReadReceiptResult];
    
    if(data.status == Msg_Status_Fail){
        [_indicator stopAnimating];
        self.retryView.image = [UIImage imageNamed:TUIKitResource(@"msg_error")];
        _readReceiptLabel.hidden = YES;
    } else {
        if (data.status == Msg_Status_Sending_2) {
            [_indicator startAnimating];
            _readReceiptLabel.hidden = YES;
        }
        else if(data.status == Msg_Status_Succ){
            [_indicator stopAnimating];
            //发送成功，说明 indicator 和 error 已不会显示在 label 中,可以开始显示已读回执label
            if(self.messageData.direction == MsgDirectionOutgoing
               && self.messageData.showReadReceipt
//               && self.messageData.innerMessage.getConversation.getType == TIM_C2C
               ){//只对发送的消息进行label显示。
                _readReceiptLabel.hidden = NO;
            }
            
        }
        else if(data.status == Msg_Status_Sending){
            [_indicator stopAnimating];
            _readReceiptLabel.hidden = YES;
        }
        self.retryView.image = nil;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.messageData.showName) {
        _nameLabel.mm_sizeToFitThan(1, 20);
        _nameLabel.hidden = NO;
    } else {
        _nameLabel.hidden = YES;
        _nameLabel.mm_height(0);
    }
    
    DUIMessageCellLayout *cellLayout = self.messageData.cellLayout;
    if (self.messageData.direction == MsgDirectionIncoming) {
        self.avatarView.mm_x = cellLayout.avatarInsets.left;
        self.avatarView.mm_y = cellLayout.avatarInsets.top;
        self.avatarView.mm_w = cellLayout.avatarSize.width;
        self.avatarView.mm_h = cellLayout.avatarSize.height;
        
        self.nameLabel.mm_top(self.avatarView.mm_y);
        
        CGSize csize = [self.messageData contentSize];
        CGFloat ctop = cellLayout.messageInsets.top + _nameLabel.mm_h;
        self.container.mm_left(cellLayout.messageInsets.left+self.avatarView.mm_maxX)
        .mm_top(ctop).mm_width(csize.width).mm_height(csize.height);
        
        self.nameLabel.mm_left(self.container.mm_x + 7) ;//与气泡对齐
        self.indicator.mm_sizeToFit().mm__centerY(self.container.mm_centerY).mm_left(self.container.mm_maxX + 8);
        self.retryView.frame = self.indicator.frame;
        self.readReceiptLabel.hidden = YES;
        
    } else {
        
        self.avatarView.mm_w = cellLayout.avatarSize.width;
        self.avatarView.mm_h = cellLayout.avatarSize.height;
        self.avatarView.mm_top(cellLayout.avatarInsets.top).mm_right(cellLayout.avatarInsets.right);
        
        self.nameLabel.mm_top(self.avatarView.mm_y);
        
        CGSize csize = [self.messageData contentSize];
        CGFloat ctop = cellLayout.messageInsets.top + _nameLabel.mm_h;
        self.container.mm_width(csize.width).mm_height(csize.height)
        .mm_right(cellLayout.messageInsets.right+self.mm_w-self.avatarView.mm_x).mm_top(ctop);
        
        self.nameLabel.mm_right(_container.mm_r);
        self.indicator.mm_sizeToFit().mm__centerY(_container.mm_centerY).mm_left(_container.mm_x - 8 - _indicator.mm_w);
        self.retryView.frame = self.indicator.frame;
        //这里不能像 retryView 一样直接使用 indicator 的设定，否则内容会显示不全。
        self.readReceiptLabel.mm_sizeToFitThan(0,self.indicator.mm_w).mm_bottom(self.container.mm_b + cellLayout.bubbleInsets.bottom).mm_left(_container.mm_x - 8 - _indicator.mm_w);
        
    }
    self.container.backgroundColor = [UIColor redColor];
}

//- (NSString *)getReadReceiptResult{
//    if([self.messageData.innerMessage isPeerReaded])
//        return @"已读";
//    else
//        return @"未读";
//}

- (void)prepareForReuse{
    [super prepareForReuse];
    //今后任何关于复用产生的 UI 问题，都可以在此尝试编码解决。
    _readReceiptLabel.text = @"未读";//一但消息复用，说明即将新消息出现，label内容改为未读。
}


@end




@implementation DUIBubbleMessageCellData

- (id)initWithDirection:(DMsgDirection)direction
{
    self = [super initWithDirection:direction];
    if (self) {
        if (direction == MsgDirectionIncoming) {
            _bubble = [[self class] incommingBubble];
            _highlightedBubble = [[self class] incommingHighlightedBubble];
            _bubbleTop = [[self class] incommingBubbleTop];
        } else {
            _bubble = [[self class] outgoingBubble];
            _highlightedBubble = [[self class] outgoingHighlightedBubble];
            _bubbleTop = [[self class] outgoingBubbleTop];
        }
    }
    return self;
}


static UIImage *sOutgoingBubble;

+ (UIImage *)outgoingBubble
{
    if (!sOutgoingBubble) {
        sOutgoingBubble = [[[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"SenderTextNodeBkg")] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{30,20,22,20}") resizingMode:UIImageResizingModeStretch];
    }
    return sOutgoingBubble;
}

+ (void)setOutgoingBubble:(UIImage *)outgoingBubble
{
    sOutgoingBubble = outgoingBubble;
}

static UIImage *sOutgoingHighlightedBubble;
+ (UIImage *)outgoingHighlightedBubble
{
    if (!sOutgoingHighlightedBubble) {
        sOutgoingHighlightedBubble = [[[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"SenderTextNodeBkgHL")] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{30,20,22,20}") resizingMode:UIImageResizingModeStretch];
    }
    return sOutgoingHighlightedBubble;
}

+ (void)setOutgoingHighlightedBubble:(UIImage *)outgoingHighlightedBubble
{
    sOutgoingHighlightedBubble = outgoingHighlightedBubble;
}

static UIImage *sIncommingBubble;
+ (UIImage *)incommingBubble
{
    if (!sIncommingBubble) {
        sIncommingBubble = [[[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"ReceiverTextNodeBkg")] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{30,22,22,22}") resizingMode:UIImageResizingModeStretch];
    }
    return sIncommingBubble;
}

+ (void)setIncommingBubble:(UIImage *)incommingBubble
{
    sIncommingBubble = incommingBubble;
}

static UIImage *sIncommingHighlightedBubble;
+ (UIImage *)incommingHighlightedBubble
{
    if (!sIncommingHighlightedBubble) {
        sIncommingHighlightedBubble =[[[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"ReceiverTextNodeBkgHL")] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{30,22,22,22}") resizingMode:UIImageResizingModeStretch];
    }
    return sIncommingHighlightedBubble;
}

+ (void)setIncommingHighlightedBubble:(UIImage *)incommingHighlightedBubble
{
    sIncommingHighlightedBubble = incommingHighlightedBubble;
}


static CGFloat sOutgoingBubbleTop = -2;

+ (CGFloat)outgoingBubbleTop
{
    return sOutgoingBubbleTop;
}

+ (void)setOutgoingBubbleTop:(CGFloat)outgoingBubble
{
    sOutgoingBubbleTop = outgoingBubble;
}

static CGFloat sIncommingBubbleTop = -2;

+ (CGFloat)incommingBubbleTop
{
    return sIncommingBubbleTop;
}

+ (void)setIncommingBubbleTop:(CGFloat)incommingBubbleTop
{
    sIncommingBubbleTop = incommingBubbleTop;
}


@end


@interface DUIBubbleMessageCell ()

//@property (nonatomic, strong, readwrite) DUIBubbleMessageCellData *bubbleData;

@end

@implementation DUIBubbleMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bubbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.container addSubview:_bubbleView];
        _bubbleView.mm_fill();
        _bubbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)fillWithData:(DUIBubbleMessageCellData *)data
{
    [super fillWithData:data];
    _bubbleData = data;
//    self.bubbleData = data;//error
    self.bubbleView.image = data.bubble;
//    NSLog(@"%s, %d,%f,%f", __func__, __LINE__, data.bubble.size.width, data.bubble.size.height);
    self.bubbleView.highlightedImage = data.highlightedBubble;
    self.bubbleView.backgroundColor = [UIColor greenColor];
//    NSLog(@"%s, %d, %f,%f,%f,%f", __func__, __LINE__, _bubbleView.frame.origin.x, _bubbleView.frame.origin.y
//          , _bubbleView.frame.size.width, _bubbleView.frame.size.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.bubbleView.mm_top(self.bubbleData.bubbleTop);//跑偏了
    self.retryView.mm__centerY(self.bubbleView.mm_centerY);
}

@end
