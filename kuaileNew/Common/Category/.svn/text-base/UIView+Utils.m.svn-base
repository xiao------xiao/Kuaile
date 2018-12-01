//
//  UIView+Utils.m
//  刷刷
//
//  Created by 谭真 on 16/4/16.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

#pragma mark - 纯文字的HUD

/// 显示一个纯文字的tipLable
- (void)showInfo:(NSString *)message {
    [SGInfoAlert showInfo:message bgColor:[[UIColor darkGrayColor] CGColor] fgColor:[[UIColor whiteColor] CGColor] inView:[UIApplication sharedApplication].keyWindow vertical:0.5];
}



- (void)showNoneDataWithText:(NSString*)text hasImage:(BOOL)isHasImage count:(NSInteger)count fontSize:(CGFloat)fontSize{
    if (count < 1) {
        [self hideNoneData]; return;
    }
    UIImage *image = [UIImage imageNamed:@"nodata"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    imageView.tag = 1234;
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __kScreenWidth, 50)];
    label.centerX = self.centerX;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = text;
    label.tag = 12345;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor lightGrayColor];
    [self addSubview:label];
    
    if (isHasImage) {
        imageView.centerY = self.height*0.5;
        imageView.mj_x = 40;
        label.centerY = self.height * 0.5;
        label.mj_x = CGRectGetMaxX(imageView.frame) + 20;
    } else {
        imageView.hidden = YES;
        label.frame = CGRectMake(0, 0, self.width, self.height);
    }
}

- (void)showNoneDataWithText:(NSString*)text IsHasImage:(BOOL)isHasImage fontSize:(CGFloat)fontSize {
    [self showNoneDataWithText:text hasImage:isHasImage count:1 fontSize:fontSize];
}

- (void)showNoneDataWithText:(NSString*)text IsHasImage:(BOOL)isHasImage{
    [self showNoneDataWithText:text hasImage:isHasImage count:1 fontSize:16];
}

- (void)hideNoneData {
    if ([self viewWithTag:1234]) {
        [[self viewWithTag:1234] removeFromSuperview];
    }
    if ([self viewWithTag:12345]) {
        [[self viewWithTag:12345] removeFromSuperview];
    }
}

#pragma mark - 正在加载指示器

- (void)showLoading {
    [self hideRefreshButton];
    [self showLoadingWithLeft:0 top:0];
}

- (void)showLoadingWithLeft:(CGFloat)left top:(CGFloat)top {
    [self hideLoading];
    
    UIActivityIndicatorView *_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.tag = 111;
    [_activityView startAnimating];
    _activityView.frame = CGRectMake(self.width / 2 - 15 + left - 40, self.height / 2 - 20 - top, 40, 40);
    [self addSubview:_activityView];
    
    UILabel *_tipLable  = [[UILabel alloc] init];
    _tipLable.tag = 222;
    _tipLable.frame = CGRectMake(self.width / 2 - 20 + left, self.height / 2 - 20 - top, 80, 40);
    _tipLable.text = @"Loading...";
    _tipLable.font = [UIFont systemFontOfSize:16];
    _tipLable.textColor = [UIColor lightGrayColor];
    [self addSubview:_tipLable];
}

- (void)hideLoading {
    if ([self viewWithTag:111]) {
        UIView *view = [self viewWithTag:111] ;
        if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
            [(UIActivityIndicatorView *)view stopAnimating];
        }
        [view removeFromSuperview];
    }
    if ([self viewWithTag:222]) {
        [[self viewWithTag:222] removeFromSuperview];
    }
}

- (void)showRefreshButton {
    [self showRefreshButtonWithLeft:0 top:0];
}

- (void)showRefreshButtonWithErrorStr:(NSString *)errorStr {
    [self showRefreshButtonWithLeft:0 top:0 errorStr:errorStr];
}

- (void)showRefreshButtonWithLeft:(CGFloat)left top:(CGFloat)top {
    [self showRefreshButtonWithLeft:left top:top errorStr:nil];
}

