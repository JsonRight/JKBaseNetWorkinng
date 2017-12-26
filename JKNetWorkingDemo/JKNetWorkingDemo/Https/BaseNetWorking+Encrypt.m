//
//  BaseNetWorking+Encrypt.m
//  HaoLyy
//
//  Created by jk on 2017/3/22.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "BaseNetWorking+Encrypt.h"


@implementation BaseNetWorking (Encrypt)
- (void)encryptedUrlWithSessionMessage:(BaseSessionMessage *)sessionMsg{

    sessionMsg->encryptedUrlString=[NSString stringWithFormat:@"%@%@",sessionMsg->baseUrl,sessionMsg->requestUrl];
    if (sessionMsg->isDlog) {
        DLog(@"baseUrl:%@\nrequestUrl:%@\n请求参数:\n%@",sessionMsg->baseUrl,sessionMsg->requestUrl,sessionMsg->paramsDic);
    }
}
@end
