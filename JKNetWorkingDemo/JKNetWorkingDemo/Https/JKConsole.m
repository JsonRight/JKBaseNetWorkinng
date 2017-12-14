//
//  JKConsole.m
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/14.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import "JKConsole.h"
@interface JKDebugViewController :UIViewController
/**<#Description#>*/
@property (nonatomic, strong) UITextView *textView;
/**<#Description#>*/
@property (nonatomic, strong) NSMutableString *logStr;


@end
@interface JKDebugViewController ()
{
    NSMutableString* _logStr;
}

@end
@implementation JKDebugViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    DDLog(@"控制台出现");
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.view.bounds.size.width == [UIScreen mainScreen].bounds.size.width) {
        self.textView.scrollEnabled = YES;
    }else{
        self.textView.scrollEnabled = NO;
    }
}
-(NSMutableString *)logStr{
    if (!_logStr) {
        _logStr = [NSMutableString stringWithCapacity:0];
    }
    return _logStr;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
        _textView.backgroundColor = [UIColor blackColor];
        _textView.font = [UIFont boldSystemFontOfSize:13];
        _textView.textColor = [UIColor whiteColor];
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.selectable = NO;
        _textView.alwaysBounceVertical = YES;
        [self.view addSubview:_textView];
        _textView.text = self.logStr;
        [_textView scrollRectToVisible:CGRectMake(0, _textView.contentSize.height-15, _textView.contentSize.width, 10) animated:YES];
    }
    return _textView;
    
}
- (void)setLogStr:(NSMutableString *)logStr{
    _logStr = [logStr mutableCopy];
    self.textView.text = _logStr;
    [self.textView scrollRectToVisible:CGRectMake(0, self.textView.contentSize.height-15, self.textView.contentSize.width, 10) animated:YES];
}

- (void)printMSGFromJKConsole:(const char *)msg{
        [self.logStr appendString:[NSString stringWithUTF8String:msg]];
        self.logStr  = _logStr;
}

@end



#pragma mark -- console
@interface JKConsole (){
    
}

/**<#Description#>*/
@property (nonatomic, strong) JKDebugViewController *debugVC;
/**<#Description#>*/
@property (nonatomic, strong) UISwipeGestureRecognizer *swipe;
/**<#Description#>*/
@property (nonatomic, strong) UITapGestureRecognizer *tap;
/**<#Description#>*/
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@end

@implementation JKConsole

+ (JKConsole* )console{
    static dispatch_once_t onceToken;
    static JKConsole* console = nil;
    dispatch_once(&onceToken, ^{
        console = [JKConsole new];
        console.windowLevel = UIWindowLevelStatusBar + 101;
        console.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 120, 50, 50);
        console.layer.masksToBounds = YES;
        console.layer.cornerRadius = 25;
        console.rootViewController = [[UINavigationController alloc]initWithRootViewController:console.debugVC];
        [console addGestureRecognizer:console.swipe];
        [console addGestureRecognizer:console.tap];
        [console addGestureRecognizer:console.pan];
    });
    return console;
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
- (JKDebugViewController *)debugVC{
    if (!_debugVC) {
        _debugVC = [[JKDebugViewController alloc]init];
    }
    return _debugVC;
}
- (void)show{
    
    [self makeKeyAndVisible];
    self.hidden = NO;
}
- (void)dissmiss{
    
    self.hidden = YES;
}

#pragma mark-  三种手势的添加
//右滑隐藏
- (void)swipeLogView:(UISwipeGestureRecognizer *)swipeGesture{
    
    if (self.bounds.size.width == [UIScreen mainScreen].bounds.size.width) {//如果是显示情况并且往右边滑动就隐藏
        if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight) {
            [UIView animateWithDuration:0.5 animations:^{
                [self minimize];
            } completion:^(BOOL finished) {
                //                _isFullScreen = NO;
                [self addGestureRecognizer:self.pan];
            }];
        }
    }
}
//scroll vertical.
- (void)panOutTextView:(UIPanGestureRecognizer *)panGesture{
    
    if (self.bounds.size.width == [UIScreen mainScreen].bounds.size.width) {//如果是显示情况什么都不管。
        return;
    }else{//如果是隐藏情况上下移动就
        if(panGesture.state == UIGestureRecognizerStateChanged){
            CGPoint transalte = [panGesture translationInView:[UIApplication sharedApplication].keyWindow];
            CGRect rect = self.frame;
            rect.origin.y += transalte.y;
            if(rect.origin.y < 88){
                rect.origin.y = 88;
            }
            CGFloat maxY = [UIScreen mainScreen].bounds.size.height - rect.size.height-88;
            if(rect.origin.y > maxY){
                rect.origin.y = maxY;
            }
            self.frame = rect;
            [panGesture setTranslation:CGPointZero inView:[UIApplication sharedApplication].keyWindow];
        }
    }
}
//双击操作
- (void)doubleTapTextView:(UITapGestureRecognizer *)tapGesture{
    
    if (self.bounds.size.width != [UIScreen mainScreen].bounds.size.width) {//变成全屏
        [UIView animateWithDuration:0.2 animations:^{
            [self maxmize];
        } completion:^(BOOL finished) {
            
            [self removeGestureRecognizer:self.pan];
        }];
    }else{//退出全屏
        [UIView animateWithDuration:0.2 animations:^{
            [self minimize];
        } completion:^(BOOL finished) {
           
            [self addGestureRecognizer:self.pan];
        }];
    }
}
- (void)maxmize {
    self.frame = [UIScreen mainScreen].bounds;
    self.layer.cornerRadius = 0;
}

- (void)minimize {
    self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 120, 50, 50);
    self.layer.cornerRadius = 25;
}
@end
CA_EXTERN void Delog_(const char *className, NSUInteger line, NSString* format, ... ){
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = nil;
        message = [[NSString alloc] initWithFormat:format arguments:args];
        message = [NSString stringWithFormat:@"<%s : %ld>%@\n",className,(long)line,message];
        
        const char *resultCString = NULL;
        if ([message canBeConvertedToEncoding:NSUTF8StringEncoding]) {
            resultCString = [message cStringUsingEncoding:NSUTF8StringEncoding];
        }
        //控制台打印
        printf("%s", resultCString);
        //UI上去展示日志内容
        [[JKConsole console].debugVC printMSGFromJKConsole:resultCString];
    }
}
