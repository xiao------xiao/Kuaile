//
//  TZJobModel.m
//  kuaile
//
//  Created by liujingyi on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobModel.h"

@implementation TZJobModel

+ (instancetype)jobModelWithDict:(NSDictionary *)dict {
    TZJobModel *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}


/** 把后台返回的  元/月 去掉 */
- (NSString *)salary {
    if ([_salary containsString:@"以下"] || [_salary containsString:@"以上"]) {
        return _salary;
    } else if ([_salary containsString:@"/月"]) {
        _salary = [_salary substringToIndex:_salary.length - 2];
    } else {
        return _salary;
    }
    return _salary;
}

// 改时间戳 - 时间
- (NSString *)start_time {
    if ([_start_time containsString:@"-"]) {
        return _start_time;
    } else {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_start_time.doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *start_time = [formatter stringFromDate:date];
        return start_time;
    }
}

// 改时间戳 - 时间
- (NSString *)sendtime {
    if ([_sendtime containsString:@"-"]) {
        return _sendtime;
    } else {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_sendtime.doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *sendtime = [formatter stringFromDate:date];
        return sendtime;
    }
}

- (NSString *)updated {
    if ([_updated containsString:@"-"]) {
        return _updated;
    } else {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_updated.doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *updated = [formatter stringFromDate:date];
        return updated;
    }
}

- (NSString *)work_time {
    _work_time = [_work_time stringByReplacingOccurrencesOfString:@"：" withString:@":"];
    return _work_time;
}

@end
