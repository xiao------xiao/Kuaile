//
//  XYSalaryListCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/28.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSalaryListCell.h"
#import "XYInComeModel.h"


@interface XYSalaryListCell ()
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthsLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *allSalaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UILabel *allTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allTitleLabelLeftMargin;

@end

@implementation XYSalaryListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bigView.backgroundColor = [UIColor whiteColor];
    self.bigView.layer.cornerRadius = 5;
    self.bigView.clipsToBounds = YES;
    if (mScreenWidth < 375) {
        self.monthsLabel.font = [UIFont systemFontOfSize:14];
        self.allTitleLabel.font = [UIFont systemFontOfSize:14];
        self.updateTimeLabel.font = [UIFont systemFontOfSize:11];
        self.allTitleLabelLeftMargin.constant = 25;
    }
}


- (void)setModel:(XYInComeListModel *)model {
    _model = model;
    
    CGFloat frontBoldFont = 24;
    CGFloat backBoldFont = 16;
    if (mScreenWidth < 375) {
        frontBoldFont = 20;
        backBoldFont = 14;
    }
    self.monthCountLabel.attributedText = [NSAttributedString attributedStringsWithFrontText:model.month_count frontBoldFont:frontBoldFont frontColor:TZColor(6, 191, 252) backText:@"个月" backBoldFont:backBoldFont backColor:TZColor(6, 191, 252)];
    self.allSalaryLabel.attributedText = [NSAttributedString attributedStringsWithFrontText:model.total_income frontBoldFont:frontBoldFont frontColor:TZColor(6, 191, 252) backText:@"元" backBoldFont:backBoldFont backColor:TZColor(6, 191, 252)];
    self.companyLabel.text = model.company;
    self.updateTimeLabel.text = [NSString stringWithFormat:@"更新至%@月",model.last_month];
}

- (IBAction)chectBtnClick:(id)sender {
    if (self.didClickCheckBtnBlock) {
        self.didClickCheckBtnBlock();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
