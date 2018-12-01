//
//  TZButtonCell.m
//  yishipi
//
//  Created by ttouch on 16/10/14.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "TZButtonCell.h"

@implementation TZButtonCell

- (void)configSubviews {
    [self configButton];
}

- (void)configButton {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _button.imageView.clipsToBounds = YES;
    _button.frame = CGRectMake(0, 0, self.width, self.height);
    [self.contentView addSubview:_button];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setGrayStyleWithTitle:(NSString *)title {
    [self setTitle:title textColor:TZColorRGB(114) fontSize:14];
}

- (void)setTitle:(NSString *)title textColor:(UIColor *)textColor fontSize:(NSInteger)fontSize {
    [self.button setTitle:title forState:UIControlStateNormal];
    [self.button setTitleColor:textColor forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger buttonWH = _buttonWH ? _buttonWH : self.height;
    self.titleLable.frame = CGRectMake(10, 0, mScreenWidth - _buttonWH - 10, self.height);
    if (_isButtonAtRight) {
        _button.frame = CGRectMake(mScreenWidth - buttonWH - 10, (self.height - buttonWH) / 2, buttonWH, buttonWH);
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    } else {
        _button.frame = CGRectMake(0, 0, self.width, buttonWH);
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
}

@end


@implementation TZImageCell

- (void)configSubviews {
    [self configImgView];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgView.frame = CGRectMake(0, _topInset, self.width, self.height - _topInset - _bottomInset);
}

@end

