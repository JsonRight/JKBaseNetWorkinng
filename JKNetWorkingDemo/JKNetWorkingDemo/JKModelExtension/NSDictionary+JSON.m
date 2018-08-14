//
//  NSDictionary+JSON.m
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/14.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import "NSDictionary+JSON.h"
#import "NSString+Base.h"

@implementation NSDictionary (JSON)
- (NSString*)toJSONString
{
    NSError* error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:(NSJSONWritingOptions)0 error:&error];
    if (!error && data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (NSDictionary*)dictionaryWithJSONString: (NSString*)JSONString
{
    if (JKIsEmptyString(JSONString)) {
        return nil;
    }
    
    NSError* error = nil;
    NSData* data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return nil;
    }
    
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return nil;
    }
    return object;
}
@end
