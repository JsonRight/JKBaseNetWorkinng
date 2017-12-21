//
//  NSURLProtocol+WebKitCache.m
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/19.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import "NSURLProtocol+WebKitCache.h"
#import <WebKit/WebKit.h>
#import "NSObject+SelectorExtension.h"

FOUNDATION_STATIC_INLINE Class ContextControllerClass() {
    static Class cls;
    if (!cls) {
        cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
    }
    return cls;
}

FOUNDATION_STATIC_INLINE SEL RegisterSchemeSelector() {
    return NSSelectorFromString(@"registerSchemeForCustomProtocol:");
}

FOUNDATION_STATIC_INLINE SEL UnregisterSchemeSelector() {
    return NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
}

@implementation NSURLProtocol (WebKitSupport)

+ (void)jk_registerSchemes:(NSArray<NSString * > *)schemes {
    Class cls = ContextControllerClass();
    SEL sel = RegisterSchemeSelector();
    if ([(id)cls canRunToSelector:sel]) {
        for (NSString* str in schemes) {
             [(id)cls runSelector:sel withObjects:@[str]];
        }
    }
}

+ (void)jk_unregisterSchemes:(NSArray<NSString * > *)schemes {
    Class cls = ContextControllerClass();
    SEL sel = UnregisterSchemeSelector();
    if ([(id)cls canRunToSelector:sel]) {
        for (NSString* str in schemes) {
            [(id)cls runSelector:sel withObjects:@[str]];
        }
    }
}
@end
