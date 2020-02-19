//
//  DUIMessageController.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/9.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIMessageController.h"

#import "DUIMessageCell.h"
#import "DUITextMessageCell.h"
//#import "TUISystemMessageCell.h"
//#import "TUIVoiceMessageCell.h"
//#import "TUIImageMessageCell.h"
//#import "TUIFaceMessageCell.h"
//#import "TUIVideoMessageCell.h"
//#import "TUIFileMessageCell.h"
//#import "TUIJoinGroupMessageCell.h"
#import "DUIKitConfig.h"
#import "DUIFaceView.h"
#import "DHeader.h"
#import "DUIKit.h"
#import "DHelper.h"
#import "DUIConversationCell.h"
//#import "TIMMessage+DataProvider.h"
//#import "TUIImageViewController.h"
//#import "TUIVideoViewController.h"
//#import "TUIFileViewController.h"
//#import "TUIConversationDataProviderService.h"
#import "NSString+TUICommon.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "MMLayout/UIView+MMLayout.h"
//#import "TIMMessage+DataProvider.h"
//#import "TUIUserProfileControllerServiceProtocol.h"
//#import <ImSDK/ImSDK.h>


#define MAX_MESSAGE_SEP_DLAY (5 * 60)

@interface DUIMessageController () <DUIMessageCellDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) DIMConversation *conv;
@property (nonatomic, strong) NSMutableArray *uiMsgs;
@property (nonatomic, strong) NSMutableArray *heightCache;
@property (nonatomic, strong) DIMMessage *msgForDate;
@property (nonatomic, strong) DIMMessage *msgForGet;
@property (nonatomic, strong) DUIMessageCellData *menuUIMsg;
@property (nonatomic, strong) DUIMessageCellData *reSendUIMsg;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) BOOL isScrollBottom;
@property (nonatomic, assign) BOOL isLoadingMsg;
@property (nonatomic, assign) BOOL isInVC;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL noMoreMsg;
@property (nonatomic, assign) BOOL firstLoad;
//@property id<TUIConversationDataProviderServiceProtocol> conversationDataProviderService;
@property (nonatomic, strong) UILabel* testView;
@end

@implementation DUIMessageController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupViews];
    
    self.isActive = YES;
}

- (void)setupViews
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMessage:) name:TUIKitNotification_TIMMessageListener object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRevokeMessage:) name:TUIKitNotification_TIMMessageRevokeListener object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUploadMessage:) name:TUIKitNotification_TIMUploadProgressListener object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecvMessageReceipts:) name:TUIKitNotification_onRecvMessageReceipts object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewController:)];
    [self.view addGestureRecognizer:tap];
    self.tableView.estimatedRowHeight = 0;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = TMessageController_Background_Color;

    [self.tableView registerClass:[DUITextMessageCell class] forCellReuseIdentifier:TTextMessageCell_ReuseId];
//    [self.tableView registerClass:[TUIVoiceMessageCell class] forCellReuseIdentifier:TVoiceMessageCell_ReuseId];
//    [self.tableView registerClass:[TUIImageMessageCell class] forCellReuseIdentifier:TImageMessageCell_ReuseId];
//    [self.tableView registerClass:[TUISystemMessageCell class] forCellReuseIdentifier:TSystemMessageCell_ReuseId];
//    [self.tableView registerClass:[TUIFaceMessageCell class] forCellReuseIdentifier:TFaceMessageCell_ReuseId];
//    [self.tableView registerClass:[TUIVideoMessageCell class] forCellReuseIdentifier:TVideoMessageCell_ReuseId];
//    [self.tableView registerClass:[TUIFileMessageCell class] forCellReuseIdentifier:TFileMessageCell_ReuseId];
//    [self.tableView registerClass:[TUIJoinGroupMessageCell class] forCellReuseIdentifier:TJoinGroupMessageCell_ReuseId];


    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, TMessageController_Header_Height)];
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.tableHeaderView = _indicatorView;
    

    _testView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 30)];
    _testView.backgroundColor = RGBA(100, 100, 100, 0.5);
    [self.view addSubview:_testView];

    _heightCache = [NSMutableArray array];
    _uiMsgs = [[NSMutableArray alloc] init];
    _firstLoad = YES;
    
    NSLog(@"%s,%d", __func__, self.view == self.tableView);
}

- (void)viewWillAppear:(BOOL)animated
{
    self.isInVC = YES;
    [self readedReport];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.isInVC = NO;
    [self readedReport];
    [super viewWillDisappear:animated];
}

- (void)readedReport
{
    if (self.isInVC && self.isActive) {
        //TODO:待实现
    }
}

- (void)applicationBecomeActive
{
    self.isActive = YES;
    [self readedReport];
}

