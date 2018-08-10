//
//  JKNetWorking+Encrypt.h
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/10.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import "JKNetWorking.h"

@interface JKNetWorking (Encrypt)
/*
 接口Url拼接、参数加密
 */
- (void)encryptedUrlWithSessionMessage:(SessionManager *)sessionMsg;
@end
