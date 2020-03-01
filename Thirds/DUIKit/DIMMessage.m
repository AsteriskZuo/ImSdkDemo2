//
//  DIMMessage.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/9.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DIMMessage.h"


@implementation TIMElem



@end


@implementation TIMTextElem



@end


@implementation DIMImage

- (void)getImage:(NSString*)path succ:(DIMSucc)succ fail:(DIMFail)fail
{
    //TODO:DAISHIXIAN
}

- (void)getImage:(NSString*)path progress:(DIMProgress)progress succ:(DIMSucc)succ fail:(DIMFail)fail
{
    //TODO:DAISHIXIAN
}

@end

@implementation DIMImageElem



@end


@interface DIMMessage ()

@property (nonatomic, strong) NSMutableArray* elems;


@end

@implementation DIMMessage

- (instancetype)init
{
    if (self = [super init]) {
        _elems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (int)addElem:(TIMElem*)elem
{
    [_elems addObject:elem];
    return _elems.count;
}


- (TIMElem*)getElem:(int)index
{
    return _elems[index];
}


@end
