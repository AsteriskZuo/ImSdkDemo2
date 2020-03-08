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
#import "DCommon.h"
#import "DHelper.h"
#import "DUIMessageCell.h"
#import "DUIImageMessageCell.h"
#import "DUIFileMessageCell.h"
#import "DUIInputMoreCell.h"
#import "DUIInputMoreView.h"
#import "DUIInputBarView.h"
#import "DUIGroupPendencyViewModel.h"
#import "DUIGroupPendencyController.h"

#import "MMLayout/UIView+MMLayout.h"
#import "ReactiveObjC.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CLIMSDK_ios/CLIMSDK_ios.h>


@interface DUIChatController () <UINavigationControllerDelegate, DUIInputControllerDelegate, DUIMessageControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate>

@property (nonatomic, strong) CLIMConversation *conversation;

@property (nonatomic, strong) UIView *tipsView;
@property (nonatomic, strong) UILabel *pendencyLabel;
@property (nonatomic, strong) UIButton *pendencyBtn;

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
//    _messageController.view.backgroundColor = [UIColor redColor];
    _messageController.delegate = self;
    [_messageController setConversation:_conversation];
    [self addChildViewController:_messageController];
    [self.view addSubview:_messageController.view];
    
    _inputController = [[DUIInputController alloc] init];
    _inputController.view.frame = CGRectMake(0, self.view.frame.size.height - TTextView_Height - Bottom_SafeHeight, self.view.frame.size.width, TTextView_Height - Bottom_SafeHeight);
    _inputController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    _inputController.view.backgroundColor = [UIColor purpleColor];
    _inputController.delegate = self;
    [self addChildViewController:_inputController];
    [self.view addSubview:_inputController.view];
    
    self.navigationController.delegate = self;
    
    self.tipsView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tipsView.backgroundColor = RGB(246, 234, 190);
    [self.view addSubview:self.tipsView];
    self.tipsView.mm_height(24).mm_width(self.view.mm_w);

    self.pendencyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.tipsView addSubview:self.pendencyLabel];
    self.pendencyLabel.font = [UIFont systemFontOfSize:12];


    self.pendencyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.tipsView addSubview:self.pendencyBtn];
    [self.pendencyBtn setTitle:@"点击处理" forState:UIControlStateNormal];
    [self.pendencyBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.pendencyBtn addTarget:self action:@selector(openPendency:) forControlEvents:UIControlEventTouchUpInside];
    [self.pendencyBtn sizeToFit];
    self.tipsView.hidden = YES;
    
//    self.tipsView.hidden = NO;
//    self.tipsView.mm_top(self.navigationController.navigationBar.mm_maxY);
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    

    
    
    @weakify(self);
    [RACObserve(self, moreMenus) subscribeNext:^(NSArray *x) {
        @strongify(self)
        [self.inputController.moreView setData:x];
    }];
    
//    [RACObserve(self.pendencyViewModel, unReadCnt) subscribeNext:^(NSNumber *unReadCnt) {
//        @strongify(self)
//        if ([unReadCnt intValue]) {
//            self.pendencyLabel.text = [NSString stringWithFormat:@"%@条入群请求", unReadCnt];
//            [self.pendencyLabel sizeToFit];
//            CGFloat gap = (self.tipsView.mm_w - self.pendencyLabel.mm_w - self.pendencyBtn.mm_w-8)/2;
//            self.pendencyLabel.mm_left(gap).mm__centerY(self.tipsView.mm_h/2);
//            self.pendencyBtn.mm_hstack(8);
//
//            [UIView animateWithDuration:1.f animations:^{
//                self.tipsView.hidden = NO;
//                self.tipsView.mm_top(self.navigationController.navigationBar.mm_maxY);
//            }];
//        } else {
//            self.tipsView.hidden = YES;
//        }
//    }];
}

- (void)notifyRotate:(NSNotification* )notification
{
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        NSLog(@"竖屏");//竖屏
    } else {
        NSLog(@"横屏");//横屏
    }
    [self dispatchRotate:self withNotification:notification];
    [self.view setNeedsLayout];
}

