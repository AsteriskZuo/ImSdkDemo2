//
//  Common.h
//  ImSdkDemo
//
//  Created by yu.zuo on 2020/1/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>


#define TUIKitFace(name) [[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"TUIKitFace" ofType:@"bundle"]] resourcePath] stringByAppendingPathComponent:name]
#define TUIKitResource(name) [[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"TUIKitResource" ofType:@"bundle"]] resourcePath] stringByAppendingPathComponent:name]

#define weakify(object) autoreleasepool   {} __weak  typeof(object) weak##object = object;
#define strongify(object) autoreleasepool {} __strong  typeof(weak##object) object = weak##object;



NS_ASSUME_NONNULL_BEGIN

@interface Common : NSObject

@end

NS_ASSUME_NONNULL_END
