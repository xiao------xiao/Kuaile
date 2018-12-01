//
//  TZUserManager.m
//  刷刷
//
//  Created by 谭真 on 16/1/24.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import "TZUserManager.h"
#import "XYCityModel.h"
#import "XYWelfareModel.h"
#import "XYUserInfoModel.h"
#import "TZFindSnsModel.h"
#import "TZResumeModel.h"
#import "XYGroupInfoModel.h"
#import "XYRecommendFriendModel.h"


#define UserInfoFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_info_%@.file",[mUserDefaults objectForKey:@"userUid"]]])
#define CityFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"city.file"]])
#define WelfareFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"welfare.file"]])
#define SavedWelfareFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"saved_welfare.file"]])
#define UserSnsFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_sns.file"]])
#define UserCommissionFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_commission.file"]])
#define UserDefaultResumeFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_DefaultResume.file"]])
#define UserFriendsFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_friends.file"]])
#define UserGroupsFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_groups.file"]])
#define UserContactsFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_contacts.file"]])
#define UserNearGroupsFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_nearGroups.file"]])
#define UserNearPeoplesFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_nearPeoples.file"]])
#define UserSametownSnsFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_sameTownSns.file"]])

#define UserSametownSnsFilePath(tag) ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_sameTownSns(%zd).file",tag]])
#define UserRecommendGroupFilePath(tag) ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_recommendGroup(%zd).file",tag]])

@implementation TZUserManager

#pragma mark - 所有数据

+ (void)load {
    NSString *uid = [mUserDefaults objectForKey:@"userUid"];
    NSString *city = [mUserDefaults objectForKey:@"city"];
    if (!uid) {
        [mUserDefaults setObject:@"0" forKey:@"userUid"];
    }
    if (!city) {
        [mUserDefaults setObject:@"37" forKey:@"city"];
    }
    [mUserDefaults synchronize];
}

/// 同步个人信息
+ (void)syncUserModel {
    [self syncUserModelWithCompletion:nil];
}

+ (void)syncUserModelWithCompletion:(void (^)(XYUserInfoModel *model))completion {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiProfileInfo params:@{@"sessionid":sessionId} success:^(NSDictionary *result) {
        [TZUserManager setUserModelWithDict:result[@"data"]];
        XYUserInfoModel *model = [XYUserInfoModel mj_objectWithKeyValues:result[@"data"]];
        
//        SCLoginManager *lgM = [SCLoginManager shareLoginManager];
//        if (model.nickname.length > 0 && model.nickname) {
//            lgM.nickname = model.nickname;
//        } else {
//            lgM.nickname = model.username;
//        }
        [mNotificationCenter postNotificationName:@"didUpdateMemberInfo" object:nil];

        if (completion) {
            completion(model);
        }
    } failure:^(NSString *msg) {
    }];
}

/// 获得当前登录用户的个人信息
+ (XYUserInfoModel *)getUserModel {
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoFilePath];
    XYUserInfoModel *model = [XYUserInfoModel mj_objectWithKeyValues:dict];
    return model;
}

/// 设置当前登录用户的个人信息
+ (void)setUserModelWithDict:(NSDictionary *)dict {

//    if (dict[@"name"]) {
//        [mUserDefaults setObject:dict[@"name"] forKey:@"realName"];
//    }
    
    NSString *name = [dict objectForKey:@"name"];
    if ([CommonTools isNotNull:name]) {
        if (name && name.length) {
            [mUserDefaults setObject:dict[@"name"] forKey:@"realName"];
        }
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login"];
    [[NSUserDefaults standardUserDefaults] setObject:dict[@"uid"] forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
//    NSString *code = [dict objectForKey:@"qrcode"];
//     [mUserDefaults setObject:code forKey:@"QRCode"];
    
    
    BOOL saveSuccess = [NSKeyedArchiver archiveRootObject:dict toFile:UserInfoFilePath];
    if (!saveSuccess) {
        NSLog(@"个人信息保存失败");
    }
}


+ (void)postUpdateInfoNotification {
    [mNotificationCenter postNotificationName:@"didUpdateMemberInfo" object:nil];
}

/// 版本更新
+ (void)syncAppVersion {
    [self syncAppVersionWithComplete:nil];
}
+ (void)syncAppVersionWithComplete:(void (^)(NSString *version))complete {
    
    [TZHttpTool postWithURL:ApiItunesConnect params:nil success:^(NSDictionary *result) {
        NSDictionary *dict = [[result[@"results"] mj_JSONObject] firstObject];
        NSString *lastVersion = [dict objectForKey:@"version"];
        [mUserDefaults setObject:lastVersion forKey:@"lastVersion"];
        [mUserDefaults synchronize];
    } failure:^(NSString *msg) {
        
    }];
    
   
}


/// 同步二维码
+ (void)syncUserQR {
    [self syncUserQRWithCompletion:nil];
}


+ (void)syncUserQRWithCompletion:(void (^)(NSString *qrStr))completion {
    
    NSString *sessonId = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiGetRecruitQR params:@{@"sessionid":sessonId} success:^(NSDictionary *result) {
        NSString *code = result[@"data"][@"qrcode"];
        if (completion) {
            completion(code);
        }
        [mUserDefaults setObject:code forKey:@"QRCode"];
    } failure:^(NSString *msg) {
    }];
}
+ (NSString *)getUserQR {
    return [mUserDefaults objectForKey:@"QRCode"];
}


/// 同步个人好友
+ (void)syncUserFriends:(NSArray *)friends {
    BOOL success = [NSKeyedArchiver archiveRootObject:friends toFile:UserFriendsFilePath];
}

+ (NSArray *)getUserFriends {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:UserFriendsFilePath];
    return [XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:array];
}

