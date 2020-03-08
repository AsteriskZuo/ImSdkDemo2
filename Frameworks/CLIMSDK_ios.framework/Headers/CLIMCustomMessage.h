//
//  CLIMCustomMessage.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/10/10.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

//#import <CLIMSDK_ios/CLIMSDK_ios.h>
#import <Foundation/Foundation.h>
#import "CLIMMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLIMCustomMessage : CLIMMessage

@property(nonatomic, copy) NSString* customType;

@property(nonatomic, copy) id rawData;

@end

NS_ASSUME_NONNULL_END
