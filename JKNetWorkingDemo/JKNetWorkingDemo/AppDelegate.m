//
//  AppDelegate.m
//  JKNetWorkingDemo
//
//  Created by jk on 2017/9/27.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "AppDelegate.h"
//#import "JKConsole.h"
#import "JKGuidePageWindow.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    [JKGuidePageWindow makeShowImage:^(JKGuidePageViewController *make) {
        make.setImageArr(@[@"引导页750x1334",@"引导页750x1334",@"引导页750x1334"], NO);
        make.setTimer(3);
        make.setScrollViewStyle(nil, CGRectNull, CGSizeZero, YES);
        make.setCustomViewAnimateWhenHiddenBlock(^CABasicAnimation *{
            CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
            
            animation.fromValue=@1;
            
            animation.toValue=@1.5;
            
            animation.duration=0.5;
            
            animation.autoreverses=YES;
            
            animation.repeatCount=1;
            
            animation.removedOnCompletion=NO;
            
            animation.fillMode=kCAFillModeForwards;
            
            return animation;
        });
    } clickImageActionBlock:^(NSInteger selectIndex, NSString *selectImageStr) {
        
    } btnActionBlock:^{
        
    } animateFinished:^{
        
    }];
    //控制台显示
//    [JKConsole sheareConsoleShowAndVisible];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        for (int i = 0; i<10; i++) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                //测试打印效果
//                DDLog(@"日志打印：%ld",i)
//            });
//        }
//    });
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
