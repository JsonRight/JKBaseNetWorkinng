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
    if (sessionMsg.isDlog) {
        DLog(@"%@===>\n%@",sessionMsg.requestUrl,task);
    }
    
    if (sessionMsg.successBlock) {
        sessionMsg.successBlock(sessionMsg);
    }
}

-(void)responseForJsonToMsgWith:(NSURLSessionDataTask* )task responseObject:(id )responseObject msg:(BaseSessionMessage*)sessionMsg{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&parseError];
    
    sessionMsg.responseString= [[NSString alloc]initWithData:jsonData encoding:(NSUTF8StringEncoding)];
    
    sessionMsg.responseData=jsonData;
    
    sessionMsg.jsonItems=[NSMutableDictionary dictionaryWithDictionary:responseObject];
    

    sessionMsg.dataDic=[sessionMsg.jsonItems objectForKey:@"result"];
    sessionMsg.flag=[sessionMsg.jsonItems objectForKey:@"flag"];
    sessionMsg.lockerFlag=[sessionMsg.jsonItems objectForKey:@"lockerFlag"];
    sessionMsg.msg=[sessionMsg.jsonItems objectForKey:@"msg"];
    
    if (sessionMsg.isDlog) {
        DLog(@"%@===>\n%@",sessionMsg.requestUrl,sessionMsg.responseString);
    }
    
    if (sessionMsg.successBlock) {
        sessionMsg.successBlock(sessionMsg);
    }
    
    
}
-(void)responseForDataToMsgWith:(NSURLSessionDataTask* )task responseObject:(id )responseObject msg:(BaseSessionMessage*)sessionMsg{
    
    NSError *parseError = nil;
    
    NSMutableDictionary*responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:&parseError];
    NSString*responseStr= [[NSString alloc]initWithData:responseObject encoding:(NSUTF8StringEncoding)];
    sessionMsg.responseString=responseStr;
    sessionMsg.responseData=responseObject;
    sessionMsg.jsonItems=responseJson;
    
    sessionMsg.dataDic=[sessionMsg.jsonItems objectForKey:@"result"];
    sessionMsg.flag=[sessionMsg.jsonItems objectForKey:@"flag"];
    sessionMsg.lockerFlag=[sessionMsg.jsonItems objectForKey:@"lockerFlag"];
    sessionMsg.msg=[sessionMsg.jsonItems objectForKey:@"msg"];
    
    if (sessionMsg.isDlog) {
        DLog(@"%@===>\n%@",sessionMsg.requestUrl,sessionMsg.responseString);
    }
    
    if (sessionMsg.successBlock) {
        sessionMsg.successBlock(sessionMsg);
    }
   
}
-(void)responseFailureWith:(NSURLSessionDataTask* )task error:(NSError*)error msg:(BaseSessionMessage*)sessionMsg{
   
    NSHTTPURLResponse * response=error.userInfo[@"com.alamofire.serialization.response.error.response"];
    NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary*responseJson=nil;
    if (data) {
        NSError *parseError = nil;
        
       responseJson  = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:&parseError];
    }
   

    switch (response.statusCode) {
        case 502://密匙错误
        {
           
        }
            break;
        case 303:
        {
            
        }
            break;
        
            
        default:
        {
            
            
        }
            break;
    }
 
    sessionMsg.responseString=str;
    sessionMsg.responseData=data;
    sessionMsg.jsonItems=responseJson;
    sessionMsg.flag=@"404";
    sessionMsg.lockerFlag=@"网络错误";
    sessionMsg.msg=@"连接出错了，检查一下网络？";
    if (sessionMsg.isDlog) {
        DLog(@"%@===>\n%@",sessionMsg.requestUrl,sessionMsg.responseString);
    }
    if (sessionMsg.failureBlock) {
        sessionMsg.failureBlock(sessionMsg);
    }
    
}
@end
