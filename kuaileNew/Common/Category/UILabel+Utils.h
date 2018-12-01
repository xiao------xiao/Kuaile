//
//  UILabel+Utils.h
//  yangmingFinance
//
//  Created by ttouch on 2016/11/17.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utils)

/// 让文字挨着上边显示
- (void)setNearTop;

/// 设置标题、颜色、字体、对齐方式
- (void)setTitle:(id)title color:(id)color;
- (void)setFont:(id)font color:(id)color;
- (void)setTitle:(NSString *)title font:(id)font color:(id)color;
- (void)setTitle:(NSString *)title font:(id)font color:(id)color alignment:(NSTextAlignment)alignment;

@end
