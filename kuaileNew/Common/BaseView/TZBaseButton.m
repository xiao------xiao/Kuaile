//
//  TZBaseButton.m
//  yishipi
//
//  Created by ttouch on 16/9/28.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "TZBaseButton.h"

@interface TZBaseButton ()
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat lableWidth;
@end

@implementation TZBaseButton

- (void)setDirection:(NSInteger)direction {
    _direction = direction;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect rect = [super titleRectForContentRect:contentRect];
    _lableWidth = rect.size.width;
    if (_direction == 1) {
        return rect;
    }
    
    switch (_direction) {
        case 2: {   
            rect.origin.x = rect.origin.x - _imageWidth - 1;
            //NSLog(@"图片在右边,文字尺寸：%@",NSStringFromCGRect(rect));
        } break;
        default: break;
    }
    return rect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect rect = [super imageRectForContentRect:contentRect];
    _imageWidth = rect.size.width;
    if (_direction == 1) {
        return rect;
    }
    
    switch (_direction) {
        case 2: {
            rect.origin.x = rect.origin.x + self.lableWidth + 2;
            //NSLog(@"图片在右边,图片尺寸：%@",NSStringFromCGRect(rect));
        } break;
        default: break;
    }
    return rect;
}

@end
