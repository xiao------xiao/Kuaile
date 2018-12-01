//
//  NSAttributedString+Utils.h
//  DemoProduct
//
//  Created by 谭真 on 16/6/10.
//  Copyright © 2016年 周毅莹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Utils)

+ (NSAttributedString *)attributedTextWithText:(NSString *)string;
+ (NSAttributedString *)attributedTextWithText:(NSString *)string textColor:(UIColor *)textColor;
+ (NSAttributedString *)attributedTextWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize;

+ (NSMutableArray *)partsArrayFromText:(NSString *)text;
+ (NSMutableArray *)partsArrayFromText:(NSString *)text forShow:(BOOL)forShow;

@end
