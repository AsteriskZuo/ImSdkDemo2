//
//  DConversationListViewModel.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/27.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DUIConversationCellData;

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^ConversationListFilterBlock)(DUIConversationCellData *data);

@interface DConversationListViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<DUIConversationCellData* >* conversationList;

@property (nonatomic, strong) ConversationListFilterBlock listFilter;

- (void)removeData:(DUIConversationCellData *)data;

- (void)loadConversation;

@end

NS_ASSUME_NONNULL_END
