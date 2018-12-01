//
//  ZJNearbyCell.m
//  kuaile
//
//  Created by 吴振建 on 2016/12/22.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import "ZJNearbyCell.h"
#import "TZFindSnsModel.h"

@interface ZJNearbyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLbl;
@property (nonatomic, strong) UIView *everyView;

@end

@implementation ZJNearbyCell {
    CGFloat _marign;
    CGFloat _everyViewX;
    CGFloat _everyViewY;
    CGFloat _everyViewW;
    CGFloat _everyViewH;
    CGFloat _recommondImgViewWH;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCellKind:(NSInteger)cellKind {
    _cellKind = cellKind;
    if (_cellKind == 0) {
        _marign = 1;
        _everyViewW = (mScreenWidth - _marign *3) / 4;
        _everyViewH = _everyViewW +30;
        self.headerTitleLbl.text = @"附近的人";
        for (int i = 0; i < 4; i ++) {
            [self creatBtnTag:i];
            [self createdLblTag:10];
        }
    } else if (_cellKind == 1){
        _marign = 1;
        _everyViewW = (mScreenWidth - _marign *3) / 4;
        _everyViewH = _everyViewW +30;
        self.headerTitleLbl.text = @"附近的群";
        for (int i = 0; i < 4; i ++) {
            [self creatBtnTag:i];
            [self createdLblTag:10];
        }
    } else if (_cellKind == 2){
        _marign = 1;
        _everyViewW = mScreenWidth;
        _everyViewH = 70;
        _recommondImgViewWH = 60;
        self.headerTitleLbl.text = @"推荐群组";
        for (int i = 0; i < 3; i ++) {
            [self creatBtnTag:i];
            [self createdLblTag:11];
            [self createdLblTag:12];
        }
    }
}

- (UIButton *)creatBtnTag:(NSInteger)tag{
    _everyView = [[UIView alloc] init];
    _everyView.tag = tag;
    _everyView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEveryTapView:)];
    [_everyView addGestureRecognizer:tap];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *sexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    if (_cellKind == 0) {
        btn.frame = CGRectMake(5, 5, _everyViewW - 10, _everyViewW - 10);
        btn.layer.cornerRadius = (_everyViewW - 10)/2;
        sexBtn.frame = CGRectMake(_everyViewW - 10 + 5 - 38, _everyViewW - 10 + 5 - 18, 38, 18);
        [sexBtn setBackgroundImage:[UIImage imageNamed:@"girl"] forState:0];
        sexBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        sexBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [sexBtn setTitle:@"30" forState:0];
    }
    if (_cellKind == 1) {
        btn.frame = CGRectMake(5, 5, _everyViewW - 10, _everyViewW - 10);
        btn.layer.cornerRadius = 5;
    }
    if (_cellKind == 2) {
        btn.frame = CGRectMake(5, 5, _recommondImgViewWH, _recommondImgViewWH);
        btn.layer.cornerRadius = 5;
    }
    [self.imgSupView addSubview:_everyView];
    [_everyView addSubview:btn];
    [_everyView addSubview:sexBtn];
    return btn;
}

- (UILabel *)createdLblTag:(NSInteger)tag {
    UILabel *lbl = [[UILabel alloc] init];
    if (tag == 10) {
        lbl.frame = CGRectMake(5, _everyViewW - 5, _everyViewW - 10, 35);
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:14];
    }
    if (tag == 11) {
        lbl.frame = CGRectMake(_recommondImgViewWH +20, 5, 200, 20);
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.font = [UIFont systemFontOfSize:16];
    }
    if (tag == 12) {
        CGFloat lblY = _recommondImgViewWH + 5 - 30;
        lbl.frame = CGRectMake(_recommondImgViewWH +20, lblY, 200, 30);
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.font = [UIFont systemFontOfSize:13];
    }
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.text = @"假数据";
    [_everyView addSubview:lbl];
    return lbl;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i < self.imgSupView.subviews.count; i ++) {
        _everyView = self.imgSupView.subviews[i];
        if (_cellKind == 2) {
            _everyViewX = 0;
            _everyViewY = i * (70 + _marign);
        } else {
            _everyViewY = 0;
            _everyViewX = i * (_everyViewW + _marign);
        }
        _everyView.frame = CGRectMake(_everyViewX, _everyViewY, _everyViewW, _everyViewH);
    }
}

// 点击cellHeader
- (IBAction)clickNearPeopleHeaderBtn:(id)sender {
    
}
// 点击单个按钮
- (void)clickEveryTapView:(UITapGestureRecognizer *)tapView {
    
}


@end
