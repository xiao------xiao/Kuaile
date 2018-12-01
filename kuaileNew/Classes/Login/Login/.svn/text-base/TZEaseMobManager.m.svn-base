//
//  TZEaseMobManager.m
//  刷刷
//
//  Created by 谭真 on 16/2/2.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import "TZEaseMobManager.h"
#import "TTGlobalUICommon.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK+InterfaceAdapter.h>
#import "ApplyViewController.h"

@implementation TZEaseMobManager

#pragma mark - 登录环信

+ (void)autoLogin {
    NSString *has_logout = [mUserDefaults objectForKey:@"has_logout"];
    if ([has_logout isEqualToString:@"1"]) {
        return;
    }
    NSString *strPhone = DEF_PERSISTENT_GET_OBJECT(DEF_USERNAME);
    NSString *strPassword = DEF_PERSISTENT_GET_OBJECT(DEF_USERPWD);
    if (strPhone && strPhone.length > 0 && strPassword.length > 0) {
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        RACSignal *sign = [ICEImporter loginWithUsername:strPhone password:strPassword];
        [sign subscribeNext:^(id x) {
            // 保存对象信息
            [userModel setValueWithDict:x];
            NSString *easemobUsername = userModel.phone;
            if (easemobUsername.length < 2) {
                easemobUsername = userModel.username;
            }
            
            [mUserDefaults setObject:userModel.username forKey:DEF_USERNAME];
            [mUserDefaults setObject:easemobUsername forKey:@"easeMobUsername"]; // 存储环信的用户名
            [mUserDefaults synchronize];
            
            // 登录环信的服务器
            [self loginEaseMobWithUsername:easemobUsername password:strPassword completion:nil];
        } error:^(NSError *error) {
            userModel.hasLogin = NO;
        }];
    }
}

+ (void)loginEaseMobWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL success))completion {
    // 异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username password:password completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         [[UIViewController currentViewController] hideTextHud];
         if (loginInfo && !error) {
             ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
             userModel.hasHXLogin = YES;
             
             [mUserDefaults setObject:username forKey:kSDKUsername];
             DEF_PERSISTENT_SET_OBJECT(password, DEF_USERPWD);
             // 设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
             [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             // 获取数据库中数据
             [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             // 获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             // 发送自动登陆状态通知
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             if (completion) {
                 completion(YES);
             }
             [mUserDefaults setObject:@"0" forKey:@"has_logout"];
             [mUserDefaults synchronize];
         } else {
             switch (error.errorCode) {
                 case EMErrorNotFound: TTAlertNoTitle(error.description); break;
                 case EMErrorNetworkNotConnected:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                     break;
                 case EMErrorServerNotReachable:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                     break;
                 case EMErrorServerAuthenticationFailure:
                     TTAlertNoTitle(error.description);
                     break;
                 case EMErrorServerTimeout:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                     break;
                 default:
                     //                     TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
#warning 2015 11 12 屏蔽登录错误
                 {
                     ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
                     userModel.hasHXLogin = YES;
                     userModel.hasLogin = YES;
                 }
                     break;
             }
             if (completion) {
                 completion(NO);
             }
         }
     } onQueue:nil];
}

#pragma mark - 注销环信登录

+ (void)logoutEaseMob {
    [self logoutEaseMobWithCompletion:nil];
}

+ (void)logoutEaseMobWithCompletion:(void (^)(BOOL success))completion {
    [[UIViewController currentViewController] showTextHUDWithPleaseWait];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIViewController currentViewController] hideTextHud];
                if (error && error.errorCode != EMErrorServerNotLogin) {
                    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
                    userModel.hasLogin = YES;
                    
                    // 注销失败后，继续调用注销的方法
                    [self logoutEaseMobWithCompletion:completion];
                } else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                    // 设置全局单例对象登录信息
                    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
                    userModel.hasHXLogin = NO;
                    // 注销掉第三方登录授权
                    ShareType shareType = [[mUserDefaults objectForKey:@"ShareType"] intValue];
                    [ShareSDK cancelAuthWithType:shareType];
                    if (completion) {
                        completion(YES);
                    }
                }
            });
        } onQueue:nil];
    });
}

#pragma mark - 昵称头像

+ (void)syncEaseMobInfoWithModelArray:(NSArray *)modelArray usernameKey:(NSString *)usernameKey WithCompletion:(void (^)(BOOL success))completion {
    NSMutableString *usernameStr = [NSMutableString string];
    for (NSInteger i = 0; i < modelArray.count; i++) {
        id object = modelArray[i];
        if ([object isKindOfClass:[NSString class]]) {
            [usernameStr appendFormat:@"%@,",object];
        } else {
            [usernameStr appendFormat:@"%@,",[object valueForKey:usernameKey]];
        }
    }
    if (usernameStr.length) {
        [usernameStr deleteCharactersInRange:NSMakeRange(usernameStr.length - 1, 1)];
    }
    [self syncEaseMobInfoWithUsernames:usernameStr WithCompletion:completion];
}

/// 同步昵称头像信息
+ (void)syncEaseMobInfoWithUsernames:(NSString *)usernames WithCompletion:(void (^)(BOOL success))completion {
    
    [TZHttpTool postWithURL:ApiDeletefetAvatar params:@{@"usernames":usernames} success:^(id json) {
        for (NSDictionary *dict in json[@"data"]) {
            NSString *phone = [NSString stringWithFormat:@"%@",dict[@"phone"]];
            if (phone.length) {
                [TZEaseMobManager saveNickName:dict[@"nickname"] username:dict[@"phone"]];
            } else {
                [TZEaseMobManager saveNickName:dict[@"nickname"] username:dict[@"username"]];
            }
            [TZEaseMobManager saveAvatar:dict[@"avatar"] username:dict[@"phone"]];
            [TZEaseMobManager saveAvatar:dict[@"avatar"] username:dict[@"username"]];
        }
        if (completion) {
            completion(YES);
        }
    } failure:^(NSString *msg) {
        if (completion) {
            completion(NO);
        }
    }];

}

/// 存储username对应的昵称
+ (void)saveNickName:(NSString *)nickName username:(NSString *)username {
    [mUserDefaults setObject:nickName forKey:[NSString stringWithFormat:@"%@111%@",username,username]];
    [mUserDefaults synchronize];
}

/// 取出username对应的昵称
+ (NSString *)nickNameWithUsername:(NSString *)username {
    NSString *nickname = [NSString stringWithFormat:@"%@",[mUserDefaults objectForKey:[NSString stringWithFormat:@"%@111%@",username,username]]];
    if (nickname.length && ![nickname isEqualToString:@"(null)"]) {
        return nickname;
    }
    return username;
}

/// 存储username对应的头像
+ (void)saveAvatar:(NSString *)avatar username:(NSString *)username {
    [mUserDefaults setObject:avatar forKey:[NSString stringWithFormat:@"%@1%@",username,username]];
    [mUserDefaults synchronize];
}

/// 取出username对应的头像
+ (NSString *)avatarWithUsername:(NSString *)username {
    NSString *avatar = [NSString stringWithFormat:@"%@",[mUserDefaults objectForKey:[NSString stringWithFormat:@"%@1%@",username,username]]];
    if (avatar.length && ![avatar isEqualToString:@"(null)"]) {
        return avatar;
    }
    return [ApiUserAvatar stringByAppendingString:username];
}


@end
