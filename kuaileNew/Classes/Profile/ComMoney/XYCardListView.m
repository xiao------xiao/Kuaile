//
//  XYCardListView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/20.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCardListView.h"

@interface XYCardListView ()
@property (nonatomic, assign) CGFloat titleW;
@property (nonatomic, strong) NSMutableArray *imgs;

@end


@implementation XYCardListView

- (instancetype)init {
    self = [super init];
    if (self) {
        _imgs = [NSMutableArray array];
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = NSTextAlignmentLeft;
    _titleLabel.textColor = TZGreyText150Color;
    _titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_titleLabel];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
    self.titleW = [CommonTools sizeOfText:title fontSize:13].width;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    for (int i = 0; i < images.count; i++) {
        NSString *imageName = images[i];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:imageName];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self addSubview:imgView];
        [self.imgs addObject:imgView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(10, (self.height - 20) / 2.0, self.titleW, 20);
    
    CGFloat imgWH = 20;
    CGFloat imgX = 0;
    CGFloat margin = 10;
    NSInteger count = self.imgs.count;
    for (int i = 0; i < count; i++) {
        
        UIImageView *imgView = self.imgs[i];
        imgX = self.width - ((margin + imgWH) * (i + 1));
        imgView.frame = CGRectMake(imgX, (self.height - imgWH)/2.0, imgWH, imgWH);
    }
}

@end
