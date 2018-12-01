//
//  TZJobListViewController.h
//  kuaile
//
//  Created by liujingyi on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZJobListViewControllerTypeNormal,      // 一般情况 jobs
    TZJobListViewControllerTypeCollction,   // 收藏职位
    TZJobListViewControllerTypeHistory,     // 投递记录
    TZJobListViewControllerTypeRecommed,    // 推荐职位
    TZJobListViewControllerTypeOthers,      // 该公司其他职位
    
    TZJobListViewControllerTypeSchoolJob,    // 校园招聘 jobs
    TZJobListViewControllerTypePartTimeJob,  // 兼职工作 jobs
    TZJobListViewControllerTypeReturnMoney,  // 入职返现 jobs
    TZJobListViewControllerTypeEatJob,       // 包吃包住 jobs
    TZJobListViewControllerTypeOverseasJob,   // 海外招聘 jobs
    TZJobListViewControllerTypeNearbyJob,    // 附近工作 jobs
    TZJobListViewControllerTypeSearch,       // 搜索职位 jobs
    TZJobListViewControllerTypeRelievedCompany, // 放心企业 jobs
    TZJobListViewControllerTypeGetui,   // 推送来的推荐职位

    TZJobListViewControllerTypeNoti, // 系统消息进入
} TZJobListViewControllerType;

@class TZJobListScreeningView;
@interface TZJobListViewController : UIViewController

@property (strong, nonatomic) TZJobListScreeningView *screeningView; // 放到外面，设置是否需要隐藏
@property (nonatomic, copy) NSString *jobTitle;
@property (nonatomic, assign) TZJobListViewControllerType type;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *uid; // 公司的uid

/** 新参数，职位分类的id */
@property (nonatomic, copy) NSString *laid;
/// 推送来的推荐职位 职位ids
@property (nonatomic, copy) NSString *is_mess;

/** 2015.11.10更新 记录是否从热门职位跳转而来 */
@property (nonatomic, assign) BOOL isFromHotJob;

/** 2015.12.8更新 从前面带来一个标题 */
@property (nonatomic, copy) NSString *vCtrlTitle;

// 补充一个地址 工资
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *salary;

@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, assign) BOOL shaixuanHotJobs;//热门工作

- (void)showBack;

@end
