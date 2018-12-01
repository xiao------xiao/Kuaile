//
//  XYJobCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/22.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYJobCell.h"
#import "TZJobModel.h"

@interface XYJobCell ()

@property (weak, nonatomic) IBOutlet UILabel *jobCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *wageLabel;

@end

@implementation XYJobCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.jobCategoryLabel.font = [UIFont boldSystemFontOfSize:16];
    self.wageLabel.font = [UIFont boldSystemFontOfSize:16];
    self.deleteBtn.hidden = YES;
}

- (void)setModel:(TZJobModel *)model {
    _model = model;
    self.jobCategoryLabel.text = model.recruit_name;
    self.companyLabel.text = model.company_name;
    self.locationLabel.text = model.address;
    self.wageLabel.text = model.salary;
    self.deleteBtn.hidden = !model.edit;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 已投递",model.sendtime];
}

- (IBAction)deleteBtnClick:(id)sender {
    if (self.didClickDeleteBtnBlock) {
        self.didClickDeleteBtnBlock();
    }
}



@end
