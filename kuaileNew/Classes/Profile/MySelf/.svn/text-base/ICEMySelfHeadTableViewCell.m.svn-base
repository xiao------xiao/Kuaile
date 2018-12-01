//
//  ICEMySelfHeadTableViewCell.m
//  hxjjyh
//
//  Created by ttouch on 15/8/25.
//  Copyright (c) 2015年 陈冰. All rights reserved.
//

#import "ICEMySelfHeadTableViewCell.h"
#import "XYUserInfoModel.h"

@implementation ICEMySelfHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgViewHead.layer.cornerRadius = 30;
    self.imgViewHead.contentMode = UIViewContentModeScaleAspectFill;
    self.imgViewHead.clipsToBounds = YES;
    self.vertifyBtn.layer.cornerRadius = 3;
    self.vertifyBtn.clipsToBounds = YES;
    [self.vertifyBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.vertifyBtn.layer setBorderWidth:0.8];
    if (mScreenWidth < 375) self.tipLabel.font = [UIFont systemFontOfSize:11];
    self.sexBtn.hidden = YES;
}

- (void)setModel:(XYUserInfoModel *)model {
    _model = model;
    NSString *salary = model.salary_date;
    NSString *point = model.point;
    NSString *commission = model.commission;
    if (!salary || salary.length < 1) { self.salaryLbl.text = @"暂无";}
    else { self.salaryLbl.text = salary;}
    if (!point) { self.labPoints.text = @"0";}
    else {self.labPoints.text = point;}
    if (!commission) { self.commissionLbl.text = @"0";}
    else {self.commissionLbl.text = commission;}
    // 头像
    [self.imgViewHead sd_setImageWithURL:TZImageUrlWithShortUrl(model.avatar) placeholderImage:TZPlaceholderAvaterImage options:SDWebImageRefreshCached];
    if (model.nickname.length > 0) {
        self.labName.text = model.nickname;
    } else {
        self.labName.text = model.username;
    }
    // "verify":0,//0未认证 1审核中 2审核未通过 3审核通过
    NSInteger vertifyStatus = model.verify.integerValue;
    NSString *vertifyStr;
    if (vertifyStatus == 0) {
        vertifyStr = @"未认证";
    } else if (vertifyStatus == 1) {
        vertifyStr = @"审核中";
    } else if (vertifyStatus == 2) {
        vertifyStr = @"审核未通过";
    } else {
        vertifyStr = @"已认证";
    }
    CGFloat textW = [CommonTools sizeOfText:vertifyStr fontSize:13].width + 10;
    self.vertifyTextW.constant = textW;
    [self.vertifyBtn setTitle:vertifyStr forState:0];
}

- (IBAction)clickThreeBtn:(UIButton *)sender {
    if (sender.tag == 1) {
        return;
    }
    if (sender.tag == 2) {
        return;
    }
    if (sender.tag == 3) {
        return;
    }
}

- (IBAction)vertifyBtnClick:(UIButton *)sender {
    NSString *text = sender.titleLabel.text;
    if ([text isEqualToString:@"未认证"] || [text isEqualToString:@"审核未通过"]) {
        if (self.didClickVertifyBtnBlock) {
            self.didClickVertifyBtnBlock(sender.titleLabel.text);
        }
    }
}

- (IBAction)moreBtnClick:(id)sender {
}


- (IBAction)clickQRcode:(id)sender {
    if (self.didCheckCodeBlock) {
        self.didCheckCodeBlock();
    }
}

- (IBAction)salaryBtnClick:(UIButton *)sender {
    if (self.didClickHeaderBtnsBlock) {
        self.didClickHeaderBtnsBlock(sender.tag);
    }
}









@end
