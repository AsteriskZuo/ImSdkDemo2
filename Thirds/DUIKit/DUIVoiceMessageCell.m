//
//  DUIVoiceMessageCell.m
//  ImSdkDemo
//
//  Created by zuoyu on 2020/3/3.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIVoiceMessageCell.h"
#import "DUIMessageCellLayout.h"
#import "DUIImageCache.h"
#import "DCommon.h"
#import "DHeader.h"
#import "DHelper.h"
#import "DUIMessageCell.h"

#import "DIMMessage.h"

#import <AVFoundation/AVFoundation.h>

#import "ReactiveObjC.h"
#import "UIView+MMLayout.h"

@interface DUIVoiceMessageCellData () <AVAudioPlayerDelegate>

@property AVAudioPlayer *audioPlayer;
@property NSString *wavPath;

@end

@implementation DUIVoiceMessageCellData

- (instancetype)initWithDirection:(DMsgDirection)direction
{
    self = [super initWithDirection:direction];
    if (self) {
        if (direction == MsgDirectionIncoming) {
            self.cellLayout = [DIncommingVoiceCellLayout new];
            _voiceImage = [[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"message_voice_receiver_normal")];
            _voiceAnimationImages = [NSArray arrayWithObjects:
                                     [[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"message_voice_receiver_playing_1")],
                                     [[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"message_voice_receiver_playing_2")],
                                     [[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"message_voice_receiver_playing_3")], nil];
            _voiceTop = [[self class] incommingVoiceTop];
        } else {
            self.cellLayout = [DOutgoingVoiceCellLayout new];
            
            _voiceImage = [[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"message_voice_sender_normal")];
            _voiceAnimationImages = [NSArray arrayWithObjects:
                                     [[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"message_voice_sender_playing_1")],
                                     [[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"message_voice_sender_playing_2")],
                                     [[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"message_voice_sender_playing_3")], nil];
            _voiceTop = [[self class] outgoingVoiceTop];
        }
    }
    
    return self;
}

- (void)stopVoiceMessage
{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    self.isPlaying = NO;
}

- (void)playVoiceMessage
{
    if (self.isPlaying) {
        return;
    }
    self.isPlaying = YES;
    
//    if(self.innerMessage.customInt == 0)
//        self.innerMessage.customInt = 1;

    BOOL isExist = NO;
    NSString *path = [self getVoicePath:&isExist];
    if(isExist) {
        [self playInternal:path];
    } else {
        if(self.isDownloading) {
            return;
        }
        //网络下载
        DIMSoundElem *imSound = [self getIMSoundElem];
        self.isDownloading = YES;
        @weakify(self)
        [imSound getSound:path succ:^{
            @strongify(self)
            self.isDownloading = NO;
            [self playInternal:path];;
        } fail:^(int code, NSString *msg) {
            @strongify(self)
            self.isDownloading= NO;
            [self stopVoiceMessage];
        }];
    }
}

- (NSString *)getVoicePath:(BOOL *)isExist
{
    NSString *path = nil;
    BOOL isDir = false;
    *isExist = NO;
    if(self.direction == MsgDirectionOutgoing) {
        //上传方本地是否有效
        path = [NSString stringWithFormat:@"%@%@", TUIKit_Voice_Path, _path.lastPathComponent];
        if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]){
            if(!isDir){
                *isExist = YES;
            }
        }
    }

    if(!*isExist) {
        //查看本地是否存在
        path = [NSString stringWithFormat:@"%@%@.amr", TUIKit_Voice_Path, _uuid];
        if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]){
            if(!isDir){
                *isExist = YES;
            }
        }
    }
    return path;
}

- (void)playInternal:(NSString *)path
{
    if (!self.isPlaying)
        return;
    //play current
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.delegate = self;
    bool result = [self.audioPlayer play];
    if (!result) {
        self.wavPath = [[path stringByDeletingPathExtension] stringByAppendingString:@".wav"];
        [DHelper convertAmr:path toWav:self.wavPath];
        NSURL *url = [NSURL fileURLWithPath:self.wavPath];
        [self.audioPlayer stop];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer play];
    }
}

- (DIMSoundElem *)getIMSoundElem
{
    DIMMessage *imMsg = self.innerMessage;
    for (int i = 0; i < imMsg.elemCount; ++i) {
        DIMElem *imElem = [imMsg getElem:i];
        if([imElem isKindOfClass:[DIMSoundElem class]]){
            DIMSoundElem *imSoundElem = (DIMSoundElem *)imElem;
            return imSoundElem;
        }
    }
    return nil;
}

static CGFloat s_incommingVoiceTop = 12;

+ (void)setIncommingVoiceTop:(CGFloat)incommingVoiceTop
{
    s_incommingVoiceTop = incommingVoiceTop;
}

+ (CGFloat)incommingVoiceTop
{
    return s_incommingVoiceTop;
}

