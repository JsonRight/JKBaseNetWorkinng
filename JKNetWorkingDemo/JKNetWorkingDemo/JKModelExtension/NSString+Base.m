//
//  NSString+Base.m
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/14.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import "NSString+Base.h"

@implementation NSString (Base)

+ (BOOL)isStringNullOrEmpty: (id)string
{
    if (string == nil) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSString class]]) {
        return ((NSString*)string).length == 0;
    } else {
        return YES;
    }
}

+ (NSString *)uniqueUUID
{
    return [self generateUUID];
}

+ (NSString *)generateUUID
{
    NSString *result = nil;
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid)
    {
        result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    
    return result;
}

- (NSNumber *)isNumberGreaterThanZero
{
    NSString *regEx = @"^[1-9]\\d*|0$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    BOOL isMatch = [pred evaluateWithObject:self];
    if (isMatch) {
        return [NSNumber numberWithDouble:[self integerValue]];
    }
    return nil;
}

- (NSString *)base64encode
{
    NSData* originData = [self dataUsingEncoding:NSASCIIStringEncoding];
    
    return [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

- (NSString *)base64decode
{
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    return [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
}

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

- (NSString *)urldecode {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)urlencode {
    NSString *encUrl = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger len = [encUrl length];
    const char *c;
    c = [encUrl UTF8String];
    NSString *ret = @"";
    for(int i = 0; i < len; i++) {
        switch (*c) {
            case '~':
                ret = [ret stringByAppendingString:@"%7E"];
                break;
            case '/':
                ret = [ret stringByAppendingString:@"%2F"];
                break;
            case '\'':
                ret = [ret stringByAppendingString:@"%27"];
                break;
            case ';':
                ret = [ret stringByAppendingString:@"%3B"];
                break;
            case '?':
                ret = [ret stringByAppendingString:@"%3F"];
                break;
            case ':':
                ret = [ret stringByAppendingString:@"%3A"];
                break;
            case '@':
                ret = [ret stringByAppendingString:@"%40"];
                break;
            case '&':
                ret = [ret stringByAppendingString:@"%26"];
                break;
            case '=':
                ret = [ret stringByAppendingString:@"%3D"];
                break;
            case '+':
                ret = [ret stringByAppendingString:@"%2B"];
                break;
            case '$':
                ret = [ret stringByAppendingString:@"%24"];
                break;
            case ',':
                ret = [ret stringByAppendingString:@"%2C"];
                break;
            case '[':
                ret = [ret stringByAppendingString:@"%5B"];
                break;
            case ']':
                ret = [ret stringByAppendingString:@"%5D"];
                break;
            case '#':
                ret = [ret stringByAppendingString:@"%23"];
                break;
            case '!':
                ret = [ret stringByAppendingString:@"%21"];
                break;
            case '(':
                ret = [ret stringByAppendingString:@"%28"];
                break;
            case ')':
                ret = [ret stringByAppendingString:@"%29"];
                break;
            case '*':
                ret = [ret stringByAppendingString:@"%2A"];
                break;
            default:
                ret = [ret stringByAppendingFormat:@"%c", *c];
        }
        c++;
    }
    
    return ret;
}

@end

extern BOOL JKIsEmptyString(NSString* string)
{
    return [NSString isStringNullOrEmpty:string];
}
