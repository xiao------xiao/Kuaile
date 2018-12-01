//
//  XYCheckMoreCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCheckMoreCell.h"


@implementation XYCheckMoreCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubView];
    }
    return self;
}

- (void)configSubView {
    _button = [[UIButton alloc] init];
    _button.frame = CGRectMake((mScreenWidth - 120)/2, (self.height - 30)/2, 120, 30);
    [_button setTitleColor:TZColorRGB(154) forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button];
}

- (void)configButtonWithImg:(NSString *)img text:(NSString *)text {
    UIImage *image = [UIImage imageNamed:img];
    [_button setTitle:text forState:0];
    [_button setImage:image forState:0];
    [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, -_button.imageView.frame.size.width, 0, _button.imageView.frame.size.width)];
    [_button setImageEdgeInsets:UIEdgeInsetsMake(0, _button.titleLabel.bounds.size.width, 0, -_button.titleLabel.bounds.size.width)];
}

- (void)buttonClick {
    if (self.didClickBtnBlock) {
        self.didClickBtnBlock();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _button.frame = CGRectMake((mScreenWidth - 120)/2, (self.height - 30)/2, 120, 30);
    
}



@end
