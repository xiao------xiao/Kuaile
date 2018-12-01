//
//  XYCashExplanationController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/4/24.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCashExplanationController.h"

@interface XYCashExplanationController ()

@end

@implementation XYCashExplanationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佣金提现说明";
    [self configLabel];
}

- (void)configLabel {
    CGFloat labelH;
    if (mScreenWidth == 375) {
        labelH = 120;
    } else if (mScreenWidth == 320) {
        labelH = 150;
    } else {
        labelH = 110;
    }
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 12, mScreenWidth - 20, labelH);
    label.text = @"提现说明：\n1.用户所得的佣金、返现可在开心工作APP上进行提现。\n2.提现时，用户需完成实名认证，提现信息（支付宝、银联卡等信息）必须真实有效，与实名认证相符。\n3.用户应妥善保管自己的账号信息，如提现用户需缴纳相关税收的，由用户自行承担。";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = TZGreyText74Color;
    [self.view addSubview:label];
}


@end
