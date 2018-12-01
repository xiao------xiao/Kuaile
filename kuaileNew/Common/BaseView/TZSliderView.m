//
//  TZSliderView.m
//  yangmingFinance
//
//  Created by ttouch on 2016/11/17.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "TZSliderView.h"

@implementation TZSliderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews {
    self.finishViewH = 3;
    self.rightLableW = 35;
    
    _unfinishView = [UIView new];
    _unfinishView.backgroundColor = TZColorRGB(244);
    [self addSubview:_unfinishView];
    
    _finishView = [UIView new];
    _finishView.backgroundColor = TZColor(253, 201, 80);
    [self addSubview:_finishView];

    _rightLable = [TZLable new];
    [_rightLable setTitle:@"6/12" font:@12 color:@168 alignment:NSTextAlignmentRight];
    [self addSubview:_rightLable];
    
    self.value = 0.5;
}

- (void)setValue:(CGFloat)value {
    _value = value;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _rightLable.frame = CGRectMake(self.width - _rightLableW, 0, _rightLableW, self.height);
    _unfinishView.frame = CGRectMake(0, (self.height - _finishViewH) / 2, self.width - _rightLableW, _finishViewH);
    _finishView.frame = CGRectMake(0, _unfinishView.mj_y, _unfinishView.width * _value, _finishViewH);
}

@end
