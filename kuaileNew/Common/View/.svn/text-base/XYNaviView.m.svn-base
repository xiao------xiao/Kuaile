//
//  XYNaviView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/4/17.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYNaviView.h"

@implementation XYNaviView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self comfigSubViews];
    }
    return self;
}

- (void)comfigSubViews {
    
    _bgView = [[UIImageView alloc] init];
    _bgView.image = [UIImage imageNamed:@"tapbackground"];
    [self addSubview:_bgView];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    
    _rightBarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBarbutton.titleLabel.font = [UIFont systemFontOfSize:16];
    _rightBarbutton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_rightBarbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBarbutton addTarget:self action:@selector(rightBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBarbutton];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setRightBarbtnNormalTitle:(NSString *)rightBarbtnNormalTitle {
    _rightBarbtnNormalTitle = rightBarbtnNormalTitle;
    [_rightBarbutton setTitle:rightBarbtnNormalTitle forState:UIControlStateNormal];
}

- (void)setRightBarbtnSelectedTitle:(NSString *)rightBarbtnSelectedTitle {
    _rightBarbtnSelectedTitle = rightBarbtnSelectedTitle;
    [_rightBarbutton setTitle:rightBarbtnSelectedTitle forState:UIControlStateSelected];
}

- (void)setRightImage:(NSString *)rightImage {
    _rightImage = rightImage;
    [_rightBarbutton setImage:[UIImage imageNamed:rightImage] forState:UIControlStateNormal];
}

- (void)backBtnClick {
    if (self.didClickBackBtnBlock) {
        self.didClickBackBtnBlock();
    }
}

- (void)rightBarBtnClick:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (self.didClickRightBarBtnBlock) {
        self.didClickRightBarBtnBlock(btn.isSelected);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgView.frame = CGRectMake(0, 0, self.width, self.height);
    _backBtn.frame = CGRectMake(11, 30, 30, 30);
    CGFloat titleLabelX = CGRectGetMaxX(_backBtn.frame) + 20;
    _titleLabel.frame = CGRectMake(titleLabelX, 30, self.width - 2 * titleLabelX, 30);
    _rightBarbutton.frame = CGRectMake(self.width - 60, 30, 60, 30);
}





@end
