//
//  ZJGoodsClassifyView.m
//  yishipi
//
//  Created by 吴振建 on 16/9/30.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "ZJMoreBtnTipView.h"

@implementation ZJMoreBtnTipView

- (void)creatViewBtn {
    _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _coverBtn.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64);
    _coverBtn.backgroundColor = [UIColor clearColor];
    [_coverBtn addTarget:self action:@selector(clickCoverBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_coverBtn];
    NSArray *arrTitle = @[@"分享",@"举报"];
    NSArray *arrImg = @[@"fenxiang",@"jubao"];
    for (int i = 0; i < arrTitle.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.layer.cornerRadius = 2;
        btn.backgroundColor = TZColorRGB(235);
//        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 0);
        [btn setTitle:arrTitle[i] forState:0];
        [btn setImage:[UIImage imageNamed:arrImg[i]] forState:0];
        [btn setTitleColor:TZColorRGB(120) forState:0];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(clickClassifyBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i != arrTitle.count - 1) {
            [btn addBottomSeperatorViewWithHeight:1 color:TZColorRGB(150)];
        }
        [_coverBtn addSubview:btn];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i <_coverBtn.subviews.count; i ++) {
        UIButton *btn = _coverBtn.subviews[i];
        CGFloat btnH = 45;
        CGFloat btnW = 100;
        CGFloat btnX = mScreenWidth - btnW - 1;
        CGFloat btnY = 45 * i + 1;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

- (void)clickClassifyBtn:(UIButton *)btn {
    self.hidden = YES;
    if ( self.btnClickBlock) {
        self.btnClickBlock(btn.tag);
    }
}

- (void)clickCoverBtn {
    self.hidden = YES;
}

@end
