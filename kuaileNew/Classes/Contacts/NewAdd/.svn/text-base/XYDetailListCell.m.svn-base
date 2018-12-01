//
//  XYDetailListCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/8.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYDetailListCell.h"


@interface XYDetailListCell ()
@property (nonatomic, assign) CGFloat subTextW;
@end

@implementation XYDetailListCell

- (UIButton *)accessoryBtn {
    if (_accessoryBtn == nil) {
        _accessoryBtn = [[UIButton alloc] init];
        [_accessoryBtn addTarget:self action:@selector(accessoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_accessoryBtn];
    }
    return _accessoryBtn;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = TZControllerBgColor;
        [self.contentView addSubview:_line];
    }
    return _line;
}

- (UIImageView *)avatar {
    if (_avatar == nil) {
        _avatar = [[UIImageView alloc] init];
        _avatar.clipsToBounds = YES;
        [self.contentView addSubview:_avatar];
    }
    return _avatar;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupDefault];
        [self configSubViews];
    }
    return self;
}

- (void)setupDefault {
    self.showBgColor = NO;
    self.calculateTextWidth = NO;
    self.hideMoreView = NO;
    self.subLabelX = 110;
    self.labelX = 10;
    self.labelTextColor = TZColorRGB(126);
    self.subLabelTextColor = TZColorRGB(72);
    self.imageName = @"genduo";
}

- (void)configSubViews {
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(self.labelX, 5, self.subLabelX - 10, self.height - 10);
    _label.textAlignment = NSTextAlignmentLeft;
    _label.textColor = self.labelTextColor;
//    _label.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_label];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.frame = CGRectMake(self.subLabelX, 5, self.width - self.subLabelX - 30, self.height - 10);
    _subLabel.textAlignment = NSTextAlignmentLeft;
    _subLabel.textColor = self.subLabelTextColor;
//    _subLabel.font = [UIFont systemFontOfSize:14];
    _subLabel.numberOfLines = 0;
    [self.contentView addSubview:_subLabel];
    
    _more = [[UIImageView alloc] init];
    _more.frame = CGRectMake(self.width - 10 - 20, (self.height - 20)/2.0, 20, 20);
    _more.image = [UIImage imageNamed:self.imageName];//    navi_back_gray32  more_hui
    [self.contentView addSubview:_more];
}

- (void)setAccessoryBtnText:(NSString *)accessoryBtnText {
    _accessoryBtnText = accessoryBtnText;
    if (self.haveAccessoryBtn) {
        [self.accessoryBtn setTitle:accessoryBtnText forState:0];
    }
}

- (void)setAccessoryBtnTextColor:(UIColor *)accessoryBtnTextColor {
    _accessoryBtnTextColor = accessoryBtnTextColor;
    [self.accessoryBtn setTitleColor:accessoryBtnTextColor forState:0];
}

- (void)setAccessoryBtnFont:(CGFloat)accessoryBtnFont {
    _accessoryBtnFont = accessoryBtnFont;
    self.accessoryBtn.titleLabel.font = [UIFont systemFontOfSize:accessoryBtnFont];
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    _more.image = [UIImage imageNamed:imageName];
}

- (void)setLabelFont:(CGFloat)labelFont {
    _labelFont = labelFont;
    _label.font = [UIFont systemFontOfSize:labelFont];
}

- (void)setSubLabelFont:(CGFloat)subLabelFont {
    _subLabelFont = subLabelFont;
    _subLabel.font = [UIFont systemFontOfSize:subLabelFont];
}

- (void)setLabelTextColor:(UIColor *)labelTextColor {
    _labelTextColor = labelTextColor;
    _label.textColor = labelTextColor;
}

- (void)setSubLabelTextColor:(UIColor *)subLabelTextColor {
    _subLabelTextColor = subLabelTextColor;
    _subLabel.textColor = subLabelTextColor;
}

- (void)setSubLabelBgColor:(UIColor *)subLabelBgColor {
    _subLabelBgColor = subLabelBgColor;
    _subLabel.backgroundColor = subLabelBgColor;
    _subLabel.textColor = [UIColor whiteColor];
}

- (void)setText:(NSString *)text {
    _text = text;
    _label.text = text;
}

- (void)setAttrText:(NSAttributedString *)attrText {
    _attrText = attrText;
    _label.attributedText = attrText;
}


- (void)setSubText:(NSString *)subText {
    _subText = subText;
    _subLabel.text = subText;
    if (self.calculateTextWidth && subText.length > 0) {
        self.subTextW = [CommonTools sizeOfText:subText fontSize:13].width + 40;
        _subLabel.width = self.subTextW;
        _subLabel.textAlignment = NSTextAlignmentCenter;
        [self setNeedsLayout];
    }
}


- (void)accessoryBtnClick {
    if (self.didClickAccessoryBtnBlock) {
        self.didClickAccessoryBtnBlock();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = CGRectMake(self.labelX, 5, self.subLabelX - 10, self.height - 10);
    if (self.calculateTextWidth) {
        _subLabel.frame = CGRectMake(self.subLabelX, 5, self.subTextW, self.height - 10);
        _subLabel.layer.cornerRadius = (self.height - 10) / 2.0;
        _subLabel.clipsToBounds = YES;
    } else {
        _subLabel.frame = CGRectMake(self.subLabelX, 5, self.width - self.subLabelX - 30, self.height - 10);
    }
    if (self.hideMoreView) {
        _subLabel.textAlignment = NSTextAlignmentRight;
        _subLabel.frame = CGRectMake(self.width - 100 - 8, 5, 100, self.height - 10);
    }
    _more.frame = CGRectMake(self.width - 10 - 20, (self.height - 20)/2.0, 20, 20);
    if (self.haveAccessoryBtn) {
        self.accessoryBtn.frame = CGRectMake(self.width - 10 - 20 - 60, 5, 60, self.height - 10);
    }
    if (self.showBottomLine) {
        self.line.frame = CGRectMake(0, self.height - 1, self.width, 1);
    }
    if (self.showAvatar_label) {
        self.avatar.frame = CGRectMake(self.subLabelX, 5, self.height - 10, self.height - 10);
        self.avatar.layer.cornerRadius = (self.height - 10) / 2.0;
        
        CGFloat subX = CGRectGetMaxX(self.avatar.frame);
        _subLabel.frame = CGRectMake(subX + 10, 5, self.width - subX - 30, self.height - 10);
    }
}



@end
