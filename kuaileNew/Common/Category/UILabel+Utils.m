//
//  UILabel+Utils.m
//  yangmingFinance
//
//  Created by ttouch on 2016/11/17.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "UILabel+Utils.h"

@implementation UILabel (Utils)

/// 让文字挨着上边显示
- (void)setNearTop {
    self.text = [NSString stringWithFormat:@"%@                                                                                           \r       \r     ",self.text];
}

- (void)setTitle:(id)title color:(id)color {
    [self setTitle:title font:nil color:color alignment:-1];
}

- (void)setFont:(id)font color:(id)color {
    [self setTitle:@"" font:font color:color alignment:-1];
}

- (void)setTitle:(NSString *)title font:(id)font color:(id)color {
    [self setTitle:title font:font color:color alignment:-1];
}

- (void)setTitle:(NSString *)title font:(id)font color:(id)color alignment:(NSTextAlignment)alignment {
    self.text = title;
    if (alignment >= 0) {
        self.textAlignment = alignment;
    }
    
    if ([font isKindOfClass:[UIFont class]]) {
        self.font = font;
    } else if ([font isKindOfClass:[NSNumber class]]) {
        self.font = [UIFont systemFontOfSize:[font integerValue]];
    }
    
    if ([color isKindOfClass:[UIColor class]]) {
        self.textColor = color;
    } else if ([color isKindOfClass:[NSNumber class]]) {
        self.textColor = TZColorRGB([color integerValue]);
    }
}

@end
