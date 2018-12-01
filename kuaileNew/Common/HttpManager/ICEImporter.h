//
//  ICEImporter.h
//  hxjj
//
//  Created by ttouch on 15/7/15.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
@interface ICEImporter : NSObject

#pragma mark - HTTP 

+ (RACSignal *)sendRequestWithUrl:(NSString *)urlStr params:(NSDictionary *)params;
+ (RACSignal *)sendRequestWithUrl:(NSString *)urlStr params:(NSDictionary *)params completion:(void (^)(NSDictionary *result))completion;
+ (RACSignal *)sendLoginRequestWithUrl:(NSString *)urlStr params:(NSDictionary *)params completion:(void (^)(NSDictionary *result))completion;
+ (RACSignal *)uploadFilesWithUrl:(NSString *)urlStr params:(NSDictionary *)params files:(NSArray *)filesArray;

#pragma mark - 快捷方式...

/** 删除群 */
+ (RACSignal *)delGroupWithParams:(NSMutableDictionary *)params;

/** 加好友得积分 */
+ (RACSignal *)addFriendsIntegralWithParams:(NSMutableDictionary *)params;

/** 分享的积分 */
+ (RACSignal *)shareIntegralWithParams:(NSMutableDictionary *)params;

/** 发布动态 ApiReleaseDynamic */
+ (RACSignal *)releaseDynamicWithParams:(NSMutableDictionary *)params files:(NSArray *)filesArray;

/** ApiGetMessages 系统消息 */
+ (RACSignal *)getMessagesWithParams:(NSMutableDictionary *)params;

/** ApiLifeService 生活服务 */
+ (RACSignal *)netLifeServiceWithParams:(NSMutableDictionary *)params;

/** ApiZanSns 点赞 */
+ (RACSignal *)netZanSnsWithParams:(NSMutableDictionary *)params;

/** ApiReportSns 举报*/
+ (RACSignal *)netReportSnsWithParams:(NSMutableDictionary *)params;

/** ApiCommentSns 评论*/
+ (RACSignal *)netCommentSnsWithParams:(NSMutableDictionary *)params;

/// 1 Login 登录
+ (RACSignal *)loginWithUsername:(NSString *)username password:(NSString *)password;

/// 1.1 AutoLogin 第三方登录
+ (RACSignal *)loginWithUsername:(NSString *)username nickname:(NSString *)nickname authid:(NSString *)authid authtype:(NSString *)authtype   avatar:(NSString *)avatar;

/// 2 Register 注册
+ (RACSignal *)registerWithUsername:(NSString *)username password:(NSString *)password smsCode:(NSString *)smsCode;

/// 3 find_password 忘记密码
+ (RACSignal *)frogetWithUsername:(NSString *)username password:(NSString *)password smsCode:(NSString *)smsCode sessionID:(NSString *)sessionID;

// 4 sms 获取验证码
+ (RACSignal *)smsWithPhone:(NSString *)strPhone type:(NSString *)type;

// 5 UpdateLocation 更新用户坐标
+ (RACSignal *)locationWithLatitude:(NSString *)latitude withLongitude:(NSString *)longitude;

// 5 Logout 注销
+ (void)setSessionID:(NSString *)sessionID ;

+ (RACSignal *)logout;
// -------个人中心------------------------------------------------------------------------------------------
// 获取用户积分
+ (RACSignal *)getPoint;

/** 32 password 修改密码 */
+ (RACSignal *)passwordWithOldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd uid:(NSString *)uid userName:(NSString *)userName;

/** 33 editPerson 编辑个人信息 */
+ (RACSignal *)editPersonWithKey:(NSString *)strKey value:(NSString *)strValue;

/** 34 getPerson 获取个人信息 */ 
+ (RACSignal *)getPerson:(NSString *)uid;

/** 35 sign 签到 */
+ (RACSignal *)signWithParams:(NSMutableDictionary *)params;

/** 36 isSign 是否签到 */
+ (RACSignal *)isSign;

/** 37 signRecord 签到记录 */
+ (RACSignal *)signRecordWithPage:(NSString *)page;

/** 38 JobInvension 设置求职意向 */
+ (RACSignal *)JobInvensionWithPamams:(NSDictionary *)dictParmam;

/** 39 userIntension 获取用户求职意向 */
+ (RACSignal *)userIntension;

/** 40 point_record 积分记录 */
+ (RACSignal *)pointRecordWithPage:(NSString *)page;

/** 41 ads APP首页轮播广告 */
+ (RACSignal *)ads;

// 是否审核（用户佣金）
+ (RACSignal *)identificationvWithParams:(NSMutableDictionary *)params;

// 认证（用户佣金）
+ (RACSignal *)approveWithParams:(NSMutableDictionary *)params files:(NSArray *)filesArray;

// 佣金金额
+ (RACSignal *)userCommission;

// 获取银行信息
+ (RACSignal *)bankInfo;

// 佣金提现
+ (RACSignal *)withdrawWithParam:(NSMutableDictionary *)params;

// 佣金明细
+ (RACSignal *)commissionLog;

// 工资查询
+ (RACSignal *)salaryQueryWithParam:(NSMutableDictionary *)params;

//------------------------------------------------------------------------------------------------------
/** 42 createGroup 创建群 */
+ (RACSignal *)createGroupWithParams:(NSMutableDictionary *)params files:(NSArray *)filesArray;

// 43 附近的群
+ (RACSignal *)nearGroupsParams:(NSMutableDictionary *)params;

// 44 附近的人
+ (RACSignal *)nearPeopleParams:(NSMutableDictionary *)params;

/** 45 getGroupInfo 群信息 */
+ (RACSignal *)getGroupInfoWith:(NSString *)groupID;

// 推荐群组
+ (RACSignal *)getRecommendGroups;

@end
