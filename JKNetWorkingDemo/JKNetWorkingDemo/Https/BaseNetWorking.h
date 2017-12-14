//
//  BaseNetWorking.h
//  HaoLyy
//
//  Created by jk on 2017/3/10.
//  Copyright © 2017年 jk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "BaseSessionMessage.h"
#import "MyHelper.h"
@interface BaseNetWorking : NSObject{
    NSString* _baseUrl;
}
@property (nonatomic, assign, getter=isConnected) BOOL connected;/**<网络是否连接*/
@property(nonatomic ,assign) AFNetworkReachabilityStatus networkStatus;
+ (BaseNetWorking *) shareMannager;
@property(nonatomic,strong)NSString* baseUrl;
- (NSURLSessionDataTask *)sendSessionMessage:(BaseSessionMessage *)sessionMsg;
#pragma mark - 配置sessionManager
- (AFHTTPSessionManager *)configSessionManagerWithSessionMessage:(BaseSessionMessage *)sessionMsg;
@end
