//
//  XYSubscribeModel.h
//  kuaile
//
//  Created by 肖兰月 on 2017/3/29.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYSubscribeModel : NSObject

@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *cclass;
@property (nonatomic, copy) NSString *hope_city;
@property (nonatomic, copy) NSString *hope_salary;
@property (nonatomic, copy) NSString *hope_career;
@property (nonatomic, copy) NSString *exp;
@property (nonatomic, copy) NSString *origin;
@property (nonatomic, copy) NSString *warn;

@end

//    sessionid	是	string
//    keywords	是	string	关键词
//    class	是	int	分类id
//    hope_city	是	int	区域id
//    hope_salary	是	string	期望薪资，按职位列表传
//    hope_career	是	string	福利，按职位列表传，多个举例940#941#942，#隔开
//    star	是	string	信誉度，传数字1-5代表1-5星
//    exp	是	string	经验，按职位列表
//    origin	是	int	来源，也是职位列表0全部1开心直招2企业直招3代招
//    warn	是	int	0不提醒1三天自动提醒
