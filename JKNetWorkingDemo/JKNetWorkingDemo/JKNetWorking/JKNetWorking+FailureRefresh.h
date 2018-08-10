//
//  JKNetWorking+FailureRefresh.h
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/10.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import "JKNetWorking.h"

@interface JKNetWorking (FailureRefresh)
/*网络错误处理，token失效重新请求、网络超时等*/
- (void)regetTokenWithSessionMessage:(SessionManager *)sessionMsg;
- (void)regetInterNetTimerWithSessionMessage:(SessionManager *)sessionMsg;
@end
