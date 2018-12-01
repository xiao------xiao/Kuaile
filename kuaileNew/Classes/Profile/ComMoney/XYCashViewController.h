//
//  XYCashViewController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/20.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZBaseViewController.h"

typedef NS_ENUM(NSInteger, XYCashViewControllerType) {
    XYCashViewControllerTypeCard,
    XYCashViewControllerTypeAlipay,
};

@interface XYCashViewController : TZBaseViewController


@property (nonatomic, assign) XYCashViewControllerType type;

@end
