//
//  DIMMessage.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/9.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DIMMessage.h"


@implementation DIMElem



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



@implementation DIMSoundElem

-(void)getUrl:(void (^)(NSString * url))urlCallBack
{
    //TODO:DAISHIXIAN
}

- (void)getSound:(NSString*)path succ:(DIMSucc)succ fail:(DIMFail)fail
{
    //TODO:DAISHIXIAN
}

- (void)getSound:(NSString*)path progress:(DIMProgress)progress succ:(DIMSucc)succ fail:(DIMFail)fail
{
    //TODO:DAISHIXIAN
}

@end


@interface DIMMessage ()

@property (nonatomic, strong) NSMutableArray* elems;
@property (nonatomic, assign) int32_t cint;

@end

@implementation DIMMessage

- (instancetype)init
{
    if (self = [super init]) {
        _elems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (int)addElem:(DIMElem*)elem
{
    [_elems addObject:elem];
    return _elems.count;
}


- (DIMElem*)getElem:(int)index
{
    return _elems[index];
}

- (int)elemCount
{
    return _elems.count;
}

- (BOOL)setCustomInt:(int32_t)param
{
    _cint = param;
    return YES;
}

- (int32_t)customInt
{
    return _cint;
}


@end
