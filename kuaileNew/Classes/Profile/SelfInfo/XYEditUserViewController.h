//
//  XYEditUserViewController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/3/9.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZResumeRootController.h"
@class XYUserInfoModel;

@interface XYEditUserViewController : TZResumeRootController

// 从发现界面进入
@property (assign, nonatomic) BOOL pushFromFindVc;

@property (nonatomic, strong) XYUserInfoModel *model;

@end
