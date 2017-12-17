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
@property (nonatomic,assign) NSUInteger timeDelay;
/**<#Description#>*/
@property (nonatomic,assign) BOOL scrollDirectionVertical;//default is NO
/**展示图片数组*/
@property (nonatomic, strong) NSMutableArray *imageArr;
/**展示图片数组*/
@property (nonatomic, assign) BOOL isURL;
/**collection*/
@property (nonatomic, strong) UICollectionView *collectionView;
/**web*/
@property (nonatomic, strong) WKWebView *webView;
/**Btn*/
@property (nonatomic, strong) UIButton *disBtn;
/**URL*/
@property (nonatomic, strong) NSString *webUrl;
/**custom*/
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) CABasicAnimation *animate;
/**Timer*/
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,copy) ClickImageActionBlock clickImageActionBlock;
@property (nonatomic,copy) BtnActionBlock btnActionBlock;
@end

@implementation JKGuidePageViewController

-(instancetype)initWithClickImageActionBlock:(ClickImageActionBlock)clickImageActionBlock btnActionBlock:(BtnActionBlock)btnActionBlock{
    self = [super init];
    if (self) {
        self.clickImageActionBlock = clickImageActionBlock;
        self.btnActionBlock = btnActionBlock;
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    
}
- (void)reloadData{
    [self.collectionView reloadData];
}
- (void)addTimer{
    if ((!_timer)&&(self.timeMax>0)) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doSomething:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }else{
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
        [_disBtn setTitle:@"立即前往" forState:(UIControlStateNormal)];
//        [_disBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        _disBtn.titleLabel.textColor = [UIColor redColor];
        _disBtn.backgroundColor = [UIColor blueColor];
        _disBtn.frame = CGRectMake(self.view.bounds.size.width-100, 88, 80, 30);
        _disBtn.layer.masksToBounds = YES;
        _disBtn.layer.cornerRadius = 15;
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
    return ^(NSUInteger timeMax){
        self.timeMax = timeMax;
        return self;
    };
}
- (DismissBtnBlock)setDismissBtn{
    return ^(NSString *btnTitle,UIColor *backColor,UIColor *textColor,UIImage *backImage,CGRect frame,CGFloat cornerRadius){
        btnTitle?([self.disBtn setTitle:btnTitle forState:(UIControlStateNormal)]):1;
        if (backColor) self.disBtn.backgroundColor = backColor;
        if (textColor) [self.disBtn setTitleColor:textColor forState:(UIControlStateNormal)];
        if (backImage) [self.disBtn setBackgroundImage:backImage forState:(UIControlStateNormal)];
//        if (normelImage) [self.disBtn setImage:normelImage forState:(UIControlStateNormal)];
//        if (selectedImage) [self.disBtn setImage:selectedImage forState:(UIControlStateSelected)];
//        if (highlightedImage) [self.disBtn setImage:highlightedImage forState:(UIControlStateHighlighted)];
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
        self.setDismissBtn(@"立即使用", [UIColor whiteColor], [UIColor redColor], nil,  CGRectMake(self.view.bounds.size.width-100, 88, 80, 30), 15);
        return self;
    };
}
-(ImageArrBlock)setImageArr{
    return ^(NSArray *imageArr,BOOL isURL){
        if (imageArr.count>0) {
            self.imageArr = [imageArr mutableCopy];
        }else{
            self.imageArr = [imageArr mutableCopy];
        }
        self.isURL = isURL;
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
    if (self.isURL&&self.imageArr.count>indexPath.item&&self.imageArr[indexPath.item]) {
        [cell.imageView setImageWithURL:[NSURL URLWithString:self.imageArr[indexPath.item]] placeholderImage:nil];
    }else if(self.imageArr.count>indexPath.item&&self.imageArr[indexPath.item]){
        [cell.imageView setImage:[UIImage imageNamed:self.imageArr[indexPath.item]]];
    }
    if (self.imageArr.count==1) {
        [self scrollViewDidScroll:collectionView];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.clickImageActionBlock) {
        self.clickImageActionBlock(indexPath.item, self.imageArr[indexPath.item]);
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
    [self.disBtn setTitle:[NSString stringWithFormat:@"%lds跳过",self.timeMax] forState:(UIControlStateNormal)];
    self.disBtn.hidden = NO;
    self.timeMax--; 
}

- (void)btnAction:(UIButton* )btn{
     [self invalidate];
    if (self.btnActionBlock) {
        self.btnActionBlock();
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
