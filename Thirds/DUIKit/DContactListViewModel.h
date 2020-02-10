//
//  DContactListViewModel.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/1.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DUIContactCellData;

NS_ASSUME_NONNULL_BEGIN

@interface DContactListViewModel : NSObject

/**
 *  数据字典，负责按姓名首字母归类好友信息（TCommonContactCellData）。
 *  例如，Jack 和 James 被存放在 “J”内。
 */
@property (readonly) NSDictionary<NSString *, NSArray<DUIContactCellData *> *> *dataDict;

/**
 *  分组列表，即当前好友的分组信息。
 *  例如，当前用户只有一个好友 “Jack”，则本列表中只有一个元素“J”。
 *  分组信息最多为 A - Z 的26个字母加上“#”。
 */
@property (readonly) NSArray *groupList;

- (void)loadContacts;

@end

NS_ASSUME_NONNULL_END
