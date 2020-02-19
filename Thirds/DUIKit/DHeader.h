//
//  DHeader.h
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/1/12.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#ifndef DHeader_h
#define DHeader_h

#define Screen_Width        [UIScreen mainScreen].bounds.size.width
#define Screen_Height       [UIScreen mainScreen].bounds.size.height
#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_IPhoneX (Screen_Width >=375.0f && Screen_Height >=812.0f && Is_Iphone)

#define StatusBar_Height    (Is_IPhoneX ? (44.0):(20.0))
#define TabBar_Height       (Is_IPhoneX ? (49.0 + 34.0):(49.0))
#define NavBar_Height       (44)
#define SearchBar_Height    (55)
#define Bottom_SafeHeight   (Is_IPhoneX ? (34.0):(0))
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.f]

//unRead
#define TUnReadView_Margin_TB 2
#define TUnReadView_Margin_LR 4

//button cell
#define TButtonCell_ReuseId @"TButtonCell"
#define TButtonCell_Height 60
#define TButtonCell_Margin 10

//setting controller
#define TSettingController_Background_Color RGBA(244, 244, 246, 1.0)

//personal common cell
#define TPersonalCommonCell_Image_Size CGSizeMake(80, 80)
#define TPersonalCommonCell_Margin 10
#define TPersonalCommonCell_Indicator_Size CGSizeMake(15, 15)

//conversation cell
#define TConversationCell_Height 72
#define TConversationCell_Margin 12
#define TConversationCell_Margin_Text 14

//navigation indicator
#define indicator_radius 10
#define TNaviBarIndicatorView_Margin 5

//pop view
#define TPopView_Arrow_Size CGSizeMake(15, 10)
#define TPopView_Background_Color RGBA(188, 188, 188, 0.5)
//pop cell
#define TPopCell_ReuseId @"TPopCell"
#define TPopCell_Height 45
#define TPopCell_Margin 18
#define TPopCell_Padding 12

//info controller
#define TGroupInfoController_Background_Color RGBA(244, 244, 246, 1.0)

//face item cell
#define TFaceCell_ReuseId @"TFaceCell"

//group member cell
#define TGroupMemberCell_ReuseId @"TGroupMemberCell"
#define TGroupMemberCell_Margin 5
#define TGroupMemberCell_Head_Size CGSizeMake(60, 60)
#define TGroupMemberCell_Head_Height 60
#define TGroupMemberCell_Head_Width 60
#define TGroupMemberCell_Name_Height 20

//group members cell
#define TGroupMembersCell_ReuseId @"TGroupMembersCell"
#define TGroupMembersCell_Column_Count 5
#define TGroupMembersCell_Row_Count 2
#define TGroupMembersCell_Margin 10
#define TGroupMembersCell_Image_Size CGSizeMake(60, 60)


//cell
#define TMessageCell_Head_Width 45
#define TMessageCell_Head_Height 45
#define TMessageCell_Head_Size CGSizeMake(45, 45)
#define TMessageCell_Padding 8
#define TMessageCell_Margin 8
#define TMessageCell_Indicator_Size CGSizeMake(20, 20)

//text cell
#define TTextMessageCell_ReuseId @"TTextMessageCell"
#define TTextMessageCell_Height_Min (TMessageCell_Head_Size.height + 2 * TMessageCell_Padding)
#define TTextMessageCell_Text_PADDING (160)
#define TTextMessageCell_Text_Width_Max (Screen_Width - TTextMessageCell_Text_PADDING)
#define TTextMessageCell_Margin 12

//system cell
#define TSystemMessageCell_ReuseId @"TSystemMessageCell"
#define TSystemMessageCell_Background_Color RGBA(215, 215, 215, 1.0)
#define TSystemMessageCell_Text_Width_Max (Screen_Width * 0.5)
#define TSystemMessageCell_Margin 5

//joinGroup cell 继承自 system cell
#define TJoinGroupMessageCell_ReuseId @"TJoinGroupMessageCell"
#define TJoinGroupMessageCell_Background_Color RGBA(215, 215, 215, 1.0)
#define TJoinGroupMessageCell_Text_Width_Max (Screen_Width * 0.5)
#define TJoinGroupMessageCell_Margin 5


//image cell
#define TImageMessageCell_ReuseId @"TImageMessageCell"
#define TImageMessageCell_Image_Width_Max (Screen_Width * 0.4)
#define TImageMessageCell_Image_Height_Max TImageMessageCell_Image_Width_Max
#define TImageMessageCell_Margin_2 8
#define TImageMessageCell_Margin_1 16
#define TImageMessageCell_Progress_Color  RGBA(0, 0, 0, 0.5)

//face cell
#define TFaceMessageCell_ReuseId @"TFaceMessageCell"
#define TFaceMessageCell_Image_Width_Max (Screen_Width * 0.25)
#define TFaceMessageCell_Image_Height_Max TFaceMessageCell_Image_Width_Max
#define TFaceMessageCell_Margin 16

