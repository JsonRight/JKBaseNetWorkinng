//
//  BaseNetWorking+HTTPMethod.m
//  HaoLyy
//
//  Created by jk on 2017/3/22.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "BaseNetWorking+HTTPMethod.h"
#import "BaseNetWorking+Encrypt.h"
#import "BaseNetWorking+Response.h"
@implementation BaseNetWorking (HTTPMethod)

#pragma mark -- 普通Get请求和Post请求
- (NSURLSessionDataTask *)getMethodWithSessionMessage:(BaseSessionMessage *)sessionMsg {
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
     [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask=[sessionManager GET:sessionMsg.encryptedUrlString parameters:nil progress:sessionMsg.progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"get")
        
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"Get网络错误———————————— %@",error);
        [self responseFailureWith:task error:error msg:sessionMsg];
  
    }];
    
    
    return dataTask;
}

- (NSURLSessionDataTask *)postMethodWithSessionMessage:(BaseSessionMessage *)sessionMsg {
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask=[sessionManager POST:sessionMsg.encryptedUrlString parameters:sessionMsg.paramsDic progress:sessionMsg.progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"post")
    
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
    }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"post网络错误———————————— %@",error);
        [self responseFailureWith:task error:error msg:sessionMsg];
        
    }];
    return dataTask;
}
- (NSURLSessionDataTask *)upLoadDataMethodWithSessionMessage:(BaseSessionMessage *)sessionMsg {
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    
    NSURLSessionDataTask *dataTask = [sessionManager POST:sessionMsg.encryptedUrlString parameters:sessionMsg.paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [sessionMsg.upLoadData enumerateObjectsUsingBlock:^(UpLoadFileModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj.data  name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
        }];
    } progress:sessionMsg.progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"post")
        
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"post网络错误———————————— %@",error);
        [self responseFailureWith:task error:error msg:sessionMsg];
        
    }];
    
    return dataTask;
}

@end
