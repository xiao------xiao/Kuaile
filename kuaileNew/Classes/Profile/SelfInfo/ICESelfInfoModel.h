//
//  ICESelfInfoModel.h
//  kuaile
//
//  Created by ttouch on 15/10/19.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "BaseModel.h"

@interface ICESelfInfoModel : BaseModel

__string(birthday); ///< 生日
__string(address);  ///< 现居地
__string(uid);      ///< UID号码
__string(nickname); ///< 昵称
__string(hometown); ///< 家乡
__string(avatar);   ///< 头像

__string(phone);    ///< 电话号码
__string(gender);   ///< 性别
__string(emotion);   ///< 情感
__string(signature);   ///< 签名

@end
