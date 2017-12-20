//
//  JK_WKScriptMessageHandler.h
//  JKNetWorkingDemo
//
//  Created by Jack on 2017/12/19.
//  Copyright © 2017年 姜奎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "NSObject+SelectorExtension.h"
#import "JKUtility.h"
@interface JK_WKScriptMessageHandler : NSObject<WKScriptMessageHandler>
/**delegate*/
@property (nonatomic,weak) id delegate;
+(JK_WKScriptMessageHandler*)handlerWithDelegate:(__weak id)delegate;
- (instancetype)initWith:(__weak id)delegate;
@end
