//
//  XYShowMapResultCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/5/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYShowMapResultCell.h"

@implementation XYShowMapResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = TZColorRGB(84);
    [self.contentView addSubview:_titleLabel];
    
    _subTileLabel = [[UILabel alloc] init];
    _subTileLabel.textAlignment = NSTextAlignmentLeft;
    _subTileLabel.font = [UIFont systemFontOfSize:15];
    _subTileLabel.textColor = TZColorRGB(175);
    [self.contentView addSubview:_subTileLabel];
    
    _selImageView = [[UIImageView alloc] init];
    _selImageView.contentMode = UIViewContentModeScaleAspectFill;
    _selImageView.image = [UIImage imageNamed:@"xuanze_sel"];
    [self.contentView addSubview:_selImageView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.showSelecteImgView) {
        if (selected) {
            _selImageView.hidden = NO;
        } else {
            _selImageView.hidden = YES;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(8, 8, self.width - 50, 20);
    _subTileLabel.frame = CGRectMake(8, self.height - 8 - 20, self.width - 50, 20);
    _selImageView.frame = CGRectMake(self.width - 15 - 20, (self.height - 20)/2.0, 20, 20);
}




@end
