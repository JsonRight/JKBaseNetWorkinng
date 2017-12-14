//
//  ViewController.m
//  JKNetWorkingDemo
//
//  Created by jk on 2017/9/27.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "ViewController.h"
#import "BaseNetWorking.h"
#import "JKConsole.h"
#import "hehViewController.h"
@interface ViewController ()
/**<#Description#>*/
@property (nonatomic, strong) UIWindow *window;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[JKDebugWindow sharedDebugWindow] show];
    self.view.backgroundColor = [UIColor grayColor];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[JKConsole console] show];
    [[JKConsole console] show];
   
//    });
   
    //网络请求
    [BaseSessionMessage createRequestHTTPWithURLString:@"" paramsDic:@{} progress:^(NSProgress *progress) {
        //进度
    } success:^(BaseSessionMessage *sessionMsg) {
        DDLog(@"%@",sessionMsg.responseString);
    } failure:^(BaseSessionMessage *sessionMsg) {
        DDLog(@"!%@!  %@",nil,@"2");
    }].requestDlog(YES)//是否打印
      .sendSessionMessage();//发送请求：必写，否则不会发送网络请求
//
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DDLog(@"!%@!  %@",nil,@"2");
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DDLog(@"!%@!  %@",nil,@"dissmiss");
        [[JKConsole console] dissmiss];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DDLog(@"!%@!  %@",nil,@"show");
        [[JKConsole console] show];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
