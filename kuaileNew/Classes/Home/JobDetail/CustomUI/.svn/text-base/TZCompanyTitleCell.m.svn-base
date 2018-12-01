//
//  TZCompanyTitleCell.m
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZCompanyTitleCell.h"
#import "TZCompanyTitleModel.h"

@interface TZCompanyTitleCell()
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *size;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *companyType;
@property (weak, nonatomic) IBOutlet UIImageView *imgCompany;

// 5个星星
@property (strong, nonatomic) IBOutlet UIImageView *firstStar;
@property (strong, nonatomic) IBOutlet UIImageView *twoStar;
@property (strong, nonatomic) IBOutlet UIImageView *threeStar;
@property (strong, nonatomic) IBOutlet UIImageView *fourStar;
@property (strong, nonatomic) IBOutlet UIImageView *fiveStar;

// 认证
@property (weak, nonatomic) IBOutlet UIImageView *certifyImageView;
@property (weak, nonatomic) IBOutlet UILabel *certifyLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *certifyImageViewLeftContraint;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adressHeight;
// 地图

@end

@implementation TZCompanyTitleCell

- (void)awakeFromNib {

}
- (IBAction)map:(UIButton *)sender {
    // 用经纬度信息，加载地图.调用block，控制器去做事
    if (self.openMapBlock) {
        self.openMapBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZCompanyTitleCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setModel:(TZCompanyTitleModel *)model {
    _model = model;
    self.name.text = model.name;
    self.size.text = [NSString stringWithFormat:@"%@",model.company_scope];
    if (mScreenWidth >= 375) {
        self.adressHeight.constant = 20;
    }else {
        self.adressHeight.constant = 40;
    }
    self.address.text = model.street;
    self.companyType.text = [NSString stringWithFormat:@"%@  %@",model.company_industry,model.company_property];
    self.starNum = model.star.integerValue;
    [self.imgCompany sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"JobDetail_nopic"]];
    [self.backGroundImage sd_setImageWithURL:TZImageUrlWithShortUrl(model.logo) placeholderImage:[UIImage imageNamed:@"JobDetail_nopic"]];
    // 诚信认证
    self.certifyImageView.hidden = [model.verify isEqualToNumber:@1] ? NO : YES;
    self.certifyLable.text = [model.verify isEqualToNumber:@1] ? @"已通过企业诚信认证" : @"未通过认证";
    self.certifyImageViewLeftContraint.constant = [model.verify isEqualToNumber:@1] ? 5 : -16;
}

/** 设置星级 */
- (void)setStarNum:(NSInteger)starNum {
    _starNum = starNum;
    UIImage *star_sel = [UIImage imageNamed:@"recruit_star_sel"];
    UIImage *star_def = [UIImage imageNamed:@"recruit_star_def"];
    self.firstStar.image = starNum >= 1 ? star_sel : star_def;
    self.twoStar.image = starNum >= 2 ? star_sel : star_def;
    self.threeStar.image = starNum >= 3 ? star_sel : star_def;
    self.fourStar.image = starNum >= 4 ? star_sel : star_def;
    self.fiveStar.image = starNum >= 5 ? star_sel : star_def;
}

@end
