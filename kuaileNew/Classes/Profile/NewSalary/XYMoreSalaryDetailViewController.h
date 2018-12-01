//
//  XYMoreSalaryDetailViewController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/28.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZTableViewController.h"
@class XYSalaryDetailModel;

@interface XYMoreSalaryDetailViewController : TZTableViewController

@property (nonatomic, copy) NSString *titleText;

@property (nonatomic, strong) XYSalaryDetailModel *model;

@end
