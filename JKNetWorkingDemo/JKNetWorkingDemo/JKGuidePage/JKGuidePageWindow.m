//
//  JKGuidePageWindow.m
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/15.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import "JKGuidePageWindow.h"

@interface JKCollectionViewCell : UICollectionViewCell
/**image*/
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JKCollectionViewCell
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _imageView;
}
@end

@interface JKGuidePageWindow ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WKScriptMessageHandler>
/**计时时间*/
@property (nonatomic, assign) NSUInteger timeMax;
/**<#Description#>*/
@property (nonatomic,assign) NSUInteger timeDelay;
/**<#Description#>*/
@property (nonatomic,assign) BOOL scrollDirectionVertical;
/**展示图片数组*/
@property (nonatomic, strong) NSMutableArray *imageArr;
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
/**Timer*/
@property (nonatomic, strong) NSTimer *timer;


@end
@implementation JKGuidePageWindow

-(NSTimer *)timer{
    if (!_timer) {
        _timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeDelay] interval:1 target:self selector:@selector(doSomething:) userInfo:nil repeats:NO];
        
        _timer=[NSTimer scheduledTimerWithTimeInterval:1  target:self selector:@selector(doSomething:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
- (NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr=[NSMutableArray arrayWithCapacity:0];
    }
    return _imageArr;
}


- (UIView *)customView{
    if (!_customView) {
        _customView = [[UIView alloc]initWithFrame:self.bounds];
        _customView.backgroundColor = [UIColor whiteColor];
    }
    return _customView;
    
}
- (UIButton *)disBtn{
    if (!_disBtn) {
        _disBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_disBtn setTitle:@"" forState:(UIControlStateNormal)];
        [_disBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        _disBtn.backgroundColor = [UIColor grayColor];
        _disBtn.frame = CGRectMake(self.bounds.size.width-100, 88, 80, 30);
        _disBtn.layer.masksToBounds = YES;
        _disBtn.layer.cornerRadius = 15;
    }
    return _disBtn;
}
- (WKWebView *)webView{
    if (!_webView) {
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        [configuration.userContentController addScriptMessageHandler:self name:@"dismiss"];
        _webView = [[WKWebView alloc]initWithFrame:self.bounds configuration:configuration];
    }
    return _webView;
}
-(TimerMax)subTimerMax{
    return ^(NSUInteger timeMax){
        self.timeMax = timeMax;
        
        
        return self;
    };
}
- (TimerDelay)subTimerDelay{
    
    return ^(NSUInteger timeDelay){
        self.timeDelay = timeDelay;
        self.disBtn.hidden = YES;
        return self;
    };
}
-(ImageArr)subImageArr{
    return ^(NSArray *imageArr,CGSize itemSize,BOOL scrollDirectionVertical){
        self.imageArr = [NSMutableArray arrayWithObject:imageArr];
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        self.scrollDirectionVertical = scrollDirectionVertical;
        layout.scrollDirection = scrollDirectionVertical?UICollectionViewScrollDirectionVertical:UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = itemSize;
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView  registerClass:[JKCollectionViewCell class] forCellWithReuseIdentifier:@"JKCollectionViewCell"];
        [self.customView addSubview:_collectionView];
        return self;
    };
}
-(CustomView)subCustomView{
    return ^(UIView *customView){
        self.customView = customView;
        return self;
    };
}

#pragma mark -- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JKCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JKCollectionViewCell" forIndexPath:indexPath];
    [cell.imageView setImage:nil];
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollDirectionVertical&&scrollView.contentOffset.x == scrollView.contentSize.width-scrollView.frame.size.width) {
        [self.timer fire];
    }else if ((!self.scrollDirectionVertical)&&scrollView.contentOffset.y == scrollView.contentSize.height-scrollView.frame.size.height) {
        [self.timer fire];
    }
}
#pragma mark -- WKScriptMessageHandler
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    
}

#pragma mark -- TimerDelegate
- (void)doSomething:(NSTimer*)timer{
    self.disBtn.hidden = NO;
    
}
static JKGuidePageWindow* guidePageWindow=nil;
+ (JKGuidePageWindow*)sheareGuidePageWindow{
   
    if (!guidePageWindow) {
        guidePageWindow = [[JKGuidePageWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return guidePageWindow;
}
+ (void)dismiss{
    [guidePageWindow resignKeyWindow];
    
    guidePageWindow=nil;
}

@end
