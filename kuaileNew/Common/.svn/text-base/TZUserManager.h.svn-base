//
//  TZUserManager.h
//  刷刷
//
//  Created by 谭真 on 16/1/24.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYUserInfoModel.h"

@class TZUserModel,ICEGetCityModel,XYUserInfoModel,TZResumeModel;
@interface TZUserManager : NSObject

/// 同步个人信息
+ (void)syncUserModel;
+ (void)syncUserModelWithCompletion:(void (^)(XYUserInfoModel *model))completion;

/// 获得当前登录用户的个人信息
+ (XYUserInfoModel *)getUserModel;

/// 同步二维码
+ (void)syncUserQR;
+ (void)syncUserQRWithCompletion:(void (^)(NSString *qrStr))completion;
+ (NSString *)getUserQR;


/// 同步个人好友
+ (void)syncUserFriends:(NSArray *)friends;
+ (NSArray *)getUserFriends;

/// 同步个人群组
+ (void)syncUserGroups:(NSArray *)Groups;
+ (NSArray *)getUserGroups;

/// 同步个人通讯录
+ (void)syncUserContact:(NSArray *)contact;
+ (NSArray *)getUserContact;

/// 同步个人帖子
+ (void)syncUserSns:(NSArray *)sns;
+ (NSArray *)getUserSns;

/// 缓存动态，美拍，广场，老乡帖子
+ (void)syncSameTownSnsWithSns:(NSArray *)sns tag:(NSInteger)tag;
+ (NSArray *)getSameTownSnsWithTag:(NSInteger)tag;

/// 缓存推荐群组
+ (void)syncRecommendGroupWithGroup:(NSArray *)group tag:(NSInteger)tag;
+ (NSArray *)getRecommendGroupWithTag:(NSInteger)tag;

/// 缓存附近的人
+ (void)syncNearPeopleWithPeoples:(NSArray *)group;
+ (NSArray *)getNearPeoples;

/// 同步公司福利
+ (void)syncCompanyWelfare;
+ (void)syncCompanyWelfareWithCompletion:(void (^)(NSArray *models))completion;
+ (NSArray *)getCompanyWelfare;

/// 同步个人佣金余额
+ (void)syncUserCommission;
+ (void)syncUserCommissionWithCompletion:(void (^)(NSString *commission))completion;
+ (NSString *)getUserCommission;

/// 同步个人默认简历
+ (void)syncUserDefaultResumeWithModel:(TZResumeModel *)model;
+ (TZResumeModel *)getUserDefaultResume;

/// 缓存附近的群
+ (void)syncUserNearGroupsWithGroups:(NSArray *)groups;
+ (NSArray *)getUserNearGroups;

/// 缓存附近的人
+ (void)syncUserNearPeoplesWithPeoples:(NSArray *)peoples;
+ (NSArray *)getUserNearPeoples;


/// 存储
+ (void)saveWelfareDataWithModels:(NSArray *)models;
+ (TZResumeModel *)getSavedWelfareData;

+ (void)getNETUserModelWithCompletion:(void (^)(XYUserInfoModel *model))completion;
+ (void)postUpdateInfoNotification;

/// 版本更新
+ (void)syncAppVersion;
+ (void)syncAppVersionWithComplete:(void (^)(NSString *version))complete;

/// 设置当前登录用户的个人信息
+ (void)setUserModelWithDict:(NSDictionary *)dict;

///同步服务城市信息
+ (NSArray *)getCityModels;
+ (void)syncCityModelArray;
+ (void)syncCityModelArrayComplete:(void (^)(NSArray *models))complete;


/// 是否是登录状态,如果不是，弹出登录控制器
+ (BOOL)isLogin;
/// 是否是登录状态,如果不是，不弹出登录控制器
+ (BOOL)isLoginNoPresent;

+ (NSString *)userUid;

@end

@interface TZUserModel : NSObject
@property (nonatomic, copy) NSString *userUid;
@property (nonatomic, copy) NSString *weibo;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *roleId;
@property (nonatomic, copy) NSString *tel;

@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, copy) NSString *sex;  /// < 1 男  2女
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *hobby;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *registerIp;
@property (nonatomic, copy) NSString *logoPath;
@property (nonatomic, copy) NSString *tradePassStates;

@property (nonatomic, copy) NSString *attendNum;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *wechat;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *lastIp;
@property (nonatomic, copy) NSString *studentNum;

@property (nonatomic, copy) NSArray *roleList;
@property (nonatomic, copy) NSString *cardnum;

@property (nonatomic, copy) NSString *lastTime;     ///<
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *point;
@property (nonatomic, copy) NSString *continue_sign_days;

@end

/*
 weibo = ,
	introduce = ,
	id = 397361,
	company = ,
	cardTypeList = [
 ],
	educationList = [
 ],
	attendNum = 0,
	location = ,
	wechat = ,
	nickname = banchi,
	roleId = 0,
	tel = ,
	registerIp = 116.231.224.254,
	logoPath = http://139.196.4.252/resource/user/icon?key=icon/defaultPhoto.png,
	skillList = [
 ],
	roleList = [
 {
 status = 1002,
 remark = ,
 createBy = 1227,
 id = 1,
 updateTime = 00-00-00 00:00:00,
 roleName = ROLE_STUDENT,
 updateBy = 0,
 description = ,
 name = 学生,
 createTime = 2015-12-14 15:05:22
 }
 ],
	email = ,
	updateTime = 2016-05-30 11:17:08,
	tradePassStates = 0,
	birthday = ,
	from = 0,
	name = ,
	createdBy = 0,
	trade = ,
	status = 1002,
	lastIp = 116.231.230.71,
	studentNum = 0,
	sign = ,
	cardnum = ,
	job = ,
	gender = 0,
	qq = ,
	createTime = 2016-05-30 11:17:08,
	lastTime = 2016-05-30 17:53:43,
	phone = 18817325735
 */
