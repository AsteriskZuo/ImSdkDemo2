//
//  DUIFileViewController.m
//  ImSdkDemo
//
//  Created by zuoyu on 2020/3/4.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIFileViewController.h"
#import "DCommon.h"
#import "DHeader.h"
#import "DUIFileMessageCell.h"

#import "ReactiveObjC.h"

@interface DUIFileViewController () <UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *progress;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIDocumentInteractionController *document;
@end

@implementation DUIFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews
{
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"文件";
    //left
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:TUIKitResource(@"back")] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 10.0f;//看起来美观吧？？？
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
        leftButton.contentEdgeInsets =UIEdgeInsetsMake(0, -15, 0, 0);
        leftButton.imageEdgeInsets =UIEdgeInsetsMake(0, -15, 0, 0);
    }
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftItem];
    self.parentViewController.navigationItem.leftBarButtonItems = @[spaceItem,leftItem];

    _image = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 80) * 0.5, NavBar_Height + StatusBar_Height + 50, 80, 80)];
    _image.contentMode = UIViewContentModeScaleAspectFit;
    _image.image = [UIImage imageNamed:TUIKitResource(@"msg_file")];
    [self.view addSubview:_image];

    _name = [[UILabel alloc] initWithFrame:CGRectMake(0, _image.frame.origin.y + _image.frame.size.height + 20, self.view.frame.size.width, 40)];
    _name.textColor = [UIColor blackColor];
    _name.font = [UIFont systemFontOfSize:15];
    _name.textAlignment = NSTextAlignmentCenter;
    _name.text = _data.fileName;
    [self.view addSubview:_name];

    _button = [[UIButton alloc] initWithFrame:CGRectMake(100, _name.frame.origin.y + _name.frame.size.height + 20, self.view.frame.size.width - 200, 40)];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor colorWithRed:44/255.0 green:145/255.0 blue:247/255.0 alpha:1.0];
    _button.layer.cornerRadius = 5;
    [_button.layer setMasksToBounds:YES];
    [_button addTarget:self action:@selector(onOpen:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_button];

    @weakify(self)
    [RACObserve(_data, downladProgress) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        int progress = [x intValue];
        if (progress < 100 && progress > 0) {
            [self.button setTitle:[NSString stringWithFormat:@"正在下载%d%%", progress] forState:UIControlStateNormal];
        } else {
            [self.button setTitle:@"用其他应用程序打开" forState:UIControlStateNormal];
        }
    }];
    if ([_data isLocalExist]) {
        [self.button setTitle:@"用其他应用程序打开" forState:UIControlStateNormal];

    } else {
        [self.button setTitle:@"下载文件" forState:UIControlStateNormal];
    }
}

- (void)onOpen:(UIButton*)sender
{
    BOOL isExist = NO;
    NSString *path = [_data getFilePath:&isExist];
    if(isExist){
        NSURL *url = [NSURL fileURLWithPath:path];
        _document = [UIDocumentInteractionController interactionControllerWithURL:url];
        _document.delegate = self;
        [_document presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
    } else {
       [_data downloadFile];
    }
}

- (void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

@end
