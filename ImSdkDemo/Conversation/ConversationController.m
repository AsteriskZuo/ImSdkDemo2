//
//  ConversationController.m
//  ImSdkDemo
//
//  Created by yu.zuo on 2020/1/6.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "ConversationController.h"
#import "AppDelegate.h"

@interface ConversationController ()

@end

@implementation ConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController* controller = [((AppDelegate *)[UIApplication sharedApplication].delegate) getLoginController];
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