/// 同步个人群组
+ (void)syncUserGroups:(NSArray *)Groups {
    BOOL success = [NSKeyedArchiver archiveRootObject:Groups toFile:UserGroupsFilePath];
    if (success) {
        NSLog(@"同步个人群组成功");
    }
}
+ (NSArray *)getUserGroups {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:UserGroupsFilePath];
    return [XYGroupInfoModel mj_objectArrayWithKeyValuesArray:array];
}

/// 同步个人通讯录
+ (void)syncUserContact:(NSArray *)contact {
    BOOL success = [NSKeyedArchiver archiveRootObject:contact toFile:UserContactsFilePath];
    if (success) {
        NSLog(@"同步个人群组成功");
    }

}
+ (NSArray *)getUserContact {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:UserContactsFilePath];
}


// 同步个人帖子
+ (void)syncUserSns {
    [self syncUserSnsWithCompletion:nil];
}
+ (void)syncUserSnsWithCompletion:(void (^)(NSArray *models))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @1;
    params[@"uid"] = [mUserDefaults objectForKey:@"userUid"];
    [TZHttpTool postWithURL:ApiSnsUserList params:params success:^(NSDictionary *result) {
        NSArray *array = result[@"data"][@"sns"];
        NSArray *userSns = [TZFindSnsModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"sns"]];
        NSString *totalPage = [NSString stringWithFormat:@"%zd",[result[@"data"][@"count_page"] integerValue]];
        [mUserDefaults setObject:totalPage forKey:@"sns_totalPage"];
        if (completion) {
            completion(userSns);
        }
//        BOOL success = [NSKeyedArchiver archiveRootObject:userSns toFile:UserSnsFilePath];
        BOOL success = [NSKeyedArchiver archiveRootObject:array toFile:UserSnsFilePath];
        if (success) {
            NSLog(@"保存用户帖子成功");
        }
    } failure:^(NSString *msg) {
        
    }];
}

+ (void)syncUserSns:(NSArray *)sns {
    BOOL success = [NSKeyedArchiver archiveRootObject:sns toFile:UserSnsFilePath];
    NSLog(@"----缓存自己帖子成功");
}

+ (NSArray *)getUserSns {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:UserSnsFilePath];
    return [TZFindSnsModel mj_objectArrayWithKeyValuesArray:array];
}

/// 缓存帖子
+ (void)syncSameTownSnsWithSns:(NSArray *)sns tag:(NSInteger)tag {
    BOOL success = [NSKeyedArchiver archiveRootObject:sns toFile:UserSametownSnsFilePath(tag)];
    NSLog(@"----缓存成功");
}
+ (NSArray *)getSameTownSnsWithTag:(NSInteger)tag {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:UserSametownSnsFilePath(tag)];
    return [TZFindSnsModel mj_objectArrayWithKeyValuesArray:array];
}

/// 缓存推荐群组
+ (void)syncRecommendGroupWithGroup:(NSArray *)group tag:(NSInteger)tag {
    [NSKeyedArchiver archiveRootObject:group toFile:UserRecommendGroupFilePath(tag)];
}
+ (NSArray *)getRecommendGroupWithTag:(NSInteger)tag {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:UserRecommendGroupFilePath(tag)];
    return [XYGroupInfoModel mj_objectArrayWithKeyValuesArray:array];
}




/// 同步个人默认简历
+ (void)syncUserDefaultResumeWithModel:(TZResumeModel *)model {
    BOOL success = [NSKeyedArchiver archiveRootObject:model toFile:UserDefaultResumeFilePath];
    if (success) {
        NSLog(@"同步成功");
    }
}
+ (TZResumeModel *)getUserDefaultResume {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:UserDefaultResumeFilePath];
}


/// 同步附近的人
+ (void)syncUserNearPeoplesWithPeoples:(NSArray *)peoples{
    [NSKeyedArchiver archiveRootObject:peoples toFile:UserNearPeoplesFilePath];
}

+ (NSArray *)getUserNearPeoples {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:UserNearPeoplesFilePath];
    return [NearPeople mj_objectArrayWithKeyValuesArray:array];
}


