//
//  XYSlideNavView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/28.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSlideNavView.h"

@implementation XYSlideNavView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews {
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"左箭头白"] forState:0];
    [_backBtn setImage:[UIImage imageNamed:@"左箭头"] forState:UIControlStateDisabled];
    [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    _forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forwardBtn setImage:[UIImage imageNamed:@"右箭头白"] forState:0];  //genduo  go  navi_back_gray32  more_hui
    [_forwardBtn setImage:[UIImage imageNamed:@"右箭头"] forState:UIControlStateDisabled];
    [_forwardBtn addTarget:self action:@selector(forwardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_forwardBtn];
    
    _titleLabel = [[UILabel alloc] init];
    CGFloat titleFont = 20;
    if (mScreenWidth < 375) titleFont = 18;
    _titleLabel.font = [UIFont systemFontOfSize:titleFont];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.pageIndicatorTintColor = TZColor(147, 211, 253);
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _backBtn.frame = CGRectMake(10, 10, 30, 30);
    _forwardBtn.frame = CGRectMake(self.width - 30 - 10, 10, 30, 30);
    _titleLabel.frame = CGRectMake(50, 2, self.width - 100, 25);
    CGFloat pageY = CGRectGetMaxY(_titleLabel.frame) + 10;
    _pageControl.frame = CGRectMake(50, pageY, self.width - 100, 20);
}

- (void)backBtnClick:(UIButton *)btn {
    if (self.didClickBackBtnBlock) {
        self.didClickBackBtnBlock();
    }
}

- (void)forwardBtnClick:(UIButton *)btn {
    if (self.didClickForwardBtnBlock) {
        self.didClickForwardBtnBlock();
    }
}




@end
