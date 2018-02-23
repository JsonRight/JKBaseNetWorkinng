//
//  BaseSessionMessage.m
//  HaoLyy
//
//  Created by jk on 2017/3/10.
//  Copyright © 2017年 jk. All rights reserved.
//

#import "BaseSessionMessage.h"
#import "BaseNetWorking.h"
@implementation BaseSessionMessage
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
        self.requestBaseUrl([BaseNetWorking shareMannager].baseUrl);
        self.requestDlog(NO);
        self.requestGroup(nil);
    }
    return self;
}

- (void)dealloc{
    
    DLog(@"Msg我释放了")
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

- (BaseURL)requestBaseUrl{
    return ^(NSString* baseUrl){
        self->baseUrl = baseUrl;
        return self;
    };
}

- (DlogRequest)requestDlog{
    return ^(BOOL isDlog){
        self->isDlog = isDlog;
        return self;
    };
}

- (RequestGroup)requestGroup{
    return ^(dispatch_group_t group){
        self->group = group?group:dispatch_group_create();
        return self;
    };
}

- (SendSessionMessage)sendSessionMessage{
    return ^(){
        if (self->requestCount-- <= 0) return self;
        [[BaseNetWorking shareMannager] sendSessionMessage:self];
        return self;
    };
}

+ (BaseSessionMessage*)createSessionMessage:(void(^)(BaseSessionMessage *make))make{
    BaseSessionMessage * baseSessionMessage = [[BaseSessionMessage alloc]init];
    if (make) make(baseSessionMessage);
    if (baseSessionMessage->group) dispatch_group_enter(baseSessionMessage->group);
    return baseSessionMessage;
}

- (BaseSessionMessage *)requestHTTPWithURLString:(NSString *)urlString
                                       paramsDic:(id)paramsDic
                                        progress:(ProgressBlock)uploadProgress
                                         success:(ResponseBlock)success
                                         failure:(ResponseBlock)failure{
    
    self->paramsDic = [[NSMutableDictionary alloc] initWithDictionary:paramsDic];
    self->progressBlock = uploadProgress;
    self->successBlock = success;
    self->failureBlock = failure;
    self.sendSessionMessage();
    return self;
}

- (BaseSessionMessage *)upLoadDataWithURLString:(NSString *)urlString
                                      paramsDic:(id)paramsDic
                                     upLoadData:(NSArray<UpLoadFileModel*> *)upLoadData
                                       progress:(ProgressBlock)uploadProgress
                                        success:(ResponseBlock)success
                                        failure:(ResponseBlock)failure{
    self->paramsDic = [[NSMutableDictionary alloc] initWithDictionary:paramsDic];
    self->upLoadData = [upLoadData copy];
    self->progressBlock = uploadProgress;
    self->successBlock = success;
    self->failureBlock = failure;
    self.sendSessionMessage();
    return self;
}
+ (void)combineLatest:(NSArray <BaseSessionMessage * > *)sessionMessages reduce:(NetWorkRequestGroupBlock)reduceBlock{
    dispatch_group_t group = dispatch_group_create();
    for (BaseSessionMessage *sessionMessage in sessionMessages) {
        if (sessionMessage->group) {
            dispatch_group_enter(group);
            dispatch_group_notify(sessionMessage->group, dispatch_get_main_queue(), ^{
                dispatch_group_leave(group);
            });
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (reduceBlock) reduceBlock();
    });
}

@end
extern BaseSessionMessage *SessionMessage(UploadSessionMessage make){
    BaseSessionMessage * baseSessionMessage = [[BaseSessionMessage alloc]init];
    if (make) make(baseSessionMessage);
    if (baseSessionMessage->group) dispatch_group_enter(baseSessionMessage->group);
    return baseSessionMessage;
};
extern void SessionMessageGroup(NSArray <BaseSessionMessage * > * sessionMessages , NetWorkRequestGroupBlock reduceBlock){
    dispatch_group_t group = dispatch_group_create();
    for (BaseSessionMessage *sessionMessage in sessionMessages) {
        if (sessionMessage->group) {
            dispatch_group_enter(group);
            dispatch_group_notify(sessionMessage->group, dispatch_get_main_queue(), ^{
                dispatch_group_leave(group);
            });
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (reduceBlock) reduceBlock();
    });
};
@implementation UpLoadFileModel

@end

