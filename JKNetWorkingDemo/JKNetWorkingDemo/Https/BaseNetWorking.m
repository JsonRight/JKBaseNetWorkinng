//
//  BaseNetWorking.m
//  HaoLyy
//
//  Created by jk on 2017/3/10.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "BaseNetWorking.h"
#import "BaseNetWorking+HTTPMethod.h"

@implementation BaseNetWorking
#pragma mark - 初始化
+ (BaseNetWorking *)shareMannager{
    static BaseNetWorking *netWorking=nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        netWorking = [[BaseNetWorking alloc] init];
        [netWorking startMonitoring];
    });
    return netWorking;
}
-(void)setBaseUrl:(NSString *)baseUrl{
    _baseUrl = baseUrl;
}
-(NSString *)baseUrl{
    if (!_baseUrl) {
        _baseUrl = @"";
    }
    return _baseUrl;
}
#pragma mark - 普通数据请求
#pragma mark -- 普通http请求抽象接口
- (NSURLSessionDataTask *)sendSessionMessage:(BaseSessionMessage *)sessionMsg {

    switch (sessionMsg.baseHTTPMethodType) {
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
- (AFHTTPSessionManager *)configSessionManagerWithSessionMessage:(BaseSessionMessage *)sessionMsg {
    
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
    //设置服务器响应数据序列化格式
    [self updateResponseSerializerWith:sessionManager sessionMessage:sessionMsg];
    //设置请求体序列化格式
    [self updateResponseSerializerWith:sessionManager sessionMessage:sessionMsg];
    //设置请求超时时间
    [self updateTimeoutIntervalWith:sessionManager sessionMessage:sessionMsg];
    //配置https安全证书
    sessionManager.securityPolicy  = [self updateSecurityPolicyWith:sessionManager sessionMessage:sessionMsg];
    
    return sessionManager;
}

//设置服务器响应数据序列化格式
- (void)updateResponseSerializerWith:(AFHTTPSessionManager*)sessionManager sessionMessage:(BaseSessionMessage *)sessionMsg {
    
    if (sessionMsg.baseResponseDataType == DefaultDataType) {
        sessionManager.responseSerializer=[AFJSONResponseSerializer serializer];
    }else{
        sessionManager.responseSerializer=[AFHTTPResponseSerializer serializer];
    }
}

//设置请求体序列化格式
- (void)updateRequestSerializerWith:(AFHTTPSessionManager*)sessionManager sessionMessage:(BaseSessionMessage *)sessionMsg {
    
    if (sessionMsg.baseRequestBodyType == DefaultBodyType) {
        sessionManager.requestSerializer=[AFHTTPRequestSerializer serializer];
    } else if (sessionMsg.baseRequestBodyType == JSONBodyType) {
        sessionManager.requestSerializer=[AFJSONRequestSerializer serializer];
    }  else if (sessionMsg.baseRequestBodyType == PropertyListBodyType) {
        sessionManager.requestSerializer=[AFPropertyListRequestSerializer serializer];
    }
    
}

//设置请求超时时间
- (void)updateTimeoutIntervalWith:(AFHTTPSessionManager*)sessionManager sessionMessage:(BaseSessionMessage *)sessionMsg {
    
    [sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    sessionManager.requestSerializer.timeoutInterval=sessionMsg.timeOut;//设置请求超时时间
    [sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}

//配置https安全证书
- (AFSecurityPolicy*)updateSecurityPolicyWith:(AFHTTPSessionManager*)sessionManager sessionMessage:(BaseSessionMessage *)sessionMsg {
    
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
                DLog(@"未知网络")
                self.networkStatus=AFNetworkReachabilityStatusUnknown;
                break;
            
            case AFNetworkReachabilityStatusNotReachable:
                DLog(@"无网络");
                self.networkStatus=AFNetworkReachabilityStatusNotReachable;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DLog(@"蜂窝数据网");
                self.networkStatus=AFNetworkReachabilityStatusReachableViaWWAN;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.networkStatus=AFNetworkReachabilityStatusReachableViaWiFi;
                DLog(@"WiFi网络");
                break;
                
            default:
                break;
        }
        
    }] ;
}

@end
