//
//  XYCashCategoryView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/4/24.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCashCategoryView.h"

@implementation XYCashCategoryView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYCashCategoryView" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectAlipay.image = [UIImage imageNamed:@"对号"];
}





@end
