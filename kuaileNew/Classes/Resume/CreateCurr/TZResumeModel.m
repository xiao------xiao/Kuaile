//
//  TZResumeModel.m
//  kuaile
//
//  Created by liujingyi on 15/9/24.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZResumeModel.h"
#import "MJExtension.h"
#import "TZJobExpModel.h"

@implementation TZResumeModel

MJExtensionCodingImplementation

+ (NSDictionary *)objectClassInArray {
    return @{@"workExps":[TZJobExpModel class]};
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"isDefault":@"default"};
}

// 时间戳转换成时间
//- (NSString *)birthday {
////    if ([_birthday containsString:@"-"]) { 
////        return _birthday;
////    } else {
////        return [CommonTools getTimeStrBytimeStamp:_birthday];
////    }
////    return [CommonTools getTimeStrBytimeStamp:_birthday];
//}

// 时间戳转换成时间
- (NSString *)updated {
    if ([_updated containsString:@"-"]) {
        return _updated;
    } else {
        return [CommonTools getTimeStrBytimeStamp:_updated];
    }
}

@end
