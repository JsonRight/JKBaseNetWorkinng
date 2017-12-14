//
//  JKDebugWindow.h
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <unistd.h>
#import <sys/uio.h>
#import <pthread/pthread.h>
#ifdef DEBUG
#define DDLog(frmt, ...)  Delog_([[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, (frmt), ##__VA_ARGS__);
#else
#define DDLog(frmt, ...)
#endif


@interface  JKDebugVC : UIViewController

@end
@interface DebugWindow : UIWindow


@end
@interface JKDebugWindow : NSObject
SingletonH(DebugWindow)
/**Debug控制器*/
@property (nonatomic, strong) JKDebugVC *debugVC;
/**DebugWindow*/
@property (nonatomic, strong) DebugWindow *debugWindow;
- (void)show;
@end
CA_EXTERN void Delog_(const char *func, NSUInteger line, NSString* format, ... );
