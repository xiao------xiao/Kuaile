//
//  XYLayer.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/3.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYLayer.h"

@implementation XYLayer

- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        //
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextAddArc(ctx, 150, 200, 50, 0, 2 * M_PI, 0);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextFillPath(ctx);
}

@end
