//
//  NSArray+Traversal.h
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/14.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef id(^JKArrayMappingBlock)(NSInteger index, id object);
typedef BOOL(^JKArrayFilterBlock)(id object);
typedef id(^JKArrayObjectCreateBlock)(NSInteger index);
typedef id(^JKArrayReduceBlock)(id total, id current);

@interface NSArray (Traversal)
- (BOOL)containsObjectMathcingPredicate: (JKArrayFilterBlock)predicate;
- (id)firstObjectMatchingPredicate: (JKArrayFilterBlock)predicate;
- (NSArray*)arrayByMappingArrayWithBlock: (JKArrayMappingBlock)map;
- (NSArray*)arrayFlatternByMappingArrayWithBlock: (JKArrayMappingBlock)map;
- (id)objectByFilterWithBlock: (JKArrayFilterBlock)block;
- (id)objectbyReduceWithBlock: (JKArrayReduceBlock)block;
+ (instancetype)arrayByEnumeratingRange: (NSRange)range mappingBlock: (JKArrayObjectCreateBlock)mappingBlock;

@end
