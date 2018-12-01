//
//  XYProgressView.m
//  下载进度条
//
//  Created by 肖兰月 on 16/1/24.
//  Copyright (c) 2016年 itcast. All rights reserved.
//

#import "XYProgressView.h"

@interface XYProgressView()
@property (nonatomic,weak) UILabel *label;
@end



@implementation XYProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
    }
    return self;
}

- (UILabel *)label{
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = TZColor(54, 194, 244);
        label.font = [UIFont systemFontOfSize:16];
        [self addSubview:label];
        _label = label;
    }
    return _label;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    self.label.text = [NSString stringWithFormat:@"%.2f%%",progress * 100];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(50, 50);
    CGFloat radius = 40;
    CGFloat startP = -M_PI_2;
    CGFloat endP =-M_PI_2 +_progress * M_PI * 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startP endAngle:endP clockwise:YES];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetStrokeColorWithColor(ctx, TZColor(54, 194, 244).CGColor);
    CGContextStrokePath(ctx);
}


@end
