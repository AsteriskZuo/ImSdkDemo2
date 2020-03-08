//
//  CLIMLibraryEmotionMessage.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/7/9.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#ifndef CLIMLibraryEmotionMessage_h
#define CLIMLibraryEmotionMessage_h

#import <Foundation/Foundation.h>
#import "CLIMMessage.h"

/**
 * 用户可以修改的表情库（添加、删除表情库，无法修改表情库）
 * 用户可以单独下载表情
 */
@interface CLIMLibraryEmotionMessage : CLIMMessage

@property(nonatomic, copy) NSString* emotionId;
@property(nonatomic, copy) NSString* parentNodeId;
@property(nonatomic, copy) NSString* extra;

@end



#endif /* CLIMLibraryEmotionMessage_h */
