//
//  XYPromoteCell.m
//  yinliaopifa
//
//  Created by 肖兰月 on 2016/12/11.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XYPromoteCell.h"
#import "XYBannerModel.h"

@interface XYPromoteCell ()

@end

@implementation XYPromoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configDefaultSetting];
        [self configSubViews];
    }
    return self;
}

- (void)configDefaultSetting {
    self.margin = 2;
}

- (void)configSubViews {
    _imgView = [[UIImageView alloc] init];
    _imgView.layer.cornerRadius = 8;
    _imgView.clipsToBounds = YES;
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imgView];
}

- (void)setModel:(XYBannerModel *)model {
    _model = model;
    [_imgView sd_setImageWithURL:TZImageUrlWithShortUrl(model.brand_path) placeholderImage:TZPlaceholderImage];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imgView.frame = CGRectMake(self.margin, self.margin, mScreenWidth - self.margin * 2, self.height - self.margin * 2);
}


@end
