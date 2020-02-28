//
//  DIMConversation.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/9.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DIMConversation.h"

@interface DIMConversation ()

@property (nonatomic, strong, readwrite) NSString* convId;
@property (nonatomic, assign, readwrite) DIMConversationType convType;

@end

@implementation DIMConversation

- (instancetype)initWithConvId:(NSString*)convId convType:(DIMConversationType)convType
{
    if (self = [super init]) {
        _convId = convId;
        _convType = convType;
    }
    return self;
}

- (DIMConversationType)getType
{
    return _convType;
}

- (NSString*)getReceiver
{
    return _convId;
}

- (NSString*)getGroupName
{
    return _convId;
}

@end
