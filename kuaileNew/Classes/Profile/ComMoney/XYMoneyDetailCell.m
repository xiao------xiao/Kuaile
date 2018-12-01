//
//  XYMoneyDetailCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/24.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYMoneyDetailCell.h"
#import "XYMoneyDetailModel.h"

@interface XYMoneyDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation XYMoneyDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numLabel.textColor = TZColorRGB(92);
}


- (void)setModel:(XYMoneyDetailModel *)model {
    _model = model;
//    NSString *title = [NSString stringWithFormat:@"%@ %@",model.create_time,model.company];
    NSString *title = [NSString stringWithFormat:@"%@",model.create_time];
    self.timeLabel.text = title;
    self.categoryLabel.text = model.content;
    NSString *commission = model.commission;
    self.numLabel.text = commission;
    if (commission.floatValue > 0) {
        self.numLabel.textColor = TZColor(6, 191, 252);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
