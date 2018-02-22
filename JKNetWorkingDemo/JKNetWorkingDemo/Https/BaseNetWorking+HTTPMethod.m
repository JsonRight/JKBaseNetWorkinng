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
    NSURLSessionDataTask *dataTask=[sessionManager GET:sessionMsg->encryptedUrlString parameters:nil progress:sessionMsg->progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"GET")
        
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"GET:error———————————— %@",error);
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)postMethodWithSessionMessage:(BaseSessionMessage *)sessionMsg {
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask=[sessionManager POST:sessionMsg->encryptedUrlString parameters:sessionMsg->paramsDic progress:sessionMsg->progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"POST")
    
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"POST:error———————————— %@",error);
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}
- (NSURLSessionDataTask *)upLoadDataMethodWithSessionMessage:(BaseSessionMessage *)sessionMsg {
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask = [sessionManager POST:sessionMsg->encryptedUrlString parameters:sessionMsg->paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [sessionMsg->upLoadData enumerateObjectsUsingBlock:^(UpLoadFileModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj.data  name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
        }];
    } progress:sessionMsg->progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"POST上传")
        
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"POST上传:error———————————— %@",error);
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}
- (NSURLSessionDataTask *)HEADT_MethodWithSessionMessage:(BaseSessionMessage *)sessionMsg{
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask = [sessionManager HEAD:sessionMsg->encryptedUrlString parameters:sessionMsg->paramsDic success:^(NSURLSessionDataTask * _Nonnull task) {
        DLog(@"HEAD")
        
        [self responseForm_HEAD_RequestToMsgWith:task msg:sessionMsg];
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"HEAD:errpr———————————— %@",error);
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}
- (NSURLSessionDataTask *)PUT_MethodWithSessionMessage:(BaseSessionMessage *)sessionMsg{
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask = [sessionManager PUT:sessionMsg->encryptedUrlString parameters:sessionMsg->paramsDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"PUT")
        
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"PUT:error———————————— %@",error);
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}
- (NSURLSessionDataTask *)PATCH_MethodWithSessionMessage:(BaseSessionMessage *)sessionMsg{
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask = [sessionManager PATCH:sessionMsg->encryptedUrlString parameters:sessionMsg->paramsDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"PATCH")
        
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"PATCH:error———————————— %@",error);
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}
- (NSURLSessionDataTask *)DELETE_MethodWithSessionMessage:(BaseSessionMessage *)sessionMsg{
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask = [sessionManager DELETE:sessionMsg->encryptedUrlString parameters:sessionMsg->paramsDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"DELETE")
        
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"DELETE:error———————————— %@",error);
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}

@end
