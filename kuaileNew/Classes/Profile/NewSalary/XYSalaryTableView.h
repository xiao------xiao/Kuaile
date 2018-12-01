//
//  XYSalaryTableView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/28.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSalaryTableView : UITableView

@property (nonatomic, strong) NSArray *models;


@property (nonatomic, copy) void (^pushSalaryDetailVcBlock)();

@end
