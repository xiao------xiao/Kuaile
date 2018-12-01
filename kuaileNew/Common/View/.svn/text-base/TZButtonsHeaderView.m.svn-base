//
//  TZButtonsHeaderView.m
//  yishipi
//
//  Created by ttouch on 16/9/28.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "TZButtonsHeaderView.h"

@interface TZButtonsHeaderView ()
@property (nonatomic, strong) NSMutableArray *lineArr;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) NSMutableArray *titleWidths;

@property (nonatomic, strong) NSMutableArray *spotArr;
@end

@implementation TZButtonsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubviews];
    }
    return self;
}

/// 从xib里初始化
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews {
    self.backgroundColor = [UIColor whiteColor];
    _btnArr = [NSMutableArray array];
    _lineArr = [NSMutableArray array];
    _titleWidths = [NSMutableArray array];
    self.fontSize = 15;
    self.boldFont = 17;

    [self configDefaultSetting];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = TZColorRGB(242);
    [self addSubview:_bottomLine];
    
    _bottomIndicator = [[UIView alloc] init];
    _bottomIndicator.backgroundColor = TZMainColor;
    [self addSubview:_bottomIndicator];
    
    self.showsHorizontalScrollIndicator = NO;
}

- (void)configDefaultSetting {
    self.shouldSelect = YES;
    self.showLines = YES;
    self.showBottomLine = YES;
    self.showBottomIndicator = YES;
    self.changeFontWhenSelected = NO;
}

- (UIButton *)getButtonWithTag:(NSInteger)tag {
    TZBaseButton *btn = [TZBaseButton buttonWithType:UIButtonTypeCustom];
    btn.contentMode = UIViewContentModeScaleAspectFill;
    btn.clipsToBounds = YES;
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:TZColorRGB(128) forState:UIControlStateNormal];
    if (self.shouldSelect) {
        [btn setTitleColor:TZMainColor forState:UIControlStateSelected];
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
    
    [self addSubview:btn];
    [_btnArr addObject:btn];
    if (tag == 0) {
        btn.selected = YES;
    }
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = TZColorRGB(242);
    [self addSubview:line];
    [_lineArr addObject:line];
    
    UILabel *spotLabel = [[UILabel alloc] init];
    spotLabel.layer.cornerRadius = 2;
    spotLabel.clipsToBounds = YES;
    [self addSubview:spotLabel];
    [_spotArr addObject:spotLabel];

    return btn;
}

- (void)setSpotColor:(UIColor *)spotColor {
    _spotColor = spotColor;
    self.spotLabel.backgroundColor = spotColor;
}

- (void)setShouldSelect:(BOOL)shouldSelect {
    _shouldSelect = shouldSelect;
    if (shouldSelect) {
        UIColor *selectedColor = shouldSelect ? TZMainColor : TZColorRGB(128);
        for (NSInteger i = 0; i < _btnArr.count; i++) {
            TZBaseButton *button = self.btnArr[i];
            [button setTitleColor:selectedColor forState:UIControlStateSelected];
        }
    }
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    if (!self.btnWidth) {
        self.btnWidth = self.width / titles.count;
    }

    [_titleWidths removeAllObjects];
    for (NSString *title in titles) {
        NSInteger width;
        if (self.notCalcuLateTitleWidth) {
            width = self.btnWidth;
        } else {
            width = [CommonTools sizeOfText:title fontSize:self.fontSize].width + 10;
        }
        [_titleWidths addObject:@(width)];
    }
    for (NSInteger i = 0; i < titles.count; i++) {
        if (i >= self.btnArr.count) {
            [self getButtonWithTag:i];
        }
        TZBaseButton *button = self.btnArr[i];
        if ([titles[i] isEqualToString:@"我的帖子"]) {
            self.myTieBtn = button;
        }
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateSelected];
    }
    
    self.contentSize = CGSizeMake(self.btnWidth * titles.count, 0);
}

- (void)setBtnTitles:(NSArray *)titles fontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    [self setTitles:titles];
    for (NSInteger i = 0; i < titles.count; i++) {
        TZBaseButton *button = self.btnArr[i];
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
}

- (void)setFontSizes:(NSArray *)fontSizes {
    _fontSizes = fontSizes;
    for (NSInteger i = 0; i < self.btnArr.count; i++) {
        TZBaseButton *button = self.btnArr[i];
        button.titleLabel.font = [UIFont systemFontOfSize:[fontSizes[i] integerValue]];
    }
}

- (void)setColors:(NSArray *)colors {
    _colors = colors;
    for (NSInteger i = 0; i < self.btnArr.count; i++) {
        id color = colors[i];
        TZBaseButton *button = self.btnArr[i];
        if ([color isKindOfClass:[UIColor class]]) {
            [button setBackgroundColor:color];
        } else if ([color isKindOfClass:[NSNumber class]] && [color integerValue]) {
            [button setBackgroundColor:TZColorRGB([color integerValue])];
        }
    }
}

