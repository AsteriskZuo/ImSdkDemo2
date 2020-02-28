//
//  DUIKitConfig.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/15.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIKitConfig.h"
#import "DHeader.h"
#import "DUIFaceCell.h"
#import "DUIFaceView.h"
//#import "DUIInputMoreCell.h"
#import "DUIImageCache.h"
//#import "UIImage+DUIKIT.h"
#import "DCommon.h"



@interface DUIKitConfig ()


//提前加载资源（全路径）


@end

@implementation DUIKitConfig

- (id)init
{
    self = [super init];
    if(self){
        _avatarCornerRadius = 6.f;
//        _defaultAvatarImage = [UIImage tk_imageNamed:@"default_head"];
        _defaultAvatarImage = [UIImage imageNamed:TUIKitResource(@"default_head")];
//        _defaultGroupAvatarImage = [UIImage tk_imageNamed:@"default_head"];
        _defaultGroupAvatarImage = [UIImage imageNamed:TUIKitResource(@"default_head")];

        [self defaultResourceCache];
        [self defaultFace];
    }
    return self;
}

+ (id)defaultConfig
{
    static dispatch_once_t onceToken;
    static DUIKitConfig *config;
    dispatch_once(&onceToken, ^{
        config = [[DUIKitConfig alloc] init];
    });
    return config;
}

/**
 *  初始化默认表情，并将配默认表情写入本地缓存，方便下一次快速加载
 */
- (void)defaultFace
{
    NSMutableArray *faceGroups = [NSMutableArray array];
    //emoji group
    NSMutableArray *emojiFaces = [NSMutableArray array];
    NSArray *emojis = [NSArray arrayWithContentsOfFile:TUIKitFace(@"emoji/emoji.plist")];
    for (NSDictionary *dic in emojis) {
        DUIFaceCellData *data = [[DUIFaceCellData alloc] init];
        NSString *name = [dic objectForKey:@"face_name"];
        NSString *path = [NSString stringWithFormat:@"emoji/%@", name];
        data.name = name;
        data.path = TUIKitFace(path);
        [self addFaceToCache:data.path];
        [emojiFaces addObject:data];
    }
    if(emojiFaces.count != 0){
        DUIFaceGroup *emojiGroup = [[DUIFaceGroup alloc] init];
        emojiGroup.groupIndex = 0;
        emojiGroup.groupPath = TUIKitFace(@"emoji/");
        emojiGroup.faces = emojiFaces;
        emojiGroup.rowCount = 3;
        emojiGroup.itemCountPerRow = 9;
        emojiGroup.needBackDelete = YES;
        emojiGroup.menuPath = TUIKitFace(@"emoji/menu");
        [self addFaceToCache:emojiGroup.menuPath];
        [faceGroups addObject:emojiGroup];
        [self addFaceToCache:TUIKitFace(@"del_normal")];
    }

    //tt group
    NSMutableArray *ttFaces = [NSMutableArray array];
    for (int i = 0; i <= 16; i++) {
        DUIFaceCellData *data = [[DUIFaceCellData alloc] init];
        NSString *name = [NSString stringWithFormat:@"tt%02d", i];
        NSString *path = [NSString stringWithFormat:@"tt/%@", name];
        data.name = name;
        data.path = TUIKitFace(path);
        [self addFaceToCache:data.path];
        [ttFaces addObject:data];
    }
    if(ttFaces.count != 0){
        DUIFaceGroup *ttGroup = [[DUIFaceGroup alloc] init];
        ttGroup.groupIndex = 1;
        ttGroup.groupPath = TUIKitFace(@"tt/");
        ttGroup.faces = ttFaces;
        ttGroup.rowCount = 2;
        ttGroup.itemCountPerRow = 5;
        ttGroup.menuPath = TUIKitFace(@"tt/menu");
        [self addFaceToCache:ttGroup.menuPath];
        [faceGroups addObject:ttGroup];
    }

    _faceGroups = faceGroups;
}





#pragma mark - resource
/**
 *  将配默认配置写入本地缓存，方便下一次快速加载
 */
- (void)defaultResourceCache
{
    //common
    [self addResourceToCache:TUIKitResource(@"more_normal")];
    [self addResourceToCache:TUIKitResource(@"more_pressed")];
    [self addResourceToCache:TUIKitResource(@"face_normal")];
    [self addResourceToCache:TUIKitResource(@"face_pressed")];
    [self addResourceToCache:TUIKitResource(@"keyboard_normal")];
    [self addResourceToCache:TUIKitResource(@"keyboard_pressed")];
    [self addResourceToCache:TUIKitResource(@"voice_normal")];
    [self addResourceToCache:TUIKitResource(@"voice_pressed")];
    //text msg
    [self addResourceToCache:TUIKitResource(@"sender_text_normal")];
    [self addResourceToCache:TUIKitResource(@"sender_text_pressed")];
    [self addResourceToCache:TUIKitResource(@"receiver_text_normal")];
    [self addResourceToCache:TUIKitResource(@"receiver_text_pressed")];
    //void msg
    [self addResourceToCache:TUIKitResource(@"sender_voice")];
    [self addResourceToCache:TUIKitResource(@"receiver_voice")];
    [self addResourceToCache:TUIKitResource(@"sender_voice_play_1")];
    [self addResourceToCache:TUIKitResource(@"sender_voice_play_2")];
    [self addResourceToCache:TUIKitResource(@"sender_voice_play_3")];
    [self addResourceToCache:TUIKitResource(@"receiver_voice_play_1")];
    [self addResourceToCache:TUIKitResource(@"receiver_voice_play_2")];
    [self addResourceToCache:TUIKitResource(@"receiver_voice_play_3")];
    //file msg
    [self addResourceToCache:TUIKitResource(@"msg_file")];
    //video msg
    [self addResourceToCache:TUIKitResource(@"play_normal")];
}


- (void)addResourceToCache:(NSString *)path
{
    [[DUIImageCache sharedInstance] addResourceToCache:path];
}


- (void)addFaceToCache:(NSString *)path
{
    [[DUIImageCache sharedInstance] addFaceToCache:path];
}


@end