- (void)showRefreshButtonWithLeft:(CGFloat)left top:(CGFloat)top errorStr:(NSString *)errorStr {
    [self hideRefreshButton];
    [self hideLoading];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"重新加载" forState:0];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    //    button.layer.borderColor = [UIColor darkGrayColor].CGColor;
    //    button.layer.borderWidth = 0.5;
    if (self.width > 200) {
        button.frame = CGRectMake(50 + left, self.height / 2 - top, self.width - 100 - left, 35);
    } else {
        button.frame = CGRectMake(10 + left, self.height / 2 - top, self.width - 20 - left, 35);
    }
    button.tag = 333;
    button.backgroundColor = TZMainColor;
    [self addSubview:button];
    
    UILabel *_tipLable  = [[UILabel alloc] init];
    _tipLable.tag = 444;
    _tipLable.frame = CGRectMake(10 + left, self.height / 2 - 44 - top, self.width - 20 - left, 40);
    _tipLable.text = errorStr.length ? errorStr : @"网络异常";
    _tipLable.font = [UIFont systemFontOfSize:16];
    _tipLable.numberOfLines = 2;
    _tipLable.textAlignment = NSTextAlignmentCenter;
    _tipLable.textColor = TZColorRGB(128);
    [self addSubview:_tipLable];
    
    __weak typeof(button) weakBtn = button;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(UIButton *)btn {
    [mNotificationCenter postNotificationName:@"didClickRetryButtonNotification" object:nil];
    [btn removeFromSuperview];
    [[self viewWithTag:222] removeFromSuperview];
    [self hideRefreshButton];
}



- (void)hideRefreshButton {
    if ([self viewWithTag:333]) {
        [[self viewWithTag:333] removeFromSuperview];
    }
    if ([self viewWithTag:444]) {
        [[self viewWithTag:444] removeFromSuperview];
    }
}

/// 连续三次的动画效果 类似微博的点赞
+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer scale1:(CGFloat)scale1 scale2:(CGFloat)scale2 {
    [self showOscillatoryAnimationWithLayer:layer scale1:scale1 duration1:0.15 scale2:scale2 duration2:0.15];
}

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer scale1:(CGFloat)scale1 duration1:(CGFloat)duration1 scale2:(CGFloat)scale2 duration2:(CGFloat)duration2 {
    [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:@(scale1) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:@(scale2) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

/// 购物车动画飞入效果
+ (void)flyAnimationWithContentView:(UIView *)contentView fromX:(CGFloat)x y:(CGFloat)y {
    [self flyAnimationWithContentView:contentView fromX:x y:y toX:36 toY:mScreenHeight - 64 - 40];
}

+ (void)flyAnimationWithContentView:(UIView *)contentView fromX:(CGFloat)x y:(CGFloat)y toX:(CGFloat)toX toY:(CGFloat)toY{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationCubic;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 0.5;
    pathAnimation.repeatCount = 1;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, x, y);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, x - 160, y - 120, toX, toY);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    UIImageView *circleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhuangtai_sel"]];
    circleView.frame = CGRectMake(1, 1, 20, 20);
    [contentView addSubview:circleView];
    
    [circleView.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [circleView removeFromSuperview];
    });
}

- (void)addTopLine {
    [self addTopLineWithHeight:0.5];
}

- (void)addTopLineWithColor:(UIColor *)color {
    [self addTopLineWithHeight:0.5 color:color];
}

- (void)addTopLineWithHeight:(NSInteger)height {
    [self addTopLineWithHeight:height color:TZControllerBgColor];
}

- (void)addTopLineWithHeight:(NSInteger)height color:(UIColor *)color {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *line = [self viewWithTag:38452];
        if (!line) {
            line = [[UIView alloc] init];
            line.tag = 38452;
            NSInteger width = self.width;
            if ([self isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scrollView = (UIScrollView *)self;
                width = MAX(self.width, scrollView.contentSize.width);
            }
            line.frame = CGRectMake(0, 0, width, height);
            line.backgroundColor = color;
            [self addSubview:line];
        }
    });
}

- (void)removeTopLine {
    UIView *line = [self viewWithTag:38452];
    if (line) {
        [line removeFromSuperview];
    }
}

