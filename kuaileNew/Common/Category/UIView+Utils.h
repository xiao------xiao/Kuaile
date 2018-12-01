//
//  UIView+Utils.h
//  刷刷
//
//  Created by 谭真 on 16/4/16.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

/// 提示没有数据
- (void)showNoneDataWithText:(NSString*)text hasImage:(BOOL)isHasImage count:(NSInteger)count fontSize:(CGFloat)fontSize;
- (void)showNoneDataWithText:(NSString*)text IsHasImage:(BOOL)isHasImage;
- (void)showNoneDataWithText:(NSString*)text IsHasImage:(BOOL)isHasImage fontSize:(CGFloat)fontSize;
- (void)hideNoneData;

/// 显示正在加载的指示器
- (void)showLoading;
- (void)showLoadingWithLeft:(CGFloat)left top:(CGFloat)top;
- (void)hideLoading;
- (void)showRefreshButton;
- (void)showRefreshButtonWithErrorStr:(NSString *)errorStr;
- (void)showRefreshButtonWithLeft:(CGFloat)left top:(CGFloat)top;
- (void)showRefreshButtonWithLeft:(CGFloat)left top:(CGFloat)top errorStr:(NSString *)errorStr;
- (void)hideRefreshButton;

/// 显示一个纯文字的tipLable 会自己dismiss
- (void)showInfo:(NSString *)message;

/// 连续三次的动画效果 类似微博的点赞
+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer scale1:(CGFloat)scale1 scale2:(CGFloat)scale2;
+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer scale1:(CGFloat)scale1 duration1:(CGFloat)duration1 scale2:(CGFloat)scale2 duration2:(CGFloat)duration2;

/// 购物车动画飞入效果
+ (void)flyAnimationWithContentView:(UIView *)contentView fromX:(CGFloat)x y:(CGFloat)y;
+ (void)flyAnimationWithContentView:(UIView *)contentView fromX:(CGFloat)x y:(CGFloat)y toX:(CGFloat)toX toY:(CGFloat)toY;

- (void)addTopLine;
- (void)addTopLineWithColor:(UIColor *)color;
- (void)addTopLineWithHeight:(NSInteger)height;
- (void)addTopLineWithHeight:(NSInteger)height color:(UIColor *)color;
- (void)removeTopLine;
- (void)configTopLineWithRow:(NSInteger)row;

- (void)addCenterLine;
- (void)addCenterLineWithHeightInset:(NSInteger)heightInset;

- (void)addBottomSeperatorView;
- (void)addBottomSeperatorViewWithHeight:(NSInteger)height;
- (void)addBottomSeperatorViewWithHeight:(NSInteger)height color:(UIColor *)color;

/// 配置UITextField的leftView
- (void)configTextFieldLeftView:(UITextField *)textField leftImgName:(NSString *)imgName;
- (void)configTextFieldLeftView:(UITextField *)textField width:(NSInteger)width;

/// 设置边框颜色
- (void)setBorderColor:(id)borderColor borderWidth:(CGFloat)borderWidth;
- (void)setBorderColor:(id)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;
- (void)setBorderColor:(id)borderColor borderWidth:(CGFloat)borderWidth lineDashPattern:(NSArray *)lineDashPattern;

@end
