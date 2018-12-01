//
//  XYContactModel.h
//  kuaile
//
//  Created by 肖兰月 on 2017/6/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYContactModel : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *is_attention;
@end

//"uid": "38",//用户id
//"mobile": "18321272927",//手机号
//"avatar": "http://120.55.165.117/uploads/user_info/80901489546634.png",
//"is_attention": 0//1已是好友0不是好友
