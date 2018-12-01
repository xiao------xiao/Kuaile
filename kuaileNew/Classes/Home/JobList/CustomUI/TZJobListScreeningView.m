//
//  TZJobListScreeningView.m
//  kuaile
//
//  Created by liujingyi on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobListScreeningView.h"

@interface TZJobListScreeningView ()
@property (strong, nonatomic) IBOutlet UIView *areaTipView;
@property (strong, nonatomic) IBOutlet UIView *salaryTipView;
@property (strong, nonatomic) IBOutlet UIView *welfareTipView;
@property (strong, nonatomic) IBOutlet UIView *screenTipView;


@end
@implementation TZJobListScreeningView

- (IBAction)buttonClick:(UIButton *)sender {
   
    self.salaryTipView.hidden = YES;
    self.welfareTipView.hidden = YES;
    self.screenTipView.hidden = YES;
    self.areaTipView.hidden = YES;
    self.areaBtn.selected = NO;
    self.salaryBtn.selected = NO;
    self.welfareBtn.selected = NO;
    self.screenBtn.selected = NO;
    
    // 1、更新按钮的图片
    switch (sender.tag) {
        case 1:
            self.areaBtn.selected = YES;
            break;
        case 2:
           self.salaryBtn.selected = YES;
            break;
        case 3:
            self.welfareBtn.selected = YES;
            break;
        case 4:
            self.screenBtn.selected = YES;
            break;
        default:
            break;
    }
    
    // 2、让代理控制器去加载tableView
    if ([self.delegate respondsToSelector:@selector(screeningView:didClickButtonType:)]) {
        [self.delegate screeningView:self didClickButtonType:sender.tag];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZJobListScreeningView" owner:self options:nil] lastObject];
        [self.areaBtn setTitleColor:TZMainColor forState:UIControlStateSelected];
        [self.areaBtn setTitleColor:color_darkgray forState:UIControlStateNormal];
        [self.salaryBtn setTitleColor:TZMainColor forState:UIControlStateSelected];
        [self.salaryBtn setTitleColor:color_darkgray forState:UIControlStateNormal];
        [self.welfareBtn setTitleColor:TZMainColor forState:UIControlStateSelected];
        [self.welfareBtn setTitleColor:color_darkgray forState:UIControlStateNormal];
        [self.screenBtn setTitleColor:TZMainColor forState:UIControlStateSelected];
        [self.screenBtn setTitleColor:color_darkgray forState:UIControlStateNormal];
        
    }
    return self;
}

/** 覆盖系统的布局,否则在非4情况下尺寸有异常 */
- (void)layoutSubviews {
    [super layoutSubviews];
    self.width = __kScreenWidth;
    self.height = 44;
}

- (void)setHideTipsView:(BOOL)hideTipsView {
    _hideTipsView = hideTipsView;
    self.salaryTipView.hidden = YES;
    self.areaTipView.hidden = YES;
    self.welfareTipView.hidden = YES;
    self.screenTipView.hidden = YES;
}

- (void)setUpAreaMoreView:(BOOL)upAreaMoreView {
    _upAreaMoreView = upAreaMoreView;
    self.areaBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
}

- (void)setUpSalaryMoreView:(BOOL)upSalaryMoreView {
    _upSalaryMoreView = upSalaryMoreView;
    self.salaryBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
}

- (void)setUpWelfareMoreView:(BOOL)upWelfareMoreView {
    _upWelfareMoreView = upWelfareMoreView;
    self.welfareBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
}
-(void)setUpscreenTipView:(BOOL)upscreenTipView {
    _upscreenTipView = upscreenTipView;
    self.screenBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
}
- (void)setDownMoreView:(BOOL)downMoreView {
    _downMoreView = downMoreView;
    self.salaryBtn.imageView.transform = CGAffineTransformIdentity;
    self.welfareBtn.imageView.transform = CGAffineTransformIdentity;
    self.areaBtn.imageView.transform = CGAffineTransformIdentity;
    self.screenBtn.imageView.transform = CGAffineTransformIdentity;
}

@end
