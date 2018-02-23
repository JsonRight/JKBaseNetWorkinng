//
//  BaseNetWorking+Response.m
//  HaoLyy
//
//  Created by jk on 2017/3/22.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "BaseNetWorking+Response.h"
#import "BaseNetWorking+FailureRefresh.h"
#import "BaseNetWorking+Encrypt.h"
@implementation BaseNetWorking (Response)
-(void)responseForm_HEAD_RequestToMsgWith:(NSURLSessionDataTask* )task msg:(BaseSessionMessage*)sessionMsg{
    if (sessionMsg->isDlog) {
        DLog(@"%@===>\n%@",sessionMsg->requestUrl,task);
    }
    if (sessionMsg->successBlock) {
        sessionMsg->successBlock(sessionMsg);
    }
}

-(void)responseForJsonToMsgWith:(NSURLSessionDataTask* )task responseObject:(id )responseObject msg:(BaseSessionMessage*)sessionMsg{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&parseError];
    
    sessionMsg.responseString= [[NSString alloc]initWithData:jsonData encoding:(NSUTF8StringEncoding)];
    
    sessionMsg.responseData=jsonData;
    
    sessionMsg.jsonItems=[NSMutableDictionary dictionaryWithDictionary:responseObject];
    
    if (sessionMsg->isDlog) {
        DLog(@"%@===>\n%@",sessionMsg->requestUrl,sessionMsg.responseString);
    }
    
    if (sessionMsg->successBlock) {
        sessionMsg->successBlock(sessionMsg);
    }
    
    
}
-(void)responseForDataToMsgWith:(NSURLSessionDataTask* )task responseObject:(id )responseObject msg:(BaseSessionMessage*)sessionMsg{
    
    NSError *parseError = nil;
    
    NSMutableDictionary*responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:&parseError];
    NSString*responseStr= [[NSString alloc]initWithData:responseObject encoding:(NSUTF8StringEncoding)];
    sessionMsg.responseString=responseStr;
    sessionMsg.responseData=responseObject;
    sessionMsg.jsonItems=responseJson;
    
    if (sessionMsg->isDlog) {
        DLog(@"%@===>\n%@",sessionMsg->requestUrl,sessionMsg.responseString);
    }
    
    if (sessionMsg->successBlock) {
        sessionMsg->successBlock(sessionMsg);
    }
   
}
-(void)responseFailureWith:(NSURLSessionDataTask* )task error:(NSError*)error msg:(BaseSessionMessage*)sessionMsg{
   
    NSHTTPURLResponse * response=error.userInfo[@"com.alamofire.serialization.response.error.response"];
    //当请求出现一下几种情况，验证请求次数，进行重复请求
//    if (response.statusCode == 403||response.statusCode == 404||response.statusCode == 408||(response.statusCode>=500&&response.statusCode<=505)) {
        if (sessionMsg->requestCount>0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sessionMsg->delayTimeOut * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                sessionMsg.sendSessionMessage();
            });
            return;
        }
//    }
    
    NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary*responseJson=nil;
    if (data) {
        NSError *parseError = nil;
        
       responseJson  = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:&parseError];
    }
   
    sessionMsg.responseString=str;
    sessionMsg.responseData=data;
    sessionMsg.jsonItems=responseJson;
    if (sessionMsg->isDlog) {
        DLog(@"error:statusCode%ld %@===>\n%@",response.statusCode,sessionMsg->requestUrl,sessionMsg.responseString);
    }
    if (sessionMsg->failureBlock) {
        sessionMsg->failureBlock(sessionMsg);
    }
    if (sessionMsg->group) dispatch_group_leave(sessionMsg->group);
}
@end
