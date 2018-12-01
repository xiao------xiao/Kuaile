//
//  XYGroupCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYGroupCell.h"
#import "TZFindSnsModel.h"
#import "XYGroupInfoModel.h"

@interface XYGroupCell ()


@end

@implementation XYGroupCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYGroupCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.avaterView.layer.cornerRadius = 4;
    self.featherLabel.backgroundColor = TZColor(79, 200, 255);
    self.numLabel.backgroundColor = TZColor(255, 204, 87);
    self.featherLabel.layer.cornerRadius = 3;
    self.numLabel.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setGroupInfoModel:(XYGroupInfoModel *)groupInfoModel {
    _groupInfoModel = groupInfoModel;
    NSString *imageName = [UIImage imageNamed:@"groupPrivateHeader"];
    [self.avaterView sd_setImageWithURL:TZImageUrlWithShortUrl(groupInfoModel.avatar) placeholderImage:imageName options:SDWebImageRefreshCached];
    self.titleLabel.text = groupInfoModel.owner;
    self.statusLabel.text = groupInfoModel.desc;
    NSString *lab = groupInfoModel.lab_name;
    if (!lab && lab.length == 0) {
        self.featherLabel.hidden = YES;
        self.featherLabelConstraintW.constant = 0;
        self.numLabelLeftConstraint.constant = 0;
    } else {
        CGFloat labW = [CommonTools sizeOfText:lab fontSize:13].width;
        self.featherLabel.text = lab;
        self.featherLabelConstraintW.constant = labW + 20;
    }
    NSString *num;
    if (groupInfoModel.total_member.length) {
        num = [NSString stringWithFormat:@"%@人",groupInfoModel.total_member];
    } else {
        if (groupInfoModel.people_num.length) {
            num = [NSString stringWithFormat:@"%@人",groupInfoModel.people_num];
        } else {
            num = [NSString stringWithFormat:@"%@人",groupInfoModel.groups[@"people_num"]];
        }
    }
    CGFloat feaW = [CommonTools sizeOfText:num fontSize:13].width;
    self.numLabel.text = num;
    self.numLabelConstraintW.constant = feaW + 20;
}

//- (void)setGroup:(EMGroup *)group {
//    _group = group;
//    NSString *imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
//    NSString *strImg = [ApiTeamAvatar stringByAppendingString:group.groupId];
//    [self.avaterView sd_setImageWithURL:TZImageUrlWithShortUrl(strImg) placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageRefreshCached];
//    if (group.groupSubject && group.groupSubject.length > 0) {
//        self.titleLabel.text = group.groupSubject;
//    } else {
//        self.titleLabel.text = group.groupId;
//    }
//    self.statusLabel.text = group.groupDescription;
//    NSString *groupNum = [NSString stringWithFormat:@"%zd人",group.occupants.count];
//    CGFloat numW = [CommonTools sizeOfText:groupNum fontSize:13].width;
//    self.numLabel.text = groupNum;
//    self.numLabelConstraintW.constant = numW + 20;
//    self.featherLabelConstraintW.constant = numW + 20;
//}


-(void)setModel:(getRecommendGroup *)model {
    _model = model;
    [self.avaterView sd_setImageWithURL:TZImageUrlWithShortUrl(model.avatar) placeholderImage:TZPlaceholderImage];
    self.titleLabel.text = model.owner;
    NSString *groupLab = model.lab_name;
    if (!groupLab || groupLab.length == 0) {
        self.featherLabel.hidden = YES;
        self.featherLabelConstraintW.constant = 0;
        self.numLabelLeftConstraint.constant = 0;
    } else {
        CGFloat labW = [CommonTools sizeOfText:groupLab fontSize:13].width;
        self.featherLabel.hidden = NO;
        self.featherLabel.text = groupLab;
        self.featherLabelConstraintW.constant = labW + 20;
    }
    if (model.people_num && model.people_num.length) {
        self.numLabel.text = [NSString stringWithFormat:@"%@ 人",model.people_num];
    } else {
        self.numLabel.text = [NSString stringWithFormat:@"%@ 人",model.groups[@"people_num"]];
    }
    self.statusLabel.text = model.desc;
}
@end