- (void)setImages:(NSArray *)images {
    _images = images;
    for (NSInteger i = 0; i < self.btnArr.count; i++) {
        if ([images[i] length]) {
            TZBaseButton *button = self.btnArr[i];
            UIImage *image = [UIImage imageNamed:images[i]];
            [button setImage:image forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateSelected];
        }
    }
}

- (void)setDirections:(NSArray *)directions {
    _directions = directions;
    for (NSInteger i = 0; i < directions.count; i++) {
        TZBaseButton *button = self.btnArr[i];
        button.direction = [directions[i] integerValue];
    }
}

- (void)setShowSpots:(NSArray *)showSpots {
    _showSpots = showSpots;
    for (NSInteger i = 0; i < showSpots.count; i++) {
        UILabel *spot = self.spotArr[i];
        NSInteger num = [showSpots[i] integerValue];
        if (num == 0) {
            spot.hidden = YES;
        } else if (num == 1) {
            spot.hidden = NO;
        }
    }
}

- (void)setBtnImage:(NSString *)imageName forIndex:(NSInteger)index {
    [self setBtnImage:imageName selImage:imageName forIndex:index];
}

- (void)setBtnImage:(NSString *)imageName selImage:(NSString *)selImage forIndex:(NSInteger)index {
    TZBaseButton *button = self.btnArr[index];
    UIImage *image = [UIImage imageNamed:imageName];
    [button setImage:image forState:UIControlStateNormal];
    UIImage *selectImage = [UIImage imageNamed:selImage];
    [button setImage:selectImage forState:UIControlStateSelected];
}

- (void)setBtnImage:(NSString *)imageName selImage:(NSString *)selImage btnTitle:(NSString *)btnTitle selTitle:(NSString *)selTitle forIndex:(NSInteger)index {
    [self setBtnImage:imageName selImage:selImage forIndex:index];
    TZBaseButton *button = self.btnArr[index];
    [button setTitle:btnTitle forState:UIControlStateNormal];
    [button setTitle:selTitle forState:UIControlStateSelected];
}

- (void)setBtnImage:(NSString *)imageName selImage:(NSString *)selImage {
    for (NSInteger i = 0; i < self.btnArr.count; i++) {
        [self setBtnImage:imageName selImage:selImage forIndex:i];
    }
}

- (void)setBtnTitle:(NSString *)title forIndex:(NSInteger)index {
    TZBaseButton *button = self.btnArr[index];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
}

- (void)setBtnTitleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor forIndex:(NSInteger)index {
    TZBaseButton *button = self.btnArr[index];
    button.backgroundColor = bgColor;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateSelected];
}

- (void)setBtnsEnable:(BOOL)btnsEnable {
    for (UIButton *btn in self.btnArr) {
        btn.enabled = btnsEnable;
    }
}

- (void)setBtnWidth:(NSInteger)btnWidth {
    _btnWidth = btnWidth;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (NSInteger i = 0; i < self.btnArr.count; i++) {
        TZBaseButton *button = self.btnArr[i];
        CGFloat btnX = i * self.btnWidth;
        button.frame = CGRectMake(btnX, self.topInset, self.btnWidth, self.height - self.topInset);
        if (_showLines && i < self.btnArr.count) {
            UIView *line = self.lineArr[i];
            line.frame = CGRectMake(btnX - 0.5, self.height / 2 - 10 - (self.topInset) / 2, 1, self.height - 20 - self.topInset);
        }
        UILabel *spot = self.spotArr[i];
        spot.frame = CGRectMake(1, self.topInset - 2, 4, 4);
    }
    _bottomLine.hidden = !self.showBottomLine;
    _bottomLine.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

#pragma mark - Event Click

- (void)btnClick:(TZBaseButton *)sender {
    
    if (sender.tag == 4 && ![TZUserManager isLogin]) {
        return;
    }
    
    NSInteger canReClick = 0;
    if (self.canReClick.count > sender.tag) {
        canReClick = [self.canReClick[sender.tag] integerValue];
    }
    if (canReClick == 0 && _selectBtnIndex == sender.tag && !sender.canCancelSelect) {
        return;
    }
    [self setSelectBtnIndex:sender.tag];
    if (self.didClickButtonWithIndex) {
        self.didClickButtonWithIndex(self.btnArr[sender.tag],sender.tag);
    }
}

- (void)setSelectBtnIndex:(NSInteger)selectBtnIndex {
    _selectBtnIndex = selectBtnIndex;
    
    TZBaseButton *selectBtn = self.btnArr[selectBtnIndex];
    if (selectBtn.canKeepSelect) {
        selectBtn.selected = !selectBtn.isSelected;
    } else {
        for (TZBaseButton *button in self.btnArr) {
            if (button.tag == selectBtnIndex) {
                if (button.canCancelSelect) {
                    button.selected = !button.isSelected;
                } else {
                    button.selected = YES;
                    if (self.changeFontWhenSelected) {
                        button.titleLabel.font = [UIFont boldSystemFontOfSize:self.boldFont];
                    }
                }
            } else if (!button.canKeepSelect) {
                if (self.changeFontWhenSelected) {
                    button.titleLabel.font = [UIFont systemFontOfSize:self.boldFont];
                }
                button.selected = NO;
            }
        }
    }
    // 是否显示底部的主色调指示器
    if (self.showBottomIndicator) {
        CGFloat titleWidth = [self.titleWidths[self.selectBtnIndex] floatValue];
//        titleWidth = MIN(titleWidth, self.btnWidth);
//        CGFloat margin = self.btnWidth - titleWidth;
//        _bottomIndicator.frame = CGRectMake(self.selectBtnIndex * self.btnWidth + margin / 2, self.height - 2, titleWidth, 2);
        _bottomIndicator.frame = CGRectMake(self.selectBtnIndex * self.btnWidth, self.height - 2, self.btnWidth, 2);
    }
}

@end



@interface TZButtonsBottomView ()
@property (nonatomic, strong) UIView *headLine;
@end


@implementation TZButtonsBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shouldSelect = NO;
        self.showLines = NO;
        self.showBottomLine = NO;
        self.showBottomIndicator = NO;
        self.notCalcuLateTitleWidth = YES;
        self.showBackground = YES;
        self.showBorder = YES;
        self.showHeadLine = NO;
        self.btnY = 5;
        self.leftMargin = 15;
        [self configHeadLine];
    }
    return self;
}

