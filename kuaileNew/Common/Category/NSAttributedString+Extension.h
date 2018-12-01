//
//  NSAttributedString+Extension.h
//  yinliaopifa
//
//  Created by 肖兰月 on 2016/12/9.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Extension)

+ (NSAttributedString *)attributedStringsWithFrontText:(NSString *)frontText frontFont:(CGFloat)frontFont frontColor:(UIColor *)frontColor backText:(NSString *)backText backFont:(CGFloat)backFont backColor:(UIColor *)backColor middleText:(NSString *)middleText middleFont:(CGFloat)middleFont middleColor:(UIColor *)middleColor;

+ (NSAttributedString *)attributedStringsWithFrontText:(NSString *)frontText frontFont:(CGFloat)frontFont frontColor:(UIColor *)frontColor backText:(NSString *)backText backFont:(CGFloat)backFont backColor:(UIColor *)backColor;

+ (NSAttributedString *)attributedStringsWithFrontText:(NSString *)frontText frontBoldFont:(CGFloat)frontFont frontColor:(UIColor *)frontColor backText:(NSString *)backText backFont:(CGFloat)backFont backColor:(UIColor *)backColor;

+ (NSAttributedString *)attributedStringsWithFrontText:(NSString *)frontText frontBoldFont:(CGFloat)frontFont frontColor:(UIColor *)frontColor backText:(NSString *)backText backBoldFont:(CGFloat)backBoldFont backColor:(UIColor *)backColor;

+ (void)attributedStringsWithLabel:(UILabel *)label textFont:(CGFloat)textFont textRange:(NSRange)textRange textColor:(UIColor *)textColor isBoldFont:(BOOL)isBoldFont;


@end
