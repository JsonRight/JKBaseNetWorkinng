//
//  JKGuidePageWindow.h
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/15.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKGuidePageViewController.h"

@interface JKGuidePageWindow : UIWindow

+ (void)makeShowImage:(void(^)(JKGuidePageViewController *make))make
clickImageActionBlock:(ClickImageActionBlock)clickImageActionBlock
       btnActionBlock:(BtnActionBlock)btnActionBlock
      animateFinished:(AnimateFinishedBlock)finished;
+ (JKGuidePageWindow*)sheareGuidePageWindow;
+ (void)dismiss;
@end
