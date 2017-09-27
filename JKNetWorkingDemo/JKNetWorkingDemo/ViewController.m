//
//  ViewController.m
//  JKNetWorkingDemo
//
//  Created by jk on 2017/9/27.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "ViewController.h"
#import "BaseNetWorking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //网络请求
    [BaseSessionMessage createRequestHTTPWithURLString:@"" paramsDic:@{} progress:^(NSProgress *progress) {
        //进度
    } success:^(BaseSessionMessage *sessionMsg) {
        NSLog(@"%@",sessionMsg.responseString);
    } failure:^(BaseSessionMessage *sessionMsg) {
        NSLog(@"%@",sessionMsg.responseString);
    }].requestDlog(YES)//是否打印
      .sendSessionMessage();//发送请求：必写，否则不会发送网络请求
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
