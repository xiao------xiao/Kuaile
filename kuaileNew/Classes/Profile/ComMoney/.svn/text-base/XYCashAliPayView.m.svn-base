//
//  XYCashAliPayView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/4/24.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCashAliPayView.h"

@implementation XYCashAliPayView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYCashAliPayView" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.aliPay.clearButtonMode = UITextFieldViewModeAlways;
    self.aliPayAgain.clearButtonMode = UITextFieldViewModeAlways;
    self.name.clearButtonMode = UITextFieldViewModeAlways;
    if (mScreenWidth < 375) {
        self.tipLabel.font = [UIFont systemFontOfSize:8];
    }
}


- (void)layoutSubviews {
    self.height = 253;
}


@end
