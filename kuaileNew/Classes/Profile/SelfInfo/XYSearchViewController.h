//
//  XYSearchViewController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/5/9.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZBaseViewController.h"

@interface XYSearchViewController : TZBaseViewController

@property (nonatomic, copy) void (^didSelecteCompany)(NSString *companyName);

@end
