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
    if (self.delegate&&[self.delegate canRunToSelector:NSSelectorFromString(message.name)]) {
        [self.delegate runSelector:NSSelectorFromString(message.name) withObjects:@[message.body]];
    }
}

-(void)dealloc{
    
}

@end
