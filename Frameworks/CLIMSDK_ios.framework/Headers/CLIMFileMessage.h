//
//  CLIMFileMessage.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/5/6.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#ifndef CLIMFileMessage_h
#define CLIMFileMessage_h

#import <Foundation/Foundation.h>
#import "CLIMMessage.h"

@interface CLIMFileMessage : CLIMMessage

@property (nonatomic, copy) NSString* fileId;
@property (nonatomic, copy) NSString* fileUrl;
@property (nonatomic, assign) NSUInteger fileSize;
@property (nonatomic, copy) NSString* extra;

@end

#endif /* CLIMFileMessage_h */
