//
//  DUIError.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/17.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DUIError : NSObject

+ (NSString *)strError:(NSInteger)code msg:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
