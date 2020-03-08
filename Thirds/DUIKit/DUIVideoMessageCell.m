//
//  DUIVideoMessageCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/3/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIVideoMessageCell.h"
#import "DHeader.h"
#import "DCommon.h"
#import "DHelper.h"
#import "DUIImageCache.h"

#import "UIView+MMLayout.h"
#import "ReactiveObjC.h"

#import <CLIMSDK_ios/CLIMSDK_ios.h>

@implementation DUIVideoItem



@end

@implementation DUISnapshotItem



@end

#define TVideo_Block_Progress @"TVideo_Block_Progress";
#define TVideo_Block_Response @"TVideo_Block_Response";


@interface DUIVideoMessageCellData ()

@property (nonatomic, assign) BOOL isDownloadingSnapshot;
@property (nonatomic, assign) BOOL isDownloadingVideo;

@end


@implementation DUIVideoMessageCellData

- (instancetype)init
{
    if (self = [super init]) {
        _isDownloadingVideo = NO;
        _isDownloadingSnapshot = NO;
        _thumbProgress = 100;
        _videoProgress = 100;
        _uploadProgress = 100;
    }
    return self;
}

- (void)downloadThumb
{
    BOOL isExist = NO;
    NSString *path = [self getSnapshotPath:&isExist];
    if (isExist) {
        [self decodeThumb];
        return;
    }

    if(self.isDownloadingSnapshot) {
        return;
    }
    self.isDownloadingSnapshot = YES;


    //网络下载
//    @weakify(self)
//    DIMSnapshot *imSnapshot = [self getIMSnapshot];
//    [imSnapshot getImage:path progress:^(NSInteger curSize, NSInteger totalSize) {
//        [self updateThumbProgress:curSize * 100 / totalSize];
//    } succ:^{
//        @strongify(self)
//        self.isDownloadingSnapshot = NO;
//        [self updateThumbProgress:100];
//        [self decodeThumb];
//    } fail:^(int code, NSString *msg) {
//        @strongify(self)
//        self.isDownloadingSnapshot = NO;
//    }];
}

- (void)downloadVideo
{
    BOOL isExist = NO;
    NSString *path = [self getVideoPath:&isExist];
    if (isExist) {
        return;
    }

    if(self.isDownloadingVideo) {
        return;
    }
    self.isDownloadingVideo = YES;

    //网络下载
//    @weakify(self)
//    DIMVideo *imVideo = [self getIMVideo];
//    [imVideo getVideo:path progress:^(NSInteger curSize, NSInteger totalSize) {
//        @strongify(self)
//        [self updateVideoProgress:curSize * 100 / totalSize];
//    } succ:^{
//        @strongify(self)
//        self.isDownloadingVideo = NO;
//        [self updateThumbProgress:100];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.videoPath = path;
//        });
//    } fail:^(int code, NSString *msg) {
//        @strongify(self)
//        self.isDownloadingVideo = NO;
//    }];
}

- (BOOL)isVideoExist
{
    BOOL isExist;
    [self getVideoPath:&isExist];
    return isExist;
}

#pragma mark - private method

- (NSString *)getSnapshotPath:(BOOL *)isExist
{
    NSString *path = nil;
    BOOL isDir = NO;
    *isExist = NO;
    if(self.direction == MsgDirectionOutgoing){
        //上传方本地是否有效
        path = [NSString stringWithFormat:@"%@%@", TUIKit_Video_Path, _snapshotPath.lastPathComponent];
        if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]){
            if(!isDir){
                *isExist = YES;
            }
        }
    }

    if(!*isExist){
        if(_snapshotItem){
            //查看本地是否存在
            path = [NSString stringWithFormat:@"%@%@", TUIKit_Video_Path, _snapshotItem.uuid];
            path = [TUIKit_Video_Path stringByAppendingString:_snapshotItem.uuid];
            if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]){
                if(!isDir){
                    *isExist = YES;
                }
            }
        }
    }

    return path;
}

- (void)decodeThumb
{
    BOOL isExist = NO;
    NSString *path = [self getSnapshotPath:&isExist];
    if (!isExist) {
        return;
    }
    [DHelper asyncDecodeImage:path complete:^(NSString *path, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.thumbImage = image;
            self.thumbProgress = 100;
        });
    }];
}

//- (DIMSnapshot *)getIMSnapshot
//{
//    DIMMessage *imMsg = self.innerMessage;
//    for (int i = 0; i < imMsg.elemCount; ++i) {
//        DIMElem *imElem = [imMsg getElem:i];
//        if([imElem isKindOfClass:[DIMVideoElem class]]){
//            DIMVideoElem *imVideoElem = (DIMVideoElem *)imElem;
//            return imVideoElem.snapshot;
//        }
//    }
//    return nil;
//}

- (void)updateVideoProgress:(NSUInteger)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoProgress = progress;
    });
}

//- (DIMVideo *)getIMVideo
//{
//    DIMMessage *imMsg = self.innerMessage;
//    for (int i = 0; i < imMsg.elemCount; ++i) {
//        DIMElem *imElem = [imMsg getElem:i];
//        if([imElem isKindOfClass:[DIMVideoElem class]]){
//            DIMVideoElem *imVideoElem = (DIMVideoElem *)imElem;
//            return imVideoElem.video;
//        }
//    }
//    return nil;
//}

