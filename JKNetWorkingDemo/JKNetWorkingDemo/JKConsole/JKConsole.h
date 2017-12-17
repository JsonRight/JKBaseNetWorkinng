//
//  JKConsole.h
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/14.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <UIKit/UIKit.h>

#if defined (DebugNet) || defined (PreNet) || DEBUG //如果测试环境才有
#define DDLog(frmt, ...)  _Delog_([[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, (frmt), ##__VA_ARGS__);
#else
#define DDLog(frmt, ...)
#endif
CA_EXTERN void _Delog_(const char *className, NSUInteger line, NSString* format, ... );
@interface JKConsole : UIWindow
+ (JKConsole* )sheareConsole;
- (void)showAndVisible;
+ (void)dissmiss;
@end

