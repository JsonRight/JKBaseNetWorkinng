//
//  NSObject+JKModel.m
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/14.
//  Copyright © 2018年 姜奎. All rights reserved.
//


#import "NSObject+JKModel.h"
#import "NSArray+Traversal.h"
#import "NSDictionary+JSON.h"
#import <YYKit.h>

@implementation NSObject (JKModel)

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    [self modelSetWithJSON:dictionary];
    
    return self;
}

- (NSMutableDictionary *)toDictionary
{
    return [self modelToJSONObject];
}

- (NSString*)toJSONString
{
    return [self modelToJSONString];
}

- (id)modelCopy
{
    NSDictionary* dic = [self toDictionary];
    return [[self class] objectFromDictionary:dic];
}

#pragma mark - Encode
- (void)modelEncodeWithCoder:(NSCoder *)aCoder
{
    [self modelEncodeWithCoder:aCoder];
}

- (id)modelInitWithCoder:(NSCoder *)aDecoder
{
    return [self modelInitWithCoder:aDecoder];
}

#pragma mark - Static Utility
+ (id)objectFromDictionary:(NSDictionary*)dictionary
{
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [[self alloc] initWithDictionary:dictionary];
}

+ (id)objectFromJSONString: (NSString*)JSONString
{
    
    NSDictionary* dic = [NSDictionary dictionaryWithJSONString:JSONString];
    return [self objectFromDictionary:dic];
}

+ (NSArray*)objectArrayFromDictionaryArray: (NSArray*)dictionaryArray
{
    return [dictionaryArray arrayByMappingArrayWithBlock:^id(NSInteger index, NSDictionary* dic) {
        return [self objectFromDictionary:dic];
    }];
}

+ (NSArray*)dictionaryArrayFromObjectArray: (NSArray*)objectArray
{
    return [objectArray arrayByMappingArrayWithBlock:^id(NSInteger index, NSObject* model) {
        return [model toDictionary];
    }];
}

@end
