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
 判断是否能调用 这个sel  代替respondsToSelector：<#(SEL)#>

 @param aSelector 这个sel
 @return yes、no
 */
-(BOOL)canRunToSelector:(SEL)aSelector;

/**
 调用 这个sel  代替  performSelector:<#(SEL)#> withObject:<#(id)#>]

 @param aSelector 这个sel
 @param objects 参数对应sel的各个参数，类型需匹配，否则💥蹦💥
 @return 不知道返回个啥
 */
- (id)runSelector:(SEL)aSelector withObjects:(NSArray *)objects;

@end
