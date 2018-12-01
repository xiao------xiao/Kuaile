//
//  NSAttributedString+Extension.m
//  yinliaopifa
//
//  Created by 肖兰月 on 2016/12/9.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "NSAttributedString+Extension.h"

@implementation NSAttributedString (Extension)

+ (NSAttributedString *)attributedStringsWithFrontText:(NSString *)frontText frontFont:(CGFloat)frontFont frontColor:(UIColor *)frontColor backText:(NSString *)backText backFont:(CGFloat)backFont backColor:(UIColor *)backColor middleText:(NSString *)middleText middleFont:(CGFloat)middleFont middleColor:(UIColor *)middleColor{
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    
    NSDictionary *frontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:frontFont],
                                NSForegroundColorAttributeName:frontColor};
    NSAttributedString *frontAttr = [[NSAttributedString alloc] initWithString:frontText attributes:frontDict];
    
    NSAttributedString *middleAttr = nil;
    if (middleText && middleText.length) {
        NSDictionary *middleDict = @{NSFontAttributeName:[UIFont systemFontOfSize:middleFont],
                                     NSForegroundColorAttributeName:middleColor};
        middleAttr = [[NSAttributedString alloc] initWithString:middleText attributes:middleDict];
    }
    
    NSDictionary *backDict = @{NSFontAttributeName:[UIFont systemFontOfSize:backFont],
                               NSForegroundColorAttributeName:backColor};
    NSAttributedString *backAttr = [[NSAttributedString alloc] initWithString:backText attributes:backDict];
    
    [mutableAttr appendAttributedString:frontAttr];
    if (middleText && middleText.length) {
        [mutableAttr appendAttributedString:middleAttr?middleAttr:@""];
    }
    [mutableAttr appendAttributedString:backAttr];
    return mutableAttr;
}

+ (NSAttributedString *)attributedStringsWithFrontText:(NSString *)frontText frontFont:(CGFloat)frontFont frontColor:(UIColor *)frontColor backText:(NSString *)backText backFont:(CGFloat)backFont backColor:(UIColor *)backColor {
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    
    NSDictionary *frontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:frontFont],
                                NSForegroundColorAttributeName:frontColor};
    NSAttributedString *frontAttr = [[NSAttributedString alloc] initWithString:frontText attributes:frontDict];
    
    
    NSDictionary *backDict = @{NSFontAttributeName:[UIFont systemFontOfSize:backFont],
                               NSForegroundColorAttributeName:backColor};
    NSAttributedString *backAttr = [[NSAttributedString alloc] initWithString:backText attributes:backDict];
    
    [mutableAttr appendAttributedString:frontAttr];
    [mutableAttr appendAttributedString:backAttr];
    return mutableAttr;
}

+ (NSAttributedString *)attributedStringsWithFrontText:(NSString *)frontText frontBoldFont:(CGFloat)frontFont frontColor:(UIColor *)frontColor backText:(NSString *)backText backFont:(CGFloat)backFont backColor:(UIColor *)backColor {
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    
    NSDictionary *frontDict = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:frontFont],
                                NSForegroundColorAttributeName:frontColor};
    NSAttributedString *frontAttr = [[NSAttributedString alloc] initWithString:frontText attributes:frontDict];
    
    
    NSDictionary *backDict = @{NSFontAttributeName:[UIFont systemFontOfSize:backFont],
                               NSForegroundColorAttributeName:backColor};
    NSAttributedString *backAttr = [[NSAttributedString alloc] initWithString:backText attributes:backDict];
    
    [mutableAttr appendAttributedString:frontAttr];
    [mutableAttr appendAttributedString:backAttr];
    return mutableAttr;
}

+ (NSAttributedString *)attributedStringsWithFrontText:(NSString *)frontText frontBoldFont:(CGFloat)frontFont frontColor:(UIColor *)frontColor backText:(NSString *)backText backBoldFont:(CGFloat)backBoldFont backColor:(UIColor *)backColor {
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    
    NSDictionary *frontDict = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:frontFont],
                                NSForegroundColorAttributeName:frontColor};
    NSAttributedString *frontAttr = [[NSAttributedString alloc] initWithString:frontText attributes:frontDict];
    
    
    NSDictionary *backDict = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:backBoldFont],
                               NSForegroundColorAttributeName:backColor};
    NSAttributedString *backAttr = [[NSAttributedString alloc] initWithString:backText attributes:backDict];
    
    [mutableAttr appendAttributedString:frontAttr];
    [mutableAttr appendAttributedString:backAttr];
    return mutableAttr;
}


+ (void)attributedStringsWithLabel:(UILabel *)label textFont:(CGFloat)textFont textRange:(NSRange)textRange textColor:(UIColor *)textColor isBoldFont:(BOOL)isBoldFont {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:label.text];
    if (isBoldFont) {
        [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:textFont] range:textRange];
    } else {
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:textFont] range:textRange];
    }
    [attr addAttribute:NSForegroundColorAttributeName value:textColor range:textRange];
    label.attributedText = attr;
}


@end
