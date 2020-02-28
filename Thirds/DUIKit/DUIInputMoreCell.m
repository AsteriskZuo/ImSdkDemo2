//
//  DUIInputMoreCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/22.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIInputMoreCell.h"
#import "DCommon.h"
#import "DHeader.h"


static DUIInputMoreCellData *TUI_Photo_MoreCell;
static DUIInputMoreCellData *TUI_Picture_MoreCell;
static DUIInputMoreCellData *TUI_Video_MoreCell;
static DUIInputMoreCellData *TUI_File_MoreCell;

@implementation DUIInputMoreCellData

+ (DUIInputMoreCellData *)pictureData
{
    if (!TUI_Picture_MoreCell) {
        TUI_Picture_MoreCell = [[DUIInputMoreCellData alloc] init];
        TUI_Picture_MoreCell.title = @"拍摄";
        TUI_Picture_MoreCell.image = [UIImage imageNamed:TUIKitResource(@"more_camera")];

    }
    return TUI_Picture_MoreCell;
}

+ (void)setPictureData:(DUIInputMoreCellData *)cameraData
{
    TUI_Picture_MoreCell = cameraData;
}

+ (DUIInputMoreCellData *)photoData
{
    if (!TUI_Photo_MoreCell) {
        TUI_Photo_MoreCell = [[DUIInputMoreCellData alloc] init];
        TUI_Photo_MoreCell.title = @"相册";
        TUI_Photo_MoreCell.image = [UIImage imageNamed:TUIKitResource(@"more_picture")];
    }
    return TUI_Photo_MoreCell;
}

+ (void)setPhotoData:(DUIInputMoreCellData *)pictureData
{
    TUI_Photo_MoreCell = pictureData;
}

+ (DUIInputMoreCellData *)videoData
{
    if (!TUI_Video_MoreCell) {
        TUI_Video_MoreCell = [[DUIInputMoreCellData alloc] init];
        TUI_Video_MoreCell.title = @"视频";
        TUI_Video_MoreCell.image = [UIImage imageNamed:TUIKitResource(@"more_video")];
    }
    return TUI_Video_MoreCell;
}

+ (void)setVideoData:(DUIInputMoreCellData *)videoData
{
    TUI_Video_MoreCell = videoData;
}

+ (DUIInputMoreCellData *)fileData
{
    if (!TUI_File_MoreCell) {
        TUI_File_MoreCell = [[DUIInputMoreCellData alloc] init];
        TUI_File_MoreCell.title = @"文件";
        TUI_File_MoreCell.image = [UIImage imageNamed:TUIKitResource(@"more_file")];
    }
    return TUI_File_MoreCell;
}

+ (void)setFileData:(DUIInputMoreCellData *)fileData
{
    TUI_File_MoreCell = fileData;
}

@end

@implementation DUIInputMoreCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _image = [[UIImageView alloc] init];
    _image.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_image];

    _title = [[UILabel alloc] init];
    [_title setFont:[UIFont systemFontOfSize:14]];
    [_title setTextColor:[UIColor grayColor]];
    _title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title];
}

- (void)fillWithData:(DUIInputMoreCellData *)data
{
    //set data
    _data = data;
    _image.image = data.image;
    [_title setText:data.title];
    //update layout
    CGSize menuSize = TMoreCell_Image_Size;
    _image.frame = CGRectMake(0, 0, menuSize.width, menuSize.height);
    _title.frame = CGRectMake(0, _image.frame.origin.y + _image.frame.size.height, _image.frame.size.width, TMoreCell_Title_Height);
}

+ (CGSize)getSize
{
    CGSize menuSize = TMoreCell_Image_Size;
    return CGSizeMake(menuSize.width, menuSize.height + TMoreCell_Title_Height);
}


@end
