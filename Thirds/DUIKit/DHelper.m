//
//  DHelper.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/14.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHelper.h"
#import "UIView+Toast.h"
#import "DUIError.h"
#import "SDWebImage.h"

#import "EMVoiceConverter.h"
#import <CLIMSDK_ios/CLIMSDK_ios.h>

typedef void (^TAsyncImageComplete)(NSString *path, UIImage *image);

@implementation DHelper

+ (NSString *)genImageName:(NSString *)uuid
{
    NSString* sdkAppId = [[CLIMManager sharedInstance] getGlobalConfig].appKey;
    NSString* identifier = [[CLIMManager sharedInstance] getUserId];
    if(uuid == nil){
        uuid = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    }
    NSString *name = [NSString stringWithFormat:@"%@_%@_image_%@", sdkAppId, identifier, uuid];
    return name;
}

+ (NSString *)genSnapshotName:(NSString *)uuid
{
    NSString* sdkAppId = [[CLIMManager sharedInstance] getGlobalConfig].appKey;
    NSString* identifier = [[CLIMManager sharedInstance] getUserId];
    if(uuid == nil){
        uuid = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    }
    NSString *name = [NSString stringWithFormat:@"%@_%@_snapshot_%@", sdkAppId, identifier, uuid];
    return name;
}

+ (NSString *)genVideoName:(NSString *)uuid
{
    NSString* sdkAppId = [[CLIMManager sharedInstance] getGlobalConfig].appKey;
    NSString* identifier = [[CLIMManager sharedInstance] getUserId];
    if(uuid == nil){
        uuid = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    }
    NSString *name = [NSString stringWithFormat:@"%@_%@_video_%@", sdkAppId, identifier, uuid];
    return name;
}


+ (NSString *)genVoiceName:(NSString *)uuid withExtension:(NSString *)extent
{
    NSString* sdkAppId = [[CLIMManager sharedInstance] getGlobalConfig].appKey;
    NSString* identifier = [[CLIMManager sharedInstance] getUserId];
    if(uuid == nil){
        uuid = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    }
    NSString *name = [NSString stringWithFormat:@"%@_%@_voice_%@.%@", sdkAppId, identifier, uuid, extent];
    return name;
}

+ (NSString *)genFileName:(NSString *)uuid
{
    NSString* sdkAppId = [[CLIMManager sharedInstance] getGlobalConfig].appKey;
    NSString* identifier = [[CLIMManager sharedInstance] getUserId];
    if(uuid == nil){
        uuid = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    }
    NSString *name = [NSString stringWithFormat:@"%@_%@_file_%@", sdkAppId, identifier, uuid];
    return name;
}

+ (BOOL)isAmr:(NSString *)path
{
    return [EMVoiceConverter isAMRFile:path];
}

+ (BOOL)convertAmr:(NSString*)amrPath toWav:(NSString*)wavPath
{
    return [EMVoiceConverter amrToWav:amrPath wavSavePath:wavPath];
}

+ (BOOL)convertWav:(NSString*)wavPath toAmr:(NSString*)amrPath
{
    return [EMVoiceConverter wavToAmr:wavPath amrSavePath:amrPath];
}

+ (BOOL)fileIsExist:(NSString*)filePath
{
    BOOL isDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir]) {
        if(!isDir) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)dirIsExist:(NSString*)dirPath
{
    BOOL isDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir]) {
        return isDir;
    }
    return NO;
}

+ (void)asyncDecodeImage:(NSString *)path complete:(TAsyncImageComplete)complete
{
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.tuikit.asyncDecodeImage", DISPATCH_QUEUE_SERIAL);
    });

    dispatch_async(queue, ^{
        if(path == nil){
            return;
        }

        UIImage *image = nil;
        
        if ([path containsString:@".gif"]) { //支持动图
            image = [UIImage sd_imageWithGIFData:[NSData dataWithContentsOfFile:path]];//TODO:带实现
            if(complete){
                complete(path, image);
            }
            return;
        } else {
            image = [UIImage imageWithContentsOfFile:path];
        }
        
        if (image == nil) {
            return;
        }

        // 获取CGImage
        CGImageRef cgImage = image.CGImage;

        // alphaInfo
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }

        // bitmapInfo
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;

        // size
        size_t width = CGImageGetWidth(cgImage);
        size_t height = CGImageGetHeight(cgImage);

        // 解码：把位图提前画到图形上下文，生成 cgImage，就完成了解码。
        // context
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);

        // draw
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);

        // get CGImage
        cgImage = CGBitmapContextCreateImage(context);

        // 解码后的图片，包装成 UIImage 。
        // into UIImage
        UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:image.scale orientation:image.imageOrientation];

        // release
        if(context) CGContextRelease(context);
        if(cgImage) CGImageRelease(cgImage);

        //callback
        if(complete){
            complete(path, newImage);
        }
    });
}

+ (void)makeToast:(NSString *)str
{
    [[UIApplication sharedApplication].keyWindow makeToast:str];
}

+ (void)makeToastError:(NSInteger)error msg:(NSString *)msg
{
    [[UIApplication sharedApplication].keyWindow makeToast:[DUIError strError:error msg:msg]];
}

+ (void)makeToastActivity
{
    [[UIApplication sharedApplication].keyWindow makeToastActivity:CSToastPositionCenter];
}

+ (void)hideToastActivity
{
    [[UIApplication sharedApplication].keyWindow hideToastActivity];
}

+ (NSString *)randAvatarUrl
{
    return [NSString stringWithFormat:@"https://picsum.photos/id/%d/200/200", rand()%999];
}

@end
