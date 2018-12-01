//
//  SourceCell.m
//  kuaile
//
//  Created by 胡光健 on 2017/3/6.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "SourceCell.h"




@implementation SourceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.quanbuButton setTitleColor:color_white forState:UIControlStateSelected];
    
    self.quanbuButton.titleLabel.font = fontBig;
    [self.quanbuButton setBackgroundImage:[UIImage imageNamed:@"square_city"] forState:UIControlStateNormal];
    [self.quanbuButton setBackgroundImage:[UIImage imageNamed:@"square_city_sel"] forState:UIControlStateSelected];
    self.quanbuButton.tag = 100;
    
    MJWeakSelf
    [[self.quanbuButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        UIButton *btn = (UIButton *)x;
        int btnIndex = btn.tag -100;
        
        [weakSelf selectButton:btnIndex];
    }];
    //kaixinzhizhao
    [self.kaixinzhizhaoButton setTitleColor:color_white forState:UIControlStateSelected];
    self.kaixinzhizhaoButton.titleLabel.font = fontBig;
    [self.kaixinzhizhaoButton setBackgroundImage:[UIImage imageNamed:@"square_city"] forState:UIControlStateNormal];
    [self.kaixinzhizhaoButton setBackgroundImage:[UIImage imageNamed:@"square_city_sel"] forState:UIControlStateSelected];
    self.kaixinzhizhaoButton.tag = 101;
    
    
    [[self.kaixinzhizhaoButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        UIButton *btn = (UIButton *)x;
        int btnIndex = btn.tag -100;
        
        [weakSelf selectButton:btnIndex];
    }];
    //qiyezhizhao
   [self.qiyezhizhaoButton setTitleColor:color_white forState:UIControlStateSelected];
    self.qiyezhizhaoButton.titleLabel.font = fontBig;
    [self.qiyezhizhaoButton setBackgroundImage:[UIImage imageNamed:@"square_city"] forState:UIControlStateNormal];
    [self.qiyezhizhaoButton setBackgroundImage:[UIImage imageNamed:@"square_city_sel"] forState:UIControlStateSelected];
    
    self.qiyezhizhaoButton.tag = 102;
    
    
    [[self.qiyezhizhaoButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        UIButton *btn = (UIButton *)x;
        int btnIndex = btn.tag -100;
        
        [weakSelf selectButton:btnIndex];
    }];
    //daizhao
   [self.daizhaoButton setTitleColor:color_white forState:UIControlStateSelected];
    self.daizhaoButton.titleLabel.font = fontBig;
    [self.daizhaoButton setBackgroundImage:[UIImage imageNamed:@"square_city"] forState:UIControlStateNormal];
    [self.daizhaoButton setBackgroundImage:[UIImage imageNamed:@"square_city_sel"] forState:UIControlStateSelected];
    self.daizhaoButton.tag = 103;
    
    
    [[self.daizhaoButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        UIButton *btn = (UIButton *)x;
        int btnIndex = btn.tag -100;
        
        [weakSelf selectButton:btnIndex];
    }];
    
}
-(void)setOriginStr:(NSString *)originStr{
    _originStr = originStr;
    if ([originStr isEqualToString:@"全部"]) {
        self.quanbuButton.selected = YES;
    }else if ([originStr isEqualToString:@"开心直招"]){
        self.kaixinzhizhaoButton.selected = YES;
    }else if ([originStr isEqualToString:@"企业直招"]){
        self.qiyezhizhaoButton.selected = YES;
    }else if([originStr isEqualToString:@"代招"]){
        self.daizhaoButton.selected = YES;
    }else{
        [self selectButton:0];
    }
}
-(void)selectButton:(int)index{
    [self unselectAllButtons];
    switch (index) {
        case 0:
            self.quanbuButton.selected = YES;
            break;
        case 1:
            self.kaixinzhizhaoButton.selected = YES;
            break;
        case 2:
            self.qiyezhizhaoButton.selected = YES;
            break;
        case 3:
            self.daizhaoButton.selected = YES;
            break;
            
        default:
            break;
    }
    if(self.buttonBlock){
        self.buttonBlock(index);
    }
}
-(void)unselectAllButtons{
    self.quanbuButton.selected =NO;
    self.kaixinzhizhaoButton.selected = NO;
    self.qiyezhizhaoButton.selected = NO;
    self.daizhaoButton.selected = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
