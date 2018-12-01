//
//  TZHttpTool.m
//
//  Created by tanzhen on 15-8-25.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZHttpTool.h"
// md5加密
#import <CommonCrypto/CommonDigest.h>
#import "NetWorkStatus.h"
@implementation TZHttpTool

//+(instancetype)sharedInstance{
//    static TZHttpTool *httpTools;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        httpTools = [[TZHttpTool alloc] init];
//    });
//    return httpTools;
//}


#pragma mark 创建请求管理对象
+ (AFHTTPSessionManager *)getHttpSessionManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    return manager;
}

#pragma mark - 网络请求前处理，无网络不请求
+(BOOL)requestBeforeCheckNetWorkWithFailureBlock:(failureBlocks)errorBlock{
    BOOL isFi=[YYReachability reachability].reachable;
    if(!isFi){//无网络
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(errorBlock!=nil){
                errorBlock(nil);
                NSLog(@"无网络,请打开网络");
            }
        });
    }else{//有网络
        [NetWorkStatus startNetworkActivity];
    }
    
    return isFi;
}

#pragma mark - post
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlocks)failure
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(![self requestBeforeCheckNetWorkWithFailureBlock:failure]){
            return;
        }
        //为url编码
        NSString *urlStr = [self urlCoding:url];
        // 2.发送请求
        [[self getHttpSessionManager] POST:urlStr parameters:[self getNewParamsFromParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            NSNumber *number = responseObject[@"status"];
            if (number.integerValue == 1) {
                if (success) {
                    success(responseObject);
                }
            } else if (number.integerValue == 0) {
                NSString *msg = responseObject[@"msg"];
                if ([msg isEqualToString:@"未登录"]) {
                    [[ICELoginUserModel sharedInstance] setHasLogin:NO];
                    [CommonTools showInfo:@"登录已过期,请重新登录"];
                    [TZUserManager isLogin];
                } else {
                    if (failure) {
                        failure(msg);
                    }
                }
            }else {
                NSString *msg = responseObject[@"msg"];
                if (failure) {
                    failure(msg);
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (failure) {
                NSLog(@"网络请求日志\n请求URL：%@ \n信息：%@",url,[error.userInfo objectForKey:@"NSLocalizedDescription"]);
                failure(error.localizedDescription);
            }
        }];
        
    });
    
}


#pragma mark - post
+ (void)postWithLoginURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlocks)failure
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(![self requestBeforeCheckNetWorkWithFailureBlock:failure]){
            return;
        }
        //为url编码
        NSString *urlStr = [self urlCoding:url];
        // 2.发送请求
        [[self getHttpSessionManager] POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            NSNumber *number = responseObject[@"status"];
            if (number.integerValue == 1) {
                if (success) {
                    success(responseObject);
                }
            } else if (number.integerValue == 0) {
                NSString *msg = responseObject[@"msg"];
                if ([msg isEqualToString:@"未登录"]) {
                    [[ICELoginUserModel sharedInstance] setHasLogin:NO];
                    [CommonTools showInfo:@"登录已过期,请重新登录"];
                    [TZUserManager isLogin];
                } else {
                    if (failure) {
                        failure(msg);
                    }
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (failure) {
                NSLog(@"网络请求日志\n请求URL：%@ \n信息：%@",url,[error.userInfo objectForKey:@"NSLocalizedDescription"]);
                failure(error.localizedDescription);
            }
        }];
        
    });
    
}





