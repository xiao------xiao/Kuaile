//
//  TZFullTimeJobViewController.h
//  HappyWork
//
//  Created by liujingyi on 15/9/10.
//  Copyright (c) 2015年 memberwine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZFullTimeJobTypeHot, // 热门职位
    TZFullTimeJobTypeAll  // 全部职位
} TZFullTimeJobType;

typedef void (^ReturnJobType)(NSString *,NSString *,TZFullTimeJobType);

typedef enum : NSUInteger {
    TZFullTimeJobViewControllerNormal,  // 正常的列表页
    TZFullTimeJobViewControllerJobType, // 从选择职位处进来，通过returnJobType返回职位类型的名字，再pop掉
    
    TZFullTimeJobViewControllerTypeSchoolJob,    // 校园招聘
    TZFullTimeJobViewControllerTypePartTimeJob,  // 兼职工作
    TZFullTimeJobViewControllerTypeReturnMoney,  // 入职返现
    TZFullTimeJobViewControllerTypeEatJob,       // 包吃包住
    TZFullTimeJobViewControllerTypeNearbyJob,    // 附近工作
    TZFullTimeJobViewControllerTypeSearch,       // 搜索职位
    TZFullTimeJobViewControllerTypeRelievedCompany,  // 放心企业 RelievedCompany
    
} TZFullTimeJobViewControllerType;

@interface TZFullTimeJobViewController : TZBaseViewController
@property (nonatomic, assign) TZFullTimeJobViewControllerType type;
@property (nonatomic, assign) TZFullTimeJobType jobType;
@property (nonatomic, copy) ReturnJobType returnJobType;

@end
