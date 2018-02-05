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
/**<#Description#>*/
@property (nonatomic, strong) UIWindow *window;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_group_t group = dispatch_group_create();
//    //normel
//    [SessionMessage(nil) requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];
//
//方式1
    [[BaseSessionMessage createSessionMessage:^(BaseSessionMessage *make) {
        make.requestDlog(YES).requestTimeOut(60).requestBaseUrl(@"http://www.baidu.com1").requestCount(1).requestGroup(group);
    }] requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];

//方式2
    [SessionMessage(^(BaseSessionMessage *make) {
        make.requestDlog(YES)
            .requestTimeOut(60)
            .requestBaseUrl(@"http://www.baidu.com2")
            .requestCount(1)
            .requestGroup(group);
    }) requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];
    
//方式3
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SessionMessage(^(BaseSessionMessage *make) {
            make.requestDlog(YES);
            make.requestTimeOut(60);
            make.requestBaseUrl(@"http://www.baidu.com3");
            make.requestCount(2);
            make.requestGroup(group);
        }) requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        DLog(@"heheh");
    });
}
-(void)hehe{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
