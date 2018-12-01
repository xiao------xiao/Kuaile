//
//  XYPickerView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/5/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYPickerView.h"

@interface XYPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIButton *coverBtn;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIView *titleView;
@end

@implementation XYPickerView

- (instancetype)initWithPickerType:(XYPickerViewType)type {
    self = [super init];
    if (self) {
        self.type = type;
        if (type == XYPickerViewTypeCover) {
            [self configCoverbtn];
        }
        [self configTitleHeaderView];
        [self configPickerView];
    }
    return self;
}


- (void)configCoverbtn {
    _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _coverBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_coverBtn];
}


- (void)configTitleHeaderView {
    _titleView = [[UIView alloc] init];
    [_titleView addBottomSeperatorViewWithHeight:1];
    [self addSubview:_titleView];
    
    UIButton *cancelBtn = [self createBtnWithText:@"取消"];
    [self addSubview:cancelBtn];
    
    UIButton *doneBtn = [self createBtnWithText:@"确定"];
    [self addSubview:doneBtn];
}

- (UIButton *)createBtnWithText:(NSString *)text {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:TZColor(21, 126, 251) forState:UIControlStateNormal];
    return btn;
}

- (void)configPickerView {
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.frame = CGRectMake(0, mScreenHeight - 64 - 150, mScreenWidth, 150);
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [self addSubview:_pickerView];
}


#pragma mark -- UIPickerViewDelegate & UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataSource.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 38;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return mScreenWidth - 50;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataSource[row];
}




- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.type == XYPickerViewTypeCover) {
        _coverBtn.frame = self.bounds;
    }
    CGFloat titleH = 34;
    CGFloat pickerH = 280;
    _titleView.frame = CGRectMake(0, self.height - titleH - pickerH , mScreenWidth, titleH);
    _cancelBtn.frame = CGRectMake(0, 0, 60, _titleView.height);
    _doneBtn.frame = CGRectMake(mScreenWidth - 60, 0, 60, _titleView.height);
    CGFloat pickerY = CGRectGetMaxY(_titleView.frame);
    _pickerView.frame = CGRectMake(0, pickerY, mScreenWidth, pickerH);
}













@end
