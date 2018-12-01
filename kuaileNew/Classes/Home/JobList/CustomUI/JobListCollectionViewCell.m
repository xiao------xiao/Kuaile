//
//  JobListCollectionViewCell.m
//  kuaileNew
//
//  Created by admin on 2018/12/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "JobListCollectionViewCell.h"
@interface JobListCollectionViewCell()
@property (retain, nonatomic) UIButton *btnName;

@end
@implementation JobListCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.btnName = [[UIButton alloc] initWithFrame:self.bounds];
        //    [self.btnName setBackgroundColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.btnName setBackgroundImage:[UIImage imageNamed:@"square_city"] forState:UIControlStateNormal];
        [self.btnName setBackgroundImage:[UIImage imageNamed:@"square_city_sel"] forState:UIControlStateSelected];
        //    self.btnName.titleLabel.text = @"112222";
        [self.btnName setTitle:@"11111" forState:UIControlStateNormal];
        self.btnName.titleLabel.font = fontMid;
        [self.btnName setTitleColor:color_lightgray forState:UIControlStateNormal];
        [self.btnName setTitleColor:color_white forState:UIControlStateSelected];
        self.btnName.userInteractionEnabled = NO;
        [self.contentView addSubview:self.btnName];
    }
    return self;
}
-(void)setNameStr:(NSString *)nameStr{
    _nameStr = nameStr;
//    [self setupButton];
    [self.btnName setTitle:nameStr forState:UIControlStateNormal];
    
}
-(void)setSelect:(BOOL)select{
    _select = select;
    self.btnName.selected = select;
}
-(void)setupButton{
    self.btnName = [[UIButton alloc] initWithFrame:self.bounds];
//    [self.btnName setBackgroundColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.btnName setBackgroundImage:[UIImage imageNamed:@"square_city"] forState:UIControlStateNormal];
    [self.btnName setBackgroundImage:[UIImage imageNamed:@"square_city_sel"] forState:UIControlStateSelected];
//    self.btnName.titleLabel.text = @"112222";
    [self.btnName setTitle:@"11111" forState:UIControlStateNormal];
    self.btnName.titleLabel.font = fontMid;
    [self.btnName setTitleColor:color_darkgray forState:UIControlStateNormal];
    [self.btnName setTitleColor:color_white forState:UIControlStateSelected];
    self.btnName.userInteractionEnabled = NO;
    [self.contentView addSubview:self.btnName];
//    self.contentView.userInteractionEnabled = NO;
//    self.userInteractionEnabled =YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//
//    // Initialization code
//    [self.btnName setBackgroundImage:[UIImage imageNamed:@"square_city"] forState:UIControlStateNormal];
//    [self.btnName setBackgroundImage:[UIImage imageNamed:@"square_city_sel"] forState:UIControlStateSelected];
//    self.btnName.titleLabel.text = @"112222";
//
//    [self.btnName setTitleColor:color_lightgray forState:UIControlStateNormal];
//    [self.btnName setTitleColor:color_white forState:UIControlStateSelected];

}
//-(void)layoutSubviews{
//
//    self.btnName.titleLabel.text = self.nameStr;
//
//}

@end
