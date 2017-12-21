//
//  AppDelegate.m
//  JKNetWorkingDemo
//
//  Created by jk on 2017/9/27.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "AppDelegate.h"
#import "JKConsole.h"
#import "JKGuidePage.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    JKGuidePageWindow* guidePageWindow =[JKGuidePageWindow sheareGuidePageWindow];
    {
        //启动页，全部属性设置
        
        [guidePageWindow makeJKGuidePageWindow:^(JKGuidePageViewController *make) {
            //设置背景图片---是否网络--- 是否gif
            make.setBackGroundImage(nil, NO, NO);
            //图片数组 ---是否网络--- 是否gif
            make.setImageArr(@[@"ggg",@"ggg"], NO ,YES);
            //设置计时器 ---倒计时总时间----延时开始倒计时时间----秒数后面的按钮文字（右上角按钮）
            //当总时间为0，不进行倒计时，延时显示右上角按钮，文字显示默认/设置文字
            make.setTimer(0,3,@"s跳过");
            //设置右上角按钮属性，当倒计时延时时间>0时，请不要设置hidden=NO，(默认状态隐藏)
            make.setCountdownBtnBlock(^(UIButton *btn) {
                //            btn.hidden = NO;
            });
            //设置中间按钮属性，(默认状态隐藏)
            make.setCenterBtnBlock(^(UIButton *btn) {
                            btn.hidden = NO;
            });
            //设置图片滚动的item属性，（UICollectionView 默认横向滚动：NO）
            make.setScrollViewStyle(nil, CGRectNull, CGSizeZero, NO);
            //设置web'加载，url请转成NSURL
//            make.setWKWebView([UIScreen mainScreen].bounds, [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ajaxHtml" ofType:@"html"]]);
            //设置视频播放器  url请转成NSURL
//            make.setAVPlayer(CGRectZero, [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"]]);
            //设置倒计时按钮点击回调（启动页消失不需在block内处理）
            make.setCountdownBtnActionBlock(^(id info) {
                DDLog(@"倒计时按钮事件：%@",info)
            });
            //设置中间按钮点击回调（启动页消失不需在block内处理）
            make.setCenterBtnActionBlock(^(id info) {
                DDLog(@"中间按钮事件：%@",info)
            });
            //设置滚动图片点击回调（启动页消失不需在block内处理）
            make.setClickImageActionBlock(^(NSInteger selectIndex, NSString *selectImageStr, id info) {
                DDLog(@"点击第%ld张，图片名称：%@，其他参数：%@",selectIndex,selectImageStr,info)
            });
            make.setAnimateFinishedBlock(^(id info) {
                DDLog(@"启动页消失动画结束：%@",info)
            });
            //设置启动页显示时机：首次安装、更新后首次启动、正常启动（可传多种）
            make.setAPPLaunchStateOptions(APPLaunchStateFirst |APPLaunchStateNormal);
            //设置启动页消失时整个弹层的动画（估计用不到）
            make.setCustomViewAnimateWhenHiddenBlock(^CABasicAnimation *{
                //                CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
                //
                //                animation.fromValue=@1;
                //
                //                animation.toValue=@0.5;
                //
                //                animation.duration=0.5;
                //
                //                animation.autoreverses=YES;
                //
                //                animation.repeatCount=1;
                //
                //                animation.removedOnCompletion=NO;
                //
                //                animation.fillMode=kCAFillModeForwards;
                //
                return nil;
            });
            //自定义CustomView，那么以上所有设定 如果设置，则会重新添加
            make.setCustomView(^UIView *{
                return [[UIView alloc]initWithFrame: [UIScreen mainScreen].bounds];
            });
            
        }];
        
    }
    
    {
        
        //居然还支持替换VC，但是好像，并没有什么卵用
        //[guidePageWindow makeGuidePageWindowWithCustomVC:[UIViewController new]];
        
    }
   
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
