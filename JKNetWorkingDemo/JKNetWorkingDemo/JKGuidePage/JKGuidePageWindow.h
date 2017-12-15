//
//  JKGuidePageWindow.h
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/15.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class JKGuidePageWindow;
typedef JKGuidePageWindow *(^TimerMax)(NSUInteger timeMax);
typedef JKGuidePageWindow *(^TimerDelay)(NSUInteger timeDelay);
typedef JKGuidePageWindow *(^ImageArr)(NSArray *imageArr,CGSize itemSize,BOOL scrollDirectionVertical);
typedef JKGuidePageWindow *(^CustomView)(UIView *customView);
@interface JKGuidePageWindow : UIWindow
/**<#Description#>*/
@property (nonatomic,copy) TimerMax subTimerMax;
/**<#Description#>*/
@property (nonatomic,copy) TimerDelay subTimerDelay;
/**<#Description#>*/
@property (nonatomic,copy) ImageArr subImageArr;
/**<#Description#>*/
@property (nonatomic,copy) CustomView subCustomView;
+ (JKGuidePageWindow*)sheareGuidePageWindow;
+ (void)dismiss;
@end
