//
//  NSArray+Traversal.m
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/14.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import "NSArray+Traversal.h"

@implementation NSArray (Traversal)
- (BOOL)containsObjectMathcingPredicate: (JKArrayFilterBlock)predicate
{
    return [self firstObjectMatchingPredicate:predicate] != nil;
}

- (id)firstObjectMatchingPredicate: (JKArrayFilterBlock)predicate
{
    if (!predicate) {
        return nil;
    }
    
    for (id obj in self) {
        if (predicate(obj)) {
            return obj;
        }
    }
    
    return nil;
}

- (NSArray*)arrayByMappingArrayWithBlock: (JKArrayMappingBlock)map
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    for (id object in self) {
        id mapped = map(index, object);
        if (mapped) {
            [array addObject:mapped];
        }
        index++;
    }
    
    return [array copy];
}

- (NSArray*)arrayFlatternByMappingArrayWithBlock: (JKArrayMappingBlock)map
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    for (id object in self) {
        id mapped = map(index, object);
        if ([mapped isKindOfClass:[NSArray class]]) {
            [array addObjectsFromArray:mapped];
        } else if (mapped) {
            [array addObject:mapped];
        } else {
            // Do nothing
        }
        
        index++;
    }
    
    return array;
}

- (id)objectByFilterWithBlock: (JKArrayFilterBlock)block
{
    for (id object in self) {
        if (block(object)) {
            return object;
        }
    }
    
    return nil;
}

- (id)objectbyReduceWithBlock: (JKArrayReduceBlock)reduce
{
    if (!reduce) {
        return nil;
    }
    
    __block id result = nil;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        result = reduce(result, obj);
    }];
    
    return result;
}

+ (instancetype)arrayByEnumeratingRange: (NSRange)range mappingBlock: (JKArrayObjectCreateBlock)mappingBlock
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSInteger i = range.location; i < (range.location + range.length); i++) {
        id object = mappingBlock(i);
        if (object) {
            [array addObject:object];
        }
    }
    return array;
}
@end
