//
//  HomeSquareCell.m
//  kuaileNew
//
//  Created by admin on 2018/11/23.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "HomeSquareCell.h"

@implementation HomeSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.lbl_1 setTextColor:color_darkgray];
    [self.lbl_1 setFont:xfont(11)];
    [self.lbl_2 setTextColor:color_darkgray];
    [self.lbl_2 setFont:xfont(11)];
    [self.lbl_3 setTextColor:color_darkgray];
    [self.lbl_3 setFont:xfont(11)];
    [self.lbl_4 setTextColor:color_darkgray];
    [self.lbl_4 setFont:xfont(11)];
    
    [self.lbl_1 setText:@"入职返现"];
    [self.lbl_2 setText:@"热门工作"];
    [self.lbl_3 setText:@"服务门店"];
    [self.lbl_4 setText:@"推荐有奖"];
    
}
+(CGFloat)cellHeight{
    return 190;
}

- (IBAction)buttonPressed:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if (self.blockSquareViewPressed) {
        self.blockSquareViewPressed((int)btn.tag-100);
    }
}
+(instancetype)xibCell{
    NSLog(@"%s",__func__);
    return (HomeSquareCell *)[[[NSBundle mainBundle] loadNibNamed:@"HomeSquareCell" owner:nil options:nil] lastObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
