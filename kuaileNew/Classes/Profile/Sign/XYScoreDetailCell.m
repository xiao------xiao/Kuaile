//
//  XYScoreDetailCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/17.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYScoreDetailCell.h"
#import "XYPointTaskModel.h"

@interface XYScoreDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end


@implementation XYScoreDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(XYPointDetailModel *)model {
    _model = model;
    self.timeLabel.text = model.time;
    self.contentLabel.text = model.content;
    self.scoreLabel.text = model.point;
}



@end