- (void)applicationEnterBackground
{
    self.isActive = NO;
}

- (void)loadMessage
{
    //TODO:待实现
}

- (void)onNewMessage:(NSNotification*)notification
{
    //TODO:待实现
}
- (void)onRevokeMessage:(NSNotification*)notification
{
    //TODO:待实现
}
- (void)onUploadMessage:(NSNotification*)notification
{
    //TODO:待实现
}
- (void)didRecvMessageReceipts:(NSNotification*)notification
{
    //TODO:待实现
}
- (void)didTapViewController:(UITapGestureRecognizer*)recognizer
{
    if(_delegate && [_delegate respondsToSelector:@selector(didTapInMessageController:)]) {
        [_delegate didTapInMessageController:self];
    }
}

- (void)sendMessage:(DUIMessageCellData *)msg
{
    //TODO:待实现
}

- (void)changeMsg:(DUIMessageCellData *)msg status:(DMsgStatus)status
{
    msg.status = status;
    NSInteger index = [_uiMsgs indexOfObject:msg];
    DUIMessageCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [cell fillWithData:msg];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = StatusBar_Height + NavBar_Height;
    _testView.mm_top(offset + scrollView.contentOffset.y);
    NSLog(@"%s, %@,%f,%f,%f,%f,%f", __func__, NSStringFromClass([scrollView class]), scrollView.contentOffset.y, _testView.mm_y, scrollView.contentInset.top, scrollView.contentInset.bottom, self.tableView.tableHeaderView.frame.size.height);
    
    if(!_noMoreMsg && scrollView.contentOffset.y <= TMessageController_Header_Height){
        if(!_indicatorView.isAnimating){
            [_indicatorView startAnimating];
        }
    }
    else{
        if(_indicatorView.isAnimating){
            [_indicatorView stopAnimating];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y <= TMessageController_Header_Height){
        [self loadMessage];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _uiMsgs.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isScrollBottom == NO) {
        [self scrollToBottom:NO];
        if (indexPath.row == _uiMsgs.count-1) {
            _isScrollBottom = YES;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if(_heightCache.count > indexPath.row){
        NSLog(@"%s,%f", __func__, [_heightCache[indexPath.row] floatValue]);
        return [_heightCache[indexPath.row] floatValue];
    }
    DUIMessageCellData *data = _uiMsgs[indexPath.row];
    height = [data heightOfWidth:Screen_Width];
    [_heightCache insertObject:[NSNumber numberWithFloat:height] atIndex:indexPath.row];
    NSLog(@"%s,%f", __func__, height);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUIMessageCellData *data = _uiMsgs[indexPath.row];
    DUIMessageCell *cell = nil;
    if ([self.delegate respondsToSelector:@selector(messageController:onShowMessageData:)]) {
        cell = [self.delegate messageController:self onShowMessageData:data];
        if (cell) {
            cell.delegate = self;
            return cell;
        }
    }
    if (!data.reuseId) {
        if([data isKindOfClass:[DUITextMessageCellData class]]) {
            data.reuseId = TTextMessageCell_ReuseId;
        }
        /*else if([data isKindOfClass:[TUIFaceMessageCellData class]]) {
            data.reuseId = TFaceMessageCell_ReuseId;
        }
        else if([data isKindOfClass:[TUIImageMessageCellData class]]) {
            data.reuseId = TImageMessageCell_ReuseId;
        }
        else if([data isKindOfClass:[TUIVideoMessageCellData class]]) {
            data.reuseId = TVideoMessageCell_ReuseId;
        }
        else if([data isKindOfClass:[TUIVoiceMessageCellData class]]) {
            data.reuseId = TVoiceMessageCell_ReuseId;
        }
        else if([data isKindOfClass:[TUIFileMessageCellData class]]) {
            data.reuseId = TFileMessageCell_ReuseId;
        }
        else if([data isKindOfClass:[TUIJoinGroupMessageCellData class]]){//入群小灰条对应的数据源
            data.reuseId = TJoinGroupMessageCell_ReuseId;
        }
        else if([data isKindOfClass:[TUISystemMessageCellData class]]) {
            data.reuseId = TSystemMessageCell_ReuseId;
        }*/
        else {
            return nil;
        }
    }
    cell = [tableView dequeueReusableCellWithIdentifier:data.reuseId forIndexPath:indexPath];
    //对于入群小灰条，需要进一步设置其委托。
//    if([cell isKindOfClass:[TUIJoinGroupMessageCell class]]){
//        TUIJoinGroupMessageCell *joinCell = (TUIJoinGroupMessageCell *)cell;
//        joinCell.joinGroupDelegate = self;
//        cell = joinCell;
//    }
    cell.delegate = self;
    [cell fillWithData:_uiMsgs[indexPath.row]];

    return cell;
}

- (void)scrollToBottom:(BOOL)animate
{
    if (_uiMsgs.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_uiMsgs.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animate];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - message cell delegate

- (void)onSelectMessage:(DUIMessageCell *)cell
{
//    if([cell isKindOfClass:[TUIVoiceMessageCell class]]){
//        [self playVoiceMessage:(TUIVoiceMessageCell *)cell];
//    }
//    if ([cell isKindOfClass:[TUIImageMessageCell class]]) {
//        [self showImageMessage:(TUIImageMessageCell *)cell];
//    }
//    if ([cell isKindOfClass:[TUIVideoMessageCell class]]) {
//        [self showVideoMessage:(TUIVideoMessageCell *)cell];
//    }
//    if ([cell isKindOfClass:[TUIFileMessageCell class]]) {
//        [self showFileMessage:(TUIFileMessageCell *)cell];
//    }
    if ([self.delegate respondsToSelector:@selector(messageController:onSelectMessageContent:)]) {
        [self.delegate messageController:self onSelectMessageContent:cell];
    }
}

- (void)onLongPressMessage:(DUIMessageCell *)cell
{
    DUIMessageCellData *data = cell.messageData;
//    if ([data isKindOfClass:[TUISystemMessageCellData class]])
//        return; // 系统消息不响应

    NSMutableArray *items = [NSMutableArray array];
    if ([data isKindOfClass:[DUITextMessageCellData class]]) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(onCopyMsg:)]];
    }

    [items addObject:[[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(onDelete:)]];
//    DIMMessage *imMsg = data.innerMessage;
//    if(imMsg){
//        if([imMsg isSelf] && [[NSDate date] timeIntervalSinceDate:imMsg.timestamp] < 2 * 60){
//            [items addObject:[[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(onRevoke:)]];
//        }
//    }
//    if(imMsg.status == TIM_MSG_STATUS_SEND_FAIL){
//        [items addObject:[[UIMenuItem alloc] initWithTitle:@"重发" action:@selector(onReSend:)]];
//    }


    BOOL isFirstResponder = NO;
    if(_delegate && [_delegate respondsToSelector:@selector(messageController:willShowMenuInCell:)]){
        isFirstResponder = [_delegate messageController:self willShowMenuInCell:cell];
    }
    if(isFirstResponder){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide:) name:UIMenuControllerDidHideMenuNotification object:nil];
    }
    else{
        [self becomeFirstResponder];
    }
    UIMenuController *controller = [UIMenuController sharedMenuController];
    controller.menuItems = items;
    _menuUIMsg = data;
    [controller setTargetRect:cell.container.bounds inView:cell.container];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [controller setMenuVisible:YES animated:YES];
    });
}

