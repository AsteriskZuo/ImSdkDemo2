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
#import "DUISystemMessageCell.h"
#import "DUIVoiceMessageCell.h"
#import "DUIImageMessageCell.h"
#import "DUIFaceMessageCell.h"
#import "DUIVideoMessageCell.h"
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
#import "DUIVideoController.h"
#import "DUIFileViewController.h"
//#import "TUIConversationDataProviderService.h"
#import "NSString+TUICommon.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "MMLayout/UIView+MMLayout.h"
//#import "TIMMessage+DataProvider.h"
//#import "TUIUserProfileControllerServiceProtocol.h"
#import <CLIMSDK_ios/CLIMSDK_ios.h>
#import "CLIMNotificationDispatch.h"


#define MAX_MESSAGE_SEP_DLAY (5 * 60)

@interface DUIPopLabel : UILabel

@property (nonatomic, weak) UITableView* content;
@property (nonatomic, strong) UILabel* test;

@end

@implementation DUIPopLabel

- (instancetype)init
{
    if (self = [super init]) {
        _test = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 1, 1)];
        _test.backgroundColor = [UIColor blackColor];
        [self addSubview:_test];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _test = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 1, 1)];
        _test.backgroundColor = [UIColor blackColor];
        [self addSubview:_test];
    }
    return self;
}

/**
 * 只能更新子类，不能更新本身，不然就会死循环！！！！
 */
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    CGRect newFrame = self.frame;
//    newFrame.size.width = Screen_Width;
//    CGFloat offset = StatusBar_Height + NavBar_Height;
//    {
//        UIInterfaceOrientation status = [UIApplication sharedApplication].statusBarOrientation;
//        if (UIInterfaceOrientationPortrait == status
//            || UIInterfaceOrientationPortraitUpsideDown == status) {
//            offset = StatusBar_Height + NavBar_Height;
//        } else if (UIInterfaceOrientationLandscapeLeft == status
//                   || UIInterfaceOrientationLandscapeRight == status) {
//            offset = NavBar_Height;
//        } else {
//            NSLog(@"%s,%d", __func__, __LINE__);
//        }
//    }
//    if (_content) {
//        //这样写？有问题？？？
//        __strong typeof(_content) scontent = _content;
//        newFrame.origin.y = offset + scontent.contentOffset.y;
//        NSLog(@"%s, %@,%f,%f,%f,%f,%f", __func__
//              , NSStringFromClass([scontent class])
//              , scontent.contentOffset.y, self.mm_y
//              , scontent.contentInset.top, scontent.contentInset.bottom, scontent.tableHeaderView.frame.size.height);
//    } else {
//        UITableView* superView = (UITableView*)[self superview];
//        if (superView) {
//            newFrame.origin.y = offset + superView.contentOffset.y;
//            NSLog(@"%s, %@,%f,%f,%f,%f,%f", __func__
//                  , NSStringFromClass([superView class])
//                  , superView.contentOffset.y, self.mm_y
//                  , superView.contentInset.top, superView.contentInset.bottom, superView.tableHeaderView.frame.size.height);
//        }
//
//    }
////    self.frame = newFrame;//导致虚拟机问题？死循环了~~~
//    static int count = 0;
//    count = count % 3;
//    self.test.mm_left(++count);
//}

- (void)updateLayout:(NSNotification* )notification
{
    CGRect newFrame = self.frame;
    newFrame.size.width = Screen_Width;
    CGFloat offset = StatusBar_Height + NavBar_Height;
    
    if (false)
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
    
    if (true)
    {
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
            || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
            offset = StatusBar_Height + NavBar_Height;
        } else {
            offset = NavBar_Height;
        }
    }
    if (_content) {
        //这样写？有问题？？？
        __strong typeof(_content) scontent = _content;
        newFrame.origin.y = offset + scontent.contentOffset.y;
        NSLog(@"%s, %@,%f,%f,%f,%f,%f,%f", __func__
              , NSStringFromClass([scontent class])
              , scontent.contentOffset.y, self.mm_y
              , scontent.contentInset.top, scontent.contentInset.bottom, scontent.tableHeaderView.frame.size.height, newFrame.origin.y);
    } else {
        UITableView* superView = (UITableView*)[self superview];
        if (superView) {
            newFrame.origin.y = offset + superView.contentOffset.y;
            NSLog(@"%s, %@,%f,%f,%f,%f,%f,%f", __func__
                  , NSStringFromClass([superView class])
                  , superView.contentOffset.y, self.mm_y
                  , superView.contentInset.top, superView.contentInset.bottom, superView.tableHeaderView.frame.size.height, newFrame.origin.y);
        }

    }
    self.frame = newFrame;
}

@end

