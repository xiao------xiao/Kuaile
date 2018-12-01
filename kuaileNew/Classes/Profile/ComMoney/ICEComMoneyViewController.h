//
//  ICEComMoneyViewController.h
//  kuaile
//
//  Created by ttouch on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYIdentVerifyType) {
    XYIdentVerifyNoCheck,     // 0未认证 1审核中 2审核未通过 3审核通过
    XYIdentVerifyProceed,
    XYIdentVerifyNotYet,
    XYIdentVerifyPass
};

@class XYUserInfoModel;

@interface ICEComMoneyViewController : TZBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *btnCash;
@property (weak, nonatomic) IBOutlet UIButton *btnMoneyDetail;

@property (weak, nonatomic) IBOutlet UILabel *labComMoney;
@property (weak, nonatomic) IBOutlet UIButton *explainBtn;

@property (nonatomic, strong) XYUserInfoModel *infoModel;


@end
