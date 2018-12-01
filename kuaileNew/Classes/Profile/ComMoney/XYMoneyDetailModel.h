//
//  XYMoneyDetailModel.h
//  kuaile
//
//  Created by 肖兰月 on 2017/3/24.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYMoneyDetailModel : NSObject

@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *job_time;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *commission;

@end


//"create_time": "1445478851",      //操作时间
//"job_time": "0",            //上班时间
//"company": null,              //公司名称
//"content": "提现",            //操作类型
//"commission": "-1000"
