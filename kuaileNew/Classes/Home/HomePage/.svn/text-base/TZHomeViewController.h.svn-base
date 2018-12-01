
//
//  TZHomeViewController.h
//  HappyWork
//
//  Created by liujingyi on 15/9/10.
//  Copyright (c) 2015年 memberwine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZHomeViewControllerTypeNormal,      // 一般情况
    TZHomeViewControllerTypeCollction,   // 收藏职位
    TZHomeViewControllerTypeHistory,     // 投递记录
    TZHomeViewControllerTypeRecommed,    // 推荐职位
    TZHomeViewControllerTypeOthers,      // 该公司其他职位
    
    TZHomeViewControllerTypeSchoolJob,    // 校园招聘
    TZHomeViewControllerTypePartTimeJob,  // 兼职工作
    TZHomeViewControllerTypeReturnMoney,  // 入职返现
    TZHomeViewControllerTypeEatJob,       // 包吃包住
    TZHomeViewControllerTypeNearbyJob,    // 附近工作
    TZHomeViewControllerTypeSearch,       // 搜索职位
    TZHomeViewControllerTypeRelievedCompany, // 放心企业
    TZHomeViewControllerTypeGetui,   // 推送来的推荐职位
    TZHomeViewControllerTypeOverseasJob,   // 海外招聘
    
    
    TZHomeViewControllerTypeNoti, // 系统消息进入
} TZHomeViewControllerType;

@interface TZHomeViewController : TZBaseViewController
@property (nonatomic, assign) TZHomeViewControllerType type;


@property (weak, nonatomic) IBOutlet UIButton *btnLiveServe;
@property (weak, nonatomic) IBOutlet UIButton *btnTimeLimitBuy;
@property (weak, nonatomic) IBOutlet UIButton *btnLotteryActivity;
@property (weak, nonatomic) IBOutlet UIButton *btnSignInGifts;


// 补充一个地址 工资
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *salary;
@end
