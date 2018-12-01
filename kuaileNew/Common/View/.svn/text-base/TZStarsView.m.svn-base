//
//  ZJRepeatBtnView.m
//  yishipi
//
//  Created by 吴振建 on 2016/11/17.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "TZStarsView.h"

@interface TZStarsView ()
@property (nonatomic, strong) NSMutableArray *starArr;
@end

@implementation TZStarsView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configSubviews];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews {
    _starArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i++) {
        [self getStarBtnWithTag:i];
    }
}

- (UIButton *)getStarBtnWithTag:(NSInteger)tag {
    UIButton *star;
    if (tag < _starArr.count) {
        star = _starArr[tag];
    } else {
        star = [UIButton buttonWithType:UIButtonTypeCustom];
        star.tag = tag;
        [star setImage:[UIImage imageNamed:@"star_def36"] forState:UIControlStateNormal];
        [star setImage:[UIImage imageNamed:@"star_sel36"] forState:UIControlStateSelected];
        [star addTarget:self action:@selector(didClickStarBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:star];
        [self.starArr addObject:star];
    }
    return star;
}

- (void)setStarNum:(NSInteger)starNum {
    _starNum = starNum;
    for (NSInteger i = 0; i < starNum; i++) {
        UIButton *button = _starArr[i];
        button.selected = button.tag < starNum;
    }
}

- (void)didClickStarBtn:(UIButton *)starBtn {
    self.starNum = starBtn.tag;
    if (self.didClickStarBtnAtIndexBlock) {
        self.didClickStarBtnAtIndexBlock(starBtn.tag);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat btnY = 0;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnW = btnH;
    CGFloat marign = 2;
    for (int i = 0; i < _starArr.count; i ++) {
        UIButton *btn = _starArr[i];
        CGFloat btnX = (btnW + marign) * i;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

@end