#pragma mark  post 文件请求formData
+ (void)postWithUploadImages:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray process:(void (^)(NSInteger writedBytes, NSInteger totalBytes))process success:(successBlock)success failure:(failureBlocks)failure
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(![self requestBeforeCheckNetWorkWithFailureBlock:failure]){
            return;
        }
        //为url编码
        NSString *urlStr = [self urlCoding:url];
        NSArray *files = formDataArray;
        
        [[self getHttpSessionManager] POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull totalFormData) {
                for (NSInteger i = 0; i < files.count; i++) {
                    id fileItem = files[i];
                    id value = fileItem;
                    
                    NSString *fileName = [NSString stringWithFormat:@"image%zd.png",i];
                    NSString *key = @"img";
                    NSString *mimeType = @"image/jpeg";
                    if ([fileItem isKindOfClass:[NSDictionary class]]) {
                        value = [fileItem objectForKey:@"file"];     // 支持四种数据类型：NSData、UIImage、NSURL、NSString
                        key = [fileItem objectForKey:@"key"];        // 文件字段的key
                        fileName = [fileItem objectForKey:@"name"];  // 文件名称
                        mimeType = [fileItem objectForKey:@"type"];  // 文件类型
                        mimeType = mimeType ? mimeType : @"image/jpeg";
                    }
                    
                    
                    if ([value isKindOfClass:[NSData class]]) {
                        [totalFormData appendPartWithFileData:value name:key fileName:fileName mimeType:mimeType];
                    } else if ([value isKindOfClass:[UIImage class]]) {
                        [totalFormData appendPartWithFileData:UIImageJPEGRepresentation(value, 0.5) name:key fileName:fileName mimeType:mimeType];
                    } else if ([value isKindOfClass:[NSURL class]]) {
                        [totalFormData appendPartWithFileURL:value name:key fileName:fileName mimeType:mimeType error:nil];
                    } else if ([value isKindOfClass:[NSString class]]) {
                        [totalFormData appendPartWithFileURL:[NSURL URLWithString:value]  name:key fileName:fileName mimeType:mimeType error:nil];
                    }
                }


        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            float progress = (float)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            NSLog(@"文件上传进度: %.0f%% (%lld/%lld)",100*progress,uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
            if (process) {
                process((NSUInteger)uploadProgress.completedUnitCount,(NSUInteger)uploadProgress.totalUnitCount);
            }
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (failure) {
                NSLog(@"网络请求日志\n请求URL：%@ \n信息：%@",url,[error.userInfo objectForKey:@"NSLocalizedDescription"]);
                failure(error.localizedDescription);
            }
        }];
    });
    
}

#pragma mark  get请求
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlocks)failure
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(![self requestBeforeCheckNetWorkWithFailureBlock:failure]){
            return;
        }
        //为url编码
        NSString *urlStr = [self urlCoding:url];
        // 2.发送请求
        
        [[self getHttpSessionManager] GET:urlStr parameters:[self getNewParamsFromParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (failure) {
                NSLog(@"网络请求日志\n请求URL：%@ \n信息：%@",url,[error.userInfo objectForKey:@"NSLocalizedDescription"]);
                failure(error);
            }
            
        }];
        
    });
    
}

#pragma mark url编码
+ (NSString *)urlCoding:(NSString *)url{
    NSString *encodePath ;
    
    encodePath = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    return encodePath;
}

