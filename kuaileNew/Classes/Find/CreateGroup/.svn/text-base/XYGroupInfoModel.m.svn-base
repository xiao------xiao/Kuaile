//
//  XYGroupInfoModel.m
//  kuaile
//
//  Created by 肖兰月 on 2017/4/13.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYGroupInfoModel.h"

@implementation XYGroupInfoModel

MJExtensionCodingImplementation

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"members":[XYGroupMemberModel class]};
}

- (NSString *)created {
    return [CommonTools getTimeStrBytimeStamp:_created];
}

@end



@implementation XYGroupMemberModel

MJExtensionCodingImplementation

@end
