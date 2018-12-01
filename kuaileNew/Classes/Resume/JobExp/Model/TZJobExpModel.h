//
//  TZJobExpModel.h
//  kuaile
//
//  Created by liujingyi on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZJobExpModel : NSObject

/** 公司名称 */
@property (nonatomic, copy) NSString *company_name;
/** 开始时间 */
@property (nonatomic, copy) NSString *job_start;
/** 结束时间 */
@property (nonatomic, copy) NSString *job_end;
/** 职位类别 */
@property (nonatomic, copy) NSString *department;
/** 职位名称 */
@property (nonatomic, copy) NSString *job_name;
/** 职位描述 */
@property (nonatomic, copy) NSString *job_desc;
/** 工作经验id */
@property (nonatomic, copy) NSString *work_exp_id;

/** 该工作的职位描述的高度 */
@property (nonatomic, assign) CGFloat describeHeight;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
