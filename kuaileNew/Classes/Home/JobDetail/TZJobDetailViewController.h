//
//  TZJobDetailViewController.h
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TZJobModel,TZCompanyTitleModel;
@interface TZJobDetailViewController : TZBaseViewController
/** 职位详细模型 */
@property (nonatomic, strong) TZJobModel *model;
// 是否有返现
@property (nonatomic, copy) NSString *fanXian;

/** 公司信息模型 */
@property (nonatomic, strong) TZCompanyTitleModel *companyModel;
/** 根据recruit_id加载职位详细信息 */
@property (nonatomic, copy) NSString *recruit_id;
@property (nonatomic, copy) NSString *uid; // 公司的uid

/** 是否已经被收藏 */
@property (nonatomic, assign) BOOL haveCollection;

@property (assign, nonatomic) BOOL pushFromScanVc;
/// 被present出来的，显示返回按钮
- (void)showBack;

@end
