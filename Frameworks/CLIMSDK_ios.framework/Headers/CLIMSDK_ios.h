//
//  CLIMSDK_ios.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/4/11.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for CLIMSDK_ios.
FOUNDATION_EXPORT double CLIMSDK_iosVersionNumber;

//! Project version string for CLIMSDK_ios.
FOUNDATION_EXPORT const unsigned char CLIMSDK_iosVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CLIMSDK_ios/PublicHeader.h>


#import "CLIMConfig.h"
#import "CLIMCommon.h"
#import "CLIMListener.h"
#import "CLIMErrorCode.h"
#import "CLIMUtils.h"

#import "CLIMMessage.h"
#import "CLIMMessage+MsgExt.h"
#import "CLIMManager.h"
#import "CLIMManager+MsgExt.h"
#import "CLIMConversation.h"
#import "CLIMConversation+MsgExt.h"

#import "CLIMVoiceMessage.h"
#import "CLIMVideoMessage.h"
#import "CLIMTextMessage.h"
#import "CLIMOrderNotifyMessage.h"
#import "CLIMLocationMessage.h"
#import "CLIMLibraryEmotionMessage.h"
#import "CLIMImageMessage.h"
#import "CLIMFileMessage.h"
#import "CLIMBuiltInEmotionMessage.h"
#import "CLIMCustomMessage.h"

#import "CLIMPlatform.h"//deprecated

