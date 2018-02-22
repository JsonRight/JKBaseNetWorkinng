//
//  BaseSessionMessage.h
//  HaoLyy
//
//  Created by jk on 2017/3/10.
//  Copyright © 2017年 jk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyHelper.h"
#import <UIKit/UIKit.h>

@class BaseSessionMessage,UpLoadFileModel;

typedef NS_OPTIONS(NSUInteger, HTTPMethodTypes) {
    PostType                = 1 << 0,
    GetType                 = 1 << 1,
    UpLoadDataType          = 1 << 2,
    HEADType                = 1 << 3,
    PUTType                 = 1 << 4,
    PATCHType               = 1 << 5,
    DELETEType              = 1 << 6,
    DefaultHTTPMethodType   = PostType,
};
typedef NS_OPTIONS(NSUInteger, RequestBodyTypes) {
    HTTPBodyType            = 1 << 0,
    PropertyListBodyType    = 1 << 1,
    JSONBodyType            = 1 << 2,
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
typedef BaseSessionMessage *(^AuthorizationHeaderField)(NSString *username, NSString* password);
typedef BaseSessionMessage *(^RequestHTTPHeaders)(NSDictionary <NSString *, NSString *> *HTTPRequestHeaders);
typedef BaseSessionMessage *(^TimeOut)(CGFloat time);
typedef BaseSessionMessage *(^RequestCount)(NSInteger count);
typedef BaseSessionMessage *(^BaseURL)(NSString* urlStr);
typedef BaseSessionMessage *(^RequestGroup)(dispatch_group_t group);
typedef BaseSessionMessage *(^DlogRequest)(BOOL delog);
typedef BaseSessionMessage *(^SendSessionMessage)(void);
typedef void (^UploadSessionMessage)(BaseSessionMessage *make);
typedef void (^ProgressBlock) (NSProgress *progress);
typedef void (^ResponseBlock) (BaseSessionMessage *sessionMsg);
typedef void (^NetWorkRequestGroupBlock) (void);

@interface BaseSessionMessage : NSObject
{
@public
    HTTPMethodTypes HTTPMethodType;//请求格式
    RequestBodyTypes RequestBodyType;//请求体格式
    ResponseDataTypes ResponseDataType;//返回体格式
    NSString *username;//Authorization---username
    NSString *password;//Authorization---password
    NSDictionary <NSString *, NSString *> *HTTPRequestHeaders;//请求头
    CGFloat timeOut;//请求超时时间
    NSInteger requestCount;//请求次数
    NSString *baseUrl;//请求url
    NSString *requestUrl;//请求url
    NSString *encryptedUrlString;//加密后的url
    NSMutableDictionary *paramsDic;//参数字典
    NSArray <UpLoadFileModel * > * upLoadData;//上传数据
    BOOL isDlog;//是否打印
    dispatch_group_t group;
    ProgressBlock progressBlock;//处理下载进度的块
    ResponseBlock successBlock;//网络请求成功回调块
    ResponseBlock failureBlock;//网络请求失败回调块
}

@property (nonatomic , copy , readonly)RequestHTTPMethodType requestHTTPMethodType;//get or post 设置
@property (nonatomic , copy , readonly)RequestBodyType requestBodyType;// 请求数据类型
@property (nonatomic , copy , readonly)ResponseDataType responseDataType;//返回数据类型
@property (nonatomic , copy , readonly)AuthorizationHeaderField requestAuthorizationHeaderField;//设置http用户验证
@property (nonatomic , copy , readonly)RequestHTTPHeaders requestHTTPHeaders;//设置请求头
@property (nonatomic , copy , readonly)TimeOut requestTimeOut;//超时设置
@property (nonatomic , copy , readonly)RequestCount requestCount;//请求次数设置
@property (nonatomic , copy , readonly)BaseURL requestBaseUrl;//baseURL设置
@property (nonatomic , copy , readonly)DlogRequest requestDlog;//打印分析
@property (nonatomic , copy , readonly)RequestGroup requestGroup;//请求组设置
@property (nonatomic , copy , readonly)SendSessionMessage sendSessionMessage;//打印分析


#pragma mark - 服务器端正确响应信息
@property (nonatomic , strong) NSData *responseData;//响应数据，原始的二进制数据
@property (nonatomic , copy) NSString *responseString;//响应数据,原始的二进制数据转换成的JSON字符串
@property (nonatomic , strong) NSMutableDictionary *jsonItems;//解析服务器返回的原始json字符串得到的字典，

//初始化方法1
extern BaseSessionMessage *SessionMessage(UploadSessionMessage make);
extern void SessionMessageGroup(NSArray <BaseSessionMessage * > * sessionMessage, NetWorkRequestGroupBlock reduceBlock);
//初始化方法2
//初始化方法 二选一
+ (BaseSessionMessage*)createSessionMessage:(void(^)(BaseSessionMessage *make))make;

/*普通接口*/
- (BaseSessionMessage *)requestHTTPWithURLString:(NSString *)urlString
                                             paramsDic:(id)paramsDic
                                              progress:(ProgressBlock)uploadProgress
                                               success:(ResponseBlock)success
                                               failure:(ResponseBlock)failure;
/*上传数据*/
- (BaseSessionMessage *)upLoadDataWithURLString:(NSString *)urlString
                                      paramsDic:(id)paramsDic
                                     upLoadData:(NSArray<UpLoadFileModel*> *)upLoadData
                                       progress:(ProgressBlock)uploadProgress
                                        success:(ResponseBlock)success
                                        failure:(ResponseBlock)failure;
+ (void)combineLatest:(NSArray <BaseSessionMessage * > *)sessionMessages reduce:(void(^)(void))reduceBlock;
@end

//上传数据使用
@interface UpLoadFileModel : NSObject
@property (nonatomic, copy) NSData   * data;//二进制数据
@property (nonatomic, copy) NSString * name;//名称
@property (nonatomic, copy) NSString * fileName;//文件名
@property (nonatomic, copy) NSString * mimeType;//文件类型

@end