- (void)menuDidHide:(NSNotification*)notification
{
    if(_delegate && [_delegate respondsToSelector:@selector(didHideMenuInMessageController:)]){
        [_delegate didHideMenuInMessageController:self];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
}

- (void)onCopyMsg:(id)sender
{
    if ([_menuUIMsg isKindOfClass:[DUITextMessageCellData class]]) {
        DUITextMessageCellData *txtMsg = (DUITextMessageCellData *)_menuUIMsg;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = txtMsg.content;
    }
}

- (void)onDelete:(id)sender
{
    DIMMessage *imMsg = _menuUIMsg.innerMessage;
    if(imMsg == nil){
        return;
    }
//    if([imMsg remove]){
//        [self.tableView beginUpdates];
//        NSInteger index = [_uiMsgs indexOfObject:_menuUIMsg];
//        [_uiMsgs removeObjectAtIndex:index];
//        [_heightCache removeObjectAtIndex:index];
//        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//
//        [self.tableView endUpdates];
//    }
}

//- (void)onRevoke:(id)sender
//{
//    __weak typeof(self) ws = self;
//    [self.conv revokeMessage:_menuUIMsg.innerMessage succ:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [ws revokeMsg:ws.menuUIMsg];
//        });
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"");
//    }];
//}

//- (void)onReSend:(id)sender
//{
//    [self sendMessage:_menuUIMsg];
//}

//- (void)revokeMsg:(TUIMessageCellData *)msg
//{
//    TIMMessage *imMsg = msg.innerMessage;
//    if(imMsg == nil){
//        return;
//    }
//    NSInteger index = [_uiMsgs indexOfObject:msg];
//    if (index == NSNotFound)
//        return;
//    [_uiMsgs removeObject:msg];
//
//    [self.tableView beginUpdates];
//    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//    TUISystemMessageCellData *data = [imMsg revokeCellData];
//    [_uiMsgs insertObject:data atIndex:index];
//    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView endUpdates];
//    [self scrollToBottom:YES];
//}

@end
