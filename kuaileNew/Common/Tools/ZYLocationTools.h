//
//  ZYLocationTools.h
//  kuaile
//
//  Created by admin on 2018/11/14.
//  Copyright © 2018年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TZLocationModel,TZCityModel;
@interface ZYLocationTools : NSObject

+ (NSString *)getCityIDWithCityName:(NSString *)cityName;
/// 从数据库中搜索pid = 0 且 name像provinceName的省份
+ (NSString *)getProvinceIdWithName:(NSString *)provinceName;
/// 获取该城市模型下的 子区域模型列表
+ (NSArray *)getSubCitysWithModel:(TZCityModel *)cityModel;
+ (NSArray *)getSubCitysWithPid:(NSString *)pid;
@end
/// 定位位置的模型
@interface TZLocationModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *communityId;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@end

/// 城市选择的模型
@interface TZCityModel : NSObject
@property (nonatomic,copy) NSString *cid;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *pinyin;
@property (nonatomic,copy) NSString *is_open;
@property (nonatomic,copy) NSString *direct;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *hot;
@property (nonatomic,copy) NSString *pid;
@property (nonatomic,copy) NSString *ucfirst;
@property (nonatomic,copy) NSString *sort;
@end