- (void)configHeadLine {
    _headLine = [[UIView alloc] init];
    _headLine.backgroundColor = TZColorRGB(210);
    [self addSubview:_headLine];
}

- (void)setBorderColors:(NSArray *)borderColors {
    _borderColors = borderColors;
    if (self.showBackground) {
        for (int i = 0; i < borderColors.count; i++) {
            UIColor *color = borderColors[i];
            TZBaseButton *btn = self.btnArr[i];
            [btn setTitleColor:[UIColor whiteColor] forState:0];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn.layer setBorderColor:color.CGColor];
            [btn.layer setBorderWidth:1];
            [btn setBackgroundColor:color];
        }
    }
}

- (void)setBtnBorderColor:(UIColor *)color forIndex:(NSInteger)index {
    TZBaseButton *button = self.btnArr[index];
    button.layer.borderWidth = 1;
    button.layer.borderColor = color.CGColor;
}

- (void)setBgColors:(NSArray *)bgColors {
    _bgColors = bgColors;
    if (self.showBackground) {
        for (int i = 0; i < bgColors.count; i++) {
            UIColor *color = bgColors[i];
            TZBaseButton *btn = self.btnArr[i];
            [btn setTitleColor:[UIColor whiteColor] forState:0];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            [btn setBackgroundColor:color];
        }
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger count = self.btnArr.count;
    NSInteger cols = count;
    CGFloat margin = self.leftMargin;
    CGFloat x = 0;
    CGFloat y = self.btnY;
    CGFloat btnH = self.height - 2 * y;
    CGFloat btnWidth = (self.width - (count + 1) * margin) / count;
    for (int i = 0; i < self.btnArr.count; i++) {
        TZBaseButton *btn = self.btnArr[i];
        x = margin + (margin + btnWidth) * (i % cols);
        btn.frame = CGRectMake(x, y, btnWidth, btnH);
        btn.layer.cornerRadius = btnH / 2;
    }
    _headLine.frame = CGRectMake(0, 0, self.width, 0.8);
    _headLine.hidden = !self.showHeadLine;
}

- (void)configDefaultSetting {
    self.shouldSelect = NO;
    self.showLines = NO;
    self.showBottomLine = NO;
    self.showBottomIndicator = NO;
}

- (void)btnClick:(TZBaseButton *)sender {
    if (self.didClickButtonWithIndex) {
        self.didClickButtonWithIndex(self.btnArr[sender.tag],sender.tag);
    }
}

@end


@implementation TZButtonsCornerView

- (void)configDefaultSetting {
    self.shouldSelect = NO;
    self.showBottomLine = NO;
    self.showBottomIndicator = NO;
    self.showLines = YES;
}

- (void)btnClick:(TZBaseButton *)sender {
    if (self.didClickButtonWithIndex) {
        self.didClickButtonWithIndex(self.btnArr[sender.tag],sender.tag);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (NSInteger i = 0; i < self.btnArr.count; i++) {
        TZBaseButton *button = self.btnArr[i];
        CGFloat btnY = i * 44;
        button.frame = CGRectMake(0, btnY, self.width, 44);
        if (self.showLines && i < self.btnArr.count) {
            UIView *line = self.lineArr[i];
            line.frame = CGRectMake(0, btnY, self.width, 0.5);
        }
    }
}

@end
