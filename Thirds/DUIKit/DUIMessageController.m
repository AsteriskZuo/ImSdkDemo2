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
#import "DUIVoiceMessageCell.h"
#import "DUIImageMessageCell.h"
#import "DUIFaceMessageCell.h"
//#import "TUIVideoMessageCell.h"
#import "DUIFileMessageCell.h"
//#import "TUIJoinGroupMessageCell.h"
#import "DUIKitConfig.h"
#import "DUIFaceView.h"
#import "DHeader.h"
#import "DUIKit.h"
#import "DHelper.h"
#import "DUIConversationCell.h"
//#import "TIMMessage+DataProvider.h"
#import "DUIImagePreviewController.h"
//#import "TUIVideoViewController.h"
#import "DUIFileViewController.h"
//#import "TUIConversationDataProviderService.h"
#import "NSString+TUICommon.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "MMLayout/UIView+MMLayout.h"
//#import "TIMMessage+DataProvider.h"
//#import "TUIUserProfileControllerServiceProtocol.h"
//#import <ImSDK/ImSDK.h>
#import "DIMMessage.h"


#define MAX_MESSAGE_SEP_DLAY (5 * 60)

@interface DUIPopLabel : UILabel

@property (nonatomic, weak) UITableView* content;

@end

@implementation DUIPopLabel

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect newFrame = self.frame;
    newFrame.size.width = Screen_Width;
    CGFloat offset = StatusBar_Height + NavBar_Height;
    {
        UIInterfaceOrientation status = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationPortrait == status
            || UIInterfaceOrientationPortraitUpsideDown == status) {
            offset = StatusBar_Height + NavBar_Height;
        } else if (UIInterfaceOrientationLandscapeLeft == status
                   || UIInterfaceOrientationLandscapeRight == status) {
            offset = NavBar_Height;
        } else {
            NSLog(@"%s,%d", __func__, __LINE__);
        }
    }
    if (_content) {
        //这样写？有问题？？？
        __strong typeof(_content) scontent = _content;
        newFrame.origin.y = offset + scontent.contentOffset.y;
        NSLog(@"%s, %@,%f,%f,%f,%f,%f", __func__
              , NSStringFromClass([scontent class])
              , scontent.contentOffset.y, self.mm_y
              , scontent.contentInset.top, scontent.contentInset.bottom, scontent.tableHeaderView.frame.size.height);
    } else {
        UITableView* superView = (UITableView*)[self superview];
        if (superView) {
            newFrame.origin.y = offset + superView.contentOffset.y;
            NSLog(@"%s, %@,%f,%f,%f,%f,%f", __func__
                  , NSStringFromClass([superView class])
                  , superView.contentOffset.y, self.mm_y
                  , superView.contentInset.top, superView.contentInset.bottom, superView.tableHeaderView.frame.size.height);
        }
        
    }
    self.frame = newFrame;//导致虚拟机问题？死循环了~~~
}

@end

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
@property (nonatomic, strong) DUIPopLabel* notifyView;
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
    [self.tableView registerClass:[DUIVoiceMessageCell class] forCellReuseIdentifier:TVoiceMessageCell_ReuseId];
    [self.tableView registerClass:[DUIImageMessageCell class] forCellReuseIdentifier:TImageMessageCell_ReuseId];
//    [self.tableView registerClass:[TUISystemMessageCell class] forCellReuseIdentifier:TSystemMessageCell_ReuseId];
    [self.tableView registerClass:[DUIFaceMessageCell class] forCellReuseIdentifier:TFaceMessageCell_ReuseId];
//    [self.tableView registerClass:[TUIVideoMessageCell class] forCellReuseIdentifier:TVideoMessageCell_ReuseId];
    [self.tableView registerClass:[DUIFileMessageCell class] forCellReuseIdentifier:TFileMessageCell_ReuseId];
//    [self.tableView registerClass:[TUIJoinGroupMessageCell class] forCellReuseIdentifier:TJoinGroupMessageCell_ReuseId];


    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, TMessageController_Header_Height)];
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.tableHeaderView = _indicatorView;
    

    _notifyView = [[DUIPopLabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 30)];
    _notifyView.backgroundColor = RGBA(100, 100, 100, 0.5);
