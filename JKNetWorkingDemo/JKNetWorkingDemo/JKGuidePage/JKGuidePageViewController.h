//
//  JKGuidePageViewController.h
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2017/12/17.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "JKUtility.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
@class JKGuidePageViewController;

typedef JKGuidePageViewController *(^TimerBlock)(NSUInteger timeMax,NSUInteger timeDelay,NSString* timerTitle);
typedef JKGuidePageViewController *(^ImageArrBlock)(NSArray *imageArr,BOOL isURL,BOOL isGif);
typedef JKGuidePageViewController *(^ScrollViewStyleBlock)(UICollectionViewFlowLayout *layout,CGRect frame,CGSize itemSize,BOOL scrollDirectionVertical);
typedef JKGuidePageViewController *(^WKWebViewBlock)(CGRect frame, NSURL *url);
typedef JKGuidePageViewController *(^AVPlayerBlock)(CGRect frame, NSURL *url);
typedef void (^UploadDismissBtnBlock)(UIButton* btn);
//typedef JKGuidePageViewController *(^DismissBtnBlock)(NSString *btnTitle,UIColor *backColor,UIColor *textColor,UIImage *backImage,CGRect frame,CGFloat cornerRadius);
typedef JKGuidePageViewController *(^SetDismissBtnBlock)(UploadDismissBtnBlock block);
typedef UIView*(^CreateViewBlock)(void);

typedef JKGuidePageViewController *(^CustomViewBlock)(CreateViewBlock block);
typedef CABasicAnimation*(^CreateAnimateBlock)(void);
typedef JKGuidePageViewController *(^CustomViewAnimateWhenHiddenBlock)(CreateAnimateBlock block);
typedef void(^ClickImageActionBlock)(NSInteger selectIndex,NSString *selectImageStr ,id guidePageinfo);
typedef void(^BtnActionBlock)(id guidePageinfo);
typedef void(^AnimateFinishedBlock)(id guidePageinfo);

@interface JKGuidePageViewController : UIViewController

/**设置计时器相关属性
 timeMax 倒计时 时间
 timerTitle 倒计时 秒数后的文字
 */
@property (nonatomic,copy) TimerBlock setTimer;

/**设置ismissBtn按钮部分属性
 block btn属性设置
 */
@property (nonatomic,copy) SetDismissBtnBlock setDismissBtnBlock;

/**设置滚动视图相关属性
 layout 滚动视图布局样式
 frame 滚动视图相对位置
 itemSize item大小
 scrollDirectionVertical 是否垂直滚动
 */
@property (nonatomic,copy) ScrollViewStyleBlock setScrollViewStyle;

/**设置加载图片／gif相关属性
 imageArr 图片数组
 isURL 是否为链接
 isGif 是否为Gif
 */
@property (nonatomic,copy) ImageArrBlock setImageArr;

/**WKWeb
 frame WKWeb 显示位置
 url 加载链接
 */
@property (nonatomic,copy) WKWebViewBlock setWKWebView;

/**视频播放
 frame 播放器坐标
 url 播放链接 网络／本地
 */
@property (nonatomic,copy) AVPlayerBlock setAVPlayer;

/**自定义视图
 block 返回一个定制的视图
 使用自定义视图，以上均不可用
 */
@property (nonatomic,copy) CustomViewBlock setCustomView;
/**设置视图消失动画
 block 返回一个自定义的动画
 */
@property (nonatomic,copy) CustomViewAnimateWhenHiddenBlock setCustomViewAnimateWhenHiddenBlock;

/**
 初始化 JKGuidePageViewController

 @param clickImageActionBlock 图片点击回调
 @param btnActionBlock 按钮点击回调
 @param options app状态：首次安装，更新后首次打开，平时打开
 @return JKGuidePageViewController
 */
- (instancetype)initWithClickImageActionBlock:(ClickImageActionBlock)clickImageActionBlock
                               btnActionBlock:(BtnActionBlock)btnActionBlock
                                      options:(APPLaunchStateOptions)options;

/**
 刷新视图
 */
- (void)reloadData;
- (void)dismiss;
@end
