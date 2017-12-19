//
//  JKGuidePageViewController.m
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2017/12/17.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import "JKGuidePageViewController.h"
#import "UIImageView+AFNetworking.h"
#import "JKGuidePageWindow.h"
#import "JK_WKScriptMessageHandler.h"
@interface JKCollectionViewCell : UICollectionViewCell
/**image*/
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JKCollectionViewCell
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
@end

@interface JKGuidePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WKUIDelegate,WKNavigationDelegate>
/**计时时间*/
@property (nonatomic, assign) NSUInteger timeMax;
/**计时时间*/
@property (nonatomic, assign) NSUInteger timeDelay;

/**是否纵向滚动*/
@property (nonatomic,assign) BOOL scrollDirectionVertical;//default is NO
/**展示图片数组*/
@property (nonatomic, strong) NSMutableArray *imageArr;
/**展示图片数组*/
@property (nonatomic, assign) BOOL isURL;
/**展示图片数组*/
@property (nonatomic, assign) BOOL isGif;

/**collection*/
@property (nonatomic, strong) UICollectionView *collectionView;
/**web*/
@property (nonatomic, strong) WKWebView *webView;
/**avUrl*/
@property (nonatomic, strong) NSURL *avUrl;
///**<#Description#>*/
//@property (nonatomic, strong) WKWebViewConfiguration *configuration;
/**Btn*/
@property (nonatomic, strong) UIButton *disBtn;
/**btn默认按钮*/
@property (nonatomic, strong) NSString *btnTitle;
/**秒数后面的文字*/
@property (nonatomic, strong) NSString *timerTitle;
/**URL*/
@property (nonatomic, strong) NSURL *webUrl;
/**custom*/
@property (nonatomic, strong) UIView *customView;
/**backGroundImage*/
@property (nonatomic, strong) UIImageView *backGroundImageView;
@property (nonatomic, strong) CABasicAnimation *animate;
/**Timer*/
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,copy) ClickImageActionBlock clickImageActionBlock;
@property (nonatomic,copy) BtnActionBlock btnActionBlock;
@property (nonatomic,copy) UploadDismissBtnBlock setDisBtnBlock;
/**app启动状态*/
@property (nonatomic,assign) APPLaunchStateOptions options;
@end

@implementation JKGuidePageViewController

-(instancetype)initWithClickImageActionBlock:(ClickImageActionBlock)clickImageActionBlock btnActionBlock:(BtnActionBlock)btnActionBlock options:(APPLaunchStateOptions)options{
    self = [super init];
    if (self) {
        self.clickImageActionBlock = clickImageActionBlock;
        self.btnActionBlock = btnActionBlock;
        self.options = options;
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    
}
- (void)reloadData{
    [self.view addSubview:self.customView];
    if (_collectionView) {
        [self.customView addSubview:self.collectionView];
        [self.collectionView reloadData];
    }
    if (_webView&&self.webUrl) {
        [self.customView addSubview:self.webView];
    }
     [self.customView addSubview:self.backGroundImageView];

    if (!_disBtn) {
        self.setDismissBtnBlock(^(UIButton *btn) {
            [btn setTitle:@"hehhe" forState:(UIControlStateNormal)];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
            btn.frame = CGRectMake(self.view.bounds.size.width-100, 64, 100, 30);
            btn.layer.cornerRadius = 15;
            btn.hidden = YES;
        });
    }
    [self.customView addSubview:self.disBtn];
    
    if (!self.animate) {
        self.setCustomViewAnimateWhenHiddenBlock(^CABasicAnimation *{
            CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
            
            animation.fromValue=@1;
            
            animation.toValue=@1.5;
            
            animation.duration=0.5;
            
            animation.autoreverses=YES;
            
            animation.repeatCount=1;
            
            animation.removedOnCompletion=NO;
            
            animation.fillMode=kCAFillModeForwards;
            
            return animation;
        });
    }
   
    if ((self.options & JKGetAppLaunchState()) && (self.imageArr.count>0 || self.webUrl.absoluteString.length>0)) {
        [JKGuidePageWindow show];
    }
}

- (void)addTimer{
    if ((!_timer)&&(self.timeMax>0)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doSomething:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        });
    }else if(self.timeMax<=0&&self.timeDelay<=0){
        self.disBtn.hidden = NO;
    }
}

- (NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr=[NSMutableArray arrayWithCapacity:0];
    }
    return _imageArr;
}

