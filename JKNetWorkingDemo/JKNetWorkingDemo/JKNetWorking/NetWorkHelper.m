//
//  NetWorkHelper.m
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/10.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import "NetWorkHelper.h"
#import "JKNetWorking.h"

@implementation SessionManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestTimeOut(60.0f);
        self.delayRepeatTimeOut(0.0f);
        self.requestCount(1);
        self.HTTPMethodType(DefaultHTTPMethodType);
        self.requestBodyType(DefaultBodyType);
        self.responseDataType(DefaultDataType);
        self.requestBaseURL([JKNetWorking shareMannager].baseUrl);
        self.requestDlog(YES);
        self.requestGroup(nil);
    }
    return self;
}

- (void)dealloc{
    
    JKNetWorkDLog(@"Msg我释放了")
}

- (RequestHTTPMethodType)HTTPMethodType{
    return ^(HTTPMethodTypes type){
        self->HTTPMethodType = type;
        return self;
    };
}

- (RequestBodyType)requestBodyType{
    return ^(RequestBodyTypes type){
        self->RequestBodyType = type;
        return self;
    };
}

- (ResponseDataType)responseDataType{
    return ^(ResponseDataTypes type){
        self->ResponseDataType = type;
        return self;
    };
}
- (AuthorizationHeaderField)requestAuthorizationHeaderField{
    return ^(NSString* username,NSString* password){
        self->username = username;
        self->password = password;
        return self;
    };
}
- (RequestHTTPHeaders)requestHTTPHeaders{
    return ^(NSDictionary <NSString *, NSString *> *HTTPRequestHeaders){
        self->HTTPRequestHeaders = HTTPRequestHeaders;
        return self;
    };
}

- (TimeOut)requestTimeOut{
    return ^(CGFloat time){
        self->timeOut = time<=0?60:time;
        return self;
    };
}

- (TimeOut)delayRepeatTimeOut{
    return ^(CGFloat time){
        self->delayTimeOut = time<=0?0:time;
        return self;
    };
}

- (RequestCount)requestCount{
    return ^(NSUInteger count){
        self->requestCount = count;
        return self;
    };
}

- (BaseURL)requestBaseURL{
    return ^(NSString* baseUrl){
        self->baseUrl = baseUrl;
        return self;
    };
}

- (RequestUrl)requestURL{
    return ^(NSString* requestUrl){
        self->requestUrl = requestUrl;
        return self;
    };
}

- (RequestParams)paramsDic{
    return ^(id paramsDic){
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict addEntriesFromDictionary:paramsDic];
        self->params = dict;
        return self;
    };
}

- (UpLoadData)upLoadDataArr{
    return ^(NSArray<UpLoadFileModel*> *upLoadData){
        self->upLoadData = upLoadData;
        return self;
    };
}

- (DlogRequest)requestDlog{
    return ^(BOOL isDlog){
        self->isDlog = isDlog;
        return self;
    };
}

- (JK_Progress)progressBlock{
    return ^(ProgressBlock block){
        self->progressBlock = block;
        return self;
    };
}

- (JK_Success)successBlock{
    return ^(ResponseBlock block){
        self->successBlock = block;
        return self;
    };
}

- (JK_Failure)failureBlock{
    return ^(ResponseBlock block){
        self->failureBlock = block;
        return self;
    };
}

- (RequestGroup)requestGroup{
    return ^(dispatch_group_t group){
        self->group = group?group:dispatch_group_create();
        return self;
    };
}

extern SessionManager *SessionManagerMake(UploadSessionManager make){
    SessionManager * sessionMsg = [[SessionManager alloc]init];
    if (make) make(sessionMsg);
    if (sessionMsg->group) dispatch_group_enter(sessionMsg->group);
    return sessionMsg;
};

@end

@implementation UpLoadFileModel

@end


@implementation NetWorkHelper

extern void NetWorkMake(UploadSessionManager make){
    if (make) {
        SessionManager * sessionMsg = SessionManagerMake(make);
        if (sessionMsg->requestCount-- <= 0) {
            JKNetWorkDLog(@"无效请求")
            return;
        }
        [[JKNetWorking shareMannager] sendSessionMessage:sessionMsg];
    }else {
        JKNetWorkDLog(@"无效请求")
        return;
    }
};

extern void NetWorkMakesGroup(NSArray <SessionManager *> * sessionMsgs , NetWorkRequestGroupBlock reduceBlock){
    dispatch_group_t group = dispatch_group_create();
    if (!(sessionMsgs&&sessionMsgs.count>0)) {
        return;
    }
    for (SessionManager * sessionMsg in sessionMsgs) {
        if (sessionMsg->group&&sessionMsg->requestCount-- > 0) {
            dispatch_group_enter(group);
            dispatch_group_notify(sessionMsg->group, dispatch_get_main_queue(), ^{
                dispatch_group_leave(group);
            });
            [[JKNetWorking shareMannager] sendSessionMessage:sessionMsg];
        }else {
            JKNetWorkDLog(@"无效请求:%@",sessionMsg);
            continue;
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (reduceBlock) reduceBlock();
    });
};

@end
