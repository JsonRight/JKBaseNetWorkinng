//
//  ViewController.m
//  JKNetWorkingDemo
//
//  Created by jk on 2017/9/27.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "ViewController.h"
//#import "BaseNetWorking.h"
#import "NetWorkHelper.h"
#define DLog(...) printf("JKNetlog<%s : %d>%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#import <ReactiveCocoa.h>
@interface ViewController ()
/**<#Description#>*/
@property (nonatomic, strong) UIWindow *window;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

////
////方式1
//    BaseSessionMessage * sessionMsg = [BaseSessionMessage createSessionMessage:^(BaseSessionMessage *make) {
//        make.requestDlog(YES)
//        .requestTimeOut(60)
//        .requestBaseUrl(@"http://www.baidu.com1")
//        .requestCount(1);
//    }];
//    [sessionMsg requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];
//
////方式2
//    BaseSessionMessage * sessionMsg1 = SessionMessage(^(BaseSessionMessage *make) {
//        make.requestDlog(YES)
//        .requestTimeOut(60)
//        .requestBaseUrl(@"http://www.baidu.com2")
//        .requestCount(1);
//    });
//    [sessionMsg1 requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];
//
////方式3
//    BaseSessionMessage * sessionMsg2 = SessionMessage(^(BaseSessionMessage *make) {
//        make.requestDlog(YES);
//        make.requestTimeOut(60);
//        make.requestBaseUrl(@"http://www.baidu.com3");
//        make.requestCount(2);
//    });
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [sessionMsg2 requestHTTPWithURLString:@"" paramsDic:@{} progress:nil success:nil failure:nil];
//    });
//    SessionMessageGroup(@[sessionMsg,sessionMsg1,sessionMsg2], ^{
//        DLog(@"%@",sessionMsg->baseUrl);
//        DLog(@"%@",sessionMsg1->baseUrl);
//        DLog(@"%@",sessionMsg2->baseUrl);
//
//    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        NetWorkMake(^(SessionManager *make) {
            make.requestURL(@"words/word").paramsDic(@{@"str":@"和"}).HTTPMethodType(GetType);
            make.successBlock(^(SessionManager *sessionMsg) {

            });
            make.failureBlock(^(SessionManager *sessionMsg) {
                DLog(@"%@",sessionMsg->requestUrl);
            });
        });

        NetWorkMake(^(SessionManager *make) {
            make.requestURL(@"words/word").paramsDic(@{@"str":@"和"}).HTTPMethodType(GetType)
            .successBlock(^(SessionManager *sessionMsg) {

            })
            .failureBlock(^(SessionManager *sessionMsg) {
                DLog(@"%@",sessionMsg->requestUrl);
            });
        });

        NetWorkMake(^(SessionManager *make) {
            make.requestURL(@"words/word").paramsDic(@{@"str":@"和"}).HTTPMethodType(GetType)
            .successBlock(^(SessionManager *sessionMsg) {

            });
        });

    });
    NSURL *baseURL = [NSURL URLWithString:@"http://example.com/v1/"];
    NSURL* url1 = [NSURL URLWithString:@"foo" relativeToURL:baseURL];                  // http://example.com/v1/foo
    NSURL* url2 = [NSURL URLWithString:@"foo?bar=baz" relativeToURL:baseURL];          // http://example.com/v1/foo?bar=baz
    NSURL* url3 = [NSURL URLWithString:@"/foo" relativeToURL:baseURL];                 // http://example.com/foo
    NSURL* url4 = [NSURL URLWithString:@"foo/" relativeToURL:baseURL];                 // http://example.com/v1/foo/
    NSURL* url5 = [NSURL URLWithString:@"/foo/" relativeToURL:baseURL];                // http://example.com/foo/
    NSURL* url6 = [NSURL URLWithString:@"http://example2.com" relativeToURL:baseURL]; // http://example2.com
 
    NSURL *baseURL1 = [NSURL URLWithString:@"http://example.com/v1"];
    NSURL* url11 = [NSURL URLWithString:@"foo" relativeToURL:baseURL1];                  // http://example.com/foo
    NSURL* url21 = [NSURL URLWithString:@"/foo?bar=baz" relativeToURL:baseURL1];          // http://example.com/foo?bar=baz
    NSURL* url31 = [NSURL URLWithString:@"/foo" relativeToURL:baseURL1];                 // http://example.com/foo
    NSURL* url41 = [NSURL URLWithString:@"foo/" relativeToURL:baseURL1];                 // http://example.com/foo/
    NSURL* url51 = [NSURL URLWithString:@"/foo/" relativeToURL:baseURL1];                // http://example.com/foo/
    NSURL* url61 = [NSURL URLWithString:@"http://example2.com/" relativeToURL:baseURL1]; // http://example2.com/
   
    NSURL *baseURL12 = [NSURL URLWithString:@"http://example.com/"];
    NSURL* url111 = [NSURL URLWithString:@"foo" relativeToURL:baseURL12];                  // http://example.com/foo
    NSURL* url211 = [NSURL URLWithString:@"foo?bar=baz" relativeToURL:baseURL12];          // http://example.com/foo?bar=baz
    NSURL* url311 = [NSURL URLWithString:@"/foo" relativeToURL:baseURL12];                 // http://example.com/foo
    NSURL* url411 = [NSURL URLWithString:@"foo/" relativeToURL:baseURL12];                 // http://example.com/foo/
    NSURL* url511 = [NSURL URLWithString:@"/foo/" relativeToURL:baseURL12];                // http://example.com/foo/
    NSURL* url611 = [NSURL URLWithString:@"http://example2.com/" relativeToURL:baseURL12]; // http://example2.com/
//    NSURL* url711 = [NSURL URLWithString:nil relativeToURL:baseURL12];                   //（null）
    NSURL* url711 = [NSURL URLWithString:@"" relativeToURL:baseURL12];                      //这样才能得到正确的url http://example.com/
    
    NSURL *baseURL121 = [NSURL URLWithString:@""];
    NSURL* url6111 = [NSURL URLWithString:@"http://example2.com/" relativeToURL:baseURL121]; // http://example2.com/
    
    DLog(@"%@",url1.absoluteString)
    DLog(@"%@",url2.absoluteString)
    DLog(@"%@",url3.absoluteString)
    DLog(@"%@",url4.absoluteString)
    DLog(@"%@",url5.absoluteString)
    DLog(@"%@",url6.absoluteString)
    DLog(@"--------------")
    DLog(@"%@",url11.absoluteString)
    DLog(@"%@",url21.absoluteString)
    DLog(@"%@",url31.absoluteString)
    DLog(@"%@",url41.absoluteString)
    DLog(@"%@",url51.absoluteString)
    DLog(@"%@",url61.absoluteString)
     DLog(@"--------------")
    DLog(@"%@",url111.absoluteString)
    DLog(@"%@",url211.absoluteString)
    DLog(@"%@",url311.absoluteString)
    DLog(@"%@",url411.absoluteString)
    DLog(@"%@",url511.absoluteString)
    DLog(@"%@",url611.absoluteString)
    DLog(@"%@",url711.absoluteString)
    DLog(@"--------------")
     DLog(@"%@",url6111.absoluteString)
}
-(void)hehe{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
