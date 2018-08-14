//
//  NSDictionary+JSON.h
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/14.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

- (NSString*)toJSONString;
+ (NSDictionary*)dictionaryWithJSONString: (NSString*)JSONString;

@end
