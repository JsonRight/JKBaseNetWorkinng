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
- (instancetype)initWithURLString:(NSString *)urlString
                        paramsDic:(id)paramsDic
                       upLoadData:(id)upLoadData
                         progress:(ProgressBlock)uploadProgress
                          success:(ResponseBlock)success
                          failure:(ResponseBlock)failure
{
    self = [super init];
    if (self) {
        self.timeOut = 60.f;
        self.baseHTTPMethodType = DefaultHTTPMethodType; //默认post方法
        self.baseRequestBodyType=DefaultBodyType;
        self.baseResponseDataType=DefaultDataType;
        self.isSignError = NO;
        self.isToken=NO;//默认都没有重新获取过token,当需要重新获取时置为YES
        self.baseUrl=[BaseNetWorking shareMannager].baseUrl;//API_HOST
        self.requestUrl = urlString;
        self.paramsDic = [[NSMutableDictionary alloc] initWithDictionary:paramsDic];
        self.upLoadData=[upLoadData copy];
        self.progressBlock=uploadProgress;
        self.successBlock=success;
        self.failureBlock=failure;
        self.isDlog=NO;
    }
    return self;
}
-(void)dealloc{
    
    DLog(@"Msg我释放了")
}
+(BaseSessionMessage *)createRequestHTTPWithURLString:(NSString *)urlString paramsDic:(id)paramsDic progress:(ProgressBlock)uploadProgress success:(ResponseBlock)success failure:(ResponseBlock)failure{
    return [[BaseSessionMessage alloc]initWithURLString:urlString paramsDic:paramsDic upLoadData:nil progress:uploadProgress success:success failure:failure];
}
+(BaseSessionMessage *)upLoadDataWithURLString:(NSString *)urlString paramsDic:(id)paramsDic upLoadData:(NSArray<UpLoadFileModel*> *)upLoadData progress:(ProgressBlock)uploadProgress success:(ResponseBlock)success failure:(ResponseBlock)failure{
    return [[BaseSessionMessage alloc]initWithURLString:urlString paramsDic:paramsDic upLoadData:upLoadData progress:uploadProgress success:success failure:failure];
}
-(void)sendSessionMsg{
    [[BaseNetWorking shareMannager]sendSessionMessage:self];
}


-(RequestHTTPMethodType)HTTPMethodType{
    return ^(HTTPMethodTypes type){
        self.baseHTTPMethodType=type;
        return self;
    };
}
-(RequestBodyType)requestBodyType{
    return ^(RequestBodyTypes type){
        self.baseRequestBodyType=type;
        return self;
    };
}
-(ResponseDataType)responseDataType{
    return ^(ResponseDataTypes type){
        self.baseResponseDataType=type;
        return self;
    };
}
-(TimeOut)requestTimeOut{
    return ^(CGFloat time){
        self.timeOut=time;
        return self;
    };
}
-(BaseURL)requestBaseUrl{
    return ^(NSString* baseUrl){
        self.baseUrl=baseUrl;
        return self;
    };
}
-(DlogRequest)requestDlog{
    return ^(BOOL isDlog){
        self.isDlog=isDlog;
        return self;
    };
}
-(SendSessionMessage)sendSessionMessage{
    return ^(){
        [self sendSessionMsg];
        return self;
    };
}
-(IsToken)setIsToken{
    return ^(BOOL istoken){
        self.isToken=istoken;
        return self;
    };
}
-(TokenFailMsg)setTokenFaileMsg{
    return ^(BaseSessionMessage *tokenMsg){
        self.tokenFailMsg=tokenMsg;
        return self;
    };
}

@end
@implementation UpLoadFileModel

@end

