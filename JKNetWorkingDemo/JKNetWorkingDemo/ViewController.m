//
//  ViewController.m
//  JKNetWorkingDemo
//
//  Created by jk on 2017/9/27.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "ViewController.h"
#import "BaseNetWorking.h"
#import <ReactiveCocoa.h>
@interface ViewController ()
/**<#Description#>*/
@property (nonatomic, strong) UIWindow *window;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//
//方式1
    BaseSessionMessage * sessionMsg = [BaseSessionMessage createSessionMessage:^(BaseSessionMessage *make) {
        make.requestDlog(YES)
        .requestTimeOut(60)
        .requestBaseUrl(@"http://www.baidu.com1")
        .requestCount(1);
    }];
    [sessionMsg requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];

//方式2
    BaseSessionMessage * sessionMsg1 = SessionMessage(^(BaseSessionMessage *make) {
        make.requestDlog(YES)
        .requestTimeOut(60)
        .requestBaseUrl(@"http://www.baidu.com2")
        .requestCount(1);
    });
    [sessionMsg1 requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];
    
//方式3
    BaseSessionMessage * sessionMsg2 = SessionMessage(^(BaseSessionMessage *make) {
        make.requestDlog(YES);
        make.requestTimeOut(60);
        make.requestBaseUrl(@"http://www.baidu.com3");
        make.requestCount(2);
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sessionMsg2 requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];
    });
    SessionMessageGroup(@[sessionMsg,sessionMsg1,sessionMsg2], ^{
        DLog(@"%@",sessionMsg->baseUrl);
        DLog(@"%@",sessionMsg1->baseUrl);
        DLog(@"%@",sessionMsg2->baseUrl);
    });
   
    
    
}
-(void)hehe{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
