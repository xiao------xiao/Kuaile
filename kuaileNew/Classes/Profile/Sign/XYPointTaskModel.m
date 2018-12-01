//
//  XYPointTaskModel.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/10.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYPointTaskModel.h"

@implementation XYPointTaskModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"New_member" : @"new_member"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"finish" : [XYPointTaskSingleModel class], @"daily" : [XYPointTaskSingleModel class], @"New_member" : [XYPointTaskSingleModel class]};
}

@end


@implementation XYPointTaskSingleModel


@end




@implementation XYPointDetailModel


- (NSString *)time {
    return [CommonTools getTimeStrBytimeStamp:_time];
}

@end





