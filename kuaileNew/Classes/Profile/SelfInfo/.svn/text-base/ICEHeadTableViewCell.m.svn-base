//
//  ICEHeadTableViewCell.m
//  hxjj
//
//  Created by ttouch on 15/7/20.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICEHeadTableViewCell.h"
#import "XYUserInfoModel.h"

@implementation ICEHeadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ICEHeadTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    self.imgHeadBtn.layer.cornerRadius = self.imgHeadBtn.height / 2;
    self.imgHeadBtn.clipsToBounds = YES;
    self.coverBtn.contentMode = UIViewContentModeScaleAspectFill;
    self.coverBtn.clipsToBounds = YES;
    self.coverBtn.userInteractionEnabled = NO;
    self.careNumLabel.font = [UIFont boldSystemFontOfSize:22];
    self.careText.font = [UIFont boldSystemFontOfSize:14];
    self.fansLabel.font = [UIFont boldSystemFontOfSize:22];
    self.fanText.font = [UIFont boldSystemFontOfSize:14];
    self.tiesLabel.font = [UIFont boldSystemFontOfSize:22];
    self.tieText.font = [UIFont boldSystemFontOfSize:14];
}


- (void)setModel:(XYUserInfoModel *)model {
    _model = model;
    [self.imgHeadBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar] forState:0 placeholderImage:TZPlaceholderAvaterImage];
    [self.coverBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.background] forState:0 placeholderImage:XYPlaceHolderBgImage];
    UIImage *sexImg;
    if ([model.gender isEqualToString:@"0"]) {
        sexImg = [UIImage imageNamed:@"boy"];
    } else {
        sexImg = [UIImage imageNamed:@"girl"];
    }
    [self.sexBtn setBackgroundImage:sexImg forState:0];
    [self.sexBtn setTitle:model.age forState:0];
    self.nameLabel.text = model.nickname.length ? model.nickname : model.username;
    if (model.sign && model.sign.length) {
        self.signLabel.text = model.sign;
    } else {
        self.signLabel.text = @"未填写个性签名";
    }
    self.careNumLabel.text = model.attention_num;
    self.fansLabel.text = model.fans_num;
    self.tiesLabel.text = model.sns_num;
    self.distance_timeLabel.text = [NSString stringWithFormat:@"%@km   %@",model.distance,model.created];
}

- (IBAction)clickHeadImgBtn:(id)sender {
    if (self.blockEditHeadImg) {
        self.blockEditHeadImg();
    }
}
- (IBAction)coverBtnClick:(id)sender {
    
}

- (IBAction)changeBtnClick:(id)sender {
    if (self.didClickChangeBtnBlock) {
        self.didClickChangeBtnBlock();
    }
}

- (IBAction)tieBtnCLick:(id)sender {
    if (self.didClickTieBtnBlock) {
        self.didClickTieBtnBlock();
    }
}
- (IBAction)fanBtnClick:(id)sender {
    if (self.didClickFanBtnBlock) {
        self.didClickFanBtnBlock();
    }
}
- (IBAction)attentionBtnClicl:(id)sender {
    if (self.didClickAttentionBtnBlock) {
        self.didClickAttentionBtnBlock();
    }
}

@end
