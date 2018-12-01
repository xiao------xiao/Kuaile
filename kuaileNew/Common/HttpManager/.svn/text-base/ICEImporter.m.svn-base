//
//  ICEImporter.m
//  hxjj
//
//  Created by ttouch on 15/7/15.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICEImporter.h"

@implementation ICEImporter

+ (void)load {
    NSString *sessionID = [mUserDefaults objectForKey:@"sessionid"];
    if (!sessionID) {
        [mUserDefaults setObject:@"0" forKey:@"sessionid"];
        [mUserDefaults synchronize];
    }
}

+ (void)setSessionID:(NSString *)sessionID {
    [mUserDefaults setObject:sessionID forKey:@"sessionid"];
    
    NSLog(@"12121112 %@", [mUserDefaults objectForKey:@"sessionid"]);
    [mUserDefaults synchronize];
//    [mUserDefaults ]
}


#pragma mark - HTTP

+ (RACSignal *)sendRequestWithUrl:(NSString *)urlStr params:(NSDictionary *)params {
    return [self sendRequestWithUrl:urlStr params:params completion:nil];
}

+ (RACSignal *)sendRequestWithUrl:(NSString *)urlStr params:(NSDictionary *)params completion:(void (^)(NSDictionary *result))completion {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [TZHttpTool postWithLoginURL:urlStr params:params success:^(NSDictionary *result) {
            NSLog(@"%@",result);
            [subscriber sendNext:result];
            [subscriber sendCompleted];
            if (completion) {
                completion(result);
            }
        } failure:^(NSString *msg) {
            [CommonTools showInfo:msg];
            [[UIViewController currentViewController] hideTextHud];
            [subscriber sendError:[NSError errorWithDomain:msg code:0 userInfo:nil]];
        }];
        return nil;
    }];
}

+ (RACSignal *)sendLoginRequestWithUrl:(NSString *)urlStr params:(NSDictionary *)params completion:(void (^)(NSDictionary *result))completion {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
       
        [TZHttpTool postWithURL:urlStr params:params success:^(NSDictionary *result) {
          NSLog(@"login result  --- %@",result);
            [subscriber sendNext:result];
            [subscriber sendCompleted];
            if (completion) {
                completion(result);
            }
        } failure:^(NSString *msg) {
//            [CommonTools showInfo:msg];
            [[UIViewController currentViewController] hideTextHud];
            [subscriber sendError:[NSError errorWithDomain:msg code:0 userInfo:nil]];
        }];
        return nil;
    }];
}

+ (RACSignal *)uploadFilesWithUrl:(NSString *)urlStr params:(NSDictionary *)params files:(NSArray *)filesArray {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [TZHttpTool postWithUploadImages:urlStr params:params formDataArray:filesArray process:nil success:^(NSDictionary *result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failure:^(NSString *msg) {
            
            [CommonTools showInfo:msg];
            [[UIViewController currentViewController] hideTextHud];
            [subscriber sendError:[NSError errorWithDomain:msg code:0 userInfo:nil]];
        }];
//
//        [TZHttpTool postWithUploadImages:urlStr params:params formDataArray:filesArray complete:^(BOOL successed, NSDictionary *result) {
//            if (successed) {
//                [subscriber sendNext:result];
//                [subscriber sendCompleted];
//            } else {
//                [CommonTools showInfo:result[@"msg"]];
//                [[UIViewController currentViewController] hideTextHud];
//                [subscriber sendError:[NSError errorWithDomain:result[@"msg"] code:0 userInfo:nil]];
//            }
//        }];
        return nil;
    }];
}

#pragma mark - 快捷方式...

/** 删除群 */
+ (RACSignal *)delGroupWithParams:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiAddFriendsIntegral params:params];
}

/** 加好友得积分 */
+ (RACSignal *)addFriendsIntegralWithParams:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiAddFriendsIntegral params:params];
}

/** 分享的积分 */
+ (RACSignal *)shareIntegralWithParams:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiShareIntegral params:params];
}

/** 发布动态 ApiReleaseDynamic */
+ (RACSignal *)releaseDynamicWithParams:(NSDictionary *)params files:(NSArray *)filesArray {
    return [self uploadFilesWithUrl:ApiReleaseDynamic params:params files:filesArray];
}

/** ApiGetMessages 系统消息 */
+ (RACSignal *)getMessagesWithParams:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiGetMessages params:params];
}

/** ApiLifeService 生活服务 */
+ (RACSignal *)netLifeServiceWithParams:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiLifeService params:params];
}

/** ApiZanSns 点赞*/
+ (RACSignal *)netZanSnsWithParams:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiZanSns params:params];
}

/** ApiReportSns 举报*/
+ (RACSignal *)netReportSnsWithParams:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiReportSns params:params];
}

