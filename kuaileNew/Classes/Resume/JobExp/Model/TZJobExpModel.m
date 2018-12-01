
//
//  TZJobExpModel.m
//  kuaile
//
//  Created by liujingyi on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobExpModel.h"

@implementation TZJobExpModel

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    TZJobExpModel *model = [[TZJobExpModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (NSString *)job_end {
    if (_job_end.length < 5) {
        return @"至今";
    } else {
        return _job_end;
    }
}

@end
