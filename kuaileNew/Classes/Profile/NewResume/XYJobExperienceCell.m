//
//  XYJobExperienceCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/2.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYJobExperienceCell.h"
#import "TZJobExpModel.h"

@interface XYJobExperienceCell ()
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutJobLabel;


@end

@implementation XYJobExperienceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.categoryLabel.font = [UIFont boldSystemFontOfSize:17];
}

- (void)setModel:(TZJobExpModel *)model {
    _model = model;
    NSString *timeStr = [NSString stringWithFormat:@"%@ 至 %@",model.job_start,model.job_end];
    self.timeLabel.text = timeStr;
    self.categoryLabel.text = model.job_name;
    self.companyLabel.text = model.company_name;
    self.aboutJobLabel.text = model.job_desc;
}

@end
