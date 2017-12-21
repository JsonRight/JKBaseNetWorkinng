//
//  JKGuidePageViewController.h
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2017/12/17.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKUtility.h"

@class JKGuidePageViewController;

typedef JKGuidePageViewController *(^BackGroundImageBlock)(NSString *url,BOOL isURL,BOOL isGif);

typedef JKGuidePageViewController *(^TimerBlock)(NSUInteger timeMax,NSUInteger timeDelay,NSString* timerTitle);
typedef JKGuidePageViewController *(^ImageArrBlock)(NSArray *imageArr,BOOL isURL,BOOL isGif);
typedef JKGuidePageViewController *(^ScrollViewStyleBlock)(UICollectionViewFlowLayout *layout,CGRect frame,CGSize itemSize,BOOL scrollDirectionVertical);
typedef JKGuidePageViewController *(^WKWebViewBlock)(CGRect frame, NSURL *url);
typedef JKGuidePageViewController *(^AVPlayerBlock)(CGRect frame, NSURL *url);

typedef void (^UploadBtnBlock)(UIButton* btn);
typedef JKGuidePageViewController *(^SetBtnBlock)(UploadBtnBlock block);

typedef UIView*(^CreateViewBlock)(void);
typedef JKGuidePageViewController *(^CustomViewBlock)(CreateViewBlock block);

typedef CABasicAnimation*(^CreateAnimateBlock)(void);
typedef JKGuidePageViewController *(^CustomViewAnimateWhenHiddenBlock)(CreateAnimateBlock block);

typedef void(^ClickImageActionBlock)(NSInteger selectIndex,NSString *selectImageStr ,id info);
typedef JKGuidePageViewController *(^SetClickImageActionBlock)(ClickImageActionBlock block);

typedef void(^BtnActionBlock)(id info);
typedef JKGuidePageViewController *(^SetBtnActionBlock)(BtnActionBlock block);

typedef void(^AnimateFinishedBlock)(id info);
typedef JKGuidePageViewController *(^SetAnimateFinishedBlock)(AnimateFinishedBlock block);

typedef JKGuidePageViewController *(^SetAPPLaunchStateOptions)(APPLaunchStateOptions block);
@interface JKGuidePageViewController : UIViewController

/**设置加载图片／gif相关属性
 imageArr 图片数组
 isURL 是否为链接
 isGif 是否为Gif
 */
@property (nonatomic,copy,readonly) BackGroundImageBlock setBackGroundImage;

/**设置计时器相关属性
 timeMax 倒计时 时间
 timerTitle 倒计时 秒数后的文字
 */
@property (nonatomic,copy,readonly) TimerBlock setTimer;

/**设置ismissBtn按钮部分属性
 block btn属性设置
 */
@property (nonatomic,copy,readonly) SetBtnBlock setCountdownBtnBlock;
/**设置ismissBtn按钮部分属性
 block btn属性设置
 */
@property (nonatomic,copy,readonly) SetBtnBlock setCenterBtnBlock;

/**设置滚动视图相关属性
 layout 滚动视图布局样式
 frame 滚动视图相对位置
 itemSize item大小
 scrollDirectionVertical 是否垂直滚动
 */
@property (nonatomic,copy,readonly) ScrollViewStyleBlock setScrollViewStyle;

/**设置加载图片／gif相关属性
 imageArr 图片数组
 isURL 是否为链接
 isGif 是否为Gif
 */
@property (nonatomic,copy,readonly) ImageArrBlock setImageArr;

/**WKWeb
 frame WKWeb 显示位置
 url 加载链接
 */
@property (nonatomic,copy,readonly) WKWebViewBlock setWKWebView;

/**视频播放
 frame 播放器坐标
 url 播放链接 网络／本地
 */
@property (nonatomic,copy,readonly) AVPlayerBlock setAVPlayer;

/**自定义视图
 block 返回一个定制的视图
 使用自定义视图，以上均不可用
 */
@property (nonatomic,copy,readonly) CustomViewBlock setCustomView;

/**设置视图消失动画
 block 返回一个自定义的动画
 */
@property (nonatomic,copy,readonly) CustomViewAnimateWhenHiddenBlock setCustomViewAnimateWhenHiddenBlock;

/**点击页面图片回调
 包含图片index，图片链接
 */
@property (nonatomic,copy,readonly) SetClickImageActionBlock setClickImageActionBlock;

/**点击右上角倒计时按钮回调
 自定义右上角按钮属性
 */
@property (nonatomic,copy,readonly) SetBtnActionBlock setCountdownBtnActionBlock;

/**点击中间的按钮的回调
 自定义中间按钮属性，默认贴在滚动视图最后一页的下面
 */
@property (nonatomic,copy,readonly) SetBtnActionBlock setCenterBtnActionBlock;

/**dismiss动画结束回调
 */
@property (nonatomic,copy,readonly) SetAnimateFinishedBlock setAnimateFinishedBlock;

/**没办法，暴露出来给guideWindow调用的，
 */
@property (nonatomic,copy) AnimateFinishedBlock animateFinishedBlock;
/**设置启动图弹出时机，默认首次安装app
 三种状态：首次安装，每次启动，更新启动
 */
@property (nonatomic,copy,readonly) SetAPPLaunchStateOptions setAPPLaunchStateOptions;

/**
 刷新视图
 */
- (void)reloadData;

@end
