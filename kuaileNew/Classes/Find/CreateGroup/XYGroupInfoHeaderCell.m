//
//  XYGroupInfoHeaderCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/4/13.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYGroupInfoHeaderCell.h"
#import "XYGroupInfoModel.h"

@implementation XYGroupInfoHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleField.font = [UIFont boldSystemFontOfSize:17];
    self.avatarView.layer.cornerRadius = 3;
    self.avatarView.clipsToBounds = YES;
    self.avatarContentView.layer.cornerRadius = 5;
    self.avatarContentView.clipsToBounds = YES;
    self.titleField.userInteractionEnabled = NO;
    self.descView.userInteractionEnabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAvatarView)];
    [self.avatarView addGestureRecognizer:tap];
}

- (void)setModel:(XYGroupInfoModel *)model {
    _model = model;
    [self.avatarView sd_setImageWithURL:TZImageUrlWithShortUrl(model.avatar) placeholderImage:TZPlaceholderImage];
    
    if (model.bgImg) {
        self.bgAvatarView.image = model.bgImg;
    }else  {
        [self.bgAvatarView sd_setImageWithURL:TZImageUrlWithShortUrl(model.background) placeholderImage:XYPlaceHolderBgImage];

    }
    self.titleField.text = model.owner;
    self.descView.text = model.desc;
    self.distanceLabel.text = model.distance;
}

- (IBAction)changeBtnClick:(UIButton *)sender {
    if (self.didChangeBgAvatarBlock) {
        self.didChangeBgAvatarBlock();
    }
}

- (void)didTapAvatarView {
    if (self.didChangeAvatarBlock) {
        self.didChangeAvatarBlock();
    }
}




@end
