//
//  JKNetWorking+HTTPMethod.m
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/10.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import "JKNetWorking+HTTPMethod.h"
#import "JKNetWorking+Encrypt.h"
#import "JKNetWorking+Response.h"

@implementation JKNetWorking (HTTPMethod)
#pragma mark -- 普通Get请求和Post请求
- (NSURLSessionDataTask *)getMethodWithSessionMessage:(SessionManager *)sessionMsg {
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask=[sessionManager GET:sessionMsg->encryptedUrlString parameters:nil progress:sessionMsg->progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JKNetWorkDLog(@"GET")
        
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)postMethodWithSessionMessage:(SessionManager *)sessionMsg {
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask=[sessionManager POST:sessionMsg->encryptedUrlString parameters:sessionMsg->params progress:sessionMsg->progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JKNetWorkDLog(@"POST")
        
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}
- (NSURLSessionDataTask *)upLoadDataMethodWithSessionMessage:(SessionManager *)sessionMsg {
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask = [sessionManager POST:sessionMsg->encryptedUrlString parameters:sessionMsg->params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [sessionMsg->upLoadData enumerateObjectsUsingBlock:^(UpLoadFileModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj.data  name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
        }];
    } progress:sessionMsg->progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JKNetWorkDLog(@"POST上传")
        
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}
- (NSURLSessionDataTask *)HEADT_MethodWithSessionMessage:(SessionManager *)sessionMsg{
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask = [sessionManager HEAD:sessionMsg->encryptedUrlString parameters:sessionMsg->params success:^(NSURLSessionDataTask * _Nonnull task) {
        JKNetWorkDLog(@"HEAD")
        
        [self responseForm_HEAD_RequestToMsgWith:task msg:sessionMsg];
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}
- (NSURLSessionDataTask *)PUT_MethodWithSessionMessage:(SessionManager *)sessionMsg{
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask = [sessionManager PUT:sessionMsg->encryptedUrlString parameters:sessionMsg->params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JKNetWorkDLog(@"PUT")
        
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}
- (NSURLSessionDataTask *)PATCH_MethodWithSessionMessage:(SessionManager *)sessionMsg{
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask = [sessionManager PATCH:sessionMsg->encryptedUrlString parameters:sessionMsg->params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JKNetWorkDLog(@"PATCH")
        
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}
- (NSURLSessionDataTask *)DELETE_MethodWithSessionMessage:(SessionManager *)sessionMsg{
    AFHTTPSessionManager *sessionManager=[self configSessionManagerWithSessionMessage:sessionMsg];
    [self encryptedUrlWithSessionMessage:sessionMsg];
    NSURLSessionDataTask *dataTask = [sessionManager DELETE:sessionMsg->encryptedUrlString parameters:sessionMsg->params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JKNetWorkDLog(@"DELETE")
        
        if ([sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
            
            [self responseForJsonToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }else{
            
            [self responseForDataToMsgWith:task responseObject:responseObject msg:sessionMsg];
            
        }
        if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self responseFailureWith:task error:error msg:sessionMsg];
    }];
    return dataTask;
}
@end
