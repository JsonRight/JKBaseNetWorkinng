//
//  BaseNetWorking+BaseUrl.m
//  HaoLyyPro
//
//  Created by jk on 2017/9/26.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "BaseNetWorking+BaseUrl.h"
static NSString* name = @"正式环境";
@implementation BaseNetWorking (BaseUrl)
-(NSString *)baseUrl{

    if (!_baseUrl) {
        name=@"测试环境";
    }
#if DEBUG
#if !kProductionEnvironment
    _baseUrl = [self urls][name];
#else
    _baseUrl=@"http://www.baidu.com";
#endif
#else
    _baseUrl=@"http://www.baidu.com";
#endif
    
    return _baseUrl;
}
- (NSDictionary* )urls{
    
    return @{@"a":@"http://www.baidu.com",
             @"b":@"http://www.baidu.com",
             @"c":@"http://www.baidu.com",
             @"d":@"http://www.baidu.com",
             @"e":@"http://www.baidu.com",
             @"f":@"http://www.baidu.com",
             @"测试环境":@"http://www.baidu.com",
             @"正式环境":@"http://www.baidu.com"
             };
}
-(UIButton*)createApiSelectBtn{
   
    UIButton* btn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"接口切换" forState:(UIControlStateNormal)];
    btn.titleLabel.textColor = [UIColor lightGrayColor];
   
    btn.titleLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    btn.frame = CGRectMake(0, 0, 100, 30);

    [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return btn;
    
}
-(void)btnAction:(UIButton* )btn{
    UIAlertController* alert =[UIAlertController alertControllerWithTitle:@"当前接口地址" message:name preferredStyle:(UIAlertControllerStyleActionSheet)];
    for (NSString* str in [self urls].allKeys) {
        [alert addAction:[UIAlertAction actionWithTitle:str style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            name = action.title;
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    
}


@end