- (void)dispatchRotate:(UIViewController* )controller withNotification:(NSNotification* )notification
{
    if (controller) {
        NSArray<__kindof UIViewController *> * children = controller.childViewControllers;
        for (UIViewController* child in children) {
            [self dispatchRotate:child withNotification:notification];
            if ([child respondsToSelector:@selector(changeRotate:)]) {
                [child performSelector:@selector(changeRotate:) withObject:notification];
            }
        }
    }
}

- (void)changeRotate:(NSNotification* )notification
{
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        NSLog(@"竖屏");//竖屏
    } else {
        NSLog(@"横屏");//横屏
    }
    [self.view setNeedsLayout];
}

- (instancetype)initWithConversation:(CLIMConversation *)conversation
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _conversation = conversation;

        NSMutableArray *moreMenus = [NSMutableArray array];
        [moreMenus addObject:[DUIInputMoreCellData photoData]];
        [moreMenus addObject:[DUIInputMoreCellData pictureData]];
        [moreMenus addObject:[DUIInputMoreCellData videoData]];
        [moreMenus addObject:[DUIInputMoreCellData fileData]];
        _moreMenus = moreMenus;
    }
    return self;
}


- (void)sendMessage:(DUIMessageCellData *)message
{
    [_messageController sendMessage:message];
}

- (void)saveDraft
{
    //TODO:daishixian
}

- (void)openPendency:(UIButton*)sender
{
    //TODO:需要懒加载初始化数据
    DUIGroupPendencyController *vc = [[DUIGroupPendencyController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    [navigationController setToolbarHidden:YES animated:nil];
//    [self.navigationController setToolbarHidden:YES animated:nil];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}


#pragma mark - DUIInputControllerDelegate

- (void)inputController:(DUIInputController *)inputController didChangeHeight:(CGFloat)height
{
    @weakify(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        @strongify(self);
        CGRect msgFrame = self.messageController.view.frame;
        msgFrame.size.height = self.view.frame.size.height - height;
        self.messageController.view.frame = msgFrame;

        CGRect inputFrame = self.inputController.view.frame;
        inputFrame.origin.y = msgFrame.origin.y + msgFrame.size.height;
        inputFrame.size.height = height;
        self.inputController.view.frame = inputFrame;

        [self.messageController scrollToBottom:NO];
    } completion:nil];
}

- (void)inputController:(DUIInputController *)inputController didSendMessage:(DUIMessageCellData *)msg
{
    [_messageController sendMessage:msg];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:didSendMessage:)]) {
        [self.delegate chatController:self didSendMessage:msg];
    }
}

- (void)inputController:(DUIInputController *)inputController didSelectMoreCell:(DUIInputMoreCell *)cell
{
    if (cell.data == [DUIInputMoreCellData photoData]) {
        [self selectPhotoForSend];
    }
    if (cell.data == [DUIInputMoreCellData videoData]) {
        [self takeVideoForSend];
    }
    if (cell.data == [DUIInputMoreCellData fileData]) {
        [self selectFileForSend];
    }
    if (cell.data == [DUIInputMoreCellData pictureData]) {
        [self takePictureForSend];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(chatController:onSelectMoreCell:)]){
        [_delegate chatController:self onSelectMoreCell:cell];
    }
}

- (void)selectPhotoForSend
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)takePictureForSend
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"[%s:%d][error:not available]", __func__, __LINE__);
        if (true) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"无法访问相机" message:@"模拟器无法使用相机功能" preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self.navigationController presentViewController:ac animated:YES completion:nil];
        }
        if (false) {
            //note: UIAlertView is deprecated in iOS 8. (Note that UIAlertViewDelegate is also deprecated.) To create and manage alerts in iOS 8 and later, instead use UIAlertController with a preferredStyle of UIAlertControllerStyleAlert.
            UIAlertView* alert = [[UIAlertView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            alert.backgroundColor = [UIColor redColor];
        }
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModePhoto;
    picker.delegate = self;

    [self presentViewController:picker animated:YES completion:nil];
}

- (void)takeVideoForSend
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"[%s:%d][error:not available]", __func__, __LINE__);
        if (true) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"无法访问相机" message:@"模拟器无法使用相机功能" preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self.navigationController presentViewController:ac animated:YES completion:nil];
        }
        if (false) {
            //note: UIAlertView is deprecated in iOS 8. (Note that UIAlertViewDelegate is also deprecated.) To create and manage alerts in iOS 8 and later, instead use UIAlertController with a preferredStyle of UIAlertControllerStyleAlert.
            UIAlertView* alert = [[UIAlertView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            alert.backgroundColor = [UIColor redColor];
        }
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModeVideo;
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    [picker setVideoMaximumDuration:15];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)selectFileForSend
{
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[(NSString *)kUTTypeData] inMode:UIDocumentPickerModeOpen];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];

}


