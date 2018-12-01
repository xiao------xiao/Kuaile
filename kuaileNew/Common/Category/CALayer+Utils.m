//
//  CALayer+Utils.m
//  Emorald
//
//  Created by ttouch on 16/8/3.
//  Copyright © 2016年 zyy. All rights reserved.
//

#import "CALayer+Utils.h"

@implementation CALayer (Utils)

- (void)addStandardShadow {
    [self addStandardShadowWithOffset:CGSizeMake(1, 1)];
}

- (void)addStandardShadowWithOffset:(CGSize)offset {
    [self setShadowColor: [UIColor blackColor].CGColor];
    [self setShadowOffset:offset];
    [self setShadowOpacity :0.5];
    [self setShadowRadius :2];
}

@end
