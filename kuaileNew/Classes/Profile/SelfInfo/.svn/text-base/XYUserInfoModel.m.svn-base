//
//  XYUserInfoModel.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYUserInfoModel.h"

@implementation XYUserInfoModel

MJExtensionCodingImplementation

- (NSString *)birthday {
    return [CommonTools getTimeStrBytimeStamp:_birthday];
}

- (NSString *)created {
    NSString *timeStr = [CommonTools getFriendTimeFromTimeStamp:_created];
    return timeStr;
}

@end
