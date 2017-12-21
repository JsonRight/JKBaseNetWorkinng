//
//  JKGuidePageWindow.m
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/15.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import "JKGuidePageWindow.h"

@interface JKGuidePageWindow ()
/**<#Description#>*/
@property (nonatomic, strong) JKGuidePageViewController *guidePageViewController;
/**app启动状态*/
@property (nonatomic,assign) APPLaunchStateOptions options;
@end
@implementation JKGuidePageWindow

- (void)dealloc{
 JKDlog(@"%@释放了",[self class])
    
}
- (JKGuidePageViewController *)guidePageViewController{
    if (!_guidePageViewController) {
        _guidePageViewController = [JKGuidePageViewController new];
    }
    return _guidePageViewController;
}
- (JKGuidePageViewController *)makeJKGuidePageWindow:(void (^)(JKGuidePageViewController *make))make{
    self.rootViewController = self.guidePageViewController;
    make(self.guidePageViewController);
    [self.guidePageViewController reloadData];
    return self.guidePageViewController;
}
- (id)makeGuidePageWindowWithCustomVC:(UIViewController*)vc{
    self.rootViewController = vc;
    return vc;
}

static JKGuidePageWindow* guidePageWindow=nil;
+ (JKGuidePageWindow*)sheareGuidePageWindow{
    if (!guidePageWindow) {
        guidePageWindow = [[JKGuidePageWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        guidePageWindow.backgroundColor  = [UIColor whiteColor];
        guidePageWindow.windowLevel = UIWindowLevelNormal+1;
    }
    return guidePageWindow;
}

- (void)show{
    [self makeKeyAndVisible];
}
- (void)dismiss{
    JKSetBoolFromUserDefaults(kAppFirstInstall, YES);
    JKSetStrFromUserDefaults(kAppLastVersion, JKGetAppVersonString());
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha=0.0;
    } completion:^(BOOL finished) {
        [self resignKeyWindow];
        if (_guidePageViewController&&_guidePageViewController.animateFinishedBlock) {
            _guidePageViewController.animateFinishedBlock(nil);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kJKGuidePageWindowDidDismiss object:nil];
        [JKGuidePageWindow removeForWindows];
    }];
    
}
+(void)removeForWindows{
    guidePageWindow = nil;
}
-(void)layoutSubviews{
    [super layoutSubviews];
//    self.rootViewController.view.frame = self.bounds;
}

@end
