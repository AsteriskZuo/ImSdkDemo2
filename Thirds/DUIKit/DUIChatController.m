//
//  DUIChatController.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/7.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIChatController.h"
#import "DUIInputController.h"
#import "DUIMessageController.h"
#import "DHeader.h"

@interface DUIChatController () <UINavigationControllerDelegate>

@property (nonatomic, strong) DUIMessageController* messageController;
@property (nonatomic, strong) DUIInputController* inputController;

@end

@implementation DUIChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = YES;
    self.navigationController.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated
{
}
- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)setupViews
{
    _messageController = [[DUIMessageController alloc] init];
    _messageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TTextView_Height - Bottom_SafeHeight);
    _messageController.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:_messageController];
    [self.view addSubview:_messageController.view];
    
    _inputController = [[DUIInputController alloc] init];
    _inputController.view.frame = CGRectMake(0, self.view.frame.size.height - TTextView_Height - Bottom_SafeHeight, self.view.frame.size.width, TTextView_Height - Bottom_SafeHeight);
    _inputController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _inputController.view.backgroundColor = [UIColor purpleColor];
    [self addChildViewController:_inputController];
    [self.view addSubview:_inputController.view];
    
    self.navigationController.delegate = self;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    [navigationController setToolbarHidden:YES animated:nil];
//    [self.navigationController setToolbarHidden:YES animated:nil];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}


@end
