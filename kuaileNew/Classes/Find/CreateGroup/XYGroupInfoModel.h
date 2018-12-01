//
//  XYGroupInfoModel.h
//  kuaile
//
//  Created by 肖兰月 on 2017/4/13.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYGroupInfoModel : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *background;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *group_permissions;
@property (nonatomic, copy) NSString *user_permissions;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *grouper;
@property (nonatomic, copy) NSString *lab_id;
@property (nonatomic, copy) NSString *lab_name;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *total_member;
@property (nonatomic, copy) NSString *is_join;
@property (nonatomic, copy) NSString *is_admin;
@property (nonatomic, copy) NSString *people_num;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSDictionary *groups;

@property (nonatomic, strong) UIImage *bgImg;


@end

@interface XYGroupMemberModel : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *username;
@property (copy, nonatomic) NSString *nickname;
@property (nonatomic, copy) NSString *user_huanxin;
@property (nonatomic, copy) NSString *is_admin;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *phone;

@end




//"gid": "290",//群id
//"uid": "20340",//创建者id
//"avatar": "http://120.55.165.117/uploads/group/91331481274304.png",//群头像
//"background": "",//背景图
//"lng": "121.4823557548508",
//"lat": "31.21400719611242",
//"created": "1490169670",//创建时间
//"group_id": "11294495277057",//环信id
//"owner": "群名2",//群名
//"group_permissions": "1",//0私密群1公开群
//"user_permissions": "1",//是否管理员同意0不需要1需要
//"address": "上海西藏南路",//地址
//"desc": "rewr",//描述
//"type": "0",//推荐群 0不是1是
//"grouper": "18321272927",//群主
//"lab_id": "1#2",//标签
//"lab_name": "求职#偶遇",//标签名
//"distance": 112.35,//距离
//"total_member": "1",//总成员数
//"is_join": 1,//0未加入1已加入
//"members": [//成员。。。。群主取数组中第一个
//            {
//                "uid": "20340",
//                "username": "2017031410470048348",
//                "user_huanxin": "2017031410470048348",//环信账号，一般与username一致，去聊天拿这个字段
//                "is_admin": "1",//1为创建者群主 0不是
//                "avatar": "http://120.55.165.117/uploads/user_info/78331489546572.png"
//            }
//            ]
