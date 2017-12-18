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
/**app启动状态*/
@property (nonatomic,assign) APPLaunchStateOptions options;
@end
@implementation JKGuidePageWindow

- (void)dealloc{
    
    
}
- (JKGuidePageViewController *)makeJKGuidePageWindow:(void (^)(JKGuidePageViewController *make))make
          clickImageActionBlock:(ClickImageActionBlock)clickImageActionBlock
                 btnActionBlock:(BtnActionBlock)btnActionBlock
                animateFinished:(AnimateFinishedBlock)finished{
    self.finished = finished;
    JKGuidePageViewController* root = [[JKGuidePageViewController alloc]initWithClickImageActionBlock:clickImageActionBlock btnActionBlock:btnActionBlock options:self.options];
    self.rootViewController = root;
    make(root);
    [root reloadData];
    if (self.options & JKGetAppLaunchState()) {
        [JKGuidePageWindow show];
    }
    return root;
}
- (id)makeGuidePageWindowWithCustomVC:(UIViewController*)vc{
    self.rootViewController = vc;
    return vc;
}
static JKGuidePageWindow* guidePageWindow=nil;
+ (JKGuidePageWindow*)sheareGuidePageWithOptions:(APPLaunchStateOptions)options{
    if (!guidePageWindow) {
        guidePageWindow = [[JKGuidePageWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        guidePageWindow.backgroundColor  =[UIColor whiteColor];
        guidePageWindow.windowLevel = UIWindowLevelNormal+1;
    }
    guidePageWindow.options = options?options:APPLaunchStateFirst;
    return guidePageWindow;
}

+ (void)show{
    [guidePageWindow makeKeyAndVisible];
}
+ (void)dismiss{
    JKSetBoolFromUserDefaults(kAppFirstInstall, YES);
    JKSetStrFromUserDefaults(kAppLastVersion, JKGetAppVersonString());
    [UIView animateWithDuration:0.5 animations:^{
        guidePageWindow.alpha=0.0;
    } completion:^(BOOL finished) {
        [guidePageWindow resignKeyWindow];
        if (guidePageWindow.finished) {
            guidePageWindow.finished(nil);
        }
        guidePageWindow=nil;
    }];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
//    self.rootViewController.view.frame = self.bounds;
}

@end
