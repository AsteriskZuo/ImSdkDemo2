//
//  CLIMErrorCode.h
//  CLIMSDK_ios
//
//  Created by yu.zuo on 2019/9/17.
//  Copyright © 2019 yu.zuo. All rights reserved.
//

#ifndef CLIMErrorCode_h
#define CLIMErrorCode_h

#import <Foundation/Foundation.h>

/**
 * SDK统一错误代码
 */
typedef NS_ENUM(int, clim_error_code) {
    clim_error_success =                 0,///< 一般成功
    clim_error_fail =                    1,///< 一般错误
    clim_error_have_not_implemented =    2,///< 还没有实现
    clim_error_sdk_have_not_init =       3,///< SDK还没有初始化
    clim_error_sdk_have_init =           4,///< SDK已经初始化
    clim_error_sdk_api_have_deprecated = 5,///< API已经废弃
    clim_error_memory_create_fail =      6,///< 内存申请失败

    
    clim_error_param_error =     1025,///< 参数错误
    clim_error_param_empty =     1026,///< 参数为空
    clim_error_param_invalid =   1027,///< 参数无效
    
    clim_error_config_error =                        1100,///< 配置错误
    clim_error_config_have_not_init_sdk =            1101,///< 还没有初始化
    clim_error_config_have_init_sdk =                1102,///< 已经初始化
    clim_error_config_listener_empty =               1103,///< 没有设置监听对象
    clim_error_config_log_error =                    1104,///< 日志配置错误
    clim_error_config_file_server_error =            1105,///< 文件服务器配置错误
    clim_error_config_push_error =                   1106,///< 推送配置错误
    clim_error_config_appkey_error =                 1107,///< appid错误
    clim_error_config_navi_domain_error =            1108,///< navi域名错误
    clim_error_config_root_directory_error =         1109,///< 根目录错误
    clim_error_config_not_have_disconnect_listener = 1110,///< 没有设置断开监听对象
    clim_error_config_not_have_recv_message_listener = 1111,///< 没有设置接收消息监听对象
    clim_error_config_not_have_upload_file_listener = 1112,///< 没有设置上传文件监听对象
    clim_error_config_not_have_conversation_listener = 1113,///< 没有设置会话监听对象
    
    clim_error_http_error =                      1200,///< http错误
    clim_error_http_get_im_server_error =        1201,///< 获取服务器地址错误
    clim_error_http_get_sensitive_word_error =   1202,///< 获取敏感词错误
    
    clim_error_tcp_error =                   1300,///< tcp错误
    clim_error_tcp_not_find_host =           1301,///< 没有找到服务器
    clim_error_tcp_connect_server_timeout =  1302,///< 连接服务器超时
    clim_error_tcp_read_data_error =         1303,///< 读取数据错误
    clim_error_tcp_write_data_error =        1304,///< 写入数据错误
    clim_error_tcp_disconnect_from_server =  1305,///< 断开连接
    clim_error_tcp_trying_reconnect =        1306,///< 正在尝试重连
    clim_error_tcp_protocol_error =          1307,///< 底层协议错误
    clim_error_tcp_user_close_from_server =  1308,///< 用户主动关闭
    clim_error_tcp_user_force_close_from_server = 1309,///< 用户强制关闭（一般发生在切换网络）
    clim_error_tcp_connect_have_exist =      1310,///< 连接已经存在
    
    clim_error_network_error =                   1600,///< 网络错误
    clim_error_network_not_connect_internet =    1601,///< 没有网络
    clim_error_network_timeout =                 1602,///< 网络超时
    
    clim_error_server_code_1404 =           1700,///<clim_error_group_not_exist
    clim_error_server_code_1406 =           1701,///<clim_error_group_not_in_group
    clim_error_server_code_reconnect =      1702,///<服务器通知：用户重新连接：一般是连接到别的服务器
    clim_error_server_code_other_device_login = 1703,///<服务器通知：该账号其它设备登录
    clim_error_server_code_logout =         1704,///<用户通知：用户登出
    clim_error_server_code_blocked =        1705,///<服务器通知：
    
    clim_error_account_not_exist =               2000,///< 账户不存在
    clim_error_account_forbit_login =            2001,///< 账号被禁止登陆
    clim_error_account_expire =                  2002,///< 账号登陆过期
    clim_error_account_unknown =                 2003,///< 账号未知错误
    clim_error_account_have_login =              2004,///< 账号已经登录
    clim_error_account_have_not_login =          2005,///< 账号还没有登录
    clim_error_account_token_invalid =           2006,///< 登录 token 错误
    clim_error_account_device_id_invalid =       2007,///< 登录 device id 错误
    clim_error_account_device_info_invalid =     2008,///< 登录 device info 错误
    clim_error_account_package_name_invalid =    2009,///< 登录 包名 错误
    
    clim_error_conversation_not_exist =      3000,///< 会话不存在
    clim_error_conversation_have_deleted =   3001,///< 会话已经删除
    clim_error_conversation_update_fail =    3002,///< 会话更新失败
    clim_error_conversation_get_fail =       3003,///< 会话获取失败
    clim_error_conversation_delete_fail =    3004,///< 会话删除失败
    clim_error_conversation_add_fail =       3005,///< 会话增加失败
    clim_error_conversation_type_not_support = 3006,///< 会话类型不支持
    clim_error_conversation_type_not_exist = 3007,///< 会话不存在
    
    clim_error_message_send_error =          4000,///< 消息发送错误
    clim_error_message_recv_error =          4001,///< 消息接收错误
    clim_error_message_param_not_enough =    4002,///< 消息缺少参数
    clim_error_message_param_invalid =       4003,///< 消息参数无效
    clim_error_message_unable_parse =        4004,///< 消息对象无法解析
    clim_error_message_upload_error =        4005,///< 消息资源上传失败
    clim_error_message_download_error =      4006,///< 消息资源下载失败
    clim_error_message_too_big =             4007,///< 消息对象太大
    clim_error_message_save_fail =           4008,///< 消息保存失败
    clim_error_message_type_not_support =    4009,///< 消息类型不支持
    clim_error_message_update_fail =         4010,///< 消息更新失败
    clim_error_message_delete_fail =         4011,///< 消息删除失败
    clim_error_message_get_fail =            4012,///< 消息获取失败
    clim_error_message_revoke_fail =         4013,///< 消息撤销失败
    clim_error_message_revoking =            4014,///< 消息正在撤销
    clim_error_message_id_invalid =          4015,///< 消息id无效
    clim_error_message_revoked_id_invalid =  4016,///< 被撤消息id无效
    clim_error_message_can_not_revoke =      4017,///< 无法撤销该消息:例如：不能撤销别人的消息、超出撤销时间等
    clim_error_message_revoke_timeout =      4018,///< 撤销消息已经超过撤销最大时间
    clim_error_message_custom_field_fail =   4019,///< 保存自定义消息失败
    
    clim_error_db_error =        5000,///< 数据库错误
    clim_error_db_save_fail =    5001,///< 数据保存失败
    clim_error_db_update_fail =  5002,///< 数据更新失败
    clim_error_db_insert_fail =  5003,///< 数据插入失败
    clim_error_db_replace_fail = 5004,///< 数据替换失败
    clim_error_db_delete_fail =  5005,///< 数据删除失败
    clim_error_db_select_fail =  5006,///< 数据选择失败
    clim_error_db_not_find =     5007,///< 数据没有找到
    clim_error_db_create_tables_fail = 5008,///< 数据库表创建失败
    
    clim_error_group_not_exist =         6000,///< 群组不存在
    clim_error_group_have_dismiss =      6001,///< 群组已经解散
    clim_error_group_not_in_group =      6002,///< 不在群组中
    
    clim_error_user_not_exist =          7000,///< 用户（account是指登陆用户）没有注册
    clim_error_user_have_deleted =       7001,///< 用户（account是指登陆用户）已经注销
    
    clim_error_sensitive_word_have_not_init =    10000,///< 敏感词没有初始化
    clim_error_sensitive_word_have_init =        10001,///< 敏感词已经初始化
    clim_error_sensitive_word_get_local_fail =   10002,///< 敏感词本地获取失败
    clim_error_sensitive_word_get_server_fail =  10003,///< 敏感词服务器获取失败
    
    clim_error_local_data_type_not_support = 10100,///< 本地数据类型不支持
    
    
    #pragma mark - iOS particular
    
    clim_error_message_cache_too_much = 20001,///< 缓存消息太多
    
};

@interface CLIMErrorManager : NSObject

/**
 * 单实例
 */
+ (instancetype)sharedInstance;

/**
 * 获取错误码描述信息
 * @param code 错误码
 * @return 错误码的描述信息
 */
- (NSString*)getErrorDescription:(clim_error_code)code;

@end

#endif /* CLIMErrorCode_h */
