//
//  EMConversation+Gropp.m
//  kuaile
//
//  Created by 欧阳荣 on 2017/4/28.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "EMConversation+Gropp.h"
#import <objc/runtime.h>

@implementation EMConversation (Gropp)

static char *PersonNameKey = "PersonNameKey";
static char *PersonAcatorKey = "PersonavatorKey";

static char *PersongidKey = "PersongidKey";
static char *PersonAdminKey = "PersonadminKey";

- (void)setGroupName:(NSString *)groupName {
    [self willChangeValueForKey:@"groupName"];
    objc_setAssociatedObject(self, PersonNameKey, groupName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"groupName"];

}

- (NSString *)groupName {
    return objc_getAssociatedObject(self, PersonNameKey);
}

- (void)setGroupAvator:(NSString *)groupAvator {
    [self willChangeValueForKey:@"groupAvator"];
    objc_setAssociatedObject(self, PersonAcatorKey, groupAvator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"groupAvator"];
}

- (NSString *)groupAvator {
    return objc_getAssociatedObject(self, PersonAcatorKey);

}

- (void)setGid:(NSString *)gid {
    [self willChangeValueForKey:@"gid"];
    objc_setAssociatedObject(self, PersongidKey, gid, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"gid"];
}

- (NSString *)gid {
    return objc_getAssociatedObject(self, PersongidKey);
    
}

- (void)setIs_admin:(NSString *)is_admin {
    [self willChangeValueForKey:@"is_admin"];
    objc_setAssociatedObject(self, PersonAdminKey, is_admin, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"is_admin"];
}

- (NSString *)is_admin {
    return objc_getAssociatedObject(self, PersonAdminKey);
    
}

@end
