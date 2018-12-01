//
//  XYRecommendFriendModel.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYRecommendFriendModel.h"

@implementation XYRecommendFriendModel

MJExtensionCodingImplementation

- (NSString *)nickname {
    if (_nickname && _nickname.length) {
        return _nickname;
    } 
    return _username;
}

@end