#pragma mark - DUIMessageControllerDelegate

- (void)didTapInMessageController:(DUIMessageController *)controller
{
    [_inputController reset];
}

- (void)didHideMenuInMessageController:(DUIMessageController *)controller
{
    _inputController.inputBar.inputTextView.overrideNextResponder = nil;
}

- (void)printf:(UIResponder*)responder
{
    static int count = 0;
    ++count;
    if (nil == responder) {
        return ;
    }
    UIResponder* tmp = responder;
    do {
        NSLog(@"%s-%d, %@", __func__, count, NSStringFromClass([tmp class]));
        tmp = [tmp nextResponder];
    } while (nil != tmp);
}

- (BOOL)messageController:(DUIMessageController *)controller willShowMenuInCell:(DUIMessageCell *)cell
{
    if([_inputController.inputBar.inputTextView isFirstResponder]){
        //        [self printf:_inputController.inputBar.inputTextView];
        _inputController.inputBar.inputTextView.overrideNextResponder = cell;
        //        [self printf:_inputController.inputBar.inputTextView];
        return YES;
    }
    return NO;
}

- (DUIMessageCellData *)messageController:(DUIMessageController *)controller onNewMessage:(CLIMMessage *)data
{
    if ([self.delegate respondsToSelector:@selector(chatController:onNewMessage:)]) {
        return [self.delegate chatController:self onNewMessage:data];
    }
    return nil;
}

- (DUIMessageCell *)messageController:(DUIMessageController *)controller onShowMessageData:(DUIMessageCellData *)data
{
    if ([self.delegate respondsToSelector:@selector(chatController:onShowMessageData:)]) {
        return [self.delegate chatController:self onShowMessageData:data];
    }
    return nil;
}

- (void)messageController:(DUIMessageController *)controller onSelectMessageAvatar:(DUIMessageCell *)cell
{
    //TODO:待实现
    if (cell.messageData.identifier == nil)
        return;

    if ([self.delegate respondsToSelector:@selector(chatController:onSelectMessageAvatar:)]) {
        [self.delegate chatController:self onSelectMessageAvatar:cell];
        return;
    }
}

- (void)messageController:(DUIMessageController *)controller onSelectMessageContent:(DUIMessageCell *)cell
{
    if ([self.delegate respondsToSelector:@selector(chatController:onSelectMessageContent:)]) {
        [self.delegate chatController:self onSelectMessageContent:cell];
    }
}

