//
//  XYPointTaskModel.h
//  kuaile
//
//  Created by 肖兰月 on 2017/3/10.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYPointTaskModel : NSObject

@property (nonatomic, strong) NSArray *finish;
@property (nonatomic, strong) NSArray *daily;
@property (nonatomic, strong) NSArray *New_member;


@end

//"mid": "2",//任务id
//"mission_name": "自拍签到",//任务名称
//"daily_mission": "1",//1每日2新手
//"mission_type": "1",
//"need_num": "1",//需要完成的数量
//"point": "10",//奖励积分
//"state": "1",
//"created_at": "1489029456",
//"finish_num": "1",//已完成数量
//"is_finish": 1，//是否已完成1为已完成0为未完成
//"is_receive": 0,//0未领取奖励1已领取奖励


@interface XYPointTaskSingleModel : NSObject

@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *mission_name;
@property (nonatomic, copy) NSString *daily_mission;
@property (nonatomic, copy) NSString *mission_type;
@property (nonatomic, copy) NSString *need_num;
@property (nonatomic, copy) NSString *point;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *finish_num;
@property (nonatomic, copy) NSString *is_finish;
@property (nonatomic, copy) NSString *is_receive;
@property (nonatomic, copy) NSString *created_at;

@end



@interface XYPointDetailModel : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *point;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;

//"uid": "38",
//"username": "18321272927",
//"content": "签到",
//"point": "+30",
//"time": "1486695960",
//"type": "1"

@end


