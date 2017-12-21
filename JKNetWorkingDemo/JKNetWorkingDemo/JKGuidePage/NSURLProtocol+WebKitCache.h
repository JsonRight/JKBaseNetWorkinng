//
//  NSURLProtocol+WebKitCache.h
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/19.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 用于web缓存，但是wk好像不能用，具体原因不明
 */
@interface NSURLProtocol (WebKitCache)

+ (void)jk_registerSchemes:(NSArray<NSString * > *)schemes;

+ (void)jk_unregisterSchemes:(NSArray<NSString * > *)schemes;
@end
