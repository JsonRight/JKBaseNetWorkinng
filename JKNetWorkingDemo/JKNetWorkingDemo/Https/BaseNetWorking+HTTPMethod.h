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
 HEADType                = 1 << 3,
 PUTType                 = 1 << 4,
 PATCHType               = 1 << 5,
 DELETEType
 */
- (NSURLSessionDataTask *)getMethodWithSessionMessage:(BaseSessionMessage *)sessionMsg;
- (NSURLSessionDataTask *)postMethodWithSessionMessage:(BaseSessionMessage *)sessionMsg;
- (NSURLSessionDataTask *)upLoadDataMethodWithSessionMessage:(BaseSessionMessage *)sessionMsg;
- (NSURLSessionDataTask *)HEADT_MethodWithSessionMessage:(BaseSessionMessage *)sessionMsg;
- (NSURLSessionDataTask *)PUT_MethodWithSessionMessage:(BaseSessionMessage *)sessionMsg;
- (NSURLSessionDataTask *)PATCH_MethodWithSessionMessage:(BaseSessionMessage *)sessionMsg;
- (NSURLSessionDataTask *)DELETE_MethodWithSessionMessage:(BaseSessionMessage *)sessionMsg;
@end
