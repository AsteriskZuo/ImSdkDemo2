//
//  CLIMVideoMessage.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/7/9.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#ifndef CLIMVideoMessage_h
#define CLIMVideoMessage_h

#import <Foundation/Foundation.h>
#import "CLIMMessage.h"

@interface CLIMVideoMessage : CLIMMessage

@property(nonatomic, copy) NSString* videoId;
@property(nonatomic, copy) NSString* videoUrl;
@property(nonatomic, copy) NSString* coverImageUrl;
@property(nonatomic, assign) NSInteger videoLength;
@property(nonatomic, copy) NSString* extra;

@end



#endif /* CLIMVideoMessage_h */
