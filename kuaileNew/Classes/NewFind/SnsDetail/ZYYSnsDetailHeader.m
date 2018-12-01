//
//  ZYYSnsDetailHeader.m
//  DemoProduct
//
//  Created by 一盘儿菜 on 16/6/25.
//  Copyright © 2016年 周毅莹. All rights reserved.
//

#import "ZYYSnsDetailHeader.h"

@interface ZYYSnsDetailHeader() {
    UIView *_containerView;
}
@end

@implementation ZYYSnsDetailHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
        [self addSubview:_containerView];
        
        /*
        _indexView = [[UIView alloc] initWithFrame:CGRectZero];
        _indexView.backgroundColor = TZMainTextColor;
        _indexView.size = CGSizeMake(60, 2);
        [self addSubview:_indexView];*/
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.3, __kScreenWidth, 0.7)];
        lineView.backgroundColor = __kColorWithRGBA1(230, 230, 230);
        [self addSubview:lineView];
    }
    return self;
}

- (void)didClickButton:(UIButton*)button {
    NSInteger index = button.tag - 100;
    self.slideNumber = index;
}

- (void)setNamesArray:(NSArray *)namesArray {
    _namesArray = namesArray;
    CGFloat itemWidth = 80;
    _indexView.mj_y = 40.7;
    for (int i = 0; i < namesArray.count; i++) {
        UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(itemWidth*i, 3, itemWidth, 39)];
        [itemButton setTitle:namesArray[i] forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [itemButton setTitleColor:TZMainTextColor forState:UIControlStateSelected];
        //[itemButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.titleLabel.font = [UIFont systemFontOfSize:14];
        itemButton.tag = 100 + i;
        [_containerView addSubview:itemButton];
        
    }
}

- (void)setSlideNumber:(NSInteger)slideNumber {
    _slideNumber = slideNumber;
    for (UIButton *button in _containerView.subviews) {
        button.selected = NO;
    }
    UIButton *button = _containerView.subviews[slideNumber];
    button.selected = YES;
    _indexView.centerX = button.centerX;
    if (_didChangeCallBack) {
        _didChangeCallBack(slideNumber);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //_indexView.y = self.height - 2.7;
}
@end
