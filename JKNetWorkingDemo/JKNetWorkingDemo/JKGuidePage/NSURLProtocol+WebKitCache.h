//
//  NSURLProtocol+WebKitCache.h
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/19.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+SelectorExtension.h"
@interface NSURLProtocol (WebKitCache)

+ (void)jk_registerSchemes:(NSArray<NSString * > *)schemes;

+ (void)jk_unregisterSchemes:(NSArray<NSString * > *)schemes;
@end
