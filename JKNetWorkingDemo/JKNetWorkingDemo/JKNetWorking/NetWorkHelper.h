//
//  NetWorkHelper.h
//  JKNetWorkingDemo
//
//  Created by 姜奎 on 2018/8/10.
//  Copyright © 2018年 姜奎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NetWorkHelper,SessionManager,UpLoadFileModel;

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
typedef SessionManager *(^RequestHTTPMethodType)(HTTPMethodTypes type);
typedef SessionManager *(^RequestBodyType)(RequestBodyTypes type);
typedef SessionManager *(^ResponseDataType)(ResponseDataTypes type);
typedef SessionManager *(^AuthorizationHeaderField)(NSString *username, NSString* password);
typedef SessionManager *(^RequestHTTPHeaders)(NSDictionary <NSString *, NSString *> *HTTPRequestHeaders);
typedef SessionManager *(^TimeOut)(CGFloat time);
typedef SessionManager *(^RequestCount)(NSUInteger count);
typedef SessionManager *(^BaseURL)(NSString* baseUrl);
typedef SessionManager *(^RequestUrl)(NSString* requestUrl);
typedef SessionManager *(^RequestParams)(id paramsDic);
typedef SessionManager *(^UpLoadData)(NSArray<UpLoadFileModel*> *upLoadData);
typedef SessionManager *(^RequestGroup)(dispatch_group_t group);
typedef SessionManager *(^DlogRequest)(BOOL delog);

typedef void (^UploadSessionManager)(SessionManager *make);
typedef void (^ProgressBlock) (NSProgress *progress);
typedef void (^ResponseBlock) (SessionManager *sessionMsg);
typedef void (^NetWorkRequestGroupBlock) (void);

typedef SessionManager *(^JK_Progress)(ProgressBlock progressBlock);
typedef SessionManager *(^JK_Success)(ResponseBlock successBlock);
typedef SessionManager *(^JK_Failure)(ResponseBlock failureBlock);

@interface SessionManager : NSObject
{
@public
    HTTPMethodTypes HTTPMethodType;//请求格式
    RequestBodyTypes RequestBodyType;//请求体格式
    ResponseDataTypes ResponseDataType;//返回体格式
    NSString *username;//Authorization---username
    NSString *password;//Authorization---password
    NSDictionary <NSString *, NSString *> *HTTPRequestHeaders;//请求头
    CGFloat timeOut;//请求超时时间
    CGFloat delayTimeOut;//请求超时时间
    NSUInteger requestCount;//请求次数
    NSString *baseUrl;//请求url
    NSString *requestUrl;//请求url
    NSString *encryptedUrlString;//加密后的url
    NSMutableDictionary *params;//参数字典
    NSArray <UpLoadFileModel * > * upLoadData;//上传数据
    BOOL isDlog;//是否打印
    dispatch_group_t group;
    ProgressBlock progressBlock;//处理下载进度的块
    ResponseBlock successBlock;//网络请求成功回调块
    ResponseBlock failureBlock;//网络请求失败回调块
}

@property (nonatomic , copy , readonly)RequestHTTPMethodType HTTPMethodType;//get or post 设置
@property (nonatomic , copy , readonly)RequestBodyType requestBodyType;// 请求数据类型
@property (nonatomic , copy , readonly)ResponseDataType responseDataType;//返回数据类型
@property (nonatomic , copy , readonly)AuthorizationHeaderField requestAuthorizationHeaderField;//设置http用户验证
@property (nonatomic , copy , readonly)RequestHTTPHeaders requestHTTPHeaders;//设置请求头
@property (nonatomic , copy , readonly)TimeOut requestTimeOut;//超时设置
@property (nonatomic , copy , readonly)TimeOut delayRepeatTimeOut;//延时二次请求超时设置
@property (nonatomic , copy , readonly)RequestCount requestCount;//请求次数设置
@property (nonatomic , copy , readonly)BaseURL requestBaseURL;//baseURL设置
@property (nonatomic , copy , readonly)RequestUrl requestURL;//URL设置
@property (nonatomic , copy , readonly)RequestParams paramsDic;//参数字典
@property (nonatomic , copy , readonly)UpLoadData upLoadDataArr;//上传数据
@property (nonatomic , copy , readonly)DlogRequest requestDlog;//打印分析
@property (nonatomic , copy , readonly)JK_Progress progressBlock;//处理下载进度的块
@property (nonatomic , copy , readonly)JK_Success successBlock;//网络请求成功回调块
@property (nonatomic , copy , readonly)JK_Failure failureBlock;//网络请求失败回调块
@property (nonatomic , copy , readonly)RequestGroup requestGroup;//请求组设置

#pragma mark - 服务器端正确响应信息
@property (nonatomic , strong) NSData *responseData;//响应数据，原始的二进制数据
@property (nonatomic , copy) NSString *responseString;//响应数据,原始的二进制数据转换成的JSON字符串
@property (nonatomic , strong) NSMutableDictionary *jsonItems;//解析服务器返回的原始json字符串得到的字典，

//初始化方法1
extern SessionManager *SessionManagerMake(UploadSessionManager make);

@end

//上传数据使用
@interface UpLoadFileModel : NSObject
@property (nonatomic, copy) NSData   * data;//二进制数据
@property (nonatomic, copy) NSString * name;//名称
@property (nonatomic, copy) NSString * fileName;//文件名
@property (nonatomic, copy) NSString * mimeType;//文件类型

@end

@interface NetWorkHelper : NSObject

extern NSURLSessionDataTask * NetWorkMake(UploadSessionManager make);
/*请求组*/
extern void NetWorkMakesGroup(NSArray <SessionManager *> * sessionMsgs , NetWorkRequestGroupBlock reduceBlock);

@end
