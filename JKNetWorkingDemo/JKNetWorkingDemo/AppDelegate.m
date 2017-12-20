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
    
    JKGuidePageWindow* guidePageWindow =[JKGuidePageWindow sheareGuidePageWindow];
    [guidePageWindow makeJKGuidePageWindow:^(JKGuidePageViewController *make) {
//        make.setImageArr(@[@"https://image.baidu.com/search/down?tn=download&word=download&ie=utf8&fr=detail&url=https%3A%2F%2Ftimgsa.baidu.com%2Ftimg%3Fimage%26quality%3D80%26size%3Db9999_10000%26sec%3D1513602295155%26di%3Db2a2f6126cebfc8ec7093118d92e1584%26imgtype%3D0%26src%3Dhttp%253A%252F%252Fimg.zcool.cn%252Fcommunity%252F0121be5715d3e132f8758c9b7e43de.gif&thumburl=https%3A%2F%2Fss3.bdstatic.com%2F70cFv8Sh_Q1YnxGkpoWK1HF6hhy%2Fit%2Fu%3D2128235232%2C2821001689%26fm%3D27%26gp%3D0.jpg",@"https://image.baidu.com/search/down?tn=download&word=download&ie=utf8&fr=detail&url=https%3A%2F%2Ftimgsa.baidu.com%2Ftimg%3Fimage%26quality%3D80%26size%3Db9999_10000%26sec%3D1513602295155%26di%3Db2a2f6126cebfc8ec7093118d92e1584%26imgtype%3D0%26src%3Dhttp%253A%252F%252Fimg.zcool.cn%252Fcommunity%252F0121be5715d3e132f8758c9b7e43de.gif&thumburl=https%3A%2F%2Fss3.bdstatic.com%2F70cFv8Sh_Q1YnxGkpoWK1HF6hhy%2Fit%2Fu%3D2128235232%2C2821001689%26fm%3D27%26gp%3D0.jpg"], YES ,YES);
        
        make.setTimer(0,3,@"s跳过");
        make.setCountdownBtnBlock(^(UIButton *btn) {
//            btn.hidden = NO;
        });
        
//        make.setScrollViewStyle(nil, CGRectNull, CGSizeZero, YES);
        
        make.setWKWebView([UIScreen mainScreen].bounds, [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ajaxHtml" ofType:@"html"]]);
        
//        make.setCustomViewAnimateWhenHiddenBlock(^CABasicAnimation *{
//            CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
//            
//            animation.fromValue=@1;
//            
//            animation.toValue=@0.5;
//            
//            animation.duration=0.5;
//            
//            animation.autoreverses=YES;
//            
//            animation.repeatCount=1;
//            
//            animation.removedOnCompletion=NO;
//            
//            animation.fillMode=kCAFillModeForwards;
//            
//            return animation;
//        });
        
        make.setAVPlayer(CGRectZero, [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"]]);
        make.setCenterBtnBlock(^(UIButton *btn) {
            btn.hidden = NO;
        });
        make.setCountdownBtnActionBlock(^(id info) {
            DDLog(@"倒计时按钮事件：%@",info)
        });
        make.setClickImageActionBlock(^(NSInteger selectIndex, NSString *selectImageStr, id info) {
            DDLog(@"点击第%ld张，图片名称：%@，其他参数：%@",selectIndex,selectImageStr,info)
        });
        make.setCenterBtnActionBlock(^(id info) {
            DDLog(@"中间按钮事件：%@",info)
        });
    } ];
    //控制台显示
    [[JKConsole sheareConsole] showAndVisible];
    
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
