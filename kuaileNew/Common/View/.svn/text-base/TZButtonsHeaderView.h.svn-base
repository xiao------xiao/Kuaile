//
//  TZButtonsHeaderView.h
//  yishipi
//
//  Created by ttouch on 16/9/28.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//  多按钮组合控件

#import <UIKit/UIKit.h>

@interface TZButtonsHeaderView : UIScrollView

@property (nonatomic, strong) NSMutableArray *btnArr;

/// 是否要显示按钮中间的分割线 默认为YES
@property (nonatomic, assign) BOOL showLines;
/// 是否要显示底部的主色调指示器
@property (nonatomic, assign) BOOL showBottomIndicator;
/// 是否需要选中效果 比如选中按钮文字变红色
@property (nonatomic, assign) BOOL shouldSelect;
/// 是否要显示按钮底部的分割线 默认为YES
@property (nonatomic, assign) BOOL showBottomLine;
@property (nonatomic, strong) UIView *bottomIndicator;

///是否显示提示未读的点, 默认不显示
@property (nonatomic, strong) UILabel *spotLabel;
@property (nonatomic, strong) UIColor *spotColor;

/// 粗体大小
@property (nonatomic, assign) CGFloat boldFont;
/// 当选中时字体是否变化  默认不变化
@property (nonatomic, assign) BOOL changeFontWhenSelected;

/// 按钮的标题数组，请先设置这个值，再设置图片和方向等
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *fontSizes;
@property (nonatomic, assign) BOOL notCalcuLateTitleWidth;
@property (nonatomic, assign) NSInteger btnTitleWidthMargin;
@property (nonatomic, assign) NSInteger btnWidth;
@property (nonatomic, assign) NSInteger topInset;
/// 按钮的图片数组，传图片名字
@property (nonatomic, strong) NSArray *images;
/// 按钮图片的方向数组 1.图片在左边 2.图片在右边  默认为1
@property (nonatomic, strong) NSArray *directions;
/// 按钮是否允许重复点击 0 不允许 1 允许        默认为0
@property (nonatomic, strong) NSArray *canReClick;
/// 未读提示点的显示数组 0 不显示  1 显示
@property (nonatomic, strong) NSArray *showSpots;
// 设置按钮背景色
@property (nonatomic, strong) NSArray *colors;

/// 当前选中的按钮
@property (nonatomic, assign) NSInteger selectBtnIndex;
@property (nonatomic, assign) BOOL btnsEnable;

/// 按钮点击的block
@property (nonatomic, copy) void (^didClickButtonWithIndex)(TZBaseButton *btn, NSInteger index);


@property (nonatomic, strong) TZBaseButton *myTieBtn;

#pragma mark -- orCode
- (void)btnClick:(TZBaseButton *)sender;

// 设置按钮图片
- (void)setBtnImage:(NSString *)imageName forIndex:(NSInteger)index;
- (void)setBtnImage:(NSString *)imageName selImage:(NSString *)selImage forIndex:(NSInteger)index;
- (void)setBtnImage:(NSString *)imageName selImage:(NSString *)selImage;
- (void)setBtnImage:(NSString *)imageName selImage:(NSString *)selImage btnTitle:(NSString *)btnTitle selTitle:(NSString *)selTitle forIndex:(NSInteger)index;
// 设置按钮标题
- (void)setBtnTitle:(NSString *)title forIndex:(NSInteger)index;
- (void)setBtnTitles:(NSArray *)titles fontSize:(CGFloat)CGFloat;
- (void)setBtnTitleColor:(UIColor *)color bgColor:(UIColor *)bgColor forIndex:(NSInteger)index;

@end


@interface TZButtonsBottomView : TZButtonsHeaderView

/// 显示头部分割线  默认不显示
@property (nonatomic, assign) BOOL showHeadLine;
/// 显示边线框  默认显示
@property (nonatomic, assign) BOOL showBorder;
@property (nonatomic, strong) NSArray *borderColors;
/// 显示背景颜色   默认显示
@property (nonatomic, assign) BOOL showBackground;
@property (nonatomic, strong) NSArray *bgColors;

@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat btnY;

- (void)setBtnBorderColor:(UIColor *)color forIndex:(NSInteger)index;

@end


@interface TZButtonsCornerView : TZButtonsHeaderView

@end
