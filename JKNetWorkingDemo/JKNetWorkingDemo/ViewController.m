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
    //normel
    [SessionMessage(nil) requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];
    
//方式1
    [[BaseSessionMessage createSessionMessage:^(BaseSessionMessage *make) {
        make.requestDlog(YES).requestTimeOut(60).requestBaseUrl(@"").requestCount(1);
    }] requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];
    
//方式2
    [SessionMessage(^(BaseSessionMessage *make) {
        make.requestDlog(YES)
            .requestTimeOut(60)
            .requestBaseUrl(@"")
            .requestCount(1);
    }) requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];
    
//方式3
    [SessionMessage(^(BaseSessionMessage *make) {
        make.requestDlog(YES);
        make.requestTimeOut(60);
        make.requestBaseUrl(@"");
        make.requestCount(1);
    }) requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];
}
-(void)hehe{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
