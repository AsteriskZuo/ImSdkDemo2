//
//  LoginController.m
//  ImSdkDemo
//
//  Created by yu.zuo on 2020/1/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "LoginController.h"
#import "../Contact/ContactController.h"
#import "../Conversation/ConversationController.h"
#import "../Setting/SettingController.h"
#import "../AppDelegate.h"

@interface LoginController ()
@property (weak, nonatomic) IBOutlet UITextField *userId;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor greenColor];

    //ref: https://developer.apple.com/documentation/uikit/uicontrol/1618259-addtarget?language=objc
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:forEvent:)];
    [self.view addGestureRecognizer:tap];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onTap:(id)sender forEvent:(UIEvent*)event
{
    [self.userId resignFirstResponder];
}

- (IBAction)loginAction:(id)sender {
    
//    UITabBarController* controller = [((AppDelegate *)[UIApplication sharedApplication].delegate) getMainController];
//    controller.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:controller animated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
