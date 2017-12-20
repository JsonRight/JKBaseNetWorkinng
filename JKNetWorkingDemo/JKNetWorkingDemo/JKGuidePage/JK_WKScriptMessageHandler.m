//
//  JK_WKScriptMessageHandler.m
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/19.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import "JK_WKScriptMessageHandler.h"
static JK_WKScriptMessageHandler* scriptMessageHandler = nil;
@implementation JK_WKScriptMessageHandler
+(JK_WKScriptMessageHandler*)handlerWithDelegate:(__weak id)delegate{
    if (!scriptMessageHandler) {
        scriptMessageHandler = [JK_WKScriptMessageHandler new];
    }
    scriptMessageHandler.delegate = delegate;
    return scriptMessageHandler;
}
- (instancetype)initWith:(__weak id)delegate{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    
    JKDlog(@"(%@)",message.body);
    
    if ([message.body isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dict = (NSDictionary*)message.body;
        SEL sel = NSSelectorFromString(dict[@"funcName"]);
        
        if (self.delegate&&[self.delegate canRunToSelector:sel]) {
            JKDlog(@"(%@)",dict[@"body"]);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate runSelector:sel withObjects:dict[@"body"]];
            });
        }
    }
}

-(void)dealloc{
    
}

@end
