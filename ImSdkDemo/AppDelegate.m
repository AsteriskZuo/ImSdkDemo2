//
//  AppDelegate.m
//  ImSdkDemo
//
//  Created by yu.zuo on 2020/1/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "AppDelegate.h"
#import "DHeader.h"
#import "Login/LoginController.h"
#import "Contact/ContactController.h"
#import "Conversation/ConversationController.h"
#import "Setting/SettingController.h"
#import "bridge/CLIMNotificationDispatch.h"

#import "DServiceManager.h"
#import "DFriendProfileControllerServiceProtocol.h"
#import "FriendProfileController.h"


#import <CLIMSDK_ios/CLIMSDK_ios.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate () <UIApplicationDelegate>

@property (nonatomic, strong) UIViewController* loginController;
@property (nonatomic, strong) UITabBarController* mainController;

@end

@implementation AppDelegate

- (void)initAppDelegate
{
    [[DServiceManager shareInstance] registerService:@protocol(DFriendProfileControllerServiceProtocol) withImplementationClass:[FriendProfileController class]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initAppDelegate];
    
    self.window.rootViewController = [self getMainController];
//    UIViewController* controller = [self getLoginController];
//    controller.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
    
    [self initSdk];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[CLIMManager sharedInstance] doBackground:nil succ:^{
        NSLog(@"[%s:%d]", __func__, __LINE__);
    } fail:^(int code, NSString *message) {
        NSLog(@"[%s:%d]", __func__, __LINE__);
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[CLIMManager sharedInstance] doForeground:^{
        NSLog(@"[%s:%d]", __func__, __LINE__);
    } fail:^(int code, NSString *message) {
        NSLog(@"[%s:%d]", __func__, __LINE__);
    }];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSString* strPushToken = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    NSString *strPushToken = [NSString stringWithFormat:@"%@",deviceToken];
//    [[CLIMPlatform sharedPlatform] setPushToken:strPushToken];
    
    CLIMAPNSConfig* apnsConfig = [[CLIMAPNSConfig alloc] init];
    apnsConfig.isOpenPush = true;
    [[CLIMManager sharedInstance] setAPNSInfo:apnsConfig succ:^{
        NSLog(@"[%s:%d][success]", __func__, __LINE__);
    } fail:^(int code, NSString *message) {
        NSLog(@"[%s:%d][fail:%d]", __func__, __LINE__, code);
    }];
    
    CLIMTokenParam * config = [[CLIMTokenParam alloc] init];
    config.pushToken = strPushToken;
    [[CLIMManager sharedInstance] setPushInfo:config succ:^{
        NSLog(@"[%s:%d][success]", __func__, __LINE__);
    } fail:^(int code, NSString *message) {
        NSLog(@"[%s:%d][fail:%d]", __func__, __LINE__, code);
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"[%s:%d][%@]", __func__, __LINE__, [error description]);
}


#pragma mark - private method

- (UIViewController *)getLoginController
{
    if (self.loginController) {
        return self.loginController;
    }
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.loginController = [board instantiateViewControllerWithIdentifier:@"LoginController"];
    return self.loginController;
}

- (UITabBarController *)getMainController
{
    if (self.mainController) {
        return self.mainController;
    }
    
    self.mainController = [[UITabBarController alloc] init];
    NSLog(@"%s, %@", __FUNCTION__, self.mainController);
    
    NSString* conversationItemTitle = @"消息";
    UIImage* conversationItemNormalImage = [UIImage imageNamed:TUIKitResource(@"message_normal")];
    UIImage* conversationItemSelectImage = [UIImage imageNamed:TUIKitResource(@"message_pressed")];
    UITabBarItem* conversationItem = [[UITabBarItem alloc] initWithTitle:conversationItemTitle image:conversationItemNormalImage selectedImage:conversationItemSelectImage];
    UINavigationController* conversationItemController = [[UINavigationController alloc] initWithRootViewController:[[ConversationController alloc] init]];
    conversationItemController.tabBarItem = conversationItem;
    
    NSString* contactItemTitle = @"通讯录";
    UIImage* contactItemNormalImage = [UIImage imageNamed:TUIKitResource(@"contacts_normal")];
    UIImage* contactItemSelectImage = [UIImage imageNamed:TUIKitResource(@"contacts_pressed")];
    UITabBarItem* contactItem = [[UITabBarItem alloc] initWithTitle:contactItemTitle image:contactItemNormalImage selectedImage:contactItemSelectImage];
    UINavigationController* contactItemController = [[UINavigationController alloc] initWithRootViewController:[[ContactController alloc] init]];
    contactItemController.tabBarItem = contactItem;
    
    NSString* settingItemTitle = @"设置";
    UIImage* settingItemNormalImage = [UIImage imageNamed:TUIKitResource(@"contacts_normal")];
    UIImage* settingItemSelectImage = [UIImage imageNamed:TUIKitResource(@"contacts_pressed")];
    UITabBarItem* settingItem = [[UITabBarItem alloc] initWithTitle:settingItemTitle image:settingItemNormalImage selectedImage:settingItemSelectImage];
    UINavigationController* settingItemController = [[UINavigationController alloc] initWithRootViewController:[[SettingController alloc] init]];
    settingItemController.tabBarItem = settingItem;
    
    self.mainController.viewControllers = [NSArray arrayWithObjects:conversationItemController, contactItemController, settingItemController, nil];
    return self.mainController;
    
    
}

- (void)initSdk
{
    CLIMGlobalConfig* gConfig = [[CLIMGlobalConfig alloc] init];
    gConfig.appKey = @"test1";
    gConfig.naviDomain = @"test2";
    gConfig.naviDomainEnableSSL = true;
    
    gConfig.convListListener = [CLIMConversationListNotification sharedInstance];
    gConfig.disconnectListener = [CLIMDisconnectNotification sharedInstance];
    gConfig.recvMsgListener = [CLIMReceiverMessageNotification sharedInstance];
    gConfig.uploadFileProgressListener = [CLIMUploadFileProgressNotification sharedInstance];
    
    [[CLIMManager sharedInstance] initSdk:gConfig];
    
    [self updatePushToken];
}

- (void)updatePushToken
{
    [self getPushToken];
}

- (void)getPushToken {

    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            __weak typeof(self) weakSelf = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[UIApplication sharedApplication] registerForRemoteNotifications];
                            });
                        }
                    }];
                } else {
                    NSLog(@"requestAuthorizationWithOptions is failed.");
                }
            }];
        }
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
        if (@available(iOS 8.0, *)) {
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            } else {
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            }
        }
    }
}

@end
