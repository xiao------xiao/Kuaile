//
//  TZAddFriendCell.m
//  kuaile
//
//  Created by ttouch on 2016/12/23.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import "TZAddFriendCell.h"
#import "TZFindSnsModel.h"
#import "XYRecommendFriendModel.h"

@interface TZAddFriendCell ()


@end

@implementation TZAddFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImageView.layer.cornerRadius = 40/2.0;
    if (mScreenWidth < 375) {
        self.attentionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
}

- (void)setType:(TZAddFriendCellType)type {
    _type = type;
    if (type == TZAddFriendCellTypeSingleAttention) {
        [self.attentionBtn setTitle:@"已关注" forState:0];
        self.attentionBtn.layer.borderWidth = 0;
    } else if (type == TZAddFriendCellTypeBothAttention) {
        [self.attentionBtn setTitle:@"互相关注" forState:0];
        [self.attentionBtn setTitleColor:TZColorRGB(214) forState:0];
        self.attentionBtn.layer.borderWidth = 0;
    } else if (type == TZAddFriendCellTypeAgreenAttention) {
        [self.attentionBtn setTitle:@"已同意" forState:0];
        self.attentionBtn.layer.borderWidth = 0;
    } else if (type == TZAddFriendCellTypeNoAttention){
        [self.attentionBtn setTitle:@"+ 关注" forState:0];
        self.attentionBtn.layer.borderColor = TZMainColor.CGColor;
        self.attentionBtn.layer.borderWidth = 1.0;
        self.attentionBtn.layer.cornerRadius = 29 / 2.0;
        [self.attentionBtn setTitleColor:TZMainColor forState:UIControlStateNormal];
    }
}

- (void)setRecommendFriendMode:(XYRecommendFriendModel *)recommendFriendMode {
    _recommendFriendMode = recommendFriendMode;
    NSString *sex = recommendFriendMode.gender;
    if (sex.integerValue == 0) {
        [self.ageBtn setBackgroundImage:[UIImage imageNamed:@"boy"] forState:UIControlStateNormal];
    } else {
        [self.ageBtn setBackgroundImage:[UIImage imageNamed:@"girl"] forState:UIControlStateNormal];
    }
    NSString *nickName = recommendFriendMode.nickname;
    CGFloat nicknameW = [CommonTools sizeOfText:nickName fontSize:14].width + 2;
    if (nicknameW > mScreenWidth * 0.45) nicknameW = mScreenWidth * 0.45;
    self.nameLable.text = nickName;
    self.nameLabelConstraintW.constant = nicknameW;
    [self.ageBtn setTitle:recommendFriendMode.age forState:0];
    [self.avatarImageView sd_setImageWithURL:TZImageUrlWithShortUrl(recommendFriendMode.avatar) placeholderImage:TZPlaceholderAvaterImage];
    if (recommendFriendMode.sametown) self.fromLabel.text = @"来自老乡";
}


- (IBAction)attentionBtnClick:(id)sender {
    if (self.didAttentionBlock) {
        self.didAttentionBlock();
    }
}

@end
