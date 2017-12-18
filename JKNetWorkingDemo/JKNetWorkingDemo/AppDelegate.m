//
//  AppDelegate.m
//  JKNetWorkingDemo
//
//  Created by jk on 2017/9/27.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "AppDelegate.h"
#import "JKConsole.h"
#import "JKGuidePageWindow.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    [[JKGuidePageWindow sheareGuidePageWithOptions:APPLaunchStateFirst |APPLaunchStateNormal] makeJKGuidePageWindow:^(JKGuidePageViewController *make) {
        make.setImageArr(@[@"https://image.baidu.com/search/down?tn=download&word=download&ie=utf8&fr=detail&url=https%3A%2F%2Ftimgsa.baidu.com%2Ftimg%3Fimage%26quality%3D80%26size%3Db9999_10000%26sec%3D1513602295155%26di%3Db2a2f6126cebfc8ec7093118d92e1584%26imgtype%3D0%26src%3Dhttp%253A%252F%252Fimg.zcool.cn%252Fcommunity%252F0121be5715d3e132f8758c9b7e43de.gif&thumburl=https%3A%2F%2Fss3.bdstatic.com%2F70cFv8Sh_Q1YnxGkpoWK1HF6hhy%2Fit%2Fu%3D2128235232%2C2821001689%26fm%3D27%26gp%3D0.jpg"], YES ,YES);
        make.setTimer(0,@"跳过");
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
    } clickImageActionBlock:^(NSInteger selectIndex, NSString *selectImageStr ,id info) {
        DDLog(@"点击第%ld张，图片名称：%@，其他参数：%@",selectIndex,selectImageStr,info)
    } btnActionBlock:^(id info){
        DDLog(@"其他参数：%@",info)
    } animateFinished:^(id info){
        DDLog(@"动画结束，其他参数：%@",info)
    }];
    //控制台显示
    [[JKConsole sheareConsole] showAndVisible];
    
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
