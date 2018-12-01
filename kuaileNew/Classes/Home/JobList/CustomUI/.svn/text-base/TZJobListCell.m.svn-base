//
//  TZJobListCell.m
//  kuaile
//
//  Created by liujingyi on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobListCell.h"
#import "TZJobModel.h"

@interface TZJobListCell ()
@property (strong, nonatomic) IBOutlet UILabel *title;    // 标题
@property (strong, nonatomic) IBOutlet UILabel *date;     // 时间
@property (strong, nonatomic) IBOutlet UILabel *salary;   // 薪水
@property (strong, nonatomic) IBOutlet UILabel *area;     // 地区
@property (strong, nonatomic) IBOutlet UILabel *company;  // 公司
@property (strong, nonatomic) IBOutlet UILabel *count;    // 招聘人数
@property (strong, nonatomic) IBOutlet UILabel *grade;    // 学历
@property (strong, nonatomic) IBOutlet UILabel *experience;// 经验
@property (strong, nonatomic) IBOutlet UIButton *checkBtn;
@property (strong, nonatomic) IBOutlet UIImageView *backMoneyImageView; //返现
@property (weak, nonatomic) IBOutlet UILabel *labDistance;

// 五个星星
@property (strong, nonatomic) IBOutlet UIImageView *firstStar;
@property (strong, nonatomic) IBOutlet UIImageView *secondStar;
@property (strong, nonatomic) IBOutlet UIImageView *thirdStar;
@property (strong, nonatomic) IBOutlet UIImageView *fourthStar;
@property (strong, nonatomic) IBOutlet UIImageView *fifthStar;

// 适配屏幕相关
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *countWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *experienceWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *gradeWidthConstraint;
// 适配cell类型，是否隐藏选择框
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleLeftToSuperViewContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topImageViewLeftContraint;
// 认证
@property (weak, nonatomic) IBOutlet UIImageView *certifyImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *certifyImageViewLeftContraint;
@property (weak, nonatomic) IBOutlet UIImageView *fanxianImgView;

@property (weak, nonatomic) IBOutlet UIView *fanxianSupView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fanxainSupViewH;
@property (weak, nonatomic) IBOutlet UILabel *numMoney;
@property (weak, nonatomic) IBOutlet UILabel *welfareLabel;


@end

@implementation TZJobListCell

- (void)awakeFromNib {
    self.clipsToBounds = YES;
    if (__kScreenHeight == 480 || __kScreenHeight == 568) {
        self.countWidthConstraint.constant = 30;
        self.experienceWidthConstraint.constant = 45;
        self.gradeWidthConstraint.constant = 45;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZJobListCell" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)setModel:(TZJobModel *)model {
    _model = model;
    self.title.text = model.recruit_name;
    self.date.text = model.start_time;
    // 对薪资的显示已做处理 [model的get方法里面已经处理好]
    self.salary.text = model.salary;// 薪资
    self.area.text = model.address;
    self.company.text = model.company_name;
    if (![model.recruit_num isEqualToString:@"若干"]) {
        model.recruit_num = [model.recruit_num stringByAppendingString:@"人"];
    }
    self.count.text = [NSString stringWithFormat:@"%@",model.recruit_num];
    self.grade.text = model.degree;
    self.starNum = model.star.integerValue;
    self.experience.text = model.work_exp;
    self.checkBtn.selected = [self.model.selected isEqual: @(1)] ? YES:NO;
    self.welfareLabel.text = model.welfare;
    self.numMoney.text = [NSString stringWithFormat:@"入职最高返现%@",model.return_money];
//    if (model.distance != nil && model.distance.length > 0) {
//        self.labDistance.hidden = NO;
//        CGFloat floatDist  = [model.distance floatValue];
//        self.labDistance.text = [NSString stringWithFormat:@"%.2f千米", floatDist];
//    }
    
    // 是否显示置顶图标
//    self.topImageView.hidden = model.istop.integerValue == 1 ? NO : YES;
 
    // 是否显示返现图标
    if ([model.fan isEqualToString:@"1"]) {
        self.fanxainSupViewH.constant = 30;
        self.backMoneyImageView.hidden = YES;
        self.fanxianImgView.hidden = NO;
    } else {
        self.fanxianImgView.hidden = YES;
        self.fanxianSupView.clipsToBounds = YES;
        self.fanxainSupViewH.constant = 5;
        self.backMoneyImageView.hidden = YES;
    }
//    if (model.fan == nil || [model.return_money isEqualToString:@""]) {
//        self.backMoneyImageView.hidden = YES;
//    } else {
//        self.backMoneyImageView.hidden = [model.return_money isEqualToString:@"0"] ? YES : NO;
//    }
    
    // 对图标的位置进行动态计算和排布
    // 返现图标
    CGFloat width = [model.recruit_name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width;
    self.titleToUpImage.constant = __kScreenWidth - width - 52;
    if (__kScreenHeight == 736) {
        self.titleToUpImage.constant = __kScreenWidth - width - 62;
    }
    // 置顶图标
    if (self.backMoneyImageView.isHidden == YES) { // 没有返现 则让置顶贴着标题
        self.topImageViewLeftContraint.constant = -25;
    } else {
        self.topImageViewLeftContraint.constant = 5; // 有重用，数据要重置回来
    }
    
    // 诚信认证
    self.certifyImageView.hidden = [model.verify isEqualToNumber:@1] ? NO : YES;
    self.certifyImageViewLeftContraint.constant = [model.verify isEqualToNumber:@1] ? 3 : -17;
}

- (void)setType:(TZJobListCellType)type {
    _type = type;
    if (self.type == TZJobListCellTypeNormal) {
        self.checkBtn.hidden = NO;
        self.titleLeftToSuperViewContraint.constant = 30;
    } else {
        self.checkBtn.hidden = YES;
        self.titleLeftToSuperViewContraint.constant = 0;
//        self.topImageView.hidden = YES;
        self.titleToUpImage.constant += 30; // 让返现图标左移 30
    }
}

/** 职位的选择框被选中或取消 */
- (IBAction)checkBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    self.model.selected = sender.isSelected == YES ? @(1):@(0);
    
    // 告诉控制器我被选中了
    if ([self.delegate respondsToSelector:@selector(jobListCellDidClickCheckBtn:recruit_id:)]) {
        [self.delegate jobListCellDidClickCheckBtn:self.checkBtn recruit_id:self.model.recruit_id];
    }
}

/** 设置星级 */
- (void)setStarNum:(NSInteger)starNum {
    _starNum = starNum;
    UIImage *star_sel = [UIImage imageNamed:@"recruit_star_sel"];
    UIImage *star_def = [UIImage imageNamed:@"recruit_star_def"];
    self.firstStar.image = starNum >= 1 ? star_sel : star_def;
    self.secondStar.image = starNum >= 2 ? star_sel : star_def;
    self.thirdStar.image = starNum >= 3 ? star_sel : star_def;
    self.fourthStar.image = starNum >= 4 ? star_sel : star_def;
    self.fifthStar.image = starNum >= 5 ? star_sel : star_def;
}

@end