@interface DUIMessageController () <DUIMessageCellDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) CLIMConversation *conv;
@property (nonatomic, strong) NSString* accountId;
@property (nonatomic, strong) NSMutableArray<__kindof DUIMessageCellData* > *uiMsgs;
@property (nonatomic, strong) NSMutableArray *heightCache;
@property (nonatomic, strong) CLIMMessage *msgForDate;
@property (nonatomic, strong) CLIMMessage *msgForGet;
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
    [self initSdk];
    
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
    [self.tableView registerClass:[DUISystemMessageCell class] forCellReuseIdentifier:TSystemMessageCell_ReuseId];
    [self.tableView registerClass:[DUIFaceMessageCell class] forCellReuseIdentifier:TFaceMessageCell_ReuseId];
    [self.tableView registerClass:[DUIVideoMessageCell class] forCellReuseIdentifier:TVideoMessageCell_ReuseId];
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

- (void)changeRotate:(NSNotification* )notification
{
    return;
    
    CGFloat offset = 0;
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        NSLog(@"竖屏");//竖屏
        offset = StatusBar_Height + NavBar_Height;
    } else {
        NSLog(@"横屏");//横屏
        offset = StatusBar_Height + 200;
    }
    
    _notifyView.mm_top(offset + self.tableView.contentOffset.y);
    _notifyView.mm_width(Screen_Width);
    
    NSLog(@"[%s:%d][notify = x:%f y:%f width:%f height:%f][table = y:%f][offset = %f]", __func__, __LINE__, _notifyView.frame.origin.x, _notifyView.frame.origin.y, _notifyView.frame.size.width, _notifyView.frame.size.height, self.tableView.contentOffset.y, offset);
    
    [self.view setNeedsLayout];
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
    CLIMMessage *imMsg = msg.innerMessage;
    DUIMessageCellData *dateMsg = nil;
    if (msg.status == Msg_Status_Init)
    {
        //新消息
        if (!imMsg) {
            imMsg = [self translateFromUIMsgToIMMsg:msg];
        }
        dateMsg = [self transSystemMsgFromTimestamp:imMsg.timestamp];

    } else if (imMsg) {
        //重发
        dateMsg = [self transSystemMsgFromDate:[NSDate date]];
        NSInteger row = [_uiMsgs indexOfObject:msg];
        [_heightCache removeObjectAtIndex:row];
        [_uiMsgs removeObjectAtIndex:row];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
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
    
    @weakify(self);
    [_conv sendMessage:imMsg success:^(CLIMSendMessageResult *message) {
        NSLog(@"[%s:%d][success][msgId:%@]", __func__, __LINE__, message.msgId);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self changeMsg:msg status:Msg_Status_Succ];
        });
    } failed:^(int code, NSString *message) {
        NSLog(@"[%s:%d][fail][error:%d]", __func__, __LINE__, code);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self changeMsg:msg status:Msg_Status_Fail];
        });
    }];

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

- (CLIMMessage *)translateFromUIMsgToIMMsg:(DUIMessageCellData *)data
{
    CLIMMessage* msg = nil;
//    msg.timestamp = [NSDate date].timeIntervalSince1970 * 1000;
    if ([data isKindOfClass:[DUITextMessageCellData class]]) {
        CLIMTextMessage* msg = [[CLIMTextMessage alloc] initWithConversation:_conv];
        msg.content = ((DUITextMessageCellData*)data).content;
        return msg;
    } else if ([data isKindOfClass:[DUIImageMessageCellData class]]) {
        CLIMImageMessage* msg = [[CLIMImageMessage alloc] initWithConversation:_conv];
        msg.localPath = ((DUIImageMessageCellData* )data).path;
        return msg;
    } else if ([data isKindOfClass:[DUIVoiceMessageCellData class]]) {
        CLIMVoiceMessage* msg = [[CLIMVoiceMessage alloc] initWithConversation:_conv];
        msg.localPath = ((DUIVoiceMessageCellData*)data).path;
        msg.voiceLength = ((DUIVoiceMessageCellData*)data).duration;
        return msg;
    } else if ([data isKindOfClass:[DUIFileMessageCellData class]]) {
        return msg;
    } else if ([data isKindOfClass:[DUIFaceMessageCellData class]]) {
        return msg;
    } else if ([data isKindOfClass:[DUIVideoMessageCellData class]]) {
        return msg;
    }
    return nil;
}

