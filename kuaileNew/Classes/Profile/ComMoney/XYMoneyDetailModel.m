//
//  XYMoneyDetailModel.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/24.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYMoneyDetailModel.h"

@implementation XYMoneyDetailModel

- (NSString *)create_time {
    return [CommonTools getTimeStrBytimeStamp:_create_time];
}

@end
