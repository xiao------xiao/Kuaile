//
//  XYFoundationCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/1.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYFoundationCell.h"

@interface XYFoundationCell ()

@end

@implementation XYFoundationCell

- (UISwitch *)swit {
    if (_swit == nil) {
        _swit = [[UISwitch alloc] init];
        [_swit addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _swit;
}

- (UIImageView *)avater {
    if (_avater == nil) {
        _avater = [[UIImageView alloc] init];
        _avater.image = [UIImage imageNamed:@"image"];
    }
    return _avater;
}

- (UIImageView *)moreView {
    if (_moreView == nil) {
        _moreView = [[UIImageView alloc] init];
        _moreView.image = [UIImage imageNamed:@"genduo"];
        [self.contentView addSubview:_moreView];
    }
    return _moreView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configDefaultSettingData];
        [self configBaseView];
    }
    return self;
}

- (void)configDefaultSettingData {
    self.labelX = 10;
    self.avaterY = 5;
}

- (void)configBaseView {
    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_label];
}

- (void)setLabelText:(NSString *)labelText {
    _labelText = labelText;
    _label.text = labelText;
}

- (void)setLabelFont:(CGFloat)labelFont {
    _labelFont = labelFont;
    _label.font = [UIFont systemFontOfSize:labelFont];
}

- (void)setLabelTextColor:(UIColor *)labelTextColor {
    _labelTextColor = labelTextColor;
    _label.textColor = labelTextColor;
}

- (void)setType:(XYFoundationCellType)type {
    _type = type;
    if (type == XYFoundationCellTypeAvater) {
        [self.contentView addSubview:self.avater];
    } else if (type == XYFoundationCellTypeSwitch) {
        self.accessoryView = self.swit;
    }
}

- (void)switchValueChange:(UISwitch *)swit {
    if (self.switValueChangeBlock) {
        self.switValueChangeBlock(swit.on);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = CGRectMake(self.labelX, (self.height - 21)/2.0, self.width - self.labelX - 100, 21);
    if (_type == XYFoundationCellTypeAvater) {
        CGFloat avaterHW = self.height - 2 * self.avaterY;
        if (self.haveMoreView) {
            self.moreView.frame = CGRectMake(self.width - 30, (self.height - 20)/2.0, 20, 20);
            self.avater.frame = CGRectMake(self.width - 33 - avaterHW, self.avaterY, avaterHW, avaterHW);
        } else {
            self.avater.frame = CGRectMake(self.width - 15 - avaterHW, self.avaterY, avaterHW, avaterHW);
        }
        if (self.isRoundCornor) {
            self.avater.layer.cornerRadius = avaterHW / 2.0;
            self.avater.clipsToBounds = YES;
        }
    }
    if (_type == XYFoundationCellTypeSwitch) {
//        CGFloat switW = 30;
//        self.swit.frame = CGRectMake(self.width - switW - 10, (self.height - 20)/2.0, switW, 20);
//        _swit.frame = CGRectMake(self.width - 50, 5, 0, 0);
    }
}



@end
