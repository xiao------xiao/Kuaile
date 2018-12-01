//
//  TZHttpTool.h
//
//  Created by tanzhen on 15-8-25.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;
typedef NS_ENUM(NSInteger, HttpErrorType) {
    HttpErrorTypeNormal=0,//请求正常，无错误
    
    HttpErrorTypeURLConnectionError,//请求时出错，可能是URL不正确
    
    HttpErrorTypeStatusCodeError,//请求时出错，服务器未返回正常的状态码：200
    
    HttpErrorTypeDataNilError,//请求回的Data在解析前就是nil，导致请求无效，无法后续JSON反序列化。
    
    HttpErrorTypeDataSerializationError,//data在JSON反序列化时出错
    
    HttpErrorTypeNoNetWork,//无网络连接
    
    HttpErrorTypeServiceRetrunErrorStatus,//服务器请求成功，但抛出错误
};

typedef void (^successBlock)(NSDictionary *result);

typedef void (^errorBlock)(HttpErrorType errorType);
typedef void (^failureBlocks)(NSString *msg);
@interface TZHttpTool : NSObject

//+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *msg))failure;
//+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *msg))failure;
//
//+ (void)postLogin:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *msg))failure;
//
///// 上传多张图片(多个请求)
//+ (void)uploadOperationToUrl:(NSString *)url
//                      params:(NSDictionary *)params
//                       files:(NSArray *)files
//                     process:(void (^)(NSInteger writedBytes, NSInteger totalBytes))process
//                    complete:(void (^)(BOOL successed, NSDictionary *result))complete
//                 completeOne:(void (^)(BOOL successed, NSDictionary *result))completeOne;
///// 上传多张图片(一个请求)
//+ (void)uploadOperationToUrl:(NSString *)url
//                      params:(NSDictionary *)params
//                       files:(NSArray *)files
//                    complete:(void (^)(BOOL successed, NSDictionary *result))complete;
//
///// 上传单张图片
//+ (void)uploadImageWithUrl:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image completion:(void (^)(NSDictionary *result, NSError *error))completion;




+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlocks)failure;
+ (void)postWithLoginURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlocks)failure;
+ (void)postWithUploadImages:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray process:(void (^)(NSInteger writedBytes, NSInteger totalBytes))process success:(successBlock)success failure:(failureBlocks)failure;
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlocks)failure;


@end


