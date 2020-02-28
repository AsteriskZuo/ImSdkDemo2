//
//  ConversationController.m
//  ImSdkDemo
//
//  Created by yu.zuo on 2020/1/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "ConversationController.h"
#import "AppDelegate.h"
#import "DUIConversationListController.h"
#import "DHeader.h"
#import "DUINavigationIndicatorView.h"
#import "TNaviBarIndicatorView.h"
#import "DUIPopView.h"
#import "ChatController.h"

@interface ConversationController () <DUIConversationListControllerDelegate, DUIPopViewDelegate>

@property (nonatomic, strong) DUINavigationIndicatorView* indicatorView;
@property (nonatomic, strong) TNaviBarIndicatorView* indicatorView2;

@end

@implementation ConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor yellowColor];
    
    //如果不加这一行代码，依然可以实现点击反馈，但反馈会有轻微延迟，体验不好。
//    self.tableView.delaysContentTouches = NO;
    
    [self setupViews];
    
    
    /**
     * Unbalanced calls to begin/end appearance transitions for <UITabBarController: 0x7fd8b6015e00>.
     * ref: https://www.cnblogs.com/duzhaoquan/p/5915398.html
     * 本质上，viewWillAppear和viewDidAppear没有成对调用导致
     * 可能，viewWillDisappear和viewDidDisappear不成对也会出现上面警告
     */
    
    
    /**
    * Presenting view controllers on detached view controllers is discouraged
    * ref: https://www.jianshu.com/p/66b009a7b1f0
    * 字面意思: 在分离的视图控制器显示视图控制器是建议的
    * 这里: 当前视图控制器是分离的，不建议展示模态视图控制器
    */
    
//    [self beginAppearanceTransition:YES animated:YES];
    
//    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    UIViewController* controller = [delegate getLoginController];
//    controller.modalPresentationStyle = UIModalPresentationFullScreen;
////    [self presentViewController:controller animated:YES completion:nil];
//    [delegate.window.rootViewController presentViewController:controller animated:YES completion:nil];
    
//    [self endAppearanceTransition];
    
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController* controller = [delegate getLoginController];
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [delegate.window.rootViewController presentViewController:controller animated:YES completion:nil];
    });
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self beginAppearanceTransition:YES animated:animated];
    NSLog(@"%s, %d", __func__, __LINE__);
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self endAppearanceTransition];
    NSLog(@"%s, %d", __func__, __LINE__);
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"%s, %d", __func__, __LINE__);
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"%s, %d", __func__, __LINE__);
}


#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIViewController *)getViewController:(Class)controllerClass {
    NSArray<__kindof UIViewController *> *controllers = [self childViewControllers];
    for (UIViewController* controller in controllers) {
        if ([controller isKindOfClass:controllerClass]) {
            return controller;
        }
    }
    return nil;
}

- (void)setupViews
{
    DUIConversationListController* controller = [[DUIConversationListController alloc] init];
    controller.delegate = self;
//    self.view = controller.view;
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [moreButton setImage:[UIImage imageNamed:TUIKitResource(@"more")] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = moreItem;
    
    _indicatorView = [[DUINavigationIndicatorView alloc] init];
    [_indicatorView setLabel:@"会话"];
    self.navigationItem.titleView = _indicatorView;
    
//    _indicatorView2 = [[TNaviBarIndicatorView alloc] init];
//    self.navigationItem.titleView = _indicatorView2;
}

- (void)rightBarButtonClick:(id)sender
{
//    NSString* log = NSStringFromClass([sender class]);
//    NSLog(@"%s%@", __FUNCTION__, log);

//    [_indicatorView setLabel:@"连接中"];
//    [_indicatorView startAnimating];
    
//    [_indicatorView2 setTitle:@"连接中"];
//    [_indicatorView2 startAnimating];
    
    UIViewController* controller = [self getViewController:[DUIConversationListController class]];
    if (controller) {
        DUIConversationListController* c = (DUIConversationListController*)controller;
        if ([c respondsToSelector:@selector(test)]) {
            [c test];
        }
    }
    
    
    
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    UIButton* rightBarButton = (UIButton*)sender;
    
    NSMutableArray *menus = [NSMutableArray array];
    
    DUIPopViewCellData *friend = [[DUIPopViewCellData alloc] init];
    friend.image = [UIImage imageNamed:TUIKitResource(@"add_friend")];
    friend.name = @"发起会话";
    [menus addObject:friend];

    DUIPopViewCellData *group3 = [[DUIPopViewCellData alloc] init];
    group3.image = [UIImage imageNamed:TUIKitResource(@"create_group")];
    group3.name = @"创建讨论组";
    [menus addObject:group3];

    DUIPopViewCellData *group = [[DUIPopViewCellData alloc] init];
    group.image = [UIImage imageNamed:TUIKitResource(@"create_group")];
    group.name = @"创建群聊";
    [menus addObject:group];

    DUIPopViewCellData *room = [[DUIPopViewCellData alloc] init];
    room.image = [UIImage imageNamed:TUIKitResource(@"create_group")];
    room.name = @"创建聊天室";
    [menus addObject:room];
    
    CGFloat height = [DUIPopViewCell getHeight] * menus.count + TPopView_Arrow_Size.height;
    CGFloat orginY = StatusBar_Height + NavBar_Height;
    DUIPopView *popView = [[DUIPopView alloc] initWithFrame:CGRectMake(Screen_Width - 145, orginY, 135, height)];
    CGRect frameInNaviView = [self.navigationController.view convertRect:rightBarButton.frame fromView:[rightBarButton superview]];
    popView.arrowPoint = CGPointMake(frameInNaviView.origin.x + frameInNaviView.size.width * 0.5, orginY);
    popView.delegate = self;
    [popView setData:menus];
    [popView showInWindow:self.view.window];
}

#pragma mark - DUIConversationListControllerDelegate

- (void)ConversationController:(DUIConversationListController *)conversationController didSelectConversation:(DUIConversationCell *)conversation
{
    NSLog(@"%s", __func__);
    ChatController* controller = [[ChatController alloc] init];
    controller.conversationData = conversation.convData;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - DUIPopViewDelegate

- (void)popView:(DUIPopView *)popView didSelectRowAtIndex:(NSInteger)index
{
    NSLog(@"%s, index=%ld", __FUNCTION__, (long)index);
}

@end
