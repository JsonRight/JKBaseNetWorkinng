//
//  NSObject+JKModel.h
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/14.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JKModel)

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSMutableDictionary *)toDictionary;
- (NSString*)toJSONString;
- (id)modelCopy;

#pragma mark - Encode
- (void)modelEncodeWithCoder:(NSCoder *)aCoder;
- (id)modelInitWithCoder:(NSCoder *)aDecoder;

#pragma mark - Static Utility
+ (id)modelFromDictionary:(NSDictionary*)dictionary;
+ (id)modelFromJSONString: (NSString*)JSONString;
+ (NSArray*)modelArrayFromDictionaryArray: (NSArray*)dictionaryArray;
+ (NSArray*)dictionaryArrayFromObjectArray: (NSArray*)objectArray;
@end