- (DUISystemMessageCellData *)transSystemMsgFromTimestamp:(long long)timestamp
{
    return [self transSystemMsgFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
}

- (DUISystemMessageCellData *)transSystemMsgFromDate:(NSDate *)date
{
    if(_msgForDate == nil || fabs([date timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:_msgForDate.timestamp]]) > MAX_MESSAGE_SEP_DLAY){
        DUISystemMessageCellData *system = [[DUISystemMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
        system.content = [date tk_messageString];
        system.reuseId = TSystemMessageCell_ReuseId;
        return system;
    }
    return nil;
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
    CGFloat offset = 0;
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        NSLog(@"竖屏");//竖屏
        offset = StatusBar_Height + NavBar_Height;
    } else {
        NSLog(@"横屏");//横屏
        offset = 32;
    }
    _notifyView.mm_top(offset + scrollView.contentOffset.y);
    _notifyView.mm_width(Screen_Width);
    NSLog(@"[%s:%d][notify = x:%f y:%f width:%f height:%f][table = y:%f][offset = %f]", __func__, __LINE__, _notifyView.frame.origin.x, _notifyView.frame.origin.y, _notifyView.frame.size.width, _notifyView.frame.size.height, self.tableView.contentOffset.y, offset);
    
    
    if(!_noMoreMsg && scrollView.contentOffset.y <= TMessageController_Header_Height){
        if(!_indicatorView.isAnimating){
            [_indicatorView startAnimating];
            NSLog(@"%s,%d", __func__, __LINE__);
        }
    }
    else{
        if(_indicatorView.isAnimating){
            [_indicatorView stopAnimating];
            NSLog(@"%s,%d", __func__, __LINE__);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y <= TMessageController_Header_Height){
        [self loadMessage];
    }
}

#pragma mark - notification

- (void)initSdk
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMessageList:) name:CLIMReceiverMessageNotification_receiveNewMessageList object:nil];
}

- (void)receiveNewMessageList:(NSNotification*)notification
{
    NSArray<__kindof CLIMMessage* >* messages = notification.object;
    if (nil == messages) {
        return;
    }
    [self.tableView beginUpdates];
    for (CLIMMessage* msg in messages) {
        DUIMessageCellData* uimsg = [self translateFromIMMsgToUIMsg:msg];
        [_uiMsgs addObject:uimsg];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_uiMsgs.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
}

- (DUIMessageCellData*)translateFromIMMsgToUIMsg:(CLIMMessage*)IMMsg
{
    DMsgDirection direction = (IMMsg.sender == _accountId ? MsgDirectionOutgoing : MsgDirectionIncoming);
    if ([IMMsg isKindOfClass:[CLIMTextMessage class]]) {
        CLIMTextMessage* sdkMsg = (CLIMTextMessage*)IMMsg;
        DUITextMessageCellData* msg = [[DUITextMessageCellData alloc] initWithDirection:direction];
        msg.content = sdkMsg.content;
        return msg;
    } else if ([IMMsg isKindOfClass:[CLIMImageMessage class]]) {
        CLIMImageMessage* sdkMsg = (CLIMImageMessage* )IMMsg;
        DUIImageMessageCellData* msg = [[DUIImageMessageCellData alloc] initWithDirection:direction];
        msg.path = sdkMsg.localPath;
        for (int i = 0; i < sdkMsg.imageList.count; ++i) {
            CLIMImage* img = sdkMsg.imageList[i];
            DUIImageItem* item = [[DUIImageItem alloc] init];
            item.uuid = img.imageId;
            item.url = img.url;
            if (CLIM_IMAGE_TYPE_ORIGIN == img.type) {
                item.type = TImage_Type_Origin;
            } else if (CLIM_IMAGE_TYPE_LARGE == img.type) {
                item.type = TImage_Type_Large;
            } else if (CLIM_IMAGE_TYPE_THUMB == img.type) {
                item.type = TImage_Type_Thumb;
            }
            [msg.items addObject:item];
        }
        return msg;
    } else if ([IMMsg isKindOfClass:[CLIMVoiceMessage class]]) {
        CLIMVoiceMessage* voice = (CLIMVoiceMessage*)IMMsg;
        DUIVoiceMessageCellData* msg = [[DUIVoiceMessageCellData alloc] initWithDirection:direction];
        msg.path = voice.localPath;
        msg.duration = voice.voiceLength;
        msg.uuid = voice.voiceId;
        return msg;
    }
    return nil;
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
        else if([data isKindOfClass:[DUIVideoMessageCellData class]]) {
            data.reuseId = TVideoMessageCell_ReuseId;
        }
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

- (void)setConversation:(CLIMConversation *)conversation
{
    _conv = conversation;
    _accountId = [[CLIMManager sharedInstance] getUserId];
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        [self loadMessage];
    });
}




#pragma mark - message cell delegate

- (void)onSelectMessage:(DUIMessageCell *)cell
{
    if([cell isKindOfClass:[DUIVoiceMessageCell class]]){
        [self playVoiceMessage:(DUIVoiceMessageCell *)cell];
    }
    if ([cell isKindOfClass:[DUIImageMessageCell class]]) {
        [self showImageMessage:(DUIImageMessageCell *)cell];
    }
    if ([cell isKindOfClass:[DUIVideoMessageCell class]]) {
        [self showVideoMessage:(DUIVideoMessageCell *)cell];
    }
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
    CLIMMessage *imMsg = _menuUIMsg.innerMessage;
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

- (void)showVideoMessage:(DUIVideoMessageCell *)cell
{
    DUIVideoController *video = [[DUIVideoController alloc] init];
    video.data = [cell videoData];
    [self.navigationController pushViewController:video animated:YES];
}

- (void)showFileMessage:(DUIFileMessageCell *)cell
{
    DUIFileViewController *file = [[DUIFileViewController alloc] init];
    file.data = [cell fileData];
    [self.navigationController pushViewController:file animated:YES];
}

@end
