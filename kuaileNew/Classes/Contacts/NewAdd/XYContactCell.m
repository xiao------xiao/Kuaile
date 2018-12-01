//
//  XYContactCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/6/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYContactCell.h"
#import "XYContactModel.h"

@implementation XYContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarView.layer.cornerRadius = 27;
    self.avatarView.clipsToBounds = YES;
    if (mScreenWidth < 375) {
        self.addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
}

- (void)setType:(XYContactCellType)type {
    _type = type;
    if (type == XYContactCellTypeAdd) {
        [self.addBtn setTitle:@"+ 关注" forState:0];
        self.addBtn.layer.borderColor = TZMainColor.CGColor;
        self.addBtn.layer.borderWidth = 1.0;
        self.addBtn.layer.cornerRadius = 30 / 2.0;
        [self.addBtn setTitleColor:TZMainColor forState:UIControlStateNormal];
    } else {
        [self.addBtn setTitle:@"互相关注" forState:0];
        [self.addBtn setTitleColor:TZColorRGB(214) forState:0];
        self.addBtn.layer.borderWidth = 0;
    }
}

- (void)setModel:(XYContactModel *)model {
    _model = model;
    [self.avatarView sd_setImageWithURL:TZImageUrlWithShortUrl(model.avatar) placeholderImage:TZPlaceholderAvaterImage];
    self.name.text = model.name;
    self.phone.text = model.mobile;
}

- (IBAction)addBtnClick:(id)sender {
    if (self.didClickAddBtnBlock) {
        self.didClickAddBtnBlock();
    }
}


@end
