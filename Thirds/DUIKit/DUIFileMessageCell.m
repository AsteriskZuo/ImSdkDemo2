//
//  DUIFileMessageCell.m
//  ImSdkDemo
//
//  Created by zuoyu on 2020/3/4.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIFileMessageCell.h"
#import "DHeader.h"
#import "DCommon.h"
#import "DUIImageCache.h"

#import "DIMMessage.h"

#import "ReactiveObjC.h"

@interface DUIFileMessageCellData ()
@property (nonatomic, strong) NSMutableArray *progressBlocks;
@property (nonatomic, strong) NSMutableArray *responseBlocks;
@end

@implementation DUIFileMessageCellData

- (id)init
{
    if(self = [super init]) {
        _uploadProgress = 100;
        _downladProgress = 100;
        _isDownloading = NO;
        _progressBlocks = [NSMutableArray array];
        _responseBlocks = [NSMutableArray array];
    }
    return self;
}

- (void)downloadFile
{
    BOOL isExist = NO;
    NSString *path = [self getFilePath:&isExist];
    if(isExist){
        return;
    }
    if (self.isDownloading)
        return;
    self.isDownloading = YES;

    //网络下载
    @weakify(self)
    DIMFileElem *imFile = [self getIMFileElem];
    [imFile getFile:path progress:^(NSInteger curSize, NSInteger totalSize) {
        @strongify(self)
        [self updateDownalodProgress:curSize * 100 / totalSize];
    } succ:^{
        @strongify(self)
        self.isDownloading = NO;
        [self updateDownalodProgress:100];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.path = path;
        });
    } fail:^(int code, NSString *msg) {
        @strongify(self)
        self.isDownloading = NO;
    }];
}

- (BOOL)isLocalExist
{
    BOOL isExist;
    [self getFilePath:&isExist];
    return isExist;
}

- (NSString *)getFilePath:(BOOL *)isExist
{
    NSString *path = nil;
    BOOL isDir = NO;
    *isExist = NO;
    if(self.direction == MsgDirectionOutgoing){
        //上传方本地原图是否有效
        path = [NSString stringWithFormat:@"%@%@", TUIKit_File_Path, _path.lastPathComponent];
        if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]){
            if(!isDir){
                *isExist = YES;
            }
        }
    }

    if(!*isExist){
        //查看本地是否存在
        path = [NSString stringWithFormat:@"%@%@", TUIKit_File_Path, _fileName];
        if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]){
            if(!isDir){
                *isExist = YES;
            }
        }
    }
    if (*isExist) {
        _path = path;
    }

    // TODO: uuid

    return path;
}

- (DIMFileElem *)getIMFileElem
{
    DIMMessage *imMsg = self.innerMessage;
    for (int i = 0; i < imMsg.elemCount; ++i) {
        DIMElem *imElem = [imMsg getElem:i];
        if([imElem isKindOfClass:[DIMFileElem class]]){
            DIMFileElem *imFileElem = (DIMFileElem *)imElem;
            return imFileElem;
        }
    }
    return nil;
}

- (void)updateDownalodProgress:(NSUInteger)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.downladProgress = progress;
    });
}

- (CGSize)contentSize
{
    return TFileMessageCell_Container_Size;
}


@end

@implementation DUIFileMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.container.backgroundColor = [UIColor whiteColor];
        self.container.layer.cornerRadius = 5;
        [self.container.layer setMasksToBounds:YES];

        _fileName = [[UILabel alloc] init];
        _fileName.font = [UIFont systemFontOfSize:15];
        _fileName.textColor = [UIColor blackColor];
        [self.container addSubview:_fileName];

        _length = [[UILabel alloc] init];
        _length.font = [UIFont systemFontOfSize:12];
        _length.textColor = [UIColor grayColor];
        [self.container addSubview:_length];

        _image = [[UIImageView alloc] init];
        _image.image = [[DUIImageCache sharedInstance] getResourceFromCache:TUIKitResource(@"msg_file")];
        _image.contentMode = UIViewContentModeScaleAspectFit;
        [self.container addSubview:_image];
    }
    return self;
}

- (void)fillWithData:(DUIFileMessageCellData *)data
{
    [super fillWithData:data];
    self.fileData = data;
    _fileName.text = data.fileName;
    _length.text = [self formatLength:data.length];

    @weakify(self)

    RACSignal *progressSignal;
    if (data.direction == MsgDirectionIncoming) {
        progressSignal = [[RACObserve(data, uploadProgress) takeUntil:self.rac_prepareForReuseSignal] distinctUntilChanged];
    } else {
        progressSignal = [[RACObserve(data, uploadProgress) takeUntil:self.rac_prepareForReuseSignal] distinctUntilChanged];
    }
    [progressSignal subscribeNext:^(NSNumber *x) {
        @strongify(self)
        int progress = [x intValue];
        if (progress >= 100 || progress == 0) {
            [self.indicator stopAnimating];
        } else {
            [self.indicator startAnimating];
        }
    }];
}

- (NSString *)formatLength:(long)length
{
    double len = length;
    NSArray *array = [NSArray arrayWithObjects:@"Bytes", @"K", @"M", @"G", @"T", nil];
    int factor = 0;
    while (len > 1024) {
        len /= 1024;
        factor++;
        if(factor >= 4){
            break;
        }
    }
    return [NSString stringWithFormat:@"%4.2f%@", len, array[factor]];
}

- (void)layoutSubviews
{    
    [super layoutSubviews];

    //不区分发送和接收
    CGSize containerSize = [self.fileData contentSize];
    CGFloat imageHeight = containerSize.height - 2 * TFileMessageCell_Margin;
    CGFloat imageWidth = imageHeight;
    _image.frame = CGRectMake(containerSize.width - TFileMessageCell_Margin - imageWidth, TFileMessageCell_Margin, imageWidth, imageHeight);
    CGFloat textWidth = _image.frame.origin.x - 2 * TFileMessageCell_Margin;
    CGSize nameSize = [_fileName sizeThatFits:containerSize];
    _fileName.frame = CGRectMake(TFileMessageCell_Margin, TFileMessageCell_Margin, textWidth, nameSize.height);
    CGSize lengthSize = [_length sizeThatFits:containerSize];
    _length.frame = CGRectMake(TFileMessageCell_Margin, _fileName.frame.origin.y + nameSize.height + TFileMessageCell_Margin * 0.5, textWidth, lengthSize.height);
}

@end
