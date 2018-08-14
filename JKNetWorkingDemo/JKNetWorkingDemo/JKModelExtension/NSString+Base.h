//
//  NSString+Base.h
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/14.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base)
+ (BOOL)isStringNullOrEmpty: (id)string;
+ (NSString *)uniqueUUID;

- (NSNumber *)isNumberGreaterThanZero;
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options;
- (BOOL)containsString:(NSString *)string;
- (NSString *)urlencode;
- (NSString *)urldecode;
- (NSString *)base64encode;
- (NSString *)base64decode;

@end

extern BOOL JKIsEmptyString(NSString* string);
