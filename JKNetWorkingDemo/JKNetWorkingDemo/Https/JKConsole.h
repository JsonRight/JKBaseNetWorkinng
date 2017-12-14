//
//  JKConsole.h
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/14.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define DDLog(frmt, ...)  Delog_([[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, (frmt), ##__VA_ARGS__);
#else
#define DDLog(frmt, ...)
#endif
CA_EXTERN void Delog_(const char *className, NSUInteger line, NSString* format, ... );
@interface JKConsole : UIWindow
+ (JKConsole* )console;
- (void)show;
- (void)dissmiss;
@end

