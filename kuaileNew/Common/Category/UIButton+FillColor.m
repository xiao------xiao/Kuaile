//
//  UIButton+FillColor.m
//  kuaileNew
//
//  Created by admin on 2018/11/29.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "UIButton+FillColor.h"

@implementation UIButton (FillColor)
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
    
}
+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    return image;
    
}
@end