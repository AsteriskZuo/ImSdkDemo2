//
//  AppDelegate.m
//  ImSdkDemo
//
//  Created by yu.zuo on 2020/1/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "AppDelegate.h"
#import "Common/Common.h"
#import "Login/LoginController.h"
#import "Contact/ContactController.h"
#import "Conversation/ConversationController.h"
#import "Setting/SettingController.h"

#import "DServiceManager.h"
#import "DFriendProfileControllerServiceProtocol.h"
#import "FriendProfileController.h"

@interface AppDelegate ()

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
    
    return YES;
}

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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
