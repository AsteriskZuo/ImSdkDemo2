//
//  DUIGroupPendencyController.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/27.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DUIGroupPendencyViewModel;

/** 腾讯云 TUIKit
* 【模块名称】TUIGroupPendencyController
* 【功能说明】TUI 群组请求控制器。
*  本视图负责在群组设置为“需要管理员审批“时，为管理员提供申请的审批视图控制器。
*  本控制默认用 UITableView 实现，通过 tableView 展示所的入群申请。
*  申请的信息包括：用户头像、用户昵称、申请简介、同意按钮。点击某一具体 tableCell 后，可以进入申请对应的详细界面（在详细页面中包含拒绝按钮）。
*/
@interface DUIGroupPendencyController : UITableViewController

/**
 *  请求视图的视图模型。
 *  负责视图的具体实现。包含信息加载、未读计数、以及通过 IM SDK 同意/拒绝申请等业务逻辑
 *  详细信息请参考 Section\Chat\Pendency\ViewModel\TUIGroupPendencyViewModel.h
 */
@property DUIGroupPendencyViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
