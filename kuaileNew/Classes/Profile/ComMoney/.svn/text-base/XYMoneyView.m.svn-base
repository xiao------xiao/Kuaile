//
//  XYMoneyView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/20.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYMoneyView.h"


@implementation XYMoneyView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYMoneyView" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.moneyTextField.font = [UIFont systemFontOfSize:28];
    self.moneyTextField.clearButtonMode = UITextFieldViewModeAlways;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.height = 120;
}

@end
