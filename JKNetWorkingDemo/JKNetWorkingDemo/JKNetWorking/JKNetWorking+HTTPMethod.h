//
//  JKNetWorking+HTTPMethod.h
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/10.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import "JKNetWorking.h"

@interface JKNetWorking (HTTPMethod)
/*
 不同请求方式，此处集成get。post 数据上传
 HEADType                = 1 << 3,
 PUTType                 = 1 << 4,
 PATCHType               = 1 << 5,
 DELETEType
 */
- (NSURLSessionDataTask *)getMethodWithSessionMessage:(SessionManager *)sessionMsg;

- (NSURLSessionDataTask *)postMethodWithSessionMessage:(SessionManager *)sessionMsg;

- (NSURLSessionDataTask *)upLoadDataMethodWithSessionMessage:(SessionManager *)sessionMsg;

- (NSURLSessionDataTask *)HEADT_MethodWithSessionMessage:(SessionManager *)sessionMsg;

- (NSURLSessionDataTask *)PUT_MethodWithSessionMessage:(SessionManager *)sessionMsg;

- (NSURLSessionDataTask *)PATCH_MethodWithSessionMessage:(SessionManager *)sessionMsg;

- (NSURLSessionDataTask *)DELETE_MethodWithSessionMessage:(SessionManager *)sessionMsg;

@end
