//
//  CLIMFileManager.h
//  citylife_im_sdk
//
//  Created by gavin on 2019/3/25.
//  Copyright © 2019年 yu.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 * 文件系统基本操作
 */
@interface CLIMFileManager : NSObject

/**
 * 获取Document路径
 * @return 文档目录
 */
+ (NSString *)getDocumentPath;

/**
 * 获取Library目录
 * @return 库目录
 */
+ (NSString *)getLibraryPath;

/**
 * 获取应用程序目录
 * @return应用程序目录
 */
+ (NSString *)getApplicationPath;

/**
 * 获取Cache目录
 * @return 缓存目录
 */
+ (NSString *)getCachePath;

/**
 * 获取Temp目录
 * @return 缓存目录
 */
+ (NSString *)getTempPath;

/**
 * 判断文件是否存在于某个路径中
 * @param filePath 文件位置
 * @return YES成功 NO失败
 */
+ (BOOL)fileIsExistOfPath:(NSString *)filePath;

/**
 * 从某个路径中移除文件
 * @param filePath 文件位置
 * @return YES成功 NO失败
 */
+ (BOOL)removeFileOfPath:(NSString *)filePath;

/**
 * 从URL路径中移除文件
 * @param fileURL 文件地址
 * @return YES成功 NO失败
 */
- (BOOL)removeFileOfURL:(NSURL *)fileURL;

/**
 * 创建文件目录
 * 注意:无法创建父目录不存在的目录
 * @param dirPath 目录
 * @return YES成功 NO失败
 */
+(BOOL)creatDirectoryWithPath:(NSString *)dirPath;

/**
 * 创建文件
 * @param filePath 文件地址
 * @return YES成功 NO失败
 */
+ (BOOL)creatFileWithPath:(NSString *)filePath;

/**
 * 保存文件
 * @param filePath 文件地址
 * @param data 文件数据
 * @return YES成功 NO失败
 */
+ (BOOL)saveFile:(NSString *)filePath withData:(NSData *)data;

/**
 * 追加写文件
 * @param filePath 文件地址
 * @param data 文件数据
 * @return YES成功 NO失败
 */
+ (BOOL)appendData:(NSData *)data withPath:(NSString *)filePath;

/**
 * 获取文件内容
 * @param filePath 文件地址
 * @return 文件数据
 */
+ (NSData *)getFileData:(NSString *)filePath;

/**
 * 获取文件一部分内容
 * @param filePath 文件地址
 * @param startIndex 开始位置
 * @param length 获取长度
 * @return 文件数据
 */
+ (NSData *)getFileData:(NSString *)filePath startIndex:(long long)startIndex length:(NSInteger)length;

/**
 * 移动文件
 * @param fromPath 源文件地址
 * @param toPath 目标文件地址
 * @return 是否成功
 */
+ (BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 * 拷贝文件
 * @param fromPath 源文件地址
 * @param toPath 目标文件地址
 * @return 是否成功
 */
+(BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 * 获取文件夹下文件列表
 * @param dirPath 文件目录
 * @return 对象列表（包括文件、目录、连接点等）
 */
+ (NSArray *)getFileListInFolderWithPath:(NSString *)dirPath;

/**
 * 获取文件大小
 * @param filePath 文件地址
 * @return 文件大小
 */
+ (long long)getFileSizeWithPath:(NSString *)filePath;

/**
 * 获取文件创建时间
 * @param filePath 文件地址
 * @return 文件创建时间
 */
+ (NSString *)getFileCreatDateWithPath:(NSString *)filePath;

/**
 * 获取文件所有者
 * @param filePath 文件地址
 * @return 文件所有者
 */
+ (NSString *)getFileOwnerWithPath:(NSString *)filePath;

/**
 * 获取文件修改日期
 * @param filePath 文件地址
 * @return 文件修改日期
 */
+ (NSString *)getFileChangeDateWithPath:(NSString *)filePath;

@end

@interface CLIMFileOperator : NSObject

/**
 * 清空指定目录下所有文件和文件夹
 * @param dirPath 文件目录
 * @return YES成功 NO失败
 */
+ (BOOL)deleteAllFiles:(NSString*)dirPath;

/**
 * 获取指定目录下的所有文件地址
 * @param dirPath 文件目录
 * @return 文件地址列表
 */
+ (NSArray*)getAllFilePathWithPath:(NSString*)dirPath;

@end



/**
 * SDK相关目录操作
 * 对应目录如果不存在则自动创建
 */
@interface CLIMDirectoryManager : NSObject

+ (instancetype)sharedInstance;

/**
 * SDK存储根目录（强烈建议设置！！！）
 * 未设置则使用默认目录
 * @param dir 目录，如果nil则创建默认目录，同时如果目录不存在则创建，如果其父目录不存在则创建失败
 * @return 0.成功
 */
- (BOOL)setRootDir:(NSString*)dir;

/**
 * 获取SDK根目录
 */
- (NSString*)getRootDir;

/**
 * 获取SDK日志所在目录
 * 相对位置: {rootDir}/log
 */
- (NSString*)getLogDir;

/**
 * 获取SDK日志所在目录
 * 相对位置: {rootDir}/db
 */
- (NSString*)getDbDir;

/**
 * 获取appkey所在目录
 * 相对位置: {rootDir}/{appkey}
 * @param appKey app唯一标识
 * @return 用户目录，如果appKey=nil则返回nil
 */
- (NSString*)getAppKeyDir:(NSString*)appKey;

/**
 * 获取登录用户所在目录
 * 前置条件：拥有appKey目录
 * 相对位置: {rootDir}/{appkey}/{id}
 * @param userId 用户id
 * @return 用户目录，如果id=nil则返回nil
 */
- (NSString*)getUserDir:(NSString*)userId;

/**
 * 获取用户数据库表所在目录
 * 前置条件：拥有userId目录
 * 相对位置: {rootDir}/{appkey}/{id}/db
 * @param userId 用户id
 * @return 用户数据库表目录，如果id=nil则返回nil
 */
- (NSString*)getUserDbDir:(NSString*)userId;

/**
 * 获取用户缓存所在目录，随时可以删除，不影响正常数据
 * 前置条件：拥有userId目录
 * 相对位置: {rootDir}/{appkey}/{id}/cache
 * @param userId 用户id
 * @return 用户缓存目录，如果id=nil则返回nil
 */
- (NSString*)getUserCacheDir:(NSString*)userId;

/**
 * 获取用户数据所在目录
 * 前置条件：拥有userId目录
 * 相对位置: {rootDir}/{appkey}/{id}/data
 * @param userId 用户id
 * @return 用户数据目录，如果id=nil则返回nil
 */
- (NSString*)getUserDataDir:(NSString*)userId;

/**
 * 获取用户配置所在目录
 * 前置条件：拥有userId目录
 * 相对位置: {rootDir}/{appkey}/{id}/profile
 * @param userId 用户id
 * @return 用户配置目录，如果id=nil则返回nil
 */
- (NSString*)getUserProfileDir:(NSString*)userId;

/**
 * 获取用户语音所在目录
 * 前置条件：拥有userId目录
 * 相对位置: {rootDir}/{appkey}/{id}/voice
 * @param userId 用户id
 * @return 用户配置目录，如果id=nil则返回nil
 */
- (NSString*)getUserVoiceDir:(NSString*)userId;

/**
 * 获取用户图片所在目录
 * 前置条件：拥有userId目录
 * 相对位置: {rootDir}/{appkey}/{id}/image
 * @param userId 用户id
 * @return 用户配置目录，如果id=nil则返回nil
 */
- (NSString*)getUserImageDir:(NSString*)userId;

@end
