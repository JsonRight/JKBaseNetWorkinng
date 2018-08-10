//
//  JKNetWorking.m
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/10.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import "JKNetWorking.h"
#import "JKNetWorking+HTTPMethod.h"

@implementation JKNetWorking
#pragma mark - 初始化
+ (JKNetWorking *)shareMannager{
    static JKNetWorking *netWorking=nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        netWorking = [[JKNetWorking alloc] init];
        [netWorking startMonitoring];
    });
    return netWorking;
}

-(NSString *)baseUrl{
    if (!_baseUrl) {
        _baseUrl = @"http://www.baidu.com";
    }
    return _baseUrl;
}

#pragma mark - 普通数据请求
#pragma mark -- 普通http请求抽象接口
- (NSURLSessionDataTask *)sendSessionMessage:(SessionManager *)sessionMsg {
    
    switch (sessionMsg->HTTPMethodType) {
        case GetType:
        {
            return [self getMethodWithSessionMessage:sessionMsg];
        }
            break;
        case UpLoadDataType:
        {
            return [self upLoadDataMethodWithSessionMessage:sessionMsg];
        }
            break;
        case PostType||DefaultHTTPMethodType:
        {
            return [self postMethodWithSessionMessage:sessionMsg];
        }
            break;
        case HEADType:
        {
            return [self HEADT_MethodWithSessionMessage:sessionMsg];
        }
            break;
        case PUTType:
        {
            return [self PUT_MethodWithSessionMessage:sessionMsg];
        }
            break;
        case PATCHType:
        {
            return [self PATCH_MethodWithSessionMessage:sessionMsg];
        }
            break;
        case DELETEType:
        {
            return [self DELETE_MethodWithSessionMessage:sessionMsg];
        }
            break;
            
        default:
        {
            return nil;
        }
            break;
    }
    
}

#pragma mark - 配置sessionManager
- (AFHTTPSessionManager *)configSessionManagerWithSessionMessage:(SessionManager *)sessionMsg {
    
    //初始化一个网络会话管理器
    AFHTTPSessionManager *sessionManager=[AFHTTPSessionManager manager];
    //设置客户端可接受服务器端响应数据格式
    sessionManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:
                                                              @"text/plain",
                                                              @"application/x-www-form-urlencoded",
                                                              @"application/json",
                                                              @"text/json",
                                                              @"text/javascript",
                                                              @"text/html",
                                                              @"text/xml",
                                                              nil];
    //设置http用户名验证
    [self updateRequestAuthorizationHeaderFieldWith:sessionManager sessionMessage:sessionMsg];
    //设置请求头
    [self updateRequestHTTPHeadersWith:sessionManager sessionMessage:sessionMsg];
    //设置服务器响应数据序列化格式
    [self updateResponseSerializerWith:sessionManager sessionMessage:sessionMsg];
    //设置请求体序列化格式
    [self updateRequestSerializerWith:sessionManager sessionMessage:sessionMsg];
    //设置请求超时时间
    [self updateTimeoutIntervalWith:sessionManager sessionMessage:sessionMsg];
    //配置https安全证书
    sessionManager.securityPolicy  = [self updateSecurityPolicyWith:sessionManager sessionMessage:sessionMsg];
    
    return sessionManager;
}
//设置http用户名验证
- (void)updateRequestAuthorizationHeaderFieldWith:(AFHTTPSessionManager*)sessionManager sessionMessage:(SessionManager *)sessionMsg {
    
    if (sessionMsg->username||sessionMsg->password) {
        [sessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:sessionMsg->username password:sessionMsg->password];
    }
}
//设置请求头
- (void)updateRequestHTTPHeadersWith:(AFHTTPSessionManager*)sessionManager sessionMessage:(SessionManager *)sessionMsg {
    
    if (sessionMsg->HTTPRequestHeaders) {
        [sessionMsg->HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop){
            [sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
        }];
    }
}

//设置服务器响应数据序列化格式
- (void)updateResponseSerializerWith:(AFHTTPSessionManager*)sessionManager sessionMessage:(SessionManager *)sessionMsg {
    
    if (sessionMsg->ResponseDataType == DefaultDataType) {
        sessionManager.responseSerializer=[AFJSONResponseSerializer serializer];
    }else{
        sessionManager.responseSerializer=[AFHTTPResponseSerializer serializer];
    }
}

//设置请求体序列化格式
- (void)updateRequestSerializerWith:(AFHTTPSessionManager*)sessionManager sessionMessage:(SessionManager *)sessionMsg {
    
    if (sessionMsg->RequestBodyType == DefaultBodyType) {
        sessionManager.requestSerializer=[AFHTTPRequestSerializer serializer];
    } else if (sessionMsg->RequestBodyType == JSONBodyType) {
        sessionManager.requestSerializer=[AFJSONRequestSerializer serializer];
    }  else if (sessionMsg->RequestBodyType == PropertyListBodyType) {
        sessionManager.requestSerializer=[AFPropertyListRequestSerializer serializer];
    }
    
}

//设置请求超时时间
- (void)updateTimeoutIntervalWith:(AFHTTPSessionManager*)sessionManager sessionMessage:(SessionManager *)sessionMsg {
    
    [sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    sessionManager.requestSerializer.timeoutInterval=sessionMsg->timeOut;//设置请求超时时间
    [sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}

//配置https安全证书
- (AFSecurityPolicy*)updateSecurityPolicyWith:(AFHTTPSessionManager*)sessionManager sessionMessage:(SessionManager *)sessionMsg {
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:(AFSSLPinningModeNone)];
    [securityPolicy setValidatesDomainName:NO];
    return securityPolicy;
}

#pragma mark - 是否有网络
- (BOOL)isConnected {
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

#pragma mark - 判断网络状态

- (void)startMonitoring
{
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    [mgr startMonitoring];
    
    // 2.设置网络状态改变后的处理
    //    @weakify(self);
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //        @strongify(self);
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                JKNetWorkDLog(@"未知网络")
                self.networkStatus=AFNetworkReachabilityStatusUnknown;
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                JKNetWorkDLog(@"无网络");
                self.networkStatus=AFNetworkReachabilityStatusNotReachable;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                JKNetWorkDLog(@"蜂窝数据网");
                self.networkStatus=AFNetworkReachabilityStatusReachableViaWWAN;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.networkStatus=AFNetworkReachabilityStatusReachableViaWiFi;
                JKNetWorkDLog(@"WiFi网络");
                break;
                
            default:
                break;
        }
        
    }] ;
}

@end
