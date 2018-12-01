
//
//  ORSystemMegCell.m
//  kuaile
//
//  Created by 欧阳荣 on 2017/3/28.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "ORSystemMegCell.h"

#import "XYMessageModel.h"
#import "ORTimeTool.h"

@implementation ORSystemMegCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)loadModelData:(XYMessageModel *)model {
    self.timeLabel.text = [ORTimeTool timeShortStr:model.create_at.integerValue];
    self.timeMLabel.text = self.timeLabel.text;
    [self.tintImage sd_setImageWithURL:[NSURL URLWithString:model.data_avatar] placeholderImage:[UIImage imageNamed:@"Icon-40"]];
    self.contentLabel.text = model.content;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
}



@end
