//
//  DContactListViewModel.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/1.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DContactListViewModel.h"
#import "DUIContactCell.h"
#import "DHeader.h"

@implementation DContactListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadContacts
{
    DUIContactCellData* user01 = [[DUIContactCellData alloc] init];
    user01.avatar = [UIImage imageNamed:TUIKitResource(@"default_head")];
    user01.title = @"lisi";
    
    DUIContactCellData* user02 = [[DUIContactCellData alloc] init];
    user02.avatar = [UIImage imageNamed:TUIKitResource(@"default_head")];
    user02.title = @"zhangsan";
    
    _groupList = [NSArray arrayWithObjects:@"L", @"Z", nil];
    
    NSArray<DUIContactCellData *> *L = [NSArray arrayWithObjects:user01, nil];
    NSArray<DUIContactCellData *> *Z = [NSArray arrayWithObjects:user02, nil];
    
    NSMutableDictionary<NSString *, NSArray<DUIContactCellData *> *> *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setObject:L forKey:@"L"];
    [dataDict setObject:Z forKey:@"Z"];
    
    _dataDict = [dataDict copy];
}

@end
