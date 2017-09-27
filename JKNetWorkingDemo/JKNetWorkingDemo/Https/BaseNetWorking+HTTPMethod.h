//
//  BaseNetWorking+HTTPMethod.h
//  HaoLyy
//
//  Created by jk on 2017/3/22.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "BaseNetWorking.h"

@interface BaseNetWorking (HTTPMethod)
/*
 不同请求方式，此处集成get。post 数据上传
 */
- (NSURLSessionDataTask *)getMethodWithSessionMessage:(BaseSessionMessage *)sessionMsg;
- (NSURLSessionDataTask *)postMethodWithSessionMessage:(BaseSessionMessage *)sessionMsg;
- (NSURLSessionDataTask *)upLoadDataMethodWithSessionMessage:(BaseSessionMessage *)sessionMsg;
@end
