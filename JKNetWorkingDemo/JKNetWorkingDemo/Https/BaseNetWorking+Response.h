//
//  BaseNetWorking+Response.h
//  HaoLyy
//
//  Created by jk on 2017/3/22.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "BaseNetWorking.h"

@interface BaseNetWorking (Response)
/*
 数据返回处理
 */
-(void)responseForm_HEAD_RequestToMsgWith:(NSURLSessionDataTask* )task msg:(BaseSessionMessage*)sessionMsg;

-(void)responseForJsonToMsgWith:(NSURLSessionDataTask* )task responseObject:(id )responseObject msg:(BaseSessionMessage*)sessionMsg;

-(void)responseForDataToMsgWith:(NSURLSessionDataTask* )task responseObject:(id )responseObject msg:(BaseSessionMessage*)sessionMsg;

-(void)responseFailureWith:(NSURLSessionDataTask* )task error:(NSError*)error msg:(BaseSessionMessage*)sessionMsg;
@end
