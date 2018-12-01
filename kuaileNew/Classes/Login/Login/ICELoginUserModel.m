//
//  ICELoginUserModel.m
//  hxjj
//
//  Created by ttouch on 15/7/15.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICELoginUserModel.h"

@implementation ICELoginUserModel

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        
        ICELoginUserModel *model = [[self alloc] init];
        model.hasLogin = [mUserDefaults boolForKey:@"hasLogin"];
        
        return model;
        
    });
}

/// 登录成功后保存用户信息
- (void)setValueWithDict:(NSDictionary *)x {
    self.uid = x[@"data"][@"uid"];
    self.phone = x[@"data"][@"phone"];
    self.username = x[@"data"][@"username"];
    self.password = x[@"data"][@"password"];
    self.email = x[@"data"][@"email"];
    self.created = x[@"data"][@"created"];
    self.last_ip = x[@"data"][@"last_ip"];
    self.last_login = x[@"data"][@"last_login"];
    self.lng = x[@"data"][@"lng"];
    self.lat = x[@"data"][@"lat"];
    self.gender = x[@"data"][@"gender"];
    self.nickname = x[@"data"][@"nickname"];
    self.authid = x[@"data"][@"authid"];
    self.authtype = x[@"data"][@"authtype"];
    self.sessionid = x[@"data"][@"sessionid"];
    self.rid = x[@"data"][@"rid"];
    self.avatar = x[@"data"][@"avatar"];
    self.background = x[@"data"][@"background"];
    self.sign = x[@"data"][@"sign"];
    self.authid_qq = x[@"data"][@"authid_qq"];
    self.is_bind = x[@"data"][@"is_bind"];
    self.uvatar = x[@"data"][@"uvatar"];
    
    [mUserDefaults setObject:self.uid forKey:@"orUid"];
    self.hasLogin = YES;
}

- (NSString *)uid {
    if (!_uid) {
        return [mUserDefaults objectForKey:@"orUid"];
    }
    return _uid;
}

- (void)setHasLogin:(BOOL)hasLogin {
    _hasLogin = hasLogin;
    [mUserDefaults setBool:hasLogin forKey:@"hasLogin"];
}

@end
