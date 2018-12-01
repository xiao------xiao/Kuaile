//
//  XYTestView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/3.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYTestView.h"

@implementation XYTestView

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}



-(void)drawRect:(CGRect)rect
{
    //中间镂空的矩形框
    CGRect myRect = CGRectMake((self.width - 200) / 2.0, 200, 200, 200);
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:myRect];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
    fillLayer.fillColor = [UIColor whiteColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.layer addSublayer:fillLayer];
}


@end
