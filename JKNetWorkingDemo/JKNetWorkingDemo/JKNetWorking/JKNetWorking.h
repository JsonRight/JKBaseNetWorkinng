//
//  JKNetWorking.h
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/10.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "NetWorkHelper.h"
#ifdef DEBUG
#define JKNetWorkDLog(...) printf("JKNetlog<%s : %d>%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define JKNetWorkDLog(...)
#endif


@interface JKNetWorking : NSObject
@property (nonatomic , assign, getter=isConnected) BOOL connected;/**<网络是否连接*/
@property(nonatomic , assign) AFNetworkReachabilityStatus networkStatus;
+ (JKNetWorking *) shareMannager;
@property(nonatomic , strong)NSString* baseUrl;
- (NSURLSessionDataTask *)sendSessionMessage:(SessionManager *)sessionMsg;
#pragma mark - 配置sessionManager
- (AFHTTPSessionManager *)configSessionManagerWithSessionMessage:(SessionManager *)sessionMsg;
@end
