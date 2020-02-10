//
//  DUIMessageCellLayout.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/7.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIMessageCellLayout.h"

@implementation DUISystemMessageCellLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.messageInsets = (UIEdgeInsets){.top = 5, .bottom = 5};
    }
    return self;
}

@end


@implementation DUIOutgoingTextCellLayout

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.bubbleInsets = (UIEdgeInsets){.top = 14, .bottom = 16, .left = 16, .right = 16};
    }
    return self;
}

@end

@implementation DUIIncommingTextCellLayout

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.bubbleInsets = (UIEdgeInsets){.top = 14, .bottom = 16, .left = 16, .right = 16};
    }
    return self;
}

@end





















@implementation DUIMessageCellLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.avatarSize = CGSizeMake(40, 40);
    }
    return self;
}

static DUIMessageCellLayout *sIncommingMessageLayout;

+ (DUIMessageCellLayout *)incommingMessageLayout
{
    if (!sIncommingMessageLayout) {
        sIncommingMessageLayout = [DIncommingCellLayout new];
    }
    return sIncommingMessageLayout;
}

+ (void)setIncommingMessageLayout:(DUIMessageCellLayout *)incommingMessageLayout
{
    sIncommingMessageLayout = incommingMessageLayout;
}

static DUIMessageCellLayout *sOutgoingMessageLayout;

+ (DUIMessageCellLayout *)outgoingMessageLayout
{
    if (!sOutgoingMessageLayout) {
        sOutgoingMessageLayout = [DOutgoingCellLayout new];
    }
    return sOutgoingMessageLayout;
}

+ (void)setOutgoingMessageLayout:(DUIMessageCellLayout *)outgoingMessageLayout
{
    sOutgoingMessageLayout = outgoingMessageLayout;
}

static DUIMessageCellLayout *sSystemMessageLayout;

+ (DUIMessageCellLayout *)systemMessageLayout
{
    if (!sSystemMessageLayout) {
        sSystemMessageLayout = [DUISystemMessageCellLayout new];
    }
    return sSystemMessageLayout;
}

+ (void)setSystemMessageLayout:(DUIMessageCellLayout *)systemMessageLayout
{
    sSystemMessageLayout = systemMessageLayout;
}

static DUIMessageCellLayout *sIncommingTextMessageLayout;

+ (DUIMessageCellLayout *)incommingTextMessageLayout
{
    if (!sIncommingTextMessageLayout) {
        sIncommingTextMessageLayout = [DUIIncommingTextCellLayout new];
    }
    return sIncommingTextMessageLayout;
}

+ (void)setIncommingTextMessageLayout:(DUIMessageCellLayout *)incommingTextMessageLayout
{
    sIncommingTextMessageLayout = incommingTextMessageLayout;
}

static DUIMessageCellLayout *sOutgingTextMessageLayout;

+ (DUIMessageCellLayout *)outgoingTextMessageLayout
{
    if (!sOutgingTextMessageLayout) {
        sOutgingTextMessageLayout = [DUIOutgoingTextCellLayout new];
    }
    return sOutgingTextMessageLayout;
}

+ (void)setOutgoingTextMessageLayout:(DUIMessageCellLayout *)outgoingTextMessageLayout
{
    sOutgingTextMessageLayout = outgoingTextMessageLayout;
}
@end


@implementation DIncommingCellLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.avatarInsets = (UIEdgeInsets){
            .left = 8,
            .top = 3,
            .bottom = 1,
        };
        self.messageInsets = (UIEdgeInsets){
            .top = 3,
            .bottom = 1,
            .left = 8,
        };
    }
    return self;
}

@end

@implementation DOutgoingCellLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.avatarInsets = (UIEdgeInsets){
            .right = 8,
            .top = 3,
            .bottom = 1,
        };
        self.messageInsets = (UIEdgeInsets){
            .top = 3,
            .bottom = 1,
            .right = 8,
        };

    }
    return self;
}

@end





@implementation DIncommingVoiceCellLayout

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.bubbleInsets = (UIEdgeInsets){.top = 14, .bottom = 20, .left = 19, .right = 22};
    }
    return self;
}

@end


@implementation DOutgoingVoiceCellLayout

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.bubbleInsets = (UIEdgeInsets){.top = 14, .bottom = 20, .left = 22, .right = 20};
    }
    return self;
}

@end
