//
//  XYGroupNewsCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/5/4.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYGroupNewsCell.h"

@interface XYGroupNewsCell ()


@end

@implementation XYGroupNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.agreenBtn.layer.cornerRadius = 5;
    self.refuseBtn.layer.cornerRadius = 5;
    self.agreenBtn.clipsToBounds = YES;
    self.refuseBtn.clipsToBounds = YES;
    self.groupAvatar.layer.cornerRadius = 5;
    self.groupAvatar.clipsToBounds = YES;
    [self.agreenBtn setBackgroundColor:TZColor(33, 195, 252)];
    [self.refuseBtn setBackgroundColor:TZColor(253, 124, 119)];
    
    self.agreenBtn.hidden = YES;
    self.refuseBtn.hidden = YES;
}

- (IBAction)doNewsBtnClick:(UIButton *)sender {
    if (sender.tag == 3) { // 同意
        if (self.doGroupNewsBlock) {
            self.doGroupNewsBlock(YES);
        }
    } else { // 拒绝
        if (self.doGroupNewsBlock) {
            self.doGroupNewsBlock(NO);
        }
    }
}




@end
