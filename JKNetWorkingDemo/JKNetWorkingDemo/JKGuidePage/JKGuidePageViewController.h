//
//  JKGuidePageViewController.h
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2017/12/17.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class JKGuidePageViewController;

typedef JKGuidePageViewController *(^TimerBlock)(NSUInteger timeMax);
typedef JKGuidePageViewController *(^ImageArrBlock)(NSArray *imageArr,BOOL isURL);
typedef JKGuidePageViewController *(^ScrollViewStyleBlock)(UICollectionViewFlowLayout *layout,CGRect frame,CGSize itemSize,BOOL scrollDirectionVertical);
typedef JKGuidePageViewController *(^DismissBtnBlock)(NSString *btnTitle,UIColor *backColor,UIColor *textColor,UIImage *backImage,CGRect frame,CGFloat cornerRadius);
typedef UIView*(^CreateViewBlock)(void);
typedef JKGuidePageViewController *(^CustomViewBlock)(CreateViewBlock block);
typedef CABasicAnimation*(^CreateAnimateBlock)(void);
typedef JKGuidePageViewController *(^CustomViewAnimateWhenHiddenBlock)(CreateAnimateBlock block);
typedef void(^ClickImageActionBlock)(NSInteger selectIndex,NSString *selectImageStr);
typedef void(^BtnActionBlock)(void);
typedef void(^AnimateFinishedBlock)(void);

@interface JKGuidePageViewController : UIViewController


/**<#Description#>*/
@property (nonatomic,copy) TimerBlock setTimer;
/**<#Description#>*/
@property (nonatomic,copy) DismissBtnBlock setDismissBtn;
/**<#Description#>*/
@property (nonatomic,copy) ScrollViewStyleBlock setScrollViewStyle;
/**<#Description#>*/
@property (nonatomic,copy) ImageArrBlock setImageArr;
/**<#Description#>*/
@property (nonatomic,copy) CustomViewBlock setCustomView;
/**<#Description#>*/
@property (nonatomic,copy) CustomViewAnimateWhenHiddenBlock setCustomViewAnimateWhenHiddenBlock;

- (instancetype)initWithClickImageActionBlock:(ClickImageActionBlock)clickImageActionBlock btnActionBlock:(BtnActionBlock)btnActionBlock;
- (void)reloadData;
@end
