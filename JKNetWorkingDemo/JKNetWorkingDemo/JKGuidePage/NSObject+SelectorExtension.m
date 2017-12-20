//
//  NSObject+SelectorExtension.m
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/19.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import "NSObject+SelectorExtension.h"
#import <objc/runtime.h>
@implementation NSObject (SelectorExtension)
-(NSArray* )get_Method:(Class)class{
    NSMutableArray* selArr = [[NSMutableArray alloc] initWithCapacity:0];
    unsigned int methodCount =0;
    Method  *methodList = class_copyMethodList(class,&methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method temp = methodList[i];
        const char* selectorName =sel_getName(method_getName(temp));
        NSString *tempSelectorString = [NSString stringWithUTF8String:selectorName];
        [selArr addObject:tempSelectorString];
    }
    free(methodList);
    Class superClass = [class superclass];
    if (superClass) {
        NSArray *superSelArr = [self get_Method:superClass];
        [selArr addObjectsFromArray:superSelArr];
    }
    
    return [selArr copy];
}
-(BOOL)canRunToSelector:(SEL)aSelector{
    NSArray* selArr = [self get_Method:[self class]];
    NSString *selectorStr = NSStringFromSelector(aSelector);
    BOOL result = NO;
    for (NSString *obj in selArr) {
        if ([obj isEqualToString:selectorStr]) {
            result = YES;
            break;
        }
    }
     return result;
}

- (id)runSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    NSUInteger i = 1;
    if (objects.count) {
        for (id object in objects) {
            id tempObject = object;
            [invocation setArgument:&tempObject atIndex:++i];
        }
    }
    [invocation invoke];
    
    if (methodSignature.methodReturnLength) {
        id value;
        [invocation getReturnValue:&value];
        return value;
    }
    return nil;
}
@end
