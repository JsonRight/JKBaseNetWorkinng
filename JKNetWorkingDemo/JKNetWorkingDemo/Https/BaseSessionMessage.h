//
//  BaseSessionMessage.h
//  HaoLyy
//
//  Created by jk on 2017/3/10.
//  Copyright © 2017年 jk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseSessionMessage,UpLoadFileModel;

typedef NS_OPTIONS(NSUInteger, HTTPMethodTypes) {
    PostType                = 1 << 0,
    GetType                 = 1 << 1,
    UpLoadDataType          = 1<<2,
    DefaultHTTPMethodType   = PostType,
};
typedef NS_OPTIONS(NSUInteger, RequestBodyTypes) {
    HTTPBodyType            = 1 << 0,
    PropertyListBodyType    = 1<<1,
    JSONBodyType            = 1<<2,
    DefaultBodyType         = HTTPBodyType,
};
typedef NS_OPTIONS(NSUInteger, ResponseDataTypes) {
    JSONDataType            = 1 << 0,
    HTTPDataType            = 1 << 1,
    DefaultDataType         = JSONDataType,
};
typedef BaseSessionMessage *(^RequestHTTPMethodType)(HTTPMethodTypes type);
typedef BaseSessionMessage *(^RequestBodyType)(RequestBodyTypes type);
typedef BaseSessionMessage *(^ResponseDataType)(ResponseDataTypes type);
typedef BaseSessionMessage *(^TimeOut)(CGFloat time);
typedef BaseSessionMessage *(^BaseURL)(NSString* urlStr);
typedef BaseSessionMessage *(^DlogRequest)(BOOL delog);
typedef BaseSessionMessage *(^SendSessionMessage)(void);


typedef BaseSessionMessage *(^IsToken)(BOOL isToken);
typedef BaseSessionMessage *(^TokenFailMsg)(BaseSessionMessage* tokenFailMsg);


typedef void (^ProgressBlock) (NSProgress *progress);
typedef void (^ResponseBlock) (BaseSessionMessage *sessionMsg);


@interface BaseSessionMessage : NSObject
@property (nonatomic , assign)HTTPMethodTypes baseHTTPMethodType;
@property (nonatomic , assign)RequestBodyTypes baseRequestBodyType;
@property (nonatomic , assign)ResponseDataTypes baseResponseDataType;
@property (nonatomic , assign)CGFloat timeOut;//请求超时时间
@property (nonatomic , copy) NSString *baseUrl;//请求url
@property (nonatomic , copy) NSString *requestUrl;//请求url
@property (nonatomic , copy) NSString *encryptedUrlString;//加密后的url
@property (nonatomic , strong) NSDictionary *paramsDic;//参数字典
@property (nonatomic, copy) NSArray <UpLoadFileModel * > * upLoadData;//上传数据

@property (nonatomic , assign)BOOL isDlog;
@property (nonatomic , copy , readonly)RequestHTTPMethodType HTTPMethodType;//get or post 设置
@property (nonatomic , copy , readonly)RequestBodyType requestBodyType;// 请求数据类型
@property (nonatomic , copy , readonly)ResponseDataType responseDataType;//返回数据类型
@property (nonatomic , copy , readonly)TimeOut requestTimeOut;//超时设置
@property (nonatomic , copy , readonly)BaseURL requestBaseUrl;//baseURL设置
@property (nonatomic , copy , readonly)DlogRequest requestDlog;//打印分析
@property (nonatomic , copy , readonly)SendSessionMessage sendSessionMessage;//发起请求

@property (nonatomic, copy) ProgressBlock progressBlock;//处理下载进度的块
@property (nonatomic, copy) ResponseBlock successBlock;//网络请求成功回调块
@property (nonatomic, copy) ResponseBlock failureBlock;//网络请求失败回调块

#pragma mark - 服务器端正确响应信息
@property (nonatomic, strong) NSData *responseData;//响应数据，原始的二进制数据
@property (nonatomic, copy) NSString *responseString;//响应数据,原始的二进制数据转换成的JSON字符串
@property (nonatomic, strong) NSMutableDictionary *jsonItems;//解析服务器返回的原始json字符串得到的字典，共有3个键：ret,data和msg.ret对应状态码，data对应返回数据主体，msg对应服务器返回提示信息
@property (nonatomic, strong) NSDictionary *dataDic;//服务器返回数据主体,对应data字段

@property(nonatomic,strong)NSString* flag;//错误码
@property(nonatomic,strong)NSString* lockerFlag;//错误码的摘要
@property(nonatomic,strong)NSString* msg;//错误码的详细描述


#pragma mark - Token专用
@property (nonatomic, assign) BOOL isSignError;
@property (nonatomic, assign) BOOL isToken;
@property (nonatomic, strong) BaseSessionMessage *tokenFailMsg;//因为token实效等待重新发送的消息
@property (nonatomic , copy , readonly)IsToken setIsToken;
@property (nonatomic , copy , readonly)TokenFailMsg setTokenFaileMsg;

/*普通接口*/
+(BaseSessionMessage* )createRequestHTTPWithURLString:(NSString *)urlString
                                            paramsDic:(id)paramsDic
                                             progress:(ProgressBlock)uploadProgress
                                              success:(ResponseBlock)success
                                              failure:(ResponseBlock)failure;
/*上传数据*/
+(BaseSessionMessage* )upLoadDataWithURLString:(NSString *)urlString
                                     paramsDic:(id)paramsDic
                                    upLoadData:(NSArray<UpLoadFileModel*>*)upLoadData
                                      progress:(ProgressBlock)uploadProgress
                                       success:(ResponseBlock)success
                                       failure:(ResponseBlock)failure;

@end
//上传数据使用
@interface UpLoadFileModel : NSObject
@property (nonatomic, copy) NSData   * data;//二进制数据
@property (nonatomic, copy) NSString * name;//名称
@property (nonatomic, copy) NSString * fileName;//文件名
@property (nonatomic, copy) NSString * mimeType;//文件类型

@end

