//
//  TZJobExpCell.m
//  kuaile
//
//  Created by liujingyi on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobExpCell.h"
#import "TZJobExpModel.h"

@interface TZJobExpCell ()
@property (strong, nonatomic) IBOutlet UILabel *startDate;
@property (strong, nonatomic) IBOutlet UILabel *endDate;
@property (strong, nonatomic) IBOutlet UILabel *job;
@property (strong, nonatomic) IBOutlet UILabel *company;
@property (strong, nonatomic) IBOutlet UILabel *describe;

@end

@implementation TZJobExpCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(TZJobExpModel *)model {
    _model = model;
    self.startDate.text = model.job_start;
    self.endDate.text = model.job_end;
    self.job.text = model.job_name;
    self.company.text = model.company_name;
    self.describe.text = model.job_desc;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZJobExpCell" owner:self options:nil] lastObject];
    }
    return self;
}

@end
