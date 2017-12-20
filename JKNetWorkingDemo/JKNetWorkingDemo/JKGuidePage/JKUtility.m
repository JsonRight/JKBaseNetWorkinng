//
//  JKUtility.m
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/18.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import "JKUtility.h"

NSString * const kAppFirstInstall = @"LNAppFirstInstall";
NSString * const kAppLastVersion = @"lastVersion";
NSString * const kAppVersionString = @"CFBundleShortVersionString";
NSString * const kJKGuidePageWindowDidDismiss = @"JKGuidePageWindowDidDismiss";
NSString * const kWKScriptMessageHandler = @"WKScriptMessageHandler";
CA_EXTERN NSString* JKGetStrFromUserDefaults(NSString* key) {
    if (key) return [[NSUserDefaults standardUserDefaults] stringForKey:key];
    return nil;
}
CA_EXTERN BOOL JKGetBoolFromUserDefaults(NSString* key) {
    if (key) return [[NSUserDefaults standardUserDefaults] boolForKey:key];
    return NO;
}
CA_EXTERN NSInteger JKGetIntFromUserDefaults(NSString* key) {
    if (key) return [[NSUserDefaults standardUserDefaults] integerForKey:key];
    return NSIntegerMin;
}
CA_EXTERN float JKGetFloatFromUserDefaults(NSString* key) {
    if (key) return [[NSUserDefaults standardUserDefaults] floatForKey:key];
    return CGFLOAT_MIN;
}
CA_EXTERN NSURL* JKGetURLFromUserDefaults(NSString* key){
    if (key) return [[NSUserDefaults standardUserDefaults] URLForKey:key];
    return nil;
}
//从UserDefault 读取 float
CA_EXTERN NSArray* JKGetArryFromUserDefaults(NSString* key){
    if (key) return [[NSUserDefaults standardUserDefaults] arrayForKey:key];
    return nil;
}

//从UserDefault 读取 float
CA_EXTERN NSDictionary* JKGetDictionaryFromUserDefaults(NSString* key){
    if (key) return [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
    return nil;
}

//从UserDefault 读取 float
CA_EXTERN NSArray<NSString *> * JKGetStringArrayFromUserDefaults(NSString* key){
    if (key) return [[NSUserDefaults standardUserDefaults] stringArrayForKey:key];
    return nil;
}
CA_EXTERN NSData * JKGetDataFromUserDefaults(NSString* key){
    if (key) return [[NSUserDefaults standardUserDefaults] dataForKey:key];
    return nil;
}

CA_EXTERN void JKSetStrFromUserDefaults(NSString* key, NSString* value) {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
CA_EXTERN void JKSetBoolFromUserDefaults(NSString* key, BOOL value) {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
CA_EXTERN void JKSetIntFromUserDefaults(NSString* key, NSInteger value) {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
CA_EXTERN void JKSetFloatFromUserDefaults(NSString* key, float value) {
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
CA_EXTERN void JKSetDoubleFromUserDefaults(NSString* key, double value){
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

CA_EXTERN void JKSetURLFromUserDefaults(NSString* key, NSURL* value){
    [[NSUserDefaults standardUserDefaults] setURL:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

CA_EXTERN void JKSetObjectFromUserDefaults(NSString* key, id value){
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
CA_EXTERN void JKRemoveObjFromUserDefaults(NSString* key, ...) {
    va_list args;
    if (key){
        va_start(args, key);
        NSString* otherKey;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        while ((otherKey = va_arg(args, NSString*))) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:otherKey];
        }
        //  用VA_END宏结束可变参数的获取
        va_end(args);
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
CA_EXTERN NSString* JKGetAppVersonString(void) {
    NSDictionary* info = [NSBundle mainBundle].infoDictionary;
    return info[kAppVersionString];
}
CA_EXTERN APPLaunchStateOptions JKGetAppLaunchState() {
    APPLaunchStateOptions option  = APPLaunchStateFirst;
    // 判断是否登陆过,用当前版本号做Key来存储版本号
    BOOL userHasOnboarded = JKGetBoolFromUserDefaults(kAppFirstInstall);
    BOOL appIsUpdate = ![JKGetStrFromUserDefaults(kAppLastVersion) isEqualToString:JKGetAppVersonString()];
    if (userHasOnboarded) {//曾经登陆过
        if (appIsUpdate) {//保存版本信息与当前版本信息不同
            option = APPLaunchStateUpdate;
        }else{
            option = APPLaunchStateNormal;//保存版本信息与当前版本信息相同
        }
    }
    return option;
}
CA_EXTERN NSString* JKGetLaunchImageName(void){
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    // 竖屏
    NSString *viewOrientation = @"Portrait";
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return launchImageName;
}
CA_EXTERN BOOL JKContainsString(NSString*str,NSString* subStr){
    if (str == nil||subStr == nil) return NO;
    return [str rangeOfString:subStr].location != NSNotFound;
}