//    _notifyView.content = self.tableView;
    [self.view addSubview:_notifyView];

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
    [self.tableView beginUpdates];
    DIMMessage *imMsg = msg.innerMessage;
    DUIMessageCellData *dateMsg = nil;
    if (msg.status == Msg_Status_Init)
    {
        //新消息
        if (!imMsg) {
            imMsg = [self transIMMsgFromUIMsg:msg];
        }
//        dateMsg = [self transSystemMsgFromDate:imMsg.timestamp];

    } else if (imMsg) {
        //重发
//        dateMsg = [self transSystemMsgFromDate:[NSDate date]];
//        NSInteger row = [_uiMsgs indexOfObject:msg];
//        [_heightCache removeObjectAtIndex:row];
//        [_uiMsgs removeObjectAtIndex:row];
//        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]
//                              withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView endUpdates];
        NSLog(@"Unknown message state");
        return;
    }
//    DIMUserProfile *selfProfile = [[TIMFriendshipManager sharedInstance] querySelfProfile];

//    msg.status = Msg_Status_Sending;
//    msg.name = [selfProfile showName];
    msg.name = imMsg.sender;
//    msg.avatarUrl = [NSURL URLWithString:selfProfile.faceURL];
    msg.avatarImage = [UIImage imageNamed:TUIKitResource(@"default_head")];

    if(dateMsg){
        _msgForDate = imMsg;
        [_uiMsgs addObject:dateMsg];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_uiMsgs.count - 1 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    [_uiMsgs addObject:msg];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_uiMsgs.count - 1 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self scrollToBottom:YES];

//    __weak typeof(self) ws = self;
//    [self.conv sendMessage:imMsg succ:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [ws changeMsg:msg status:Msg_Status_Succ];
//        });
//    } fail:^(int code, NSString *desc) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [THelper makeToastError:code msg:desc];
//            [ws changeMsg:msg status:Msg_Status_Fail];
//        });
//    }];

//    int delay = 1;
//    if([msg isKindOfClass:[TUIImageMessageCellData class]]){
//        delay = 0;
//    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if(msg.status == Msg_Status_Sending){
//            [ws changeMsg:msg status:Msg_Status_Sending_2];
//        }
//    });
}

- (DIMMessage *)transIMMsgFromUIMsg:(DUIMessageCellData *)data
{
    static int count = 0;
    DIMMessage* msg = [[DIMMessage alloc] init];
    msg.timestamp = [NSDate date];
    msg.conversation = _conv;
    msg.sender = @"self";
    msg.isPeerReaded = false;
    msg.isReaded = true;
    msg.isSelf = true;
    msg.msgId = [[NSUUID UUID] UUIDString];
    msg.status = TIM_MSG_STATUS_SEND_SUCC;
    msg.uniqueId = ++count;

    if ([data isKindOfClass:[DUITextMessageCellData class]]) {
        TIMTextElem* elem = [[TIMTextElem alloc] init];
        elem.text = ((DUITextMessageCellData*)data).content;
        [msg addElem:elem];
        return msg;
    } else if ([data isKindOfClass:[DUIImageMessageCellData class]]) {
        DIMImageElem *imImage = [[DIMImageElem alloc] init];
        DUIImageMessageCellData *uiImage = (DUIImageMessageCellData *)data;
        imImage.path = uiImage.path;
        [msg addElem:imImage];
        return msg;
    } else if ([data isKindOfClass:[DUIVoiceMessageCellData class]]) {
        DIMSoundElem *imImage = [[DIMSoundElem alloc] init];
        DUIVoiceMessageCellData *uiImage = (DUIVoiceMessageCellData *)data;
        imImage.path = uiImage.path;
        imImage.second = uiImage.duration;
        imImage.dataSize = uiImage.length;
        [msg addElem:imImage];
        return msg;
    } else if ([data isKindOfClass:[DUIFileMessageCellData class]]) {
        DIMFileElem *imImage = [[DIMFileElem alloc] init];
        DUIFileMessageCellData *uiImage = (DUIFileMessageCellData *)data;
        imImage.path = uiImage.path;
        imImage.filename = uiImage.fileName;
        imImage.fileSize = uiImage.length;
        [msg addElem:imImage];
        return msg;
    } else if ([data isKindOfClass:[DUIFaceMessageCellData class]]) {
        DIMFaceElem *imImage = [[DIMFaceElem alloc] init];
        DUIFaceMessageCellData *uiImage = (DUIFaceMessageCellData *)data;
        imImage.index = (int)uiImage.groupIndex;
        imImage.data = [uiImage.faceName dataUsingEncoding:NSUTF8StringEncoding];
        [msg addElem:imImage];
        return msg;
    }
    return nil;
}