//file cell
#define TFileMessageCell_ReuseId @"TFileMessageCell"
#define TFileMessageCell_Container_Size CGSizeMake((Screen_Width * 0.5), (Screen_Width * 0.15))
#define TFileMessageCell_Margin 10
#define TFileMessageCell_Progress_Color  RGBA(0, 0, 0, 0.5)

//video cell
#define TVideoMessageCell_ReuseId @"TVideoMessageCell"
#define TVideoMessageCell_Image_Width_Max (Screen_Width * 0.4)
#define TVideoMessageCell_Image_Height_Max TVideoMessageCell_Image_Width_Max
#define TVideoMessageCell_Margin_3 4
#define TVideoMessageCell_Margin_2 8
#define TVideoMessageCell_Margin_1 16
#define TVideoMessageCell_Play_Size CGSizeMake(35, 35)
#define TVideoMessageCell_Progress_Color  RGBA(0, 0, 0, 0.5)

//voice cell
#define TVoiceMessageCell_ReuseId @"TVoiceMessaageCell"
#define TVoiceMessageCell_Max_Duration 60.0
#define TVoiceMessageCell_Height TMessageCell_Head_Size.height
#define TVoiceMessageCell_Margin 12
#define TVoiceMessageCell_Back_Width_Max (Screen_Width * 0.4)
#define TVoiceMessageCell_Back_Width_Min 60
#define TVoiceMessageCell_Duration_Size CGSizeMake(33, 33)

//text view
#define TTextView_Height (49)
#define TTextView_Button_Size CGSizeMake(30, 30)
#define TTextView_Margin 6
#define TTextView_TextView_Height_Min (TTextView_Height - 2 * TTextView_Margin)
#define TTextView_TextView_Height_Max 80
#define TTextView_Line_Height 0.5
#define TTextView_Line_Color RGBA(188, 188, 188, 0.6)
#define TTextView_Background_Color  RGBA(244, 244, 246, 1.0)

//face view
#define TFaceView_Height 180
#define TFaceView_Margin 12
#define TFaceView_Page_Padding 20
#define TFaceView_Page_Height 30
#define TFaceView_Line_Height 0.5
#define TFaceView_Page_Color RGBA(188, 188, 188, 1.0)
#define TFaceView_Line_Color RGBA(188, 188, 188, 0.6)
#define TFaceView_Background_Color  RGBA(244, 244, 246, 1.0)

//menu view
#define TMenuView_Send_Color RGBA(44, 145, 247, 1.0)
#define TMenuView_Margin 6
#define TMenuView_Menu_Height 40
#define TMenuView_Line_Width 0.5
#define TMenuView_Line_Color RGBA(188, 188, 188, 0.6)

//more view
#define TMoreView_Column_Count 4
#define TMoreView_Section_Padding 30
#define TMoreView_Margin 10
#define TMoreView_Page_Height 30
#define TMoreView_Page_Color RGBA(188, 188, 188, 1.0)
#define TMoreView_Line_Height 0.5
#define TMoreView_Line_Color RGBA(188, 188, 188, 0.6)
#define TMoreView_Background_Color  RGBA(244, 244, 246, 1.0)

//path
#define TUIKit_DB_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_tencent_imsdk_data/"]
#define TUIKit_Image_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_tencent_imsdk_data/image/"]
#define TUIKit_Video_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_tencent_imsdk_data/video/"]
#define TUIKit_Voice_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_tencent_imsdk_data/voice/"]
#define TUIKit_File_Path  [NSHomeDirectory() stringByAppendingString:@"/Documents/com_tencent_imsdk_data/file/"]

//notification
#define TUIKitNotification_TIMRefreshListener @"TUIKitNotification_TIMRefreshListener"
#define TUIKitNotification_TIMMessageListener @"TUIKitNotification_TIMMessageListener"
#define TUIKitNotification_TIMMessageRevokeListener @"TUIKitNotification_TIMMessageRevokeListener"
#define TUIKitNotification_TIMUploadProgressListener @"TUIKitNotification_TIMUploadProgressListener"
#define TUIKitNotification_TIMUserStatusListener @"TUIKitNotification_TIMUserStatusListener"
#define TUIKitNotification_TIMConnListener @"TUIKitNotification_TIMConnListener"
#define TUIKitNotification_onAddFriends @"TUIKitNotification_onAddFriends"
#define TUIKitNotification_onDelFriends @"TUIKitNotification_onDelFriends"
#define TUIKitNotification_onFriendProfileUpdate @"TUIKitNotification_onFriendProfileUpdate"
#define TUIKitNotification_onAddFriendReqs @"TUIKitNotification_onAddFriendReqs"
#define TUIKitNotification_onRecvMessageReceipts @"TUIKitNotification_onRecvMessageReceipts"
#define TUIKitNotification_onChangeUnReadCount @"TUIKitNotification_onChangeUnReadCount"

//message controller
#define TMessageController_Background_Color RGBA(244, 244, 246, 1.0)
#define TMessageController_Header_Height 40

#endif /* DHeader_h */
