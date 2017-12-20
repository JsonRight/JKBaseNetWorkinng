//
//  JKUtility.h
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/18.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define JKDlog(...) printf("<%s : %d>%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define JKDlog(...)
#endif
CA_EXTERN NSString * const kAppFirstInstall;                //app首次启动保存至UserDefaults Key
CA_EXTERN NSString * const kAppLastVersion;                 //app每次更新保存版本号至UserDefaults Key
CA_EXTERN NSString * const kAppVersionString;               //app获取当前版本 Key--CFBundleShortVersionString
CA_EXTERN NSString * const kJKGuidePageWindowDidDismiss;    //app启动页消失   全局--通知 名称
CA_EXTERN NSString * const kWKScriptMessageHandler;         //JK_WKScriptMessageHandler wk交互详细对象----->message.name

typedef NS_OPTIONS(NSUInteger, APPLaunchStateOptions){
    APPLaunchStateNormal    = 1 << 0, //正常启动
    APPLaunchStateFirst     = 1 << 1, //第一次启动   default
    APPLaunchStateUpdate    = 1 << 2 //APP更新后启动
};//default APPLaunchStateFirst 才弹出启动页
#pragma mark -- UserDefaults
//从UserDefault 读取 NSString
CA_EXTERN NSString* JKGetStrFromUserDefaults(NSString* key);

//从UserDefault 读取 BOOL
CA_EXTERN BOOL JKGetBoolFromUserDefaults(NSString* key);

//从UserDefault 读取 NSInteger
CA_EXTERN NSInteger JKGetIntFromUserDefaults(NSString* key);

//从UserDefault 读取 float
CA_EXTERN float JKGetFloatFromUserDefaults(NSString* key);

//从UserDefault 读取 NSURL
CA_EXTERN NSURL* JKGetURLFromUserDefaults(NSString* key);

//从UserDefault 读取 NSArray
CA_EXTERN NSArray* JKGetArryFromUserDefaults(NSString* key);

//从UserDefault 读取 NSDictionary
CA_EXTERN NSDictionary* JKGetDictionaryFromUserDefaults(NSString* key);

//从UserDefault 读取 NSArray<NSString *> *
CA_EXTERN NSArray<NSString *> * JKGetStringArrayFromUserDefaults(NSString* key);

//从UserDefault 读取 NSData
CA_EXTERN NSData * JKGetDataFromUserDefaults(NSString* key);


//设置UserDefault set NSString
CA_EXTERN void JKSetStrFromUserDefaults(NSString* key, NSString* value);

//设置UserDefault set BOOL
CA_EXTERN void JKSetBoolFromUserDefaults(NSString* key, BOOL value);

//设置UserDefault set NSInteger
CA_EXTERN void JKSetIntFromUserDefaults(NSString* key, NSInteger value);

//设置UserDefault set float
CA_EXTERN void JKSetFloatFromUserDefaults(NSString* key, float value);

//设置UserDefault set double
CA_EXTERN void JKSetDoubleFromUserDefaults(NSString* key, double value);

//设置UserDefault set NSURL
CA_EXTERN void JKSetURLFromUserDefaults(NSString* key, NSURL* value);

//设置UserDefault set Object
CA_EXTERN void JKSetObjectFromUserDefaults(NSString* key, id value);

//通过Key 删除 UserDefaults值
CA_EXTERN void JKRemoveObjFromUserDefaults(NSString* key, ...);

#pragma mark -- app信息
//获取 app当前版本号
CA_EXTERN NSString* JKGetAppVersonString(void);

//获取 app 使用状态：首次启动，日常启动，更新后首次启动
CA_EXTERN APPLaunchStateOptions JKGetAppLaunchState(void);

//获取 app LaunchImage --->仅支持竖屏
CA_EXTERN NSString* JKGetLaunchImageName(void);

CA_EXTERN BOOL JKContainsString(NSString*str,NSString* subStr);

