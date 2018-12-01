//
//  TZFindSnsModel.h
//  kuaile
//
//  Created by ttouch on 2016/12/26.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 一个图片的元数据 */
@interface ICEModelPicture : NSObject
@property (nonatomic, copy) NSString *thumbPath;
@property (nonatomic, copy) NSString *images;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *size;
@end

@interface TZFindSnsModel : NSObject

@property (nonatomic, copy) NSString *sid;// 帖子ID
@property (nonatomic, copy) NSString *uid;// 用户id
@property (nonatomic, copy) NSString *unickname;// 用户昵称
@property (nonatomic, copy) NSString *tag;// 帖子类型1动态2美拍3广场
@property (nonatomic, copy) NSString *uvatar;// 用户小头像
@property (nonatomic, copy) NSString *gender;// 性别0男1女
@property (nonatomic, copy) NSString *content;//发帖的内容
@property (nonatomic, copy) NSString *shareTitle;//原始

@property (nonatomic, copy) NSString *images;//发帖的图片
@property (nonatomic, copy) NSString *zan_num;//点赞数
@property (nonatomic, copy) NSString *comment_num;//评论数
@property (nonatomic, copy) NSString *ubirthday;//用于计算年龄，可能没有设定
@property (nonatomic, copy) NSArray *zan_list;//每个元素包含点赞用户id和小头像地址
@property (nonatomic, assign) BOOL isconcern;//是否关注了该用户
@property (nonatomic, copy) NSString *fcityname;//发帖的位置
@property(nonatomic,strong) NSString *age; // 年龄
@property (nonatomic, assign) BOOL ismine; //判断是否是自己的贴子
@property (nonatomic, copy) NSString* create_at;

@property (nonatomic, copy) NSDictionary *sns_data;
@property (nonatomic, copy) NSString *data_id;

@property (nonatomic, strong) NSMutableArray *imgArr;


@property (nonatomic, strong) NSMutableArray *hitsUser;
@property (nonatomic, strong) NSArray *comment;

@property (nonatomic, strong) ICELoginUserModel *user;

@property (nonatomic, copy) NSString *hit_num;

@property (nonatomic, copy) NSString *view_num;

@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *play_time;

@property (nonatomic, copy) NSString *updated_at;

@property (nonatomic, copy) NSString *is_hit;
@property (nonatomic, copy) NSString *is_attention;
@property (nonatomic, copy) NSString *is_top;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSAttributedString *attributedTitle;
/// 友好时间
@property (nonatomic, copy) NSString *friendlyTime;
/// 图片模型数组
@property (nonatomic, strong) NSMutableArray *imageArray;
/// 文字高度
@property (nonatomic, assign) CGFloat textHeight;
/// 图片view高度
@property (nonatomic, assign) CGFloat imageViewHeight;
/// 总高度
@property (nonatomic, assign) CGFloat totalHeight;
/// 记录点赞状态
@property (nonatomic, assign) BOOL is_zan;
/// 记录关注状态
//@property (nonatomic, assign) BOOL is_care;
@property (nonatomic, assign) BOOL shouldPaly;
@end

@class ICELoginUserModel;

@interface TZSnsCommentModel : NSObject
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *unickname;
@property (nonatomic, strong) NSMutableAttributedString *contentAtr;
@property (nonatomic, strong) NSMutableAttributedString *contentAtrReply;
@property (nonatomic, copy) NSString *uvatar;
@property (nonatomic, copy) NSString *buid;
@property (nonatomic, copy) NSString *bunickname;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *create_at;
@property (nonatomic, copy) NSString *updated_at;

@property (nonatomic, strong) ICELoginUserModel *buser;
@property (nonatomic, strong) ICELoginUserModel *user;

@property (nonatomic, assign) BOOL isHit;
@property (nonatomic, copy) NSString *is_hit;
@property (nonatomic, copy) NSString *hit_num;

@property (nonatomic, assign) CGFloat contentLableHeight;
@property (nonatomic, assign) CGFloat contentCourseLableHeight;
@property (nonatomic, assign) CGFloat cellListHeight;
@end

@interface TZSnsHitModel : NSObject
@property (nonatomic, copy) NSString *hid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *unickname;// 名字
@property (nonatomic, copy) NSString *uvatar;
@property (nonatomic, copy) NSString *usex;
@property (nonatomic, assign) BOOL isconcern; // 判断是否关注
@property (nonatomic, strong) ICELoginUserModel *user;
@property (nonatomic, copy) NSString *age;// 年龄
@end

// 获取附近的人的数据模型
@interface NearPeople : NSObject
@property(nonatomic,copy) NSString *uid; // 用户id
@property(nonatomic,copy) NSString * username; // 用户名
@property(nonatomic,copy) NSString *avatar; // 用户小头像url
@property(nonatomic,copy) NSString *sign; // 用户个性签名
@property(nonatomic,copy) NSString *birthday; // 用户年龄时间戳
@property(nonatomic,copy) NSString *age; // 用户年龄(岁)
@property(nonatomic,copy) NSString *nickname; // 	用户昵称
@property(nonatomic,copy) NSString *lat; //  用户所在纬度
@property(nonatomic,copy) NSString *lng; // 用户所在经度
@property(nonatomic,copy) NSString *last_login; // 最近登录时间
@property(nonatomic,copy) NSString * distance; // 距离
@property(nonatomic,copy) NSString *gender; // 	用户性别

@end

@interface NearGroup : NSObject
@property(nonatomic,copy) NSString *gid; //  群id
@property(nonatomic,copy) NSString *owner; // 群昵称
@property(nonatomic,copy) NSString *group_id; // 环信群id
@property(nonatomic,copy) NSString *desc; // 简介
@property(nonatomic,copy) NSString *grouper; // 群主
@property(nonatomic,copy) NSString *address; // 地址
@property(nonatomic,copy) NSString *avatar; //群头像url

@end


@interface getGroupModel : NSObject
@property(nonatomic,copy) NSString *address; //  地址
@property(nonatomic,copy) NSString *distance; //距离
@property(nonatomic,strong) NSArray *groups; //


@end

@interface getRecommendGroup : NSObject

@property(nonatomic,copy) NSString *gid; //  群id
@property(nonatomic,copy) NSString *owner; // 群昵称
@property(nonatomic,copy) NSString *group_id; // 环信群id
@property(nonatomic,copy) NSString *desc; // 简介
@property(nonatomic,copy) NSString *grouper; // 群主
@property(nonatomic,copy) NSString *address; // 地址
@property(nonatomic,copy) NSString *avatar; //群头像url
@property(nonatomic,copy) NSString *lng;
@property(nonatomic,copy) NSString *lat;
@property(nonatomic,copy) NSString *lab_name;
//@property(nonatomic,copy) NSString *user_permissions;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *people_num;
@property(nonatomic,strong) NSDictionary *groups; //人数

@end

/****
 "gid": "236",//群id
 "owner": "梦想之都------XC",//群名
 "desc": "菩提树下，我一站千年，只为等菩提花开。鞠一捧花香嵌入伊人冷梦，却只得一袭哀婉沉暮。",//描述
 "grouper": "17756595163",//创建者
 "address": "中国江苏省无锡市滨湖区锡南二支路",
 "group_id": "1470921266253",//环信群号
 "lng": "120.35767",
 "lat": "31.547129",
 "avatar": "http://120.55.165.117/uploads/group/27831470921265.png",//头像
 "lab_name": "",//标签
 "people_num": "0"//人数
 **/
