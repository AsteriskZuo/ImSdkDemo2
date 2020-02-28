//
//  DUIGroupPendencyViewModel.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/27.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIGroupPendencyViewModel.h"
#import "DUIGroupPendencyCell.h"

@interface DUIGroupPendencyViewModel()

@property NSArray<DUIGroupPendencyCellData* > *dataList;

@property (nonatomic, assign) uint64_t origSeq;

@property (nonatomic, assign) uint64_t seq;

@property (nonatomic, assign) uint64_t timestamp;

@property (nonatomic, assign) uint64_t numPerPage;

@end

@implementation DUIGroupPendencyViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _numPerPage = 100;

//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMessage:) name:TUIKitNotification_TIMMessageListener object:nil];
//
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPendencyChanged:) name:TUIGroupPendencyCellData_onPendencyChanged object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)loadData
{
    //TODO:待实现
}


- (void)loadNextData
{
    //TODO:待实现
}

- (void)acceptData:(DUIGroupPendencyCellData *)data
{
    //TODO:待实现
}

- (void)removeData:(DUIGroupPendencyCellData *)data
{
    //TODO:待实现
}


@end