static CGFloat s_outgoingVoiceTop = 12;

+ (void)setOutgoingVoiceTop:(CGFloat)outgoingVoiceTop
{
    s_outgoingVoiceTop = outgoingVoiceTop;
}

+ (CGFloat)outgoingVoiceTop
{
    return s_outgoingVoiceTop;
}

- (CGSize)contentSize
{
    CGFloat bubbleWidth = TVoiceMessageCell_Back_Width_Min + self.duration / TVoiceMessageCell_Max_Duration * Screen_Width;
    if(bubbleWidth > TVoiceMessageCell_Back_Width_Max){
        bubbleWidth = TVoiceMessageCell_Back_Width_Max;
    }

    CGFloat bubbleHeight = TVoiceMessageCell_Duration_Size.height;
    if (self.direction == MsgDirectionIncoming) {
        bubbleWidth = MAX(bubbleWidth, [DUIBubbleMessageCellData incommingBubble].size.width);
        bubbleHeight = [DUIBubbleMessageCellData incommingBubble].size.height;
    } else {
        bubbleWidth = MAX(bubbleWidth, [DUIBubbleMessageCellData outgoingBubble].size.width);
        bubbleHeight = [DUIBubbleMessageCellData outgoingBubble].size.height;
    }
    return CGSizeMake(bubbleWidth+TVoiceMessageCell_Duration_Size.width, bubbleHeight);
//    CGFloat width = bubbleWidth + TVoiceMessageCell_Duration_Size.width;
//    return CGSizeMake(width, TVoiceMessageCell_Duration_Size.height);
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.isPlaying = NO;
    [[NSFileManager defaultManager] removeItemAtPath:self.wavPath error:nil];//为什么？
}

@end

@implementation DUIVoiceMessageCell

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
        _voice = [[UIImageView alloc] init];
        _voice.animationDuration = 1;
        [self.bubbleView addSubview:_voice];

        _duration = [[UILabel alloc] init];
        _duration.font = [UIFont systemFontOfSize:12];
        _duration.textColor = [UIColor grayColor];
        [self.bubbleView addSubview:_duration];

        _voiceReadPoint = [[UIImageView alloc] init];
        _voiceReadPoint.backgroundColor = [UIColor redColor];
        _voiceReadPoint.frame = CGRectMake(0, 0, 5, 5);
        _voiceReadPoint.hidden = YES;
        [_voiceReadPoint.layer setCornerRadius:_voiceReadPoint.frame.size.width/2];
        [_voiceReadPoint.layer setMasksToBounds:YES];
        [self.bubbleView addSubview:_voiceReadPoint];
    }
    return self;
}

- (void)fillWithData:(DUIVoiceMessageCellData *)data;
{
    //set data
    [super fillWithData:data];
    self.voiceData = data;
    
    if (data.duration > 0) {
        _duration.text = [NSString stringWithFormat:@"%ld\"", (long)data.duration];
    } else {
        _duration.text = @"1\"";    // 显示0秒容易产生误解
    }
    _voice.image = data.voiceImage;
    _voice.animationImages = data.voiceAnimationImages;
    
    //voiceReadPoint
    //此处0为语音消息未播放，1为语音消息已播放
    //发送出的消息，不展示红点
    if(self.voiceData.innerMessage.customInt == 0 && self.voiceData.direction == MsgDirectionIncoming)
        self.voiceReadPoint.hidden = NO;

    //animate
    @weakify(self)
    [[RACObserve(data, isPlaying) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *x) {
        @strongify(self)
        if ([x boolValue]) {
            [self.voice startAnimating];
        } else {
            [self.voice stopAnimating];
        }
    }];
    if (data.direction == MsgDirectionIncoming) {
        _duration.textAlignment = NSTextAlignmentLeft;
    } else {
        _duration.textAlignment = NSTextAlignmentRight;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.duration.mm_sizeToFitThan(10,TVoiceMessageCell_Duration_Size.height).mm__centerY(self.bubbleView.mm_h/2 - 1);
    
    self.voice.mm_sizeToFit().mm_top(self.voiceData.voiceTop);
    
    if (self.voiceData.direction == MsgDirectionOutgoing) {
        self.bubbleView.mm_left(self.duration.mm_w).mm_flexToRight(0);
        self.duration.mm_left(-self.duration.mm_w);
        self.voice.mm_right(self.voiceData.cellLayout.bubbleInsets.right);
        self.voiceReadPoint.hidden = YES;
    } else {
        self.bubbleView.mm_left(0).mm_flexToRight(self.duration.mm_w);
        self.duration.mm_right(-self.duration.mm_w);
        self.voice.mm_left(self.voiceData.cellLayout.bubbleInsets.left);
        self.voiceReadPoint.mm_bottom(self.duration.mm_y + self.duration.mm_h).mm_left(self.duration.mm_x);
    }
}

@end