/// 同步公司福利
+ (void)syncCompanyWelfare {
    [self syncCompanyWelfareWithCompletion:nil];
}
+ (void)syncCompanyWelfareWithCompletion:(void (^)(NSArray *models))completion {
    [TZHttpTool postWithURL:ApiAllWelfares params:nil success:^(NSDictionary *result) {
        NSArray *welfares = [XYWelfareModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (completion) {
            completion(welfares);
        }
        BOOL success = [NSKeyedArchiver archiveRootObject:welfares toFile:WelfareFilePath];
        if (success) {
            NSLog(@"保存成功");
        }
    } failure:^(NSString *msg) {
    }];
}
+ (NSArray *)getCompanyWelfare {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:WelfareFilePath];
}


+ (void)saveWelfareDataWithModels:(NSArray *)models {
    [NSKeyedArchiver archiveRootObject:models toFile:SavedWelfareFilePath];
}
+ (NSArray *)getSavedWelfareData {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:SavedWelfareFilePath];
}

+ (void)getNETUserModelWithCompletion:(void (^)(XYUserInfoModel *model))completion {
    //ApiGetPerson
    [TZHttpTool postWithURL:ApiProfileInfo params:nil success:^(NSDictionary * json) {
        [TZUserManager setUserModelWithDict:json[@"data"]];
        if (completion) {
            TZUserModel *model = [TZUserModel mj_objectWithKeyValues:json[@"data"]];
            completion(model);
        }
    } failure:^(NSString *error) {
        [[UIViewController currentViewController] showErrorHUDWithError:error];
    }];
}


+ (NSArray *)getCityModels {
   return [NSKeyedUnarchiver unarchiveObjectWithFile:CityFilePath];
}

+ (void)syncCityModelArray {
    [self syncCityModelArrayComplete:nil];
}

+ (void)syncCityModelArrayComplete:(void (^)(NSArray *models))complete {
    [TZHttpTool postWithURL:ApiGetCitys params:nil success:^(NSDictionary *result) {
        NSArray *models = [XYCityModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        BOOL success = [NSKeyedArchiver archiveRootObject:models toFile:CityFilePath];
        if (!success) {
            DLog(@"保存失败");
        }
        if (complete) {
            complete(models);
        }
    } failure:^(NSString *msg) {
    
    }];
}

/// 用户佣金余额
+ (void)syncUserCommission {
    [self syncUserCommissionWithCompletion:nil];
}
+ (void)syncUserCommissionWithCompletion:(void (^)(NSString *commission))completion {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiUserCommission params:@{@"sessionid":sessionId} success:^(NSDictionary *result) {
        NSString *commission = result[@"data"][@"commission"];
        if (completion) {
            completion(commission);
        }
        [NSKeyedArchiver archiveRootObject:commission toFile:UserCommissionFilePath];
    } failure:^(NSString *msg) {
        //
    }];
}
+ (NSString *)getUserCommission {
    NSString *commission = [NSKeyedUnarchiver unarchiveObjectWithFile:UserCommissionFilePath];
    return commission;
}

+ (BOOL)isLogin {
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    // 这里控制标签栏的登录 通过 ! 取反
    BOOL islo = userModel.isLogin;
    BOOL ishx = userModel.isHXLogin;
    if (!userModel.isLogin || !userModel.isHXLogin) {
        ICELoginViewController *iCELogin = [[ICELoginViewController alloc] init];
        iCELogin.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        TZNaviController *navi = [[TZNaviController alloc] initWithRootViewController:iCELogin];
        [[UIViewController currentViewController] presentViewController:navi animated:YES completion:nil];
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)isLoginNoPresent {
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    // 这里控制标签栏的登录 通过 ! 取反
    if (!userModel.isLogin || !userModel.isHXLogin) {
        return NO;
    } else {
        return YES;
    }
}

+ (NSString *)userUid {
    return [NSString stringWithFormat:@"%@",[mUserDefaults objectForKey:@"userUid"]];
}

+ (NSString *)account {
    return [mUserDefaults objectForKey:@"mobile"];
}

+ (NSString *)password {
    return [mUserDefaults objectForKey:@"password"];
}

@end


@implementation TZUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userUid":@"id"};
}

- (void)setNickname:(NSString *)nickname {
    _nickname = nickname;
    if (!_name) {
        _name = nickname;
    }
}

#pragma mark - 头像

#pragma mark - 私有方法

- (void)calculateDistance {
    /*
     BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([[mUserDefaults objectForKey:@"lat"] doubleValue],[[mUserDefaults objectForKey:@"lng"] doubleValue]));
     BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(self.lat.doubleValue,self.lng.doubleValue));
     self.distance = [TZMapManager getDistanceWithPoint1:point1 point2:point2];
     // 计算一共多少米
     CGFloat multi = 1.0;
     if ([self.distance rangeOfString:@"km"].location != NSNotFound) multi = 1000.0;
     self.distanceMeter = [NSString stringWithFormat:@"%0.1f",(self.distance.floatValue * multi)];
     */
}

@end
