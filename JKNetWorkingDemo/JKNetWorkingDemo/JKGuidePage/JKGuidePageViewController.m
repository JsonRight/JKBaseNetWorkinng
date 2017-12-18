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

@interface JKGuidePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WKScriptMessageHandler>
/**计时时间*/
@property (nonatomic, assign) NSUInteger timeMax;
/**<#Description#>*/
@property (nonatomic,assign) BOOL hasTimer;
/**<#Description#>*/
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
/**Btn*/
@property (nonatomic, strong) UIButton *disBtn;
/**<#Description#>*/
@property (nonatomic, strong) NSString *btnTitle;
/**<#Description#>*/
@property (nonatomic, strong) NSString *timerTitle;
/**URL*/
@property (nonatomic, strong) NSString *webUrl;
/**custom*/
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) CABasicAnimation *animate;
/**Timer*/
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,copy) ClickImageActionBlock clickImageActionBlock;
@property (nonatomic,copy) BtnActionBlock btnActionBlock;
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
    [self.collectionView reloadData];
    if ((self.options & JKGetAppLaunchState()) && (self.imageArr.count>0 || self.webUrl.length>0)) {
        [JKGuidePageWindow show];
    }
}
- (void)addTimer{
    if ((!_timer)&&(self.timeMax>0)) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doSomething:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }else if((!_timer)&&(self.timeMax<=0)){
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
        [self.view addSubview:_customView];
    }
    return _customView;
}
- (UIButton *)disBtn{
    if (!_disBtn) {
        _disBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _disBtn.hidden = YES;
        [_disBtn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _disBtn;
}
- (WKWebView *)webView{
    if (!_webView) {
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        [configuration.userContentController addScriptMessageHandler:self name:@"dismiss"];
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
    }
    return _webView;
}

- (TimerBlock)setTimer{
    return ^(NSUInteger timeMax,NSString* timerTitle){
        self.timeMax = timeMax;
        self.timerTitle = timerTitle;
        return self;
    };
}
- (DismissBtnBlock)setDismissBtn{
    return ^(NSString *btnTitle,UIColor *backColor,UIColor *textColor,UIImage *backImage,CGRect frame,CGFloat cornerRadius){
        btnTitle?([self.disBtn setTitle:btnTitle forState:(UIControlStateNormal)]):1;
        if (backColor) self.disBtn.backgroundColor = backColor;
        if (textColor) [self.disBtn setTitleColor:textColor forState:(UIControlStateNormal)];
        if (backImage) [self.disBtn setBackgroundImage:backImage forState:(UIControlStateNormal)];
        self.btnTitle = btnTitle;
        
        if (frame.size.height != 0.0&&frame.size.width != 0.0) {
            self.disBtn.frame = frame;
            self.disBtn.layer.cornerRadius = cornerRadius;
        }
        [self.customView addSubview:self.disBtn];
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
        [self.customView addSubview:_collectionView];
        self.setDismissBtn(@"立即前往", [UIColor whiteColor], [UIColor redColor], nil,  CGRectMake(self.view.bounds.size.width-100, 88, 80, 30), 15);
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
-(CustomViewBlock)setCustomView{
    return ^(CreateViewBlock block){
        if (_customView) {
            [_customView removeFromSuperview];
            _customView = nil;
        }
        _customView = block();
        [self.view addSubview:_customView];
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
#pragma mark -- WKScriptMessageHandler
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    
}

#pragma mark -- TimerDelegate
- (void)doSomething:(NSTimer*)timer{
    if (self.timeMax==0) {
        [self btnAction:self.disBtn];
    }
    [self.disBtn setTitle:[NSString stringWithFormat:@"%ld%@",self.timeMax,self.timerTitle] forState:(UIControlStateNormal)];
    self.disBtn.hidden = NO;
    self.timeMax--; 
}

- (void)btnAction:(UIButton* )btn{
     [self invalidate];
    btn.hidden=YES;
    if (self.btnActionBlock) {
        self.btnActionBlock(nil);
    }
    [self.customView.layer addAnimation:self.animate forKey:@"animate"];
    [JKGuidePageWindow dismiss];
}

- (void)invalidate {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (NSString *)getLaunchImageName
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    // 竖屏
    NSString *viewOrientation = @"Portrait";
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return launchImageName;
}
- (void)dealloc{
    
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
