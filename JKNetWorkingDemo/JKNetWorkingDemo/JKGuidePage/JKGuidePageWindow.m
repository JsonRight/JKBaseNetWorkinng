//
//  JKGuidePageWindow.m
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/15.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import "JKGuidePageWindow.h"


@interface JKGuidePageWindow ()
@property (nonatomic,copy) AnimateFinishedBlock finished;
@end
@implementation JKGuidePageWindow

- (void)dealloc{
    
    
}
+ (void)makeShowImage:(void (^)(JKGuidePageViewController *make))make  clickImageActionBlock:(ClickImageActionBlock)clickImageActionBlock btnActionBlock:(BtnActionBlock)btnActionBlock animateFinished:(AnimateFinishedBlock)finished{
    JKGuidePageWindow* win = [JKGuidePageWindow sheareGuidePageWindow];
    win.finished = finished;
    JKGuidePageViewController* root = [[JKGuidePageViewController alloc]initWithClickImageActionBlock:clickImageActionBlock btnActionBlock:btnActionBlock];
    win.rootViewController = root;
    make(root);
    [root reloadData];
    [guidePageWindow makeKeyAndVisible];
}

static JKGuidePageWindow* guidePageWindow=nil;
+ (JKGuidePageWindow*)sheareGuidePageWindow{
    if (!guidePageWindow) {
        guidePageWindow = [[JKGuidePageWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        guidePageWindow.backgroundColor  =[UIColor whiteColor];
        guidePageWindow.windowLevel = UIWindowLevelNormal+1;
    }
    return guidePageWindow;
}
+ (void)dismiss{
  
    [UIView animateWithDuration:0.5 animations:^{
        guidePageWindow.alpha=0.0;
    } completion:^(BOOL finished) {
        [guidePageWindow resignKeyWindow];
        if (guidePageWindow.finished) {
            guidePageWindow.finished();
        }
        guidePageWindow=nil;
    }];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
//    self.rootViewController.view.frame = self.bounds;
}

@end
