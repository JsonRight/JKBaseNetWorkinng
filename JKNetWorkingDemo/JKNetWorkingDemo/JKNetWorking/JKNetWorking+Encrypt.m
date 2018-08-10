//
//  JKNetWorking+Encrypt.m
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/10.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import "JKNetWorking+Encrypt.h"

@implementation JKNetWorking (Encrypt)
- (void)encryptedUrlWithSessionMessage:(SessionManager *)sessionMsg{
    if (sessionMsg->requestUrl) {
        sessionMsg->encryptedUrlString=[NSString stringWithFormat:@"%@%@",sessionMsg->baseUrl,sessionMsg->requestUrl];
    }else {
        sessionMsg->encryptedUrlString=[NSString stringWithFormat:@"%@",sessionMsg->baseUrl];
    }
    if (sessionMsg->isDlog) {
        JKNetWorkDLog(@"baseUrl:%@\nrequestUrl:%@\n请求参数:\n%@",sessionMsg->baseUrl,sessionMsg->requestUrl,sessionMsg->params);
    }
}
@end
