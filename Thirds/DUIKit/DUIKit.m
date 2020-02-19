//
//  DUIKit.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/15.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIKit.h"
#import "DHeader.h"
#import "DCommon.h"
#import "DUIKitConfig.h"


@interface DUIKit ()
//<TIMRefreshListener, TIMMessageListener, TIMMessageRevokeListener, TIMUploadProgressListener, TIMUserStatusListener, TIMConnListener, TIMFriendshipListener, TIMMessageUpdateListener,TIMMessageReceiptListener>
@property (nonatomic) DUINetStatus netStatus;
@end

@implementation DUIKit

+ (instancetype)sharedInstance
{
    static DUIKit *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DUIKit alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _config = [DUIKitConfig defaultConfig];
        [self createCachePath];
    }
    return self;
}

- (void)createCachePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:TUIKit_Image_Path]){
        [fileManager createDirectoryAtPath:TUIKit_Image_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:TUIKit_Video_Path]){
        [fileManager createDirectoryAtPath:TUIKit_Video_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:TUIKit_Voice_Path]){
        [fileManager createDirectoryAtPath:TUIKit_Voice_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:TUIKit_File_Path]){
        [fileManager createDirectoryAtPath:TUIKit_File_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:TUIKit_DB_Path]){
        [fileManager createDirectoryAtPath:TUIKit_DB_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)setupWithAppId:(NSInteger)sdkAppId
{
//    TIMSdkConfig *sdkConfig = [[TIMSdkConfig alloc] init];
//    sdkConfig.sdkAppId = (int)sdkAppId;
//    sdkConfig.dbPath = TUIKit_DB_Path;
//    sdkConfig.connListener = self;
//    [[TIMManager sharedInstance] initSdk:sdkConfig];
//    [[TIMManager sharedInstance] addMessageListener:self];
//    [self setUserConfig];
}

- (void)setupWithAppId:(NSInteger)sdkAppId logLevel:(DIMLogLevel)logLevel
{
//    TIMSdkConfig *sdkConfig = [[TIMSdkConfig alloc] init];
//    sdkConfig.sdkAppId = (int)sdkAppId;
//    sdkConfig.dbPath = TUIKit_DB_Path;
//    sdkConfig.logLevel = logLevel;
//    sdkConfig.connListener = self;
//    [[TIMManager sharedInstance] initSdk:sdkConfig];
//    [[TIMManager sharedInstance] addMessageListener:self];
//    [self setUserConfig];
}

- (void)setUserConfig
{
//    TIMUserConfig *userConfig = [[TIMUserConfig alloc] init];
//    userConfig.disableAutoReport = YES;
//    userConfig.refreshListener = self;
//    userConfig.messageRevokeListener = self;
//    userConfig.uploadProgressListener = self;
//    userConfig.userStatusListener = self;
//    userConfig.friendshipListener = self;
//    userConfig.messageUpdateListener = self;
//    userConfig.enableReadReceipt = YES;
//    userConfig.messageReceiptListener = self;
//    [[TIMManager sharedInstance] setUserConfig:userConfig];
}


/*
- (void)onRefreshConversations:(NSArray *)conversations
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMRefreshListener object:conversations];
}

#pragma mark - TIMMessageListener
- (void)onNewMessage:(NSArray *)msgs
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMMessageListener object:msgs];
}

- (void)onRevokeMessage:(TIMMessageLocator *)locator
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMMessageRevokeListener object:locator];
}

- (void) onRecvMessageReceipts:(NSArray*)receipts
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_onRecvMessageReceipts object:receipts];
}

- (void)onUploadProgressCallback:(TIMMessage *)msg elemidx:(uint32_t)elemidx taskid:(uint32_t)taskid progress:(uint32_t)progress
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"message", [NSNumber numberWithInt:progress], @"progress", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMUploadProgressListener object:dic];
}


#pragma mark - user
- (void)onForceOffline
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMUserStatusListener object:[NSNumber numberWithInt:TUser_Status_ForceOffline]];
}

- (void)onReConnFailed:(int)code err:(NSString*)err
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMUserStatusListener object:[NSNumber numberWithInt:TUser_Status_ReConnFailed]];
}

- (void)onUserSigExpired
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMUserStatusListener object:[NSNumber numberWithInt:TUser_Status_SigExpired]];
}

#pragma mark - network

- (void)onConnSucc
{
    self.netStatus = TNet_Status_Succ;
}

- (void)onConnFailed:(int)code err:(NSString*)err
{
    self.netStatus = TNet_Status_ConnFailed;
}

- (void)onDisconnect:(int)code err:(NSString*)err
{
    self.netStatus = TNet_Status_Disconnect;
}

- (void)onConnecting
{
    self.netStatus = TNet_Status_Connecting;
}

- (void)setNetStatus:(TUINetStatus)netStatus
{
    _netStatus = netStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMConnListener object:[NSNumber numberWithInt:netStatus]];
}

- (void)onAddFriends:(NSArray *)users
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_onAddFriends object:users];
}

- (void)onDelFriends:(NSArray *)identifiers
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_onDelFriends object:identifiers];
}

- (void)onFriendProfileUpdate:(NSArray *)profiles
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_onFriendProfileUpdate object:profiles];
}

- (void)onAddFriendReqs:(NSArray *)reqs
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_onAddFriendReqs object:reqs];
}

#pragma mark - TIMMessageUpdateListener
- (void)onMessageUpdate:(NSArray*) msgs
{

}
 
 */

@end
