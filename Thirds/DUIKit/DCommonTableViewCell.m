//
//  DCommonTableViewCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/12.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DCommonTableViewCell.h"
#import "MMLayout/UIView+MMLayout.h"

@implementation DCommonCellData

- (CGFloat)heightOfWidth:(CGFloat)width
{
    return 44;
}

@end

@interface DCommonTableViewCell() <UIGestureRecognizerDelegate>

@property DCommonCellData* data;
@property UITapGestureRecognizer *tapRecognizer;

@end

@implementation DCommonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        self.tapRecognizer.delegate = self;
        self.tapRecognizer.cancelsTouchesInView = NO;

        self.colorWhenTouched = [UIColor colorWithRed:219.0/255.0 green:219.0/255.0  blue:219.0/255.0  alpha:1];
        self.changeColorWhenTouched = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)tapGesture:(UIGestureRecognizer *)gesture
{
    if (self.data.cselector) {
        UIViewController *vc = self.mm_viewController;
        if ([vc respondsToSelector:self.data.cselector]) {
            self.selected = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [vc performSelector:self.data.cselector withObject:self];
#pragma clang diagnostic pop
        }
    }
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.changeColorWhenTouched){
        self.backgroundColor = self.colorWhenTouched;
    }
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.changeColorWhenTouched){
        self.backgroundColor = [UIColor whiteColor];
    }
}


-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.changeColorWhenTouched){
        self.backgroundColor = [UIColor whiteColor];
    }
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.changeColorWhenTouched){
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)fillWithData:(DCommonCellData *)data
{
    self.data = data;
    if (data.cselector) {
        [self addGestureRecognizer:self.tapRecognizer];
    } else {
        [self removeGestureRecognizer:self.tapRecognizer];
    }
}

@end
