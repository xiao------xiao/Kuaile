//
//  TZCitisManager.m
//  kuaile
//
//  Created by liujingyi on 15/10/10.
//  Copyright © 2015年 ttouch. All rights reserved.
//  城市选择数据管理类

#import "TZCitisManager.h"

@interface TZCitisManager ()
@property (nonatomic, strong) NSArray *citis;
@end

@implementation TZCitisManager

+ (NSArray *)getCitis {
    // 应该弄成单例
#warning TODO
    TZCitisManager *mgr = [[TZCitisManager alloc] init];
    return mgr.citis;
}

/** 根据用户的选择城市，获得具体区域列表 */
- (NSArray *)citis {
    if (_citis == nil) {
        // 1.抽取数据
        NSString *userCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil];
        NSArray *bigCitys = [NSArray arrayWithContentsOfFile:path];
        NSArray *citis = [NSArray array];
        for (NSDictionary *bigDict in bigCitys) {
            if ([bigDict[@"name"] isEqualToString:userCity]) {
                citis = bigDict[@"sub"]; break;
            } else {
                NSArray *citys = bigDict[@"sub"];
                for (NSDictionary *dict in citys) {
                    if ([dict[@"name"] isEqualToString:userCity]) {
                        citis = dict[@"sub"]; break;
                    }
                }
            }
        }
        // 2.判断数据  如果找不到，就把本身返回。
        if (citis == nil || citis.count < 1) {
            citis = [NSArray arrayWithObject:userCity];
            _citis = citis;
        } else {
            NSMutableArray *mCitis = [NSMutableArray array];
            for (NSDictionary *item_dict in citis) {
                if ([item_dict[@"name"] isEqualToString:@"其他"]) {
                    continue;
                }
                if ([item_dict[@"name"] isEqualToString:@"请选择"]) {
                    [mCitis addObject:[NSString stringWithFormat:@"%@",userCity]];
                    continue;
                }
                [mCitis addObject:item_dict[@"name"]];
            }
            _citis = mCitis;
        }
    }
    return _citis;
}

@end
