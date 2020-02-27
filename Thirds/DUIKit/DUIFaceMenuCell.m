//
//  DUIFaceMenuCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/22.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIFaceMenuCell.h"
#import "DHeader.h"
#import "DCommon.h"
#import "DUIImageCache.h"

@implementation DUIFaceMenuCellData

@end

@implementation DUIFaceMenuCell

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
    self.backgroundColor = TMenuCell_UnSelected_Background_Color;
    _menu = [[UIImageView alloc] init];
    [self addSubview:_menu];
}

- (void)defaultLayout
{
}

- (void)setData:(DUIFaceMenuCellData *)data
{
    //set data
    _menu.image = [[DUIImageCache sharedInstance] getFaceFromCache:data.path];
    if(data.isSelected){
        self.backgroundColor = TMenuCell_Selected_Background_Color;
    }
    else{
        self.backgroundColor = TMenuCell_UnSelected_Background_Color;
    }
    //update layout
    CGSize size = self.frame.size;
    _menu.frame = CGRectMake(TMenuCell_Margin, TMenuCell_Margin, size.width - 2 * TMenuCell_Margin, size.height - 2 * TMenuCell_Margin);
    _menu.contentMode = UIViewContentModeScaleAspectFit;

}

@end
