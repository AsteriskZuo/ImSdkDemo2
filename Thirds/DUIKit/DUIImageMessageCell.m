//
//  DUIImageMessageCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/3/1.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIImageMessageCell.h"
#import "DHeader.h"
#import "DHelper.h"

#import "SDWebImage.h"
#import "DUIImageCache.h"
#import "MMLayout/UIView+MMLayout.h"
#import "ReactiveObjC.h"

#import <CLIMSDK_ios/CLIMSDK_ios.h>

@implementation DUIImageItem



@end

@interface DUIImageMessageCellData ()

@property (nonatomic, assign) BOOL isDownloading;

@end

@implementation DUIImageMessageCellData

- (instancetype)init
{
    if (self = [super init]) {
        _length = 0;
        _items = [[NSMutableArray alloc] init];
        _thumbProgress = 100;
        _largeProgress = 100;
        _originProgress = 100;
        _uploadProgress = 100;
    }
    return self;
}

- (void)downloadImage:(DUIImageType)type
{
    BOOL fileIsExist = NO;
    NSString* localPath = [self getImagePath:type isExist:&fileIsExist];
    if (fileIsExist) {
        [self decodeImage:type];
    } else {
        if(self.isDownloading) {
            return;
        }
        self.isDownloading = YES;

        CLIMImage* imImage = [self getIMImage:type];
        @weakify(self);
        [imImage getImage:nil progress:^(NSInteger curSize, NSInteger totalSize) {
            @strongify(self);
            [self updateProgress:curSize*100/totalSize withType:type];
        } succ:^{
            @strongify(self);
            self.isDownloading = NO;
            [self updateProgress:100 withType:type];
            [self decodeImage:type];
        } fail:^(int code, NSString *message) {
            @strongify(self);
            self.isDownloading = NO;
        }];
    }
    
}

- (void)updateProgress:(NSUInteger)progress withType:(DUIImageType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (type == TImage_Type_Thumb)
            self.thumbProgress = progress;
        if (type == TImage_Type_Large)
            self.largeProgress = progress;
        if (type == TImage_Type_Origin)
            self.originProgress = progress;
    });
}

- (void)decodeImage:(DUIImageType)type
{
    BOOL isExist = NO;
    NSString *path = [self getImagePath:type isExist:&isExist];
    if(!isExist)
    {
        return;
    }

    void (^finishBlock)(UIImage *) = ^(UIImage *image){
        if (type == TImage_Type_Thumb) {
            self.thumbImage = image;
            self.thumbProgress = 100;
            self.uploadProgress = 100;
        }
        if (type == TImage_Type_Large) {
            self.largeImage = image;
            self.largeProgress = 100;
        }
        if (type == TImage_Type_Origin) {
            self.originImage = image;
            self.originProgress = 100;
        }
    };

    NSString *cacheKey = [path substringFromIndex:TUIKit_Image_Path.length];


    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:cacheKey];
    if (cacheImage) {
        finishBlock(cacheImage);
    } else {
        [DHelper asyncDecodeImage:path complete:^(NSString *path, UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![path containsString:@".gif"]) { // gif 图片过大, 不在内存进行缓存
                    [[SDImageCache sharedImageCache] storeImageToMemory:image forKey:cacheKey];
                }
                finishBlock(image);
            });
        }];
    }
}

- (NSString *)getImagePath:(DUIImageType)type isExist:(BOOL *)isExist
{
    CLIMImage* imageItem = [self getIMImage:type];
    NSString* localPath = [imageItem getLocalPath];
    *isExist = [DHelper fileIsExist:localPath];
    return localPath;
}

- (DUIImageItem *)getTImageItem:(DUIImageType)type
{
    for (DUIImageItem *item in self.items) {
        if(item.type == type){
            return item;
        }
    }
    return nil;
}

- (CLIMImage *)getIMImage:(DUIImageType)type
{
    if ([self.innerMessage isKindOfClass:[CLIMImageMessage class]]) {
        CLIMImageMessage* imageMessage = (CLIMImageMessage* )self.innerMessage;
        for (CLIMImage* imageItem in imageMessage.imageList) {
            if (CLIM_IMAGE_TYPE_ORIGIN == imageItem.type
                && TImage_Type_Origin == type) {
                return imageItem;
            } else if (CLIM_IMAGE_TYPE_LARGE == imageItem.type
                && TImage_Type_Large == type) {
                return imageItem;
            } else if (CLIM_IMAGE_TYPE_THUMB == imageItem.type
                && TImage_Type_Thumb == type) {
                return imageItem;
            }
        }
    }
    return nil;
}

