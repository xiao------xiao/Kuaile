//
//  HJZanListCell.m
//  kuaile
//
//  Created by 胡光健 on 2017/3/16.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "HJZanListCell.h"
#import "HJZanListModel.h"

@implementation HJZanListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainImageView.layer.cornerRadius = 40 / 2;
    self.mainImageView.layer.masksToBounds = YES;
    
    if (mScreenWidth < 375) {
        self.focousBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
}

-(void)setModel:(HJZanListModel *)model {
    _model = model;
    [_mainImageView sd_setImageWithURL:TZImageUrlWithShortUrl(model.uvatar) placeholderImage:TZPlaceholderAvaterImage];
    _nameLabel.text = model.unickname;
    if ([model.usex isEqualToString:@"0"]) {
        [_ageBtn setBackgroundImage:[UIImage imageNamed:@"boy"] forState:UIControlStateNormal];
        [_ageBtn setTitle:model.age forState:UIControlStateNormal];
    }else {
        [_ageBtn setBackgroundImage:[UIImage imageNamed:@"girl"] forState:UIControlStateNormal];
        [_ageBtn setTitle:model.age forState:UIControlStateNormal];
    }
}

- (void)setType:(HJZanListCellType)type {
    _type = type;
    if (type == HJZanListCellTypeAttention) {
        [self.focousBtn setTitle:@"互相关注" forState:0];
        self.focousBtn.layer.borderWidth = 0;
        [self.focousBtn setTitleColor:TZColorRGB(214) forState:0];
    } else {
        [self.focousBtn setTitle:@"+ 关注" forState:0];
        self.focousBtn.layer.borderColor = TZMainColor.CGColor;
        self.focousBtn.layer.borderWidth = 1.0;
        self.focousBtn.layer.cornerRadius = 29 / 2.0;
        [self.focousBtn setTitleColor:TZMainColor forState:UIControlStateNormal];
    }
}

- (IBAction)focousButton:(UIButton *)sender {
    if (self.didClickAttentionBtnBlock) {
        self.didClickAttentionBtnBlock();
    }
}



@end
