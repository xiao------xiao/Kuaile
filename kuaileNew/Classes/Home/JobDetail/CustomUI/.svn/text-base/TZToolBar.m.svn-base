//
//  TZToolBar.m
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZToolBar.h"
#import "TZButton.h" // 取消高亮

#define TZSelectedColor [UIColor colorWithRed:80/255.0 green:190/255.0 blue:243/255.0 alpha:1]
#define TZNonSelectedColor [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1]

@implementation TZToolBar

+ (instancetype)toolBar {
    TZToolBar *toolBar = [[[NSBundle mainBundle] loadNibNamed:@"TZToolBar" owner:self options:nil] lastObject];
    return toolBar;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZToolBar" owner:self options:nil] lastObject];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZToolBar" owner:self options:nil] lastObject];
    }
    return self;
}

- (IBAction)leftBtnClick:(TZButton *)sender {
    [self setLeftBtnSelected];
    // 告诉外面我被点了
    if ([self.delegate respondsToSelector:@selector(toolBar:didClickButtonWithType:)]) {
        [self.delegate toolBar:self didClickButtonWithType:ToolBarButtonTypeLeft];
    }
}

- (IBAction)rightBtnClick:(TZButton *)sender {
    [self setRightBtnSelected];
    // 告诉外面我被点了
    if ([self.delegate respondsToSelector:@selector(toolBar:didClickButtonWithType:)]) {
        [self.delegate toolBar:self didClickButtonWithType:ToolBarButtonTypeRight];
    }
}

- (void)setShowLeftBtn:(BOOL)showLeftBtn {
    [self setLeftBtnSelected];
}

- (void)setShowRightBtn:(BOOL)showRightBtn {
    [self setRightBtnSelected];
}

- (void)setLeftBtnSelected {
    self.leftBtn.enabled = NO;
    self.rightBtn.enabled = YES;
    // 界面效果
    [self.leftBtn setTitleColor:TZSelectedColor forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:TZNonSelectedColor forState:UIControlStateNormal];
    self.leftTipView.hidden = NO;
    self.rightTipView.hidden = YES;
}

- (void)setRightBtnSelected {
    self.rightBtn.enabled = NO;
    self.leftBtn.enabled = YES;
    // 界面效果
    [self.rightBtn setTitleColor:TZSelectedColor forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:TZNonSelectedColor forState:UIControlStateNormal];
    self.leftTipView.hidden = YES;
    self.rightTipView.hidden = NO;
}

@end