/** ApiCommentSns 评论*/
+ (RACSignal *)netCommentSnsWithParams:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiCommentSns params:params];
}

// 5 UpdateLocation 更新用户坐标
+ (RACSignal *)locationWithLatitude:(NSString *)latitude withLongitude:(NSString *)longitude {
    NSDictionary *params = @{ @"lat" : latitude, @"lng" : longitude };
    return [self sendRequestWithUrl:ApiUpdateLocation params:params];
}

/// 1 Login 登录
+ (RACSignal *)loginWithUsername:(NSString *)username password:(NSString *)password {
    
    NSString *client_id = DEF_PERSISTENT_GET_OBJECT(CLIENT_ID);
//    NSDictionary *params = @{ @"client_id" : client_id, @"username" : username , @"password" : password };
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = client_id;
    params[@"username"] = username;
    params[@"password"] = password;
    params[@"lat"] = [mUserDefaults objectForKey:@"latitude"];
    params[@"lng"] = [mUserDefaults objectForKey:@"longitude"];
    return [self sendLoginRequestWithUrl:ApiLogin params:params completion:^(NSDictionary *result) {
        NSString *sessID = result[@"data"][@"sessionid"];
        if (sessID != nil) {
            [self setSessionID:result[@"data"][@"sessionid"]];
        }
        // 保存uid
        [mUserDefaults setObject:result[@"data"][@"username"] forKey:@"user_username"];
        [mUserDefaults setObject:result[@"data"][@"uid"] forKey:@"userUid"];
        [mUserDefaults setObject:result[@"data"][@"rid"] forKey:@"rid"];
        [mUserDefaults synchronize];
    }];
}

/// 1.1 AutoLogin 第三方登录
+ (RACSignal *)loginWithUsername:(NSString *)username nickname:(NSString *)nickname authid:(NSString *)authid authtype:(NSString *)authtype avatar:(NSString *)avatar {
    NSString *client_id = DEF_PERSISTENT_GET_OBJECT(CLIENT_ID);
    NSString *lat = [mUserDefaults objectForKey:@"latitude"];
    NSString *lng = [mUserDefaults objectForKey:@"longitude"];
    if (!lat) {
        lat = @" ";  
    }
    
    if (!lng) {
        lng = @" ";
    }
    
    NSDictionary *params = @{ @"client_id" : client_id, @"username" : username ,@"nickname" : nickname ,@"authid" : authid ,@"authtype" : authtype ,@"avatar" : avatar,@"lat" : lat,@"lng" : lng};
    
    return [self sendRequestWithUrl:ApiAuthLogin params:params completion:^(NSDictionary *result) {
        
        
        NSString * sessID = result[@"sessionid"];
        
//        NSString *sessID = [result[@"data"] objectForKey:@"sessionid"];
        if (sessID != nil) {
            [self setSessionID:sessID];
        }
        // 保存uid
        [mUserDefaults setObject:result[@"data"][@"uid"] forKey:@"userUid"];
        [mUserDefaults synchronize];
    }];
}

/// 2 Register 注册
+ (RACSignal *)registerWithUsername:(NSString *)username password:(NSString *)password smsCode:(NSString *)smsCode {
    NSDictionary *params = @{ @"phone" : username, @"code" : smsCode, @"password" : password, @"re-password" : password };
    return [self sendRequestWithUrl:ApiRegister params:params];
}

/// 3 find_password 忘记密码
+ (RACSignal *)frogetWithUsername:(NSString *)username password:(NSString *)password smsCode:(NSString *)smsCode sessionID:(NSString *)sessionID {
    NSDictionary *params = @{ @"username" : username, @"code" : smsCode, @"password" : password };
    return [self sendRequestWithUrl:ApiFindPassword params:params];
}

// 2 Sms 获取验证码
+ (RACSignal *)smsWithPhone:(NSString *)strPhone type:(NSString *)type {
    return [self sendRequestWithUrl:ApiSms params:@{ @"phone" : strPhone, @"type": type }];
}

// 5 Logout 注销
+ (RACSignal *)logout {
    // 注销成功 下次启动时不自动登录
    [mUserDefaults setObject:@"1" forKey:@"has_logout"];
    [mUserDefaults synchronize];
    return [self sendRequestWithUrl:ApiLogout params:[self getEncrypt]];
}

// -------个人中心------------------------------------------------

/** 32 password 修改密码 */
+ (RACSignal *)passwordWithOldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd uid:(NSString *)uid userName:(NSString *)userName {
    NSDictionary *params = @{
                             @"username" : userName,
                             @"phone" : [mUserDefaults objectForKey:@"easeMobUsername"],
                             @"uid" : uid,
                             @"old_pwd" : oldPwd,
                             @"pwd" : newPwd
                             };
    return [self sendRequestWithUrl:ApiPassword params:params];
}

