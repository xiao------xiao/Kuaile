//
//  XYInquireWageViewController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZBaseViewController.h"

@interface XYInquireWageViewController : TZBaseViewController

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *commitBtnText;

@property (nonatomic, copy) NSString *phoneStr;

@property (copy, nonatomic) void (^didCommitSuccessBlock)(NSString *phone);

@end
