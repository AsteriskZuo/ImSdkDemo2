//
//  GroupProfileController.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/8.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGroupProfileControllerServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupProfileController : UITableViewController <DGroupProfileControllerServiceProtocol>

@property (nonatomic, strong) NSString *groupId;

@end

NS_ASSUME_NONNULL_END
