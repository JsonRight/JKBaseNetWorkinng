//
//  NSObject+SelectorExtension.h
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/19.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SelectorExtension)

/**
 判断是否能调用 这个sel

 @param aSelector 这个sel
 @return yes、no
 */
-(BOOL)canRunToSelector:(SEL)aSelector;

/**
 调用 这个sel

 @param aSelector 这个sel
 @param objects 参数
 @return 不知道返回个啥
 */
- (id)runSelector:(SEL)aSelector withObjects:(NSArray *)objects;

@end