- (CGSize)contentSize
{
    CGSize size = CGSizeZero;
    BOOL isDir = NO;
    if(![self.path isEqualToString:@""] &&
       [[NSFileManager defaultManager] fileExistsAtPath:self.path isDirectory:&isDir]){
        if(!isDir){
            size = [UIImage imageWithContentsOfFile:self.path].size;
        }
    }

    if (CGSizeEqualToSize(size, CGSizeZero)) {
        for (DUIImageItem *item in self.items) {
            if(item.type == TImage_Type_Thumb){
                size = item.size;
            }
        }
    }
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        for (DUIImageItem *item in self.items) {
            if(item.type == TImage_Type_Large){
                size = item.size;
            }
        }
    }
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        for (DUIImageItem *item in self.items) {
            if(item.type == TImage_Type_Origin){
                size = item.size;
            }
        }
    }

    if(CGSizeEqualToSize(size, CGSizeZero)){
        return size;
    }
    if(size.height > size.width){
        size.width = size.width / size.height * TImageMessageCell_Image_Height_Max;
        size.height = TImageMessageCell_Image_Height_Max;
    } else {
        size.height = size.height / size.width * TImageMessageCell_Image_Width_Max;
        size.width = TImageMessageCell_Image_Width_Max;
    }
    return size;
}

@end


@implementation DUIImageMessageCell

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
    _thumb = [[UIImageView alloc] init];
    _thumb.layer.cornerRadius = 5.0;
    [_thumb.layer setMasksToBounds:YES];
    _thumb.contentMode = UIViewContentModeScaleAspectFit;
    _thumb.backgroundColor = [UIColor whiteColor];
    [self.container addSubview:_thumb];
    _thumb.mm_fill();
    _thumb.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    _progress = [[UILabel alloc] init];
    _progress.textColor = [UIColor whiteColor];
    _progress.font = [UIFont systemFontOfSize:15];
    _progress.textAlignment = NSTextAlignmentCenter;
    _progress.layer.cornerRadius = 5.0;
    _progress.hidden = YES;
    _progress.backgroundColor = TImageMessageCell_Progress_Color;
    [_progress.layer setMasksToBounds:YES];
    [self.container addSubview:_progress];
    _progress.mm_fill();
    _progress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)fillWithData:(DUIImageMessageCellData *)data
{
    [super fillWithData:data];
    self.imageData = data;
    _thumb.image = nil;
    if(data.thumbImage == nil) {
        [data downloadImage:TImage_Type_Thumb];
    }

    @weakify(self)
    [[RACObserve(data, thumbImage) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(UIImage *thumbImage) {
        @strongify(self)
        if (thumbImage) {
            self.thumb.image = thumbImage;
//            self.thumb.backgroundColor = [UIColor redColor];
//            self.container.backgroundColor = [UIColor greenColor];
//
//            NSLog(@"%s,%d,thumb.size=%f,%f", __func__, __LINE__, self.thumb.image.size.width, self.thumb.image.size.height);
//            NSLog(@"%s,%d,container.size=%f,%f, origin=%f,%f", __func__, __LINE__, self.container.frame.size.width, self.container.frame.size.height, self.container.frame.origin.x, self.container.frame.origin.y);
        }
    }];
    
    if (data.direction == MsgDirectionIncoming) {
        [[[RACObserve(data, thumbProgress) takeUntil:self.rac_prepareForReuseSignal] distinctUntilChanged] subscribeNext:^(NSNumber *x) {
            @strongify(self)
            int progress = [x intValue];
            self.progress.text = [NSString stringWithFormat:@"%d%%", progress];
            self.progress.hidden = (progress >= 100 || progress == 0);
        }];
    } else {
        [[[RACObserve(data, uploadProgress) takeUntil:self.rac_prepareForReuseSignal] distinctUntilChanged] subscribeNext:^(NSNumber *x) {
            @strongify(self)
            int progress = [x intValue];
            if (progress >= 100 || progress == 0) {
                [self.indicator stopAnimating];
            } else {
                [self.indicator startAnimating];
            }
        }];
    }
}

@end
