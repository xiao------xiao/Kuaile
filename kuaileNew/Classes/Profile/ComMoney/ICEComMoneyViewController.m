//
//  ICEComMoneyViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICEComMoneyViewController.h"
#import "ICECashViewController.h"
#import "ICEMoneyDetailViewController.h"
#import "TZStoreNaviBar.h"
#import "XYMoneyDetailViewController.h"
#import "XYInquireWageViewController.h"
#import "XYCashCategoryController.h"
#import "XYCashExplanationController.h"
#import "XYUserInfoModel.h"
#import "XYFaceCertifyViewController.h"
#import "ICECommissionViewController.h"


@interface ICEComMoneyViewController () {
    XYIdentVerifyType _verifyType;
}
@property (nonatomic, strong) TZStoreNaviBar *naviBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerConstraintH;

@end

@implementation ICEComMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configBtnShape];
    [self configTZNaviBarView];
    [self configBtn];
    [self configLab];
    
    [mNotificationCenter addObserver:self selector:@selector(configLab) name:@"didUpdateMemberInfo" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.infoModel = [TZUserManager getUserModel];
    if (!self.infoModel) {
        [TZUserManager syncUserModelWithCompletion:^(XYUserInfoModel *model) {
            self.infoModel = model;
            [self loadType:self.infoModel.verify];
        }];
    }
    [self loadType:self.infoModel.verify];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)configBtnShape {
    self.btnCash.layer.cornerRadius = 25;
    self.btnCash.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.headerConstraintH.constant = mScreenHeight / 1.9;
    self.btnMoneyDetail.layer.cornerRadius = 25;
    self.btnMoneyDetail.clipsToBounds = YES;
    [self.btnMoneyDetail.layer setBorderColor:TZColorRGB(200).CGColor];
    [self.btnMoneyDetail.layer setBorderWidth:1];
}


- (void)configTZNaviBarView {
    _naviBar = [[TZStoreNaviBar alloc] init];
    _naviBar.frame = CGRectMake(0, 0, __kScreenWidth, 64);
    _naviBar.moreBtn.hidden = YES;
    _naviBar.naviTitleLable.text = @"我的佣金";
    _naviBar.naviTitleLable.textColor = [UIColor whiteColor];
    [self.view addSubview:_naviBar];
    __weak typeof(self) weakSelf = self;
    [[_naviBar.messageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)configBtn {
    [[self.btnCash rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        ICECashViewController *iCECash = [[ICECashViewController alloc] init];
//        iCECash.strCashMoney = self.labComMoney.text;
//        [self.navigationController pushViewController:iCECash animated:YES];
//        iCECash.cashViewBlack = ^() {
//            [self configLab];
//        };
//        
//        XYInquireWageViewController *inquireVc = [[XYInquireWageViewController alloc] init];
//        inquireVc.titleText = @"佣金提现";
//        [self.navigationController pushViewController:inquireVc animated:YES];
//
        if ([self shouldPushBindPhoneVc]) return;

        [self pushMyMoneyVc];
        
    }];
    [[self.btnMoneyDetail rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        ICEMoneyDetailViewController *iCECash = [[ICEMoneyDetailViewController alloc] initWithNibName:@"ICEMoneyDetailViewController" bundle:[NSBundle mainBundle]];
//        [self.navigationController pushViewController:iCECash animated:YES];
        if ([self shouldPushBindPhoneVc]) return;

        XYMoneyDetailViewController *detailVc = [[XYMoneyDetailViewController alloc] init];
        [self.navigationController pushViewController:detailVc animated:YES];
    }];
    [[self.explainBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        XYCashExplanationController *explainVc = [[XYCashExplanationController alloc] init];
        [self.navigationController pushViewController:explainVc animated:YES];
    }];
}

/// 检测是否需要去绑定手机号
- (BOOL)shouldPushBindPhoneVc {
    //    NSString *phone = DEF_PERSISTENT_GET_OBJECT(DEF_USERNAME);
    if ([self.infoModel.is_bind isEqualToString:@"2"]) { // 没有绑定手机号
        XYInquireWageViewController *bindVc = [[XYInquireWageViewController alloc] init];
        bindVc.titleText = @"绑定手机号";
        bindVc.commitBtnText = @"绑定手机号";
        [self.navigationController pushViewController:bindVc animated:YES];
        return YES;
    }
    return NO;
}


- (void)configLab {
    
    
//    NSString *commission = [TZUserManager getUserCommission];
//    if (commission == nil) {
//        [TZUserManager syncUserCommissionWithCompletion:^(NSString *commission) {
//            self.labComMoney.text = [NSString stringWithFormat:@"¥%@", commission];
//            [NSAttributedString attributedStringsWithLabel:self.labComMoney textFont:28 textRange:NSMakeRange(0, 1) textColor:[UIColor whiteColor] isBoldFont:YES];
//        }];
//    }
    self.labComMoney.text = [NSString stringWithFormat:@"¥%@", [TZUserManager getUserModel].commission];
    [NSAttributedString attributedStringsWithLabel:self.labComMoney textFont:28 textRange:NSMakeRange(0, 1) textColor:[UIColor whiteColor] isBoldFont:YES];
}


- (void)loadType:(NSString *)type {
    if ([type isEqualToString:@"0"]) {
        _verifyType = XYIdentVerifyNoCheck;
    } else if ([type isEqualToString:@"1"]) {
        _verifyType = XYIdentVerifyProceed;
    } else if ([type isEqualToString:@"2"]) {
        _verifyType = XYIdentVerifyNotYet;
    } else if ([type isEqualToString:@"3"]) {
        _verifyType = XYIdentVerifyPass;
    }
}


/// 去我的佣金页面
- (void)pushMyMoneyVc {
    switch (_verifyType) {
            case XYIdentVerifyNoCheck: {
                XYFaceCertifyViewController *faceVc = [[XYFaceCertifyViewController alloc] init];
                [self.navigationController pushViewController:faceVc animated:YES];
                
            } break;
            case XYIdentVerifyProceed: {
                ICECommissionViewController *iCECommission = [[ICECommissionViewController alloc] initWithNibName:@"ICECommissionViewController" bundle:[NSBundle mainBundle] commissionType:ICECommissionTypePassing];
                iCECommission.style = ICECommissionStyleCommiss;
                [self.navigationController pushViewController:iCECommission animated:YES];
            }  break;
            case XYIdentVerifyNotYet: {
                ICECommissionViewController *iCECommission = [[ICECommissionViewController alloc] initWithNibName:@"ICECommissionViewController" bundle:[NSBundle mainBundle] commissionType:ICECommissionTypeNoPass];
                iCECommission.style = ICECommissionStyleCommiss;
                [self.navigationController pushViewController:iCECommission animated:YES];
            } break;
            case XYIdentVerifyPass: {
                XYCashCategoryController *categoryVc = [[XYCashCategoryController alloc] init];
                [self.navigationController pushViewController:categoryVc animated:YES];
                
            } break;
        default: break;
    }
}




@end