#pragma mark - UINavigationControllerDelegate,UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 快速点的时候会回调多次
    @weakify(self)
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageOrientation imageOrientation = image.imageOrientation;
            if(imageOrientation != UIImageOrientationUp)
            {
                CGFloat aspectRatio = MIN ( 1920 / image.size.width, 1920 / image.size.height );
                CGFloat aspectWidth = image.size.width * aspectRatio;
                CGFloat aspectHeight = image.size.height * aspectRatio;

                UIGraphicsBeginImageContext(CGSizeMake(aspectWidth, aspectHeight));
                [image drawInRect:CGRectMake(0, 0, aspectWidth, aspectHeight)];
                image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }

            NSData *data = UIImageJPEGRepresentation(image, 0.75);
            NSString *path = [TUIKit_Image_Path stringByAppendingString:[DHelper genImageName:nil]];
            [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            
            DUIImageMessageCellData *uiImage = [[DUIImageMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
            uiImage.path = path;
            uiImage.length = data.length;
            [self sendMessage:uiImage];

            if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:didSendMessage:)]) {
                [self.delegate chatController:self didSendMessage:uiImage];
            }
        }
        else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
            NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
            
            if(![url.pathExtension  isEqual: @"mp4"]) {
                NSString* tempPath = NSTemporaryDirectory();
                NSURL *urlName = [url URLByDeletingPathExtension];
                NSURL *newUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@%@.mp4", tempPath,[urlName.lastPathComponent stringByRemovingPercentEncoding]]];
                // mov to mp4
                AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
                AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
                 exportSession.outputURL = newUrl;
                 exportSession.outputFileType = AVFileTypeMPEG4;
                 exportSession.shouldOptimizeForNetworkUse = YES;

                 [exportSession exportAsynchronouslyWithCompletionHandler:^{
                 switch ([exportSession status])
                 {
                      case AVAssetExportSessionStatusFailed:
                           NSLog(@"Export session failed");
                           break;
                      case AVAssetExportSessionStatusCancelled:
                           NSLog(@"Export canceled");
                           break;
                      case AVAssetExportSessionStatusCompleted:
                      {
                           //Video conversion finished
                           NSLog(@"Successful!");
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self sendVideoWithUrl:newUrl];
                          });
                      }
                           break;
                      default:
                           break;
                  }
                 }];
            } else {
                [self sendVideoWithUrl:url];
            }
        }
    }];
}

- (void)sendVideoWithUrl:(NSURL*)url {
    NSData *videoData = [NSData dataWithContentsOfURL:url];
    NSString *videoPath = [NSString stringWithFormat:@"%@%@.mp4", TUIKit_Video_Path, [DHelper genVideoName:nil]];
    [[NSFileManager defaultManager] createFileAtPath:videoPath contents:videoData attributes:nil];
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset =  [AVURLAsset URLAssetWithURL:url options:opts];
    NSInteger duration = (NSInteger)urlAsset.duration.value / urlAsset.duration.timescale;
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
    gen.appliesPreferredTrackTransform = YES;
    gen.maximumSize = CGSizeMake(192, 192);
    NSError *error = nil;
    CMTime actualTime;
    CMTime time = CMTimeMakeWithSeconds(0.0, 10);
    CGImageRef imageRef = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *imagePath = [TUIKit_Video_Path stringByAppendingString:[DHelper genSnapshotName:nil]];
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
    
//    TUIVideoMessageCellData *uiVideo = [[TUIVideoMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
//    uiVideo.snapshotPath = imagePath;
//    uiVideo.snapshotItem = [[TUISnapshotItem alloc] init];
//    UIImage *snapshot = [UIImage imageWithContentsOfFile:imagePath];
//    uiVideo.snapshotItem.size = snapshot.size;
//    uiVideo.snapshotItem.length = imageData.length;
//    uiVideo.videoPath = videoPath;
//    uiVideo.videoItem = [[TUIVideoItem alloc] init];
//    uiVideo.videoItem.duration = duration;
//    uiVideo.videoItem.length = videoData.length;
//    uiVideo.videoItem.type = url.pathExtension;
//    uiVideo.uploadProgress = 0;
//    [self sendMessage:uiVideo];
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:didSendMessage:)]) {
//        [self.delegate chatController:self didSendMessage:uiVideo];
//    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    [url startAccessingSecurityScopedResource];
    NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] init];
    NSError *error;
    @weakify(self)
    [coordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
        @strongify(self)
        NSData *fileData = [NSData dataWithContentsOfURL:url];
        NSString *fileName = [url lastPathComponent];
        NSString *filePath = [TUIKit_File_Path stringByAppendingString:fileName];
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileData attributes:nil];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
            DUIFileMessageCellData *uiFile = [[DUIFileMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
            uiFile.path = filePath;
            uiFile.fileName = fileName;
            uiFile.length = (int)fileSize;
            uiFile.uploadProgress = 0;
            [self sendMessage:uiFile];

            if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:didSendMessage:)]) {
                [self.delegate chatController:self didSendMessage:uiFile];
            }
        }
    }];
    [url stopAccessingSecurityScopedResource];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