- (UIView *)customView{
    if (!_customView) {
        _customView = [[UIView alloc]initWithFrame:self.view.bounds];
        _customView.backgroundColor = [UIColor grayColor];
    }
    return _customView;
}
- (UIButton *)disBtn{
    if (!_disBtn) {
        _disBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_disBtn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _disBtn;
}

- (WKWebView *)webView{
    if (!_webView) {
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        JK_WKScriptMessageHandler* handler = [[JK_WKScriptMessageHandler alloc]initWith:self];
        [configuration.userContentController addScriptMessageHandler:handler name:@"dismiss"];
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
        _webView.UIDelegate=self;
        _webView.navigationDelegate=self;
        [_webView setMultipleTouchEnabled:YES];
        [_webView setAutoresizesSubviews:YES];
        _webView.scrollView.bounces = NO;
        [_webView.scrollView setAlwaysBounceVertical:YES];
    }
    return _webView;
}
- (UIImageView *)backGroundImageView{
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _backGroundImageView.image = [UIImage imageNamed:JKGetLaunchImageName()];
        _backGroundImageView.hidden = YES;
    }
    return _backGroundImageView;
}

- (TimerBlock)setTimer{
    return ^(NSUInteger timeMax,NSUInteger timeDelay,NSString* timerTitle){
        self.timeMax = timeMax;
        self.timeDelay = timeDelay;
        self.timerTitle = timerTitle;
        return self;
    };
}

- (SetDismissBtnBlock)setDismissBtnBlock{
    return ^(UploadDismissBtnBlock block){
        block(self.disBtn);
        return self;
    };
}

- (ScrollViewStyleBlock)setScrollViewStyle{
    return ^(UICollectionViewFlowLayout* layout,CGRect frame,CGSize itemSize,BOOL scrollDirectionVertical){
        if (!layout) {
            layout = [[UICollectionViewFlowLayout alloc]init];
            self.scrollDirectionVertical = scrollDirectionVertical;
            layout.scrollDirection = scrollDirectionVertical?UICollectionViewScrollDirectionVertical:UICollectionViewScrollDirectionHorizontal;
            if (itemSize.height != 0.0&&itemSize.width != 0.0) {
                layout.itemSize = itemSize;
            }else if(frame.size.height != 0.0&&frame.size.width != 0.0){
                layout.itemSize = frame.size;
            }else{
                layout.itemSize = self.customView.bounds.size;
            }
            layout.minimumInteritemSpacing = 0.0;
            layout.minimumLineSpacing = 0.0;
        }
        if (frame.size.height != 0.0&&frame.size.width != 0.0) {
            _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
        }else{
            _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        }
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_collectionView  registerClass:[JKCollectionViewCell class] forCellWithReuseIdentifier:@"JKCollectionViewCell"];
//        self.setDismissBtn(@"立即前往", [UIColor whiteColor], [UIColor redColor], nil,  CGRectMake(self.view.bounds.size.width-100, 64, 100, 30), 15);
        return self;
    };
}
-(ImageArrBlock)setImageArr{
    return ^(NSArray *imageArr,BOOL isURL,BOOL isGif){
        if (imageArr.count>0) {
            self.imageArr = [imageArr mutableCopy];
        }else{
            self.imageArr = [imageArr mutableCopy];
        }
        self.isURL = isURL;
        self.isGif = isGif;
        if (!_collectionView) {
            self.setScrollViewStyle(nil, self.view.bounds, self.view.bounds.size, NO);
        }
        return self;
    };
}
- (WKWebViewBlock)setWKWebView{
    return ^(CGRect frame, NSURL *url){
        if (url) {
            self.webUrl = url;
            [self.webView setFrame:frame];
            self.backGroundImageView.hidden = NO;
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
        }
        return self;
    };
}
- (AVPlayerBlock)setAVPlayer{
    return ^(CGRect frame, NSURL *url){
        
        self.avUrl = url;
        return self;
    };
}
-(CustomViewBlock)setCustomView{
    return ^(CreateViewBlock block){
        if (_customView) {
            [_customView removeFromSuperview];
            _customView = nil;
        }
        _customView = block();
        return self;
    };
}
- (CustomViewAnimateWhenHiddenBlock)setCustomViewAnimateWhenHiddenBlock{
    return ^(CreateAnimateBlock block){
        self.animate = block();
        return self;
    };
}

