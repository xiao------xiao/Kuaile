//
//  XYScoreTaskCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/17.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYScoreTaskCell.h"
#import "XYPointTaskModel.h"

@interface XYScoreTaskCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;


@end

@implementation XYScoreTaskCell



- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setType:(XYScoreTaskCellType)type {
    _type = type;
    if (type == XYScoreTaskCellTypeLabe) {
        self.rewardBtn.userInteractionEnabled = NO;
        self.rewardBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setupRewardBtnTitleColor:TZGreyText74Color bgImage:nil borderW:0 borderColor:nil];
    } else if (type == XYScoreTaskCellTypeButtonDoing) {
        self.rewardBtn.userInteractionEnabled = NO;
        self.rewardBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.rewardBtn setTitle:@"进行中" forState:0];
        [self setupRewardBtnTitleColor:TZColor(253, 130, 73) bgImage:nil borderW:0.8 borderColor:TZColor(253, 130, 73)];
    } else if (type == XYScoreTaskCellTypeButtonDone){
        self.rewardBtn.userInteractionEnabled = NO;
        self.rewardBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.rewardBtn setTitle:@"已领取" forState:0];
        [self setupRewardBtnTitleColor:TZGreyText150Color bgImage:nil borderW:0.8 borderColor:TZColorRGB(200)];
    } else {
        self.rewardBtn.userInteractionEnabled = YES;
        self.rewardBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.rewardBtn setTitle:@"领取奖励" forState:0];
        [self setupRewardBtnTitleColor:[UIColor whiteColor] bgImage:@"Background" borderW:0 borderColor:nil];
    }
}

- (void)setModel:(XYPointTaskSingleModel *)model {
    _model = model;
    self.titleLabel.text = model.mission_name;
    self.scoreLabel.text = model.point;
}

- (void)setupRewardBtnTitleColor:(UIColor *)titleColor bgImage:(NSString *)bgImage borderW:(CGFloat)borderW borderColor:(UIColor *)borderColor {
    self.rewardBtn.layer.cornerRadius = self.rewardBtn.height / 2.0;
    self.rewardBtn.clipsToBounds = YES;
    [self.rewardBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.rewardBtn setBackgroundImage:[UIImage imageNamed:bgImage?bgImage:@""] forState:UIControlStateNormal];
    [self.rewardBtn.layer setBorderColor:borderColor.CGColor];
    [self.rewardBtn.layer setBorderWidth:borderW];
}


- (IBAction)rewardBtnClick:(id)sender {
    if (self.receiveRewardBlock) {
        self.receiveRewardBlock();
    }
}

@end
