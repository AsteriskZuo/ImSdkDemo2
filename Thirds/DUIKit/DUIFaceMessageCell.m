//
//  DUIFaceMessageCell.m
//  ImSdkDemo
//
//  Created by zuoyu on 2020/3/4.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIFaceMessageCell.h"
#import "DHeader.h"
#import "DCommon.h"
#import "DUIImageCache.h"

#import "UIView+MMLayout.h"

@implementation DUIFaceMessageCellData

- (CGSize)contentSize
{
    UIImage *image = [[DUIImageCache sharedInstance] getResourceFromCacheWithAutoAdd:self.path];
    CGFloat imageHeight = image.size.height;
    CGFloat imageWidth = image.size.width;
    if(imageHeight > TFaceMessageCell_Image_Height_Max){
        imageHeight = TFaceMessageCell_Image_Height_Max;
        imageWidth = image.size.width / image.size.height * imageHeight;
    }
    if (imageWidth > TFaceMessageCell_Image_Width_Max){
        imageWidth = TFaceMessageCell_Image_Width_Max;
        imageHeight = image.size.height / image.size.width * imageWidth;
    }
    return CGSizeMake(imageWidth, imageHeight);
}

@end

@interface DUIFaceMessageCell ()

@end

@implementation DUIFaceMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _face = [[UIImageView alloc] init];
        _face.contentMode = UIViewContentModeScaleAspectFit;
        [self.container addSubview:_face];
        _face.mm_fill();
        _face.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}


- (void)fillWithData:(DUIFaceMessageCellData *)data
{
    //set data
    [super fillWithData:data];
    self.faceData = data;

    _face.image = [[DUIImageCache sharedInstance] getResourceFromCacheWithAutoAdd:data.path];;
}

@end
