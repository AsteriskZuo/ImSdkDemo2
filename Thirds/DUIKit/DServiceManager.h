//
//  DServiceManager.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/5.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DServiceManager : NSObject

+ (instancetype)shareInstance;

- (void)registerService:(Protocol*)protocol withImplementationClass:(Class)implClass;
- (void)unRegisterService:(Protocol*)protocol withImplementationClass:(Class)implClass;

- (NSArray<id>*)createObject:(Protocol*)protocol;

@end

NS_ASSUME_NONNULL_END