#pragma mark -- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JKCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JKCollectionViewCell" forIndexPath:indexPath];
    
    if(self.isURL&&self.imageArr.count>indexPath.item&&self.imageArr[indexPath.item]){
        DDLog(@"网络图片")
        if (self.isGif) {
            [cell.imageView setImage:[UIImage imageNamed:JKGetLaunchImageName()]];
            [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:self.imageArr[indexPath.item]] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                [cell.imageView setImage:[UIImage sd_animatedGIFWithData:data]];
            }];
        }else{
           [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArr[indexPath.item]] placeholderImage:[UIImage imageNamed:JKGetLaunchImageName()]];
        }
    }else if (self.isGif&&self.imageArr.count>indexPath.item&&self.imageArr[indexPath.item]){
        
        UIImage * image= nil;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:self.imageArr[indexPath.item] ofType:@"gif"];
        
        NSData* data = [NSData dataWithContentsOfFile:path];
        if (data) {
            image = [UIImage sd_animatedGIFWithData:data];
        }
        DDLog(@"本地gif")
        [cell.imageView setImage:image?image:[UIImage imageNamed:JKGetLaunchImageName()]];

        
    }else if(self.imageArr.count>indexPath.item&&self.imageArr[indexPath.item]){
        DDLog(@"本地图片")
        UIImage* image = [UIImage imageNamed:self.imageArr[indexPath.item]];
        [cell.imageView setImage:image?image:[UIImage imageNamed:JKGetLaunchImageName()]];
    }else{
        [cell.imageView setImage:[UIImage imageNamed:JKGetLaunchImageName()]];
    }
    
    if (self.imageArr.count==1) {
        [self scrollViewDidScroll:collectionView];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.clickImageActionBlock) {
        self.clickImageActionBlock(indexPath.item, self.imageArr[indexPath.item],nil);
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((!self.scrollDirectionVertical)&&scrollView.contentOffset.x == scrollView.contentSize.width-scrollView.frame.size.width) {
        [self addTimer];
    }else if (self.scrollDirectionVertical&&scrollView.contentOffset.y == scrollView.contentSize.height-scrollView.frame.size.height) {
        [self addTimer];
    }
}
#pragma mark -1. WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    DDLog(@"%@",webView.URL)
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
 
    DDLog(@"加载成功");
    self.backGroundImageView.hidden = YES;
    [self addTimer];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    DDLog(@"加载失败");
    self.backGroundImageView.hidden = NO;
    [self addTimer];
 
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    UIApplication *app = [UIApplication sharedApplication];
    // 打电话
    if ([scheme isEqualToString:@"tel"]) {
        if ([app canOpenURL:URL]) {
            [app openURL:URL];
            // 一定要加上这句,否则会打开新页面
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    // 打开appstore
    if ([URL.absoluteString containsString:@"itunes.apple.com"]) {
        if ([app canOpenURL:URL]) {
            [app openURL:URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    //如果是跳转一个新页面，就当前页面加载
    if (navigationAction.targetFrame==nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}



#pragma mark - 2. WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
    
}
/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 警告框消失调用
 */

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction: [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 *  web界面中有弹出确认框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           确认框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 确认框消失调用
 */
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction: [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [alert addAction: [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


/**
 *  web界面中有弹出输入框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param prompt           输入框中的内容
 *  @param defaultText      输入框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 输入框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"请输入" message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = defaultText;
        //        textField.text = defaultText;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alert.textFields.firstObject).text;
        completionHandler(input);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark -- TimerDelegate
- (void)doSomething:(NSTimer*)timer{
    if (self.timeMax==0) {
        [self btnAction:_disBtn];
    }
    if (_disBtn) {
        [self.disBtn setTitle:[NSString stringWithFormat:@"%ld%@",self.timeMax,self.timerTitle] forState:(UIControlStateNormal)];
        self.disBtn.hidden = NO;
    }
    self.timeMax--;
}

- (void)btnAction:(UIButton* )btn{
    [self dismiss];
}

- (void)invalidate {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)dismiss{
    [self invalidate];
    if (_disBtn) {
        _disBtn.hidden=YES;
    }
    if (self.btnActionBlock) {
        self.btnActionBlock(nil);
    }
    [self.customView.layer addAnimation:self.animate forKey:@"animate"];
    [JKGuidePageWindow dismiss];
}

- (void)dealloc{
    if (_webView) {
        [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"dismiss"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
