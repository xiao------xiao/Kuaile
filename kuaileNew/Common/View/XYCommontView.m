//
//  XYCommentView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/14.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCommontView.h"

@implementation XYCommontView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = TZColorRGB(245);
        [self configDefaultSetting];
        [self configSubView];
    }
    return self;
}

- (void)configDefaultSetting {
    self.fontSize = 12;
}

- (void)configSubView {
    _frontLabel = [[UILabel alloc] init];
    _frontLabel.frame = CGRectMake(10, (self.height - 20)/2.0, mScreenWidth * 0.7, 20);
    _frontLabel.font = [UIFont systemFontOfSize:self.fontSize];
    _frontLabel.textAlignment = NSTextAlignmentLeft;
    _frontLabel.textColor = TZGreyText150Color;
    [self addSubview:_frontLabel];
    
    _backLabel = [[UILabel alloc] init];
    _backLabel.frame = CGRectMake(10, (self.height - 20)/2.0, mScreenWidth * 0.7, 20);
    _backLabel.font = [UIFont systemFontOfSize:self.fontSize];
    _backLabel.textAlignment = NSTextAlignmentRight;
    _backLabel.textColor = TZGreyText150Color;
    [self addSubview:_backLabel];
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    _frontLabel.font = [UIFont systemFontOfSize:fontSize];
    _backLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)setFrontText:(NSString *)frontText {
    _frontText = frontText;
    _frontLabel.text = frontText;
}

- (void)setBackText:(NSString *)backText {
    _backText = backText;
    _backLabel.text = backText;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _frontLabel.frame = CGRectMake(10, (self.height - 20)/2.0, mScreenWidth * 0.7, 20);
    _backLabel.frame = CGRectMake(self.width - 10 - mScreenWidth * 0.2, (self.height - 20)/2.0, mScreenWidth * 0.2, 20);
}

@end
