//
//  XYCashCodeView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/4/24.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCashCodeView.h"

@implementation XYCashCodeView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYCashCodeView" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.clipsToBounds = YES;
    self.code.clearButtonMode = UITextFieldViewModeAlways;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.height = 80;
}

@end
