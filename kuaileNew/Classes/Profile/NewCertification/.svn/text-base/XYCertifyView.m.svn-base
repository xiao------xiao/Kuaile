//
//  XYCertifyView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCertifyView.h"

@implementation XYCertifyView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYCertifyView" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.faceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.cardBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.waitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    CGFloat imgViewW = 60;
    if (mScreenWidth < 375) imgViewW = 30;
    if (mScreenWidth >= 540) imgViewW = 80;
    self.lastImgConstraintW.constant = imgViewW;
    self.faceBtn.enabled = NO;
    self.cardBtn.enabled = NO;
    self.waitBtn.enabled = NO;
}

- (IBAction)faceBtnClick:(id)sender {
}

- (IBAction)cardBtnClick:(id)sender {
    if (self.didClickBtnBlock) {
        self.didClickBtnBlock();
    }
}

- (IBAction)waitBtnClick:(id)sender {
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat certifyViewH = 50;
    if (mScreenWidth < 375) certifyViewH = 44;
    self.height = certifyViewH;
}



@end
