//
//  ZYLocationTools.m
//  kuaile
//
//  Created by admin on 2018/11/14.
//  Copyright © 2018年 ttouch. All rights reserved.
//

#import "ZYLocationTools.h"
#import <MapKit/MapKit.h>
#import "FMDB.h"

#define TZLocationModelFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"locationModel.plist"]

@implementation ZYLocationTools
static FMDatabase *_db;

+ (void)initialize {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city.db" ofType:nil];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
}
/// 从数据库中搜索pid = 0 且 name像provinceName的省份
+ (NSString *)getProvinceIdWithName:(NSString *)provinceName {
    NSString *provinceId;
    NSString *sqlURL = [NSString stringWithFormat:@"SELECT * FROM hp_city WHERE name LIKE '%@' AND pid = 0;",provinceName];
    FMResultSet *set = [_db executeQuery:sqlURL];
    
    NSMutableArray *models = [NSMutableArray array];
    if (set.next) {
        NSDictionary *dict = set.resultDictionary;
        provinceId = dict[@"cid"];
        [models addObject:dict];
    }
    return provinceId;
}
/// 获取该城市模型下的 子区域模型列表
+ (NSArray *)getSubCitysWithModel:(TZCityModel *)cityModel {
    return [self getSubCitysWithPid:cityModel.cid];
}

+ (NSArray *)getSubCitysWithPid:(NSString *)pid {
    NSString *sqlURL = [NSString stringWithFormat:@"SELECT * FROM hp_city WHERE pid = %zd;",pid.integerValue];
    
    FMResultSet *set = [_db executeQuery:sqlURL];
    NSMutableArray *models = [NSMutableArray array];
    while (set.next) {
        
        TZCityModel *cityModel = [TZCityModel mj_objectWithKeyValues:set.resultDictionary];
        if (![cityModel.name containsString:@"其他"] && ![cityModel.name containsString:@"长株潭"]) {
            [models addObject:cityModel];
        }
    }
    return models;
}


@end
@implementation TZLocationModel

@end


@implementation TZCityModel

@end
