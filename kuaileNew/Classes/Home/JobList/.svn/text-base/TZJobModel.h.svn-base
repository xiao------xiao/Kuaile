//
//  TZJobModel.h
//  kuaile
//
//  Created by liujingyi on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>
/** {
 "recruit_id": "38",//职位id
 "recruit_name": "作业员",//名
 "recruit_num": "若干",//招聘人数
 "origin": "1",//来源0全部1开心直招2企业直招3代招
 "return_money": "",//返现金额
 "address": "江苏 - 无锡",//地址
 "city": "157",//市id
 "town": "4429",//镇id
 "uid": "340",//用户id
 "start_time": "2017-01-13",//时间
 "istop": "1",
 "company_name": "绿点科技(无锡)有限公司",//公司名
 "welfare": "包住宿 - 班车 - 工作餐 - 入职返现 - 节日福利 - 五险一金 - 加班补助",//福利
 "work_exp": "不限",//工作经验
 "degree": "不限",//学历
 "salary": "300105000",//薪资,代表意思上方有
 "star": "5",//星级
 "verify": "1",//1代表已认证0代表未认证
 "logo": "http://www.hap-job.com/uploads/company/img/85741452674721.gif",//公司logo
 "fan": 1//1代表有入职返现标志0代表没有
 }
 */
@interface TZJobModel : NSObject

// 职位列表页需要的数据
@property (nonatomic, copy) NSString *distance;

/** 通过认证 1  未通过 0   */
@property (nonatomic, strong) NSNumber *verify;

/** 入职返现  */
@property (nonatomic, copy) NSString *return_money;

/** 入职返现 有值就有返图标  */
@property (nonatomic, copy) NSString *fan;

/** 工作时限  */
@property (nonatomic, copy) NSString *work_time;

/** 是否置顶 */
@property (nonatomic, copy) NSString *istop;

/** 招聘recruit_id */
@property (nonatomic, copy) NSString *recruit_id;

/** 招聘recruit_name */
@property (nonatomic, copy) NSString *recruit_name;

/** 招聘公司的uid */
@property (nonatomic, copy) NSString *uid;

/** 招聘标题 */
@property (nonatomic, copy) NSString *title;

/** 薪水 */
@property (nonatomic, copy) NSString *salary;

/** 工作区域 */
@property (nonatomic, copy) NSString *address;

/** 发布日期 */
@property (nonatomic, copy) NSString *start_time;

/** 发布日期 */
@property (nonatomic, copy) NSString *created;

/** 更新日期 */
@property (nonatomic, copy) NSString *updated;

/** 来源的公司 */
@property (nonatomic, copy) NSString *company_name;

/** 经验要求 */
@property (nonatomic, copy) NSString *work_exp;

/** 学历要求 */
@property (nonatomic, copy) NSString *degree;

/** 招聘人数 */
@property (nonatomic, copy) NSString *recruit_num;

/** 工作被选中 */
@property (nonatomic, strong) NSNumber *selected;

// 职位详情页(职位信息)需要的数据

/** 福利 */
@property (nonatomic, copy) NSString *welfare;

/** 职位描述 */
@property (nonatomic, copy) NSString *job_desc;

/** 职位类型 */
@property (nonatomic, copy) NSString *jobs_property;

/** 浏览量 */
@property (nonatomic, copy) NSString *looks;

// 职位详情页（公司信息）需要的数据

/** 联系邮箱 */
@property (nonatomic, copy) NSString *rece_mail;

/** 公司规模 */
@property (nonatomic, copy) NSString *companySize;
/** 公司规模 */
@property (nonatomic, copy) NSString *company_scope;

/** 公司地址 */
@property (nonatomic, copy) NSString *street;

/** 公司简介 */
@property (nonatomic, copy) NSString *desc;

/** 公司类别 */
@property (nonatomic, copy) NSString *company_industry;

/** 评分 */
@property (nonatomic, strong) NSNumber *star;

/** 公司名字 */
@property (nonatomic, copy) NSString *name;

/** 公司规模 */
@property (nonatomic, copy) NSString *company_property;

/** 公司logo */
@property (nonatomic, copy) NSString *logo;

/** 公司联系人 */
@property (nonatomic, copy) NSString *contact;

/** 公司联系人电话 */
@property (nonatomic, copy) NSString *phone;


@property (nonatomic, copy) NSString *company_tel;
// 投递记录需要的数据

/** 投递时间 */
@property (nonatomic, copy) NSString *sendtime;
@property (nonatomic, copy) NSString *deliver_id;

@property (nonatomic, assign) BOOL edit;

+ (instancetype)jobModelWithDict:(NSDictionary *)dict;

@end
