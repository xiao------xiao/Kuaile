//
//  ICELoginUserModel.h
//  hxjj
//
//  Created by ttouch on 15/7/15.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "BaseModel.h"

@interface ICELoginUserModel : BaseModel

__string(uid);              ///< 用户id
__string(phone);            ///< 手机号码
__string(username);         ///< 用户名
__string(password);         ///< 密码
__string(email);            ///< 邮箱
__string(created);          ///< 创建时间
__string(last_ip);          ///< 上次登录IP
__string(last_login);       ///< 上次登录时间
__string(lng);              ///< 经度
__string(lat);              ///< 纬度
__string(gender);           ///< 性别
__string(nickname);         ///< 昵称
__string(age);              ///< 年龄
__string(authid);           ///< 第三方登录授权id
__string(authtype);         ///< 第三方登录类型 1.QQ，2.微信，3.微博
__string(sessionid);        ///< sessionID
__string(rid);              ///< 备注：7、业务员，8、求职者
__string(avatar);           ///< 头像
__string(background);       ///< 背景图
__string(emotional_state);  ///< 情感状态
__string(sign);             ///< 个性签名

__string(authid_qq);        ///< authid_qq
__string(is_bind);          ///< is_bind  1 绑定了手机号  2 解绑了
//__string(rid);             ///< 备注7：业务员 8.求职者
__string(uvatar);        ///< 头像
// 用户是否已经登陆
@property (nonatomic, assign, getter=isLogin) BOOL hasLogin;        // 正常登录
@property (nonatomic, assign, getter=isHXLogin) BOOL hasHXLogin;    // 环信登录

@property (nonatomic, assign) EMConnectionState connectionState;    // 网络状态


+ (instancetype)sharedInstance;

/// 登录成功后保存用户信息
- (void)setValueWithDict:(NSDictionary *)dict;

@end


/**
{
    "status": 1,
    "msg": "登录成功",
    "sessionid": null,
    "data": {
        "uid": "62",      //用户id
        "phone": null,     //手机
        "username": "13524713723",      //用户名
        "password": "e10adc3949ba59abbe56e057f20f883e",         //密码
        "email": null,       //邮箱
        "created": "1445047312",      //创建时间
        "last_ip": "116.226.57.16",   //上次登录IP
        "last_login": "1445060878",   //上次登录时间
        "lng": "",                  //经度
        "lat": "",                  //纬度
        "gender": "0",              //性别
        "nickname": "",             //昵称
        "authid": "",               //第三方登录id
        "authtype": "0",            //第三方登录类型  1.QQ，2.微信，3.微博
        "sessionid": "6cju840s7gr6v56s54vt2bi1k5",
        "rid": "8"  备注：7、业务员，8、求职者
    }
}
*/