- (NSString *)getVideoPath:(BOOL *)isExist
{
    NSString *path = nil;
    BOOL isDir = NO;
    *isExist = NO;
    if(self.direction == MsgDirectionOutgoing){
        //上传方本地原图是否有效
        path = [NSString stringWithFormat:@"%@%@", TUIKit_Video_Path, _videoPath.lastPathComponent];
        if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]){
            if(!isDir){
                *isExist = YES;
            }
        }
    }

    if(!*isExist){
        if(_videoItem){
            //查看本地是否存在
            path = [NSString stringWithFormat:@"%@%@.%@", TUIKit_Video_Path, _videoItem.uuid, _videoItem.type];
            if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]){
                if(!isDir){
                    *isExist = YES;
                }
            }
        }
    }
    if (*isExist) {
        _videoPath = path;
    }

    return path;
}

- (void)updateThumbProgress:(NSUInteger)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.thumbProgress = progress;
    });
}


#pragma mark - override method

- (CGSize)contentSize
{
    CGSize size = CGSizeZero;
    BOOL isDir = NO;
    if(![self.snapshotPath isEqualToString:@""] &&
       [[NSFileManager defaultManager] fileExistsAtPath:self.snapshotPath isDirectory:&isDir]){
        if(!isDir){
            size = [UIImage imageWithContentsOfFile:self.snapshotPath].size;
        }
    }
    else{
        size = self.snapshotItem.size;
    }
    if(CGSizeEqualToSize(size, CGSizeZero)){
        return size;
    }
    if(size.height > size.width){
        size.width = size.width / size.height * TVideoMessageCell_Image_Height_Max;
        size.height = TVideoMessageCell_Image_Height_Max;
    }
    else{
        size.height = size.height / size.width * TVideoMessageCell_Image_Width_Max;
        size.width = TVideoMessageCell_Image_Width_Max;
    }
    return size;
}

@end


@implementation DUIVideoMessageCell

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
        _thumb = [[UIImageView alloc] init];
        _thumb.layer.cornerRadius = 5.0;
        [_thumb.layer setMasksToBounds:YES];
        _thumb.contentMode = UIViewContentModeScaleAspectFit;
        _thumb.backgroundColor = [UIColor whiteColor];
        [self.container addSubview:_thumb];
        _thumb.mm_fill();
        _thumb.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        CGSize playSize = TVideoMessageCell_Play_Size;
        _play = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, playSize.width, playSize.height)];
        _play.contentMode = UIViewContentModeScaleAspectFit;
        _play.image = [[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"play_normal")];
        [self.container addSubview:_play];


        _duration = [[UILabel alloc] init];
        _duration.textColor = [UIColor whiteColor];
        _duration.font = [UIFont systemFontOfSize:12];
        [self.container addSubview:_duration];


        _progress = [[UILabel alloc] init];
        _progress.textColor = [UIColor whiteColor];
        _progress.font = [UIFont systemFontOfSize:15];
        _progress.textAlignment = NSTextAlignmentCenter;
        _progress.layer.cornerRadius = 5.0;
        _progress.hidden = YES;
        _progress.backgroundColor = TVideoMessageCell_Progress_Color;
        [_progress.layer setMasksToBounds:YES];
        [self.container addSubview:_progress];
        _progress.mm_fill();
        _progress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)fillWithData:(DUIVideoMessageCellData *)data;
{
    [super fillWithData:data];
    self.videoData = data;
    _thumb.image = nil;
    if(data.thumbImage == nil){
        [data downloadThumb];
    }

    @weakify(self)
    [[RACObserve(data, thumbImage) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(UIImage *thumbImage) {
        @strongify(self)
        if (thumbImage) {
            self.thumb.image = thumbImage;
        }
    }];

    _duration.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)data.videoItem.duration / 60, (long)data.videoItem.duration % 60];;

    if (data.direction == MsgDirectionIncoming) {
        [[[RACObserve(data, thumbProgress) takeUntil:self.rac_prepareForReuseSignal] distinctUntilChanged] subscribeNext:^(NSNumber *x) {
            @strongify(self)
            int progress = [x intValue];
            self.progress.text = [NSString stringWithFormat:@"%d%%", progress];
            self.progress.hidden = (progress >= 100 || progress == 0);
            self.play.hidden = !self.progress.hidden;
        }];
    } else {
        [[[RACObserve(data, uploadProgress) takeUntil:self.rac_prepareForReuseSignal] distinctUntilChanged] subscribeNext:^(NSNumber *x) {
            @strongify(self)
            int progress = [x intValue];
            self.play.hidden = !self.progress.hidden;
            if (progress >= 100 || progress == 0) {
                [self.indicator stopAnimating];
            } else {
                [self.indicator startAnimating];
            }
        }];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _play.mm_width(TVideoMessageCell_Play_Size.width).mm_height(TVideoMessageCell_Play_Size.height).mm_center();
    _duration.mm_sizeToFitThan(20, 20).mm_right(TVideoMessageCell_Margin_3).mm_bottom(TVideoMessageCell_Margin_3);
}

@end