- (void)configTopLineWithRow:(NSInteger)row {
    if (row == 0) {
        [self addTopLine];
    } else {
        [self removeTopLine];
    }
}

- (void)addCenterLine {
    [self addCenterLineWithHeightInset:0];
}

- (void)addCenterLineWithHeightInset:(NSInteger)heightInset {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *line = [self viewWithTag:38453];
        if (!line) {
            line = [[UIView alloc] init];
            line.tag = 38453;
            line.frame = CGRectMake(self.width / 2, heightInset, 0.5, self.height - heightInset * 2);
            line.backgroundColor = TZControllerBgColor;
            [self addSubview:line];
        }
    });
}

//- (void)addBottomSeperatorView {
//    [self addBottomSeperatorViewWithHeight:10];
//}
//
//- (void)addBottomSeperatorViewWithHeight:(NSInteger)height {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIView *seperator = [self viewWithTag:38454];
//        if (!seperator) {
//            seperator = [[UIView alloc] init];
//            seperator.tag = 38454;
//            seperator.frame = CGRectMake(0, self.height - height, self.width, height);
//            seperator.backgroundColor = TZControllerBgColor;
//            [self addSubview:seperator];
//        }
//    });
//}

- (void)addBottomSeperatorView {
    [self addBottomSeperatorViewWithHeight:10 color:TZControllerBgColor];
}

- (void)addBottomSeperatorViewWithHeight:(NSInteger)height {
    [self addBottomSeperatorViewWithHeight:height color:TZControllerBgColor];
}

- (void)addBottomSeperatorViewWithHeight:(NSInteger)height color:(UIColor *)color{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *seperator = [self viewWithTag:38454];
        if (!seperator) {
            seperator = [[UIView alloc] init];
            seperator.tag = 38454;
            CGFloat selRowH = self.height;
            seperator.frame = CGRectMake(0, self.height - height, self.width, height);
            seperator.backgroundColor = color;
            [self addSubview:seperator];
        }
    });
}

- (void)configTextFieldLeftView:(UITextField *)textField leftImgName:(NSString *)imgName {
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    [textField.leftView addSubview:[self createButtonWithImageName:imgName]];
}

- (void)configTextFieldLeftView:(UITextField *)textField width:(NSInteger)width {
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.height)];
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (UIButton *)createButtonWithImageName:(NSString *)imageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(8, 12, 16, 16);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.contentMode = UIViewContentModeCenter;
    return button;
}

/// 设置边框颜色
- (void)setBorderColor:(id)borderColor borderWidth:(CGFloat)borderWidth {
    [self setBorderColor:borderColor borderWidth:borderWidth cornerRadius:0];
}

- (void)setBorderColor:(id)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
    if ([borderColor isKindOfClass:[UIColor class]]) {
        UIColor *color = borderColor;
        self.layer.borderColor = color.CGColor;
    } else if ([borderColor isKindOfClass:[NSNumber class]]) {
        self.layer.borderColor = TZColorRGB([borderColor integerValue]).CGColor;
    }
    
    self.layer.borderWidth = borderWidth;
    if (cornerRadius > 0) {
        self.layer.cornerRadius = cornerRadius;
    }
}

- (void)setBorderColor:(id)borderColor borderWidth:(CGFloat)borderWidth lineDashPattern:(NSArray *)lineDashPattern {
    if (!lineDashPattern || !lineDashPattern.count) {
        [self setBorderColor:borderColor borderWidth:borderWidth];
    } else {
        // 虚线边框
        CAShapeLayer *border = [CAShapeLayer layer];
        if ([borderColor isKindOfClass:[UIColor class]]) {
            UIColor *color = borderColor;
            border.strokeColor = color.CGColor;
        } else if ([borderColor isKindOfClass:[NSNumber class]]) {
            border.strokeColor = TZColorRGB([borderColor integerValue]).CGColor;
        }
        border.fillColor = nil;
        border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        border.frame = self.bounds;
        border.lineWidth = borderWidth;
        border.lineCap = @"square";
        border.lineDashPattern = lineDashPattern;
        [self.layer addSublayer:border];
    }
}

@end
