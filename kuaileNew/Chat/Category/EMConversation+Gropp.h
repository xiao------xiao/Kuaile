//
//  EMConversation+Gropp.h
//  kuaile
//
//  Created by 欧阳荣 on 2017/4/28.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "EMConversation.h"

@interface EMConversation (Gropp)
//ORcode 需要自己获取
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *groupAvator;
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *is_admin;
@end
