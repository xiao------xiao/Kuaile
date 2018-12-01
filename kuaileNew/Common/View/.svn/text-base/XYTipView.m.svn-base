//
//  XYTipView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/16.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYTipView.h"

@interface XYTipView ()
@property (nonatomic, strong) UIButton *cover;
@property (nonatomic, strong) UIView *btnContentView;
@property (nonatomic, strong) NSMutableArray *btnArray;
@end

@implementation XYTipView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupDefaultSetting];
//        [self configSubViews];
    }
    return self;
}

// 设置默认状态
- (void)setupDefaultSetting {
    _btnArray = [NSMutableArray array];
    self.btnCoverBgColor = [UIColor clearColor];
    self.btnBgColor = [UIColor whiteColor];
    self.titleColor = TZGreyText150Color;
    self.showShadow = YES;
    self.btnH = 40;
    self.btnW = 100;
    self.lineColor = TZColorRGB(235);
//    self.noCover = NO;
}

- (void)setNoCover:(BOOL)noCover {
    _noCover = noCover;
    if (!noCover) {
        _cover = [UIButton buttonWithType:UIButtonTypeCustom];
        _cover.backgroundColor = self.btnCoverBgColor;
        [_cover addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cover];
        
        _btnContentView = [[UIView alloc] init];
        _btnContentView.backgroundColor = [UIColor whiteColor];
        if (self.showShadow) {
            [_btnContentView.layer addStandardShadowWithOffset:CGSizeMake(0.5, 0.8)];
        }
        [_btnContentView.layer setCornerRadius:2];
        [self addSubview:_btnContentView];
    }
}

- (void)configSubViews {
    if (!self.noCover) {
        _cover = [UIButton buttonWithType:UIButtonTypeCustom];
        _cover.backgroundColor = self.btnCoverBgColor;
        [_cover addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cover];
        
        _btnContentView = [[UIView alloc] init];
        _btnContentView.backgroundColor = [UIColor whiteColor];
        if (self.showShadow) {
            [_btnContentView.layer addStandardShadowWithOffset:CGSizeMake(0.5, 0.8)];
        }
        [_btnContentView.layer setCornerRadius:2];
        [self addSubview:_btnContentView];
    }
}

- (void)configTipBtnsWithTitles:(NSArray *)titles images:(NSArray *)images {
    NSInteger count = 0;
    if (titles.count >= images.count) {
        count = titles.count;
    } else {
        count = images.count;
    }
    for (int i = 0; i < count; i++) {
        NSString *title = titles[i];
        UIImage *image = [UIImage imageNamed:images[i]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        if (image) {
            [btn setImage:image forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, self.titleLeftEdge, 0, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, self.imageRightEdge);
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        if (i != count - 1) {
            [btn addBottomSeperatorViewWithHeight:1 color:self.lineColor];
        }
        if (self.noCover) {
            [self addSubview:btn];
        } else {
           [_btnContentView addSubview:btn];
        }
        [self.btnArray addObject:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _cover.frame = self.bounds;
    _btnContentView.frame = CGRectMake(self.width - self.btnW - 4, 4, self.btnW, self.btnH * self.btnArray.count);
    CGFloat btnH = self.btnH;
    CGFloat btnW = self.btnW;
    CGFloat btnY = 0;
    for (int i = 0; i < self.btnArray.count; i++) {
        UIButton *btn = self.btnArray[i];
        btnY = btnH * (i % self.btnArray.count);
        btn.frame = CGRectMake(0, btnY, btnW, btnH);
    }
}

- (void)btnClick:(UIButton *)btn {
    if (self.didClickBtnBlock) {
        self.didClickBtnBlock(btn.tag);
    }
}

- (void)coverBtnClick {
//    self.hidden = YES;
    if (self.didClickCoverBtnBlock) {
        self.didClickCoverBtnBlock();
    }
}


@end