//+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *msg))failure {
//    // 1.创建请求管理者
//
//
//
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//       mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    // 2.发送请求
//    [mgr GET:url parameters:[self getNewParamsFromParams:params] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSNumber *number = responseObject[@"status"];
//        if (number.integerValue == 1) {
//            if (success) {
//                success(responseObject);
//            }
//        } else if (number.integerValue == 0) {
//            [CommonTools showInfo:responseObject[@"msg"]];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        if (failure) {
//            failure(error.localizedDescription);
//        }
//    }];
//}
//
//+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *msg))failure {
//    // 1.创建请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    // 2.发送请求
//
//    NSLog(@"url-----%@",url);
//    [mgr POST:url parameters:[self getNewParamsFromParams:params] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSNumber *number = responseObject[@"status"];
//        if (number.integerValue == 1) {
//            if (success) {
//                success(responseObject);
//            }
//        } else if (number.integerValue == 0) {
//            NSString *msg = responseObject[@"msg"];
//            if ([msg isEqualToString:@"未登录"]) {
//                [[ICELoginUserModel sharedInstance] setHasLogin:NO];
//                [CommonTools showInfo:@"登录已过期,请重新登录"];
//                [TZUserManager isLogin];
//            } else {
//                if (failure) {
//                    failure(msg);
//                }
//            }
//        }else {
//            NSString *msg = responseObject[@"msg"];
//            if (failure) {
//                failure(msg);
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        if (failure) {
//            failure(error.localizedDescription);
//        }
//    }];
//}
//
//+ (void)postLogin:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *msg))failure {
//    // 1.创建请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//
//    AFJSONResponseSerializer *response = (AFJSONResponseSerializer *)mgr.responseSerializer;
//    response.removesKeysWithNullValues = YES;
//
//
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    // 2.发送请求
//    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSNumber *number = responseObject[@"status"];
//        if (number.integerValue == 1) {
//            if (success) {
//                success(responseObject);
//            }
//        } else if (number.integerValue == 0) {
//            NSString *msg = responseObject[@"msg"];
//            if ([msg isEqualToString:@"未登录"]) {
//                [[ICELoginUserModel sharedInstance] setHasLogin:NO];
//                [CommonTools showInfo:@"登录已过期,请重新登录"];
//                [TZUserManager isLogin];
//            } else {
//                if (failure) {
//                    failure(msg);
//                }
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        if (failure) {
//            failure(error.localizedDescription);
//        }
//    }];
//}
//
///// 上传多张图片（多个请求）
//+ (void)uploadOperationToUrl:(NSString *)url
//                      params:(NSDictionary *)params
//                       files:(NSArray *)files
//                     process:(void (^)(NSInteger writedBytes, NSInteger totalBytes))process
//                    complete:(void (^)(BOOL successed, NSDictionary *result))complete
//                 completeOne:(void (^)(BOOL successed, NSDictionary *result))completeOne {
//    NSMutableArray *mutableOperations = [NSMutableArray array];
//
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    for (NSInteger i = 0; i < files.count; i++) {
//        id fileItem = files[i];
//        id value = fileItem;
//        NSString *fileName = [NSString stringWithFormat:@"image%zd.png",i];
//        NSString *key = @"img";
//        NSString *mimeType = @"image/jpeg";
//        if ([fileItem isKindOfClass:[NSDictionary class]]) {
//            value = [fileItem objectForKey:@"file"];     // 支持四种数据类型：NSData、UIImage、NSURL、NSString
//            key = [fileItem objectForKey:@"key"];        // 文件字段的key
//            fileName = [fileItem objectForKey:@"name"];  // 文件名称
//            mimeType = [fileItem objectForKey:@"type"];  // 文件类型
//            mimeType = mimeType ? mimeType : @"image/jpeg";
//        }
//        NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:[self getNewParamsFromParams:params] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            if ([value isKindOfClass:[NSData class]]) {
//                [formData appendPartWithFileData:value name:key fileName:fileName mimeType:mimeType];
//            } else if ([value isKindOfClass:[UIImage class]]) {
//                [formData appendPartWithFileData:UIImageJPEGRepresentation(value, 0.5) name:key fileName:fileName mimeType:mimeType];
//            } else if ([value isKindOfClass:[NSURL class]]) {
//                [formData appendPartWithFileURL:value name:key fileName:fileName mimeType:mimeType error:nil];
//            } else if ([value isKindOfClass:[NSString class]]) {
//                [formData appendPartWithFileURL:[NSURL URLWithString:value] name:key fileName:fileName mimeType:mimeType error:nil];
//            }
//        } error:nil];
//
//        AFHTTPRequestOperation *operation = nil;
//        AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
//        operationManager.responseSerializer.acceptableContentTypes = nil;
//        operation = [operationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if (completeOne) { completeOne(true, responseObject); }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            if (completeOne) { completeOne(false, nil); }
//        }];
//        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//            float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
//            NSLog(@"文件上传进度: %.0f%% (%lld/%lld)",100*progress,totalBytesWritten,totalBytesExpectedToWrite);
//            if (process) {
//                process((NSUInteger)totalBytesWritten,(NSUInteger)totalBytesExpectedToWrite);
//            }
//        }];
//        [mutableOperations addObject:operation];
//    }
//    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
//        NSLog(@"已上传%zd个文件，共%zd个文件", numberOfFinishedOperations, totalNumberOfOperations);
//    } completionBlock:^(NSArray *operations) {
//        NSLog(@"所有文件上传完成");
//        if (complete) {  complete(YES,nil); }
//    }];
//    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
//}
//
///// 上传多张图片(一个请求)
//+ (void)uploadOperationToUrl:(NSString *)url
//                      params:(NSDictionary *)params
//                       files:(NSArray *)files
//                    complete:(void (^)(BOOL successed, NSDictionary *result))complete {
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (NSInteger i = 0; i < files.count; i++) {
//            id fileItem = files[i];
//            id value = fileItem;
//            NSString *fileName = [NSString stringWithFormat:@"image%zd.png",i];
//            NSString *key = @"img";
//            NSString *mimeType = @"image/jpeg";
//            if ([fileItem isKindOfClass:[NSDictionary class]]) {
//                value = [fileItem objectForKey:@"file"];     // 支持四种数据类型：NSData、UIImage、NSURL、NSString
//                key = [fileItem objectForKey:@"key"];        // 文件字段的key
//                fileName = [fileItem objectForKey:@"name"];  // 文件名称
//                mimeType = [fileItem objectForKey:@"type"];  // 文件类型
//                mimeType = mimeType ? mimeType : @"image/jpeg";
//            }
//
//            if ([value isKindOfClass:[NSData class]]) {
//                [formData appendPartWithFileData:value name:key fileName:fileName mimeType:mimeType];
//            } else if ([value isKindOfClass:[UIImage class]]) {
//                [formData appendPartWithFileData:UIImageJPEGRepresentation(value, 0.5) name:key fileName:fileName mimeType:mimeType];
//            } else if ([value isKindOfClass:[NSURL class]]) {
//                [formData appendPartWithFileURL:value name:key fileName:fileName mimeType:mimeType error:nil];
//            } else if ([value isKindOfClass:[NSString class]]) {
//                [formData appendPartWithFileURL:[NSURL URLWithString:value]  name:key fileName:fileName mimeType:mimeType error:nil];
//            }
//        }
//    } error:nil];
//
//    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
//    operationManager.responseSerializer.acceptableContentTypes = nil;
//    AFHTTPRequestOperation *operation = [operationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (complete) { complete(true, responseObject); }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (complete) { complete(false, nil); }
//    }];
//    [operation start];
//}
//
///// 上传单张图片
//+ (void)uploadImageWithUrl:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image completion:(void (^)(NSDictionary *result, NSError *error))completion {
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:imageData name:@"img" fileName:@"imageName.png" mimeType:@"image/jpeg"];
//    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        if (completion) {
//            completion(responseObject[@"data"], nil);
//        }
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        if (completion) {
//            completion(nil, error);
//        }
//    }];
//}
//
#pragma mark - 私有方法

+ (NSDictionary *)getNewParamsFromParams:(NSDictionary *)params {
    NSMutableDictionary *newParams = [[NSMutableDictionary alloc] initWithDictionary:params];

    if (![newParams.allKeys containsObject:@"sessionid"]) {
        newParams[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
//        if (![TZUserManager isLoginNoPresent]) {
//            newParams[@"sessionid"] = @"";
//        }

    }


    [newParams addEntriesFromDictionary:[self getEncrypt]];
    return newParams;
}

/// 时间戳 + "ttouch2015"  MD5下: 生成a7f19dfb05f1f43d9a0c1093324825ce
+ (NSDictionary *)getEncrypt {
    // 时间戳
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString* strTime = [NSString stringWithFormat:@"%0.f",timeStamp];
    // 密钥
    NSString *reqtoken = [strTime stringByAppendingString:@"ttouch2016"];
    NSString *reqtokenMD5 = [self MD5:reqtoken];
    
    
    // authToken
    NSString *authToken = [mUserDefaults objectForKey:@"authToken"] ? [mUserDefaults objectForKey:@"authToken"] : @"";
    // appVersion
    NSString *appVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    // @"1457752582"   @"b25d5942bcb308198ad0f51cfe18f2c2"
    NSDictionary *tokenKey = @{@"time":strTime,@"token":reqtokenMD5, @"authToken":authToken,@"device":@"2",@"appVersion":appVersion};
    return tokenKey;
}

/// 对字符串进行MD5加密
+ (NSString *)MD5:(NSString *)aStr {
    if (aStr == nil || aStr.length == 0) {
        return nil;
    }
    const char *value = [aStr UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02x",outputBuffer[i]];
    }
    return outputString;
}

@end


