//
//  XYCashView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/4/24.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCashBankView.h"

@implementation XYCashBankView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYCashBankView" owner:self options:nil] lastObject];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.account.clearButtonMode = UITextFieldViewModeAlways;
    self.name.clearButtonMode = UITextFieldViewModeAlways;
    self.bank.clearButtonMode = UITextFieldViewModeAlways;
    if (mScreenWidth < 375) {
        self.tipLabel.font = [UIFont systemFontOfSize:8];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.height = 190;
}

@end
