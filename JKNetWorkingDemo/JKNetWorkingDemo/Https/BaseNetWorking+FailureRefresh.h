//
//  BaseNetWorking+FailureRefresh.h
//  HaoLyy
//
//  Created by jk on 2017/3/22.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "BaseNetWorking.h"

@interface BaseNetWorking (FailureRefresh)
/*网络错误处理，token失效重新请求、网络超时等*/
- (void)regetTokenWithSessionMessage:(BaseSessionMessage *)sessionMsg;
- (void)regetInterNetTimerWithSessionMessage:(BaseSessionMessage *)sessionMsg;
@end
