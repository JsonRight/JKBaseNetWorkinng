//
//  JKNetWorking+Response.h
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/10.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import "JKNetWorking.h"

@interface JKNetWorking (Response)
/*
 数据返回处理
 */
-(void)responseForm_HEAD_RequestToMsgWith:(NSURLSessionDataTask* )task msg:(SessionManager*)sessionMsg;

-(void)responseForJsonToMsgWith:(NSURLSessionDataTask* )task responseObject:(id )responseObject msg:(SessionManager*)sessionMsg;

-(void)responseForDataToMsgWith:(NSURLSessionDataTask* )task responseObject:(id )responseObject msg:(SessionManager*)sessionMsg;

-(void)responseFailureWith:(NSURLSessionDataTask* )task error:(NSError*)error msg:(SessionManager*)sessionMsg;
@end
