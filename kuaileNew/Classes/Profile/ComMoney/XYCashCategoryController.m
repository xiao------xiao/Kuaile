//
//  XYCashCategoryController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/4/24.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCashCategoryController.h"
#import "XYCashCategoryView.h"
#import "XYCashViewController.h"
#import "YYControl.h"

@interface XYCashCategoryController ()
@property (nonatomic, strong) XYCashCategoryView *cashCategoryView;
@property (nonatomic, assign) NSInteger selectedNum;
@end

@implementation XYCashCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佣金提现";
    self.selectedNum = 1;
    [self configCashCategoryView];
    [self configNextBtn];
}

- (void)configCashCategoryView {
    _cashCategoryView = [[XYCashCategoryView alloc] init];
    _cashCategoryView.frame = CGRectMake(20, 20, mScreenWidth - 40, 150);
    // 支付宝
    [_cashCategoryView.alipayBtn setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        _cashCategoryView.selectCard.image = [UIImage imageNamed:@"xuanze_def"];
        _cashCategoryView.selectAlipay.image = [UIImage imageNamed:@"对号"];
        self.selectedNum = 1;
    }];
    // 银联
    [_cashCategoryView.cardBtn setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        _cashCategoryView.selectAlipay.image = [UIImage imageNamed:@"xuanze_def"];
        _cashCategoryView.selectCard.image = [UIImage imageNamed:@"对号"];
        self.selectedNum = 2;
    }];
    // 微信
    [_cashCategoryView.wechatBtn setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self showInfo:@"暂未开通"];
//        self.selectedNum = 3;
    }];
    [self.view addSubview:_cashCategoryView];
}

- (void)configNextBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, (mScreenHeight - 64)/2.0, mScreenWidth - 40, 45);
    [btn setBackgroundColor:TZColor(0, 194, 255)];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.layer.cornerRadius = 45/2.0;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)nextBtnClick {
    XYCashViewController *cashVc = [[XYCashViewController alloc] init];
    if (self.selectedNum == 1) {
        cashVc.type = XYCashViewControllerTypeAlipay;
    } else if (self.selectedNum == 2) {
        cashVc.type = XYCashViewControllerTypeCard;
    }
    [self.navigationController pushViewController:cashVc animated:YES];
}







@end
