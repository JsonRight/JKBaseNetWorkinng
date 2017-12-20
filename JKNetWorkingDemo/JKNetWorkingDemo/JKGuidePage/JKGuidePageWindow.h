//
//  JKGuidePageWindow.h
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/15.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKGuidePageViewController.h"
#import "JKUtility.h"

@interface JKGuidePageWindow : UIWindow

/**
 jk定制启动页视图

 @param make 定制视图Block，在内部可定制部分属性，详见 JKGuidePageViewController 控制器
 
 @return JKGuidePageViewController
 */
- (JKGuidePageViewController *)makeJKGuidePageWindow:(void(^)(JKGuidePageViewController *make))make;

/**
 高度自定义启动页视图

 @param vc 传入预定制启动视图，无需管理app首次启动状态
 @return 返回预定制的启动图，没啥用
 */
- (id)makeGuidePageWindowWithCustomVC:(UIViewController*)vc;


/**
 初始化 启动图控制Window

 @return 启动图控制Window
 */
+ (JKGuidePageWindow *)sheareGuidePageWindow;

/**
 启动页显示，无需手动加载
 */
- (void)show;
/**
 启动页消失，自定义视图，消失时调用
 */
- (void)dismiss;
@end
