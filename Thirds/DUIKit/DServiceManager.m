//
//  DServiceManager.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/5.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DServiceManager.h"

@interface DServiceItem : NSObject

@property (nonatomic, strong) NSString* className;
@property (nonatomic, assign) NSUInteger priorityLevel;

@end

@implementation DServiceItem

@end

@interface DServiceManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableArray<DServiceItem*>* >* list;

@end

@implementation DServiceManager

+ (instancetype)shareInstance
{
    static DServiceManager* _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DServiceManager alloc] init];
    });
    return _manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _list = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)registerService:(Protocol*)protocol withImplementationClass:(Class)implClass
{
    NSString* protocolName = NSStringFromProtocol(protocol);
    if (0 == protocolName.length) {
        return;
    }
    NSString* implClassName = NSStringFromClass(implClass);
    if (0 == implClassName.length) {
        return;
    }
    NSMutableArray<DServiceItem*>* protocolList = _list[protocolName];
    if (protocolList) {
        for (DServiceItem* item in protocolList) {
            if ([item.className isEqualToString:implClassName]) {
                return;
            }
        }
        DServiceItem* item = [[DServiceItem alloc] init];
        item.className = implClassName;
        item.priorityLevel = NSUIntegerMax;
        [protocolList addObject:item];
    } else {
        DServiceItem* item = [[DServiceItem alloc] init];
        item.className = implClassName;
        item.priorityLevel = NSUIntegerMax;
        _list[protocolName] = [NSMutableArray<DServiceItem*> arrayWithObject:item];
    }
}

- (void)unRegisterService:(Protocol*)protocol withImplementationClass:(Class)implClass
{
    NSString* protocolName = NSStringFromProtocol(protocol);
    if (0 == protocolName.length) {
        return;
    }
    NSString* implClassName = NSStringFromClass(implClass);
    if (0 == implClassName.length) {
        return;
    }
    NSMutableArray<DServiceItem*>* protocolList = _list[protocolName];
    if (protocolList) {
        for (DServiceItem* item in protocolList) {
            if ([item.className isEqualToString:implClassName]) {
                [protocolList removeObject:item];
                return;
            }
        }
    }
}

- (NSArray<id>*)createObject:(Protocol*)protocol
{
    NSString* protocolName = NSStringFromProtocol(protocol);
    if (0 == protocolName.length) {
        return nil;
    }
    NSMutableArray<DServiceItem*>* protocolList = _list[protocolName];
    if (!protocolList) {
        return nil;
    }
    if (0 == protocolList.count) {
        return nil;
    }
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (DServiceItem* item in protocolList) {
        Class implClass = NSClassFromString(item.className);
        if ([[implClass class] respondsToSelector:@selector(shareInstance)]) {
            id implClassObject = [[implClass class] shareInstance];
            [result addObject:implClassObject];
        } else if ([[implClass class] respondsToSelector:@selector(init)]) {
            id implClassObject = [[implClass alloc] init];
            [result addObject:implClassObject];
        } else {
            continue;
        }
    }
    return result;
}

@end
