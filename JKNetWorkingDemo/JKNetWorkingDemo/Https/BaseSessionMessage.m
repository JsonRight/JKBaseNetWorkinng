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
        self->timeOut = 60.f;
        self->requestCount = 1;
        self->HTTPMethodType = DefaultHTTPMethodType; //默认post方法
        self->RequestBodyType = DefaultBodyType;
        self->ResponseDataType = DefaultDataType;
        self->baseUrl = [BaseNetWorking shareMannager].baseUrl;//API_HOST
        self->isDlog = NO;
    }
    return self;
}

- (void)dealloc{
    
    DLog(@"Msg我释放了")
}

- (void)sendSessionMsg{
    [[BaseNetWorking shareMannager] sendSessionMessage:self];
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
        self->timeOut = time;
        return self;
    };
}

- (RequestCount)requestCount{
    return ^(NSInteger count){
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
        self->group = group;
        return self;
    };
}

- (SendSessionMessage)sendSessionMessage{
    return ^(){
        [[BaseNetWorking shareMannager] sendSessionMessage:self];
        return self;
    };
}

+ (BaseSessionMessage*)createSessionMessage:(void(^)(BaseSessionMessage *make))make{
    BaseSessionMessage * baseSessionMessage = [[BaseSessionMessage alloc]init];
    if (make) make(baseSessionMessage);
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

@end
extern BaseSessionMessage *SessionMessage(UploadSessionMessage make){
    BaseSessionMessage * baseSessionMessage = [[BaseSessionMessage alloc]init];
    if (make) make(baseSessionMessage);
    return baseSessionMessage;
};
@implementation UpLoadFileModel

@end