/** 33 editPerson 编辑个人信息 */
+ (RACSignal *)editPersonWithKey:(NSString *)strKey value:(NSString *)strValue {
    return [self sendRequestWithUrl:ApiEditPerson params:@{ strKey : strValue }];
}

/** 34 getPerson 获取个人信息 */
+ (RACSignal *)getPerson:(NSString *)username {
    NSDictionary *params;
    if (username) {
        params = @{ @"username" : username };
    }
    return [self sendRequestWithUrl:ApiGetPerson params:params];
}

/** 35 sign 签到 */
+ (RACSignal *)signWithParams:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiSign params:params];
}

/** 36 isSign 是否签到 */
+ (RACSignal *)isSign {
    return [self sendRequestWithUrl:ApiIsSign params:nil];
}

/** 37 signRecord 签到记录 */
+ (RACSignal *)signRecordWithPage:(NSString *)page {
    return [self sendRequestWithUrl:ApiSignRecord params:@{ @"page" : page }];
}

/** 38 JobInvension 设置求职意向 */
+ (RACSignal *)JobInvensionWithPamams:(NSDictionary *)dictParmam {
    return [self sendRequestWithUrl:ApiJobInvension params:dictParmam];
}

/** 39 userIntension 获取用户求职意向 */
+ (RACSignal *)userIntension {
    return [self sendRequestWithUrl:ApiUserInvension params:nil];
}

/** 40 point_record 积分记录 */
+ (RACSignal *)pointRecordWithPage:(NSString *)page  {
    return [self sendRequestWithUrl:ApiPointRecord params:@{ @"page" : page }];
}

/** 41 userIntension 获取用户求职意向 */
+ (RACSignal *)ads {
    return [self sendRequestWithUrl:ApiAds params:nil];
}

// 是否审核（用户佣金）
+ (RACSignal *)identificationvWithParams:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiIdentificationv params:params];
}

// 认证（用户佣金）
+ (RACSignal *)approveWithParams:(NSDictionary *)params files:(NSArray *)filesArray {
    return [self uploadFilesWithUrl:ApiApprove params:params files:filesArray];
}

// 佣金金额
+ (RACSignal *)userCommission {
    return [self sendRequestWithUrl:ApiUserCommission params:nil];
}

// 获取银行信息
+ (RACSignal *)bankInfo {
    return [self sendRequestWithUrl:ApiBankInfo params:nil];
}

// 佣金提现
+ (RACSignal *)withdrawWithParam:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiWithdraw params:params];
}

// 佣金明细
+ (RACSignal *)commissionLog {
    return [self sendRequestWithUrl:ApiCommissionLog params:nil];
}

// 获取用户积分
+ (RACSignal *)getPoint {
    return [self sendRequestWithUrl:ApiGetPoint params:nil];
}

// 工资查询
+ (RACSignal *)salaryQueryWithParam:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiSalaryQuery params:params];
}

//------------------------------------------------------------------------------------------------------
/** 42 createGroup 创建群 */
+ (RACSignal *)createGroupWithParams:(NSDictionary *)params files:(NSArray *)filesArray {
    return [self uploadFilesWithUrl:ApiCreateGroup params:params files:filesArray];
}

// 43 附近的群
+ (RACSignal *)nearGroupsParams:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiNearGroups params:params];
}

// 44 附近的人
+ (RACSignal *)nearPeopleParams:(NSDictionary *)params {
    return [self sendRequestWithUrl:ApiNearPeople params:params];
}

// 推荐群组
+ (RACSignal *)getRecommendGroups {
    return [self sendRequestWithUrl:ApiGetRecommendGroups params:nil];
}

/** 45 getGroupInfo 群信息 */
+ (RACSignal *)getGroupInfoWith:(NSString *)groupID {
    return [self sendRequestWithUrl:ApiGetGroupInfo params:@{ @"group_id" : groupID }];
}

#pragma mark - 私有方法

/**
 *  时间戳 + “HX2015”     md5下；生成a7f19dfb05f1f43d9a0c1093324825ce
 */
+ (NSDictionary *)getEncrypt {
    // 时间戳
    //NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    //NSString* strTime = [NSString stringWithFormat:@"%0.f",timeStamp];
    
    // 密钥
    //NSString *reqtoken = [strTime stringByAppendingString:__ICEAFHttpEncryptKey];
    //NSString *reqtokenMD5 = [reqtoken md5];
    
    // @"time"  : strTime, @"token" : reqtokenMD5,
    NSDictionary *tokenKey;
    NSString *sessionid = [mUserDefaults objectForKey:@"sessionid"];
    if (sessionid.length && ![sessionid isEqualToString:@"0"]) {
        tokenKey = @{ @"sessionid" : sessionid};
    }
    return tokenKey;
}

@end

