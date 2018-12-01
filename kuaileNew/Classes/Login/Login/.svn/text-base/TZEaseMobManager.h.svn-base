//
//  TZEaseMobManager.h
//  刷刷
//
//  Created by 谭真 on 16/2/2.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZEaseMobManager : NSObject

/// 登录环信
+ (void)autoLogin;
+ (void)loginEaseMobWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL success))completion;

/// 注销环信登录
+ (void)logoutEaseMob;
+ (void)logoutEaseMobWithCompletion:(void (^)(BOOL success))completion;

#pragma mark - 昵称头像

/// 同步昵称头像信息
+ (void)syncEaseMobInfoWithModelArray:(NSArray *)modelArray usernameKey:(NSString *)usernameKey WithCompletion:(void (^)(BOOL success))completion;
+ (void)syncEaseMobInfoWithUsernames:(NSString *)usernames WithCompletion:(void (^)(BOOL success))completion;

/// 存储username对应的昵称
+ (void)saveNickName:(NSString *)nickName username:(NSString *)username;
/// 取出username对应的昵称
+ (NSString *)nickNameWithUsername:(NSString *)username;
/// 存储username对应的头像
+ (void)saveAvatar:(NSString *)avatar username:(NSString *)username;
/// 取出username对应的头像
+ (NSString *)avatarWithUsername:(NSString *)username;

@end
