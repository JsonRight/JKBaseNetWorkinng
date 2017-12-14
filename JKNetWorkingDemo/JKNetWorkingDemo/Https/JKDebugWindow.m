//
//  JKDebugWindow.m
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import "JKDebugWindow.h"


@interface JKDebugVC (){
    UITextView *_textView;
}
@property (nonatomic,copy) NSString *text;
/**<#Description#>*/
@property (nonatomic, strong) UISwipeGestureRecognizer *swipe;
/**<#Description#>*/
@property (nonatomic, strong) UITapGestureRecognizer *tap;
/**<#Description#>*/
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, strong)NSString *string;
///是否显示控制台
@property (nonatomic, assign)BOOL isShowConsole;
//添加一个全局的logString 防止局部清除
@property (nonatomic, copy)NSMutableString *logSting;
//记录打印数，来确定打印更新
@property (nonatomic, assign)NSInteger currentLogCount;
//是否全屏
@property (nonatomic, assign)BOOL isFullScreen;
@end
@implementation JKDebugVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.swipe];
    [self.view addGestureRecognizer:self.tap];
    [self.view addGestureRecognizer:self.pan];
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _textView.backgroundColor = [UIColor blackColor];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _textView.font = [UIFont boldSystemFontOfSize:13];
    _textView.textColor = [UIColor whiteColor];
    _textView.editable = NO;
    _textView.scrollEnabled = NO;
    _textView.selectable = NO;
    _textView.alwaysBounceVertical = YES;
#ifdef __IPHONE_11_0
    if([_textView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
        _textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#pragma clang diagnostic pop
        
    }
#endif
    [self.view addSubview:_textView];
    _textView.text = self.text;
    [_textView scrollRectToVisible:CGRectMake(0, _textView.contentSize.height-15, _textView.contentSize.width, 10) animated:YES];
    [self startPrintLog];
    
}
- (UISwipeGestureRecognizer *)swipe{
    if (!_swipe) {
        _swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action: @selector(swipeLogView:)];
    }
    return _swipe;
}
- (UITapGestureRecognizer*)tap{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapTextView:)];
        _tap.numberOfTapsRequired = 2;
    }
    return _tap;
}
- (UIPanGestureRecognizer*)pan{
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOutTextView:)];
    }
    return _pan;
}
- (void)setText:(NSString *)text {
    _text = [text copy];
    if(_textView){
        _textView.text = text;
        [_textView scrollRectToVisible:CGRectMake(0, _textView.contentSize.height-15, _textView.contentSize.width, 10) animated:YES];
    }
}
#pragma mark-  三种手势的添加
//右滑隐藏
- (void)swipeLogView:(UISwipeGestureRecognizer *)swipeGesture{
    
    if (_isFullScreen) {//如果是显示情况并且往右边滑动就隐藏
        if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight) {
            [UIView animateWithDuration:0.5 animations:^{
                [self minimize];
            } completion:^(BOOL finished) {
                _isFullScreen = NO;
                [self.view addGestureRecognizer:self.pan];
            }];
        }
    }
}
//scroll vertical.
- (void)panOutTextView:(UIPanGestureRecognizer *)panGesture{
    
    if (_isFullScreen == YES) {//如果是显示情况什么都不管。
        return;
    }else{//如果是隐藏情况上下移动就
        if(panGesture.state == UIGestureRecognizerStateChanged){
            CGPoint transalte = [panGesture translationInView:[UIApplication sharedApplication].keyWindow];
            CGRect rect = self.view.window.frame;
            rect.origin.y += transalte.y;
            if(rect.origin.y < 0){
                rect.origin.y = 0;
            }
            CGFloat maxY = [UIScreen mainScreen].bounds.size.height - rect.size.height;
            if(rect.origin.y > maxY){
                rect.origin.y = maxY;
            }
            self.view.window.frame = rect;
            [panGesture setTranslation:CGPointZero inView:[UIApplication sharedApplication].keyWindow];
        }
    }
}
//双击操作
- (void)doubleTapTextView:(UITapGestureRecognizer *)tapGesture{
    
    if (_isFullScreen == NO) {//变成全屏
        [UIView animateWithDuration:0.2 animations:^{
            [self maxmize];
        } completion:^(BOOL finished) {
            _isFullScreen = YES;
            [self.view removeGestureRecognizer:self.pan];
        }];
    }else{//退出全屏
        [UIView animateWithDuration:0.2 animations:^{
            [self minimize];
        } completion:^(BOOL finished) {
            _isFullScreen = NO;
            [self.view addGestureRecognizer:self.pan];
        }];
    }
}
- (void)maxmize {
    self.view.window.frame = [UIScreen mainScreen].bounds;
    _textView.scrollEnabled =  YES;
}

- (void)minimize {
    self.view.window.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 30, 120, [UIScreen mainScreen].bounds.size.width - 60, 90);
    _textView.scrollEnabled = NO;
}
//开始显示log日志 更新频率0.5s
- (void)startPrintLog{
    _isFullScreen = NO;
    _isShowConsole = YES;
    _logSting = [NSMutableString new];
    DDLog(@"%@__%@",nil,@"2");
}

- (void)printMSG:(NSString *)msg andFunc:(const char *)function andLine:(NSInteger )Line{
   
    msg = [NSString stringWithFormat:@"<%s : %ld>%@\n",function,(long)Line,msg];
    
    const char *resultCString = NULL;
    if ([msg canBeConvertedToEncoding:NSUTF8StringEncoding]) {
        resultCString = [msg cStringUsingEncoding:NSUTF8StringEncoding];
    }
    //控制台打印
    printf("%s", resultCString);
    if (self.isShowConsole) {//如果显示的话手机上的控制台开始显示。
        [_logSting appendString:msg];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.text = _logSting;
        });
    }
}

@end

@implementation DebugWindow
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    self.rootViewController.view.frame = self.bounds;
//
//}
@end
@interface JKDebugWindow ()

@end
@implementation JKDebugWindow

SingletonM(DebugWindow)

- (void)show{
    
    self.debugWindow.windowLevel = UIWindowLevelStatusBar + 101;
    self.debugWindow.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 30, 120, [UIScreen mainScreen].bounds.size.width - 60, 90);
    self.debugWindow.rootViewController = self.debugVC;
    [self.debugWindow makeKeyAndVisible];
}


-(JKDebugVC *)debugVC{
    if (!_debugVC) {
        _debugVC = [[JKDebugVC alloc]init];
    }
    return _debugVC;
}
-(DebugWindow *)debugWindow{
    if (!_debugWindow) {
        _debugWindow = [[DebugWindow alloc]init];
    }
    return _debugWindow;
    
}

@end
CA_EXTERN void Delog_(const char *func, NSUInteger line, NSString* format, ... ){
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = nil;
        message = [[NSString alloc] initWithFormat:format arguments:args];
        //UI上去展示日志内容
        [[JKDebugWindow sharedDebugWindow].debugVC printMSG:message andFunc:func andLine:line];
    }
}


