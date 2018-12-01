//
//  XYAvaterView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/2.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYAvaterView.h"

@implementation XYAvaterView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configDefaultSetting];
    }
    return self;
}

- (void)configDefaultSetting {
//    self.imgCornerRadius = 35;
    self.hideSexbtn = NO;
}

- (void)configAvaterViewWithImage:(NSString *)image title:(NSString *)title ages:(NSString *)age gender:(NSString *)gender {
    _imgView = [[UIImageView alloc] init];
    [_imgView sd_setImageWithURL:TZImageUrlWithShortUrl(image) placeholderImage:TZPlaceholderAvaterImage options:SDWebImageRefreshCached];
    CGFloat r = self.imgCornerRadius;
    _imgView.layer.cornerRadius = self.imgCornerRadius;
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.clipsToBounds = YES;
    [self addSubview:_imgView];
    
    if (!self.hideSexbtn) {
        _sexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sexBtn setTitle:age forState:0];
        if ([gender isEqualToString:@"0"]) {
            [_sexBtn setBackgroundImage:[UIImage imageNamed:@"boy"] forState:0];
        }else {
            [_sexBtn setBackgroundImage:[UIImage imageNamed:@"girl"] forState:0];
        }
        [_sexBtn setTitleColor:[UIColor whiteColor] forState:0];
        _sexBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _sexBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self addSubview:_sexBtn];
    }
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = title;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = TZColorRGB(128);
    _titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.imgViewY) self.imgViewY = 5;
    _imgView.frame = CGRectMake((self.width - 70) / 2.0, self.imgViewY, 70, 70);
//    _imgView.frame = CGRectMake(4, self.imgViewY, self.width - 8, self.width - 8);
    CGFloat maxImgY = CGRectGetMaxY(_imgView.frame);
    _sexBtn.frame = CGRectMake(self.width / 2.0, maxImgY - 18, 38, 18);
    _titleLabel.frame = CGRectMake(2, maxImgY + 8, self.width - 4, 20);
}

@end
