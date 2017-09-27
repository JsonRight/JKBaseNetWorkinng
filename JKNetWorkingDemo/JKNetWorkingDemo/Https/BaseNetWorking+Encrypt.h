//
//  BaseNetWorking+Encrypt.h
//  HaoLyy
//
//  Created by jk on 2017/3/22.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "BaseNetWorking.h"

@interface BaseNetWorking (Encrypt)
/*
 接口Url拼接、参数加密
 */
- (void)encryptedUrlWithSessionMessage:(BaseSessionMessage *)sessionMsg;
@end
