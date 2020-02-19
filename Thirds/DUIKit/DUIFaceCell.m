//
//  DUIFaceCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/15.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIFaceCell.h"
#import "DUIImageCache.h"

@implementation DUIFaceCellData



@end

@implementation DUIFaceCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupViews];
        [self defaultLayout];
    }
    return self;
}

- (void)setupViews
{
    _face = [[UIImageView alloc] init];
    _face.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_face];
}

- (void)defaultLayout
{
    CGSize size = self.frame.size;
    _face.frame = CGRectMake(0, 0, size.width, size.height);
}

- (void)setData:(DUIFaceCellData *)data
{
    _face.image = [[DUIImageCache sharedInstance] getFaceFromCache:data.path];
    [self defaultLayout];
}

@end