//- (TUISystemMessageCellData *)transSystemMsgFromDate:(NSDate *)date
//{
//    if(_msgForDate == nil || fabs([date timeIntervalSinceDate:_msgForDate.timestamp]) > MAX_MESSAGE_SEP_DLAY){
//        TUISystemMessageCellData *system = [[TUISystemMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
//        system.content = [date tk_messageString];
//        system.reuseId = TSystemMessageCell_ReuseId;
//        return system;
//    }
//    return nil;
//}

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
    _notifyView.mm_top(offset + scrollView.contentOffset.y);
    NSLog(@"%s, %@,%f,%f,%f,%f,%f", __func__, NSStringFromClass([scrollView class]), scrollView.contentOffset.y, _notifyView.mm_y, scrollView.contentInset.top, scrollView.contentInset.bottom, self.tableView.tableHeaderView.frame.size.height);
    
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
        else if([data isKindOfClass:[DUIFaceMessageCellData class]]) {
            data.reuseId = TFaceMessageCell_ReuseId;
        }
        else if([data isKindOfClass:[DUIImageMessageCellData class]]) {
            data.reuseId = TImageMessageCell_ReuseId;
        }
//        else if([data isKindOfClass:[TUIVideoMessageCellData class]]) {
//            data.reuseId = TVideoMessageCell_ReuseId;
//        }
        else if([data isKindOfClass:[DUIVoiceMessageCellData class]]) {
            data.reuseId = TVoiceMessageCell_ReuseId;
        }
        else if([data isKindOfClass:[DUIFileMessageCellData class]]) {
            data.reuseId = TFileMessageCell_ReuseId;
        }
//        else if([data isKindOfClass:[TUIJoinGroupMessageCellData class]]){//入群小灰条对应的数据源
//            data.reuseId = TJoinGroupMessageCell_ReuseId;
//        }
//        else if([data isKindOfClass:[TUISystemMessageCellData class]]) {
//            data.reuseId = TSystemMessageCell_ReuseId;
//        }
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

- (void)setConversation:(DIMConversation *)conversation
{
    _conv = conversation;
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
    if([cell isKindOfClass:[DUIVoiceMessageCell class]]){
        [self playVoiceMessage:(DUIVoiceMessageCell *)cell];
    }
    if ([cell isKindOfClass:[DUIImageMessageCell class]]) {
        [self showImageMessage:(DUIImageMessageCell *)cell];
    }
//    if ([cell isKindOfClass:[TUIVideoMessageCell class]]) {
//        [self showVideoMessage:(TUIVideoMessageCell *)cell];
//    }
    if ([cell isKindOfClass:[DUIFileMessageCell class]]) {
        [self showFileMessage:(DUIFileMessageCell *)cell];
    }
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

- (void)onRetryMessage:(DUIMessageCell *)cell
{
}

- (void)onSelectMessageAvatar:(DUIMessageCell *)cell
{
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

- (void)playVoiceMessage:(DUIVoiceMessageCell *)cell
{
    for (NSInteger index = 0; index < _uiMsgs.count; ++index) {
        if(![_uiMsgs[index] isKindOfClass:[DUIVoiceMessageCellData class]]){
            continue;
        }
        DUIVoiceMessageCellData *uiMsg = _uiMsgs[index];
        if(uiMsg == cell.voiceData){
            [uiMsg playVoiceMessage];
            cell.voiceReadPoint.hidden = YES;
        }
        else{
            [uiMsg stopVoiceMessage];
        }
    }
}

- (void)showImageMessage:(DUIImageMessageCell *)cell
{
    DUIImagePreviewController *image = [[DUIImagePreviewController alloc] init];
    image.data = [cell imageData];
    [self.navigationController pushViewController:image animated:YES];
}

//- (void)showVideoMessage:(TUIVideoMessageCell *)cell
//{
//    TUIVideoViewController *video = [[TUIVideoViewController alloc] init];
//    video.data = [cell videoData];
//    [self.navigationController pushViewController:video animated:YES];
//}
//
- (void)showFileMessage:(DUIFileMessageCell *)cell
{
    DUIFileViewController *file = [[DUIFileViewController alloc] init];
    file.data = [cell fileData];
    [self.navigationController pushViewController:file animated:YES];
}

@end
