//
//  ZYYHitNumberCell.m
//  DemoProduct
//
//  Created by 一盘儿菜 on 16/6/25.
//  Copyright © 2016年 周毅莹. All rights reserved.
//

#import "ZYYHitNumberCell.h"
@interface ZYYHitNumberCell () {
    NSMutableArray *_imageViewArr;
}
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation ZYYHitNumberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        _imageViewArr = [NSMutableArray array];
        
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.zanBtn setBackgroundImage:[UIImage imageNamed:@"zan_def"] forState:UIControlStateNormal];
        [self.zanBtn setBackgroundImage:[UIImage imageNamed:@"zan_sel"] forState:UIControlStateSelected];
        [self.contentView addSubview:_zanBtn];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"more"];
        [self.contentView addSubview:_imgView];
    }
    return self;
}

- (void)setMembers:(NSArray *)members {
    _members = members;
    if (_imageViewArr.count > 0) {
        [_imageViewArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self configImageView];
}

- (void)configImageView {
    CGFloat x;
    CGFloat width = 28;
    CGFloat margin = 5;
    for (NSInteger i = 0; i < _members.count; i++) {
        UIImageView *imageView;
        if (i < _imageViewArr.count) {
            imageView = _imageViewArr[i];
        } else {
            imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = width / 2;
            imageView.clipsToBounds = YES;
            [_imageViewArr addObject:imageView];
        }
        ICELoginUserModel *model = _members[i];
        NSURL *avatarUrl;
        if ([model.avatar containsString:@"http://"]) {
            avatarUrl = [NSURL URLWithString:model.avatar];
        } else {
            avatarUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ApiSystemImage,model.avatar]];
        }
        [imageView sd_setImageWithURL:avatarUrl placeholderImage:TZPlaceholderAvaterImage];
        // frame
        x = i * (width + margin) + margin * 9;
        if (x >= (mScreenWidth - 50)) break;
        imageView.frame = CGRectMake(x, 2, width, width);
        [self addSubview:imageView];
    }
}

- (void)setIsReport:(BOOL)isReport {
    _isReport = isReport;
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isReport) {
        _zanBtn.frame = CGRectMake(12, 6 + 8, 18, 18);
        _imgView.frame = CGRectMake(mScreenWidth - 30, 6 + 8, 10, 18);
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[UIImageView class]]) {
                subView.y = 6 + 3;
            }
        }
    } else {
        _imgView.frame = CGRectMake(mScreenWidth - 30, 6, 10, 18);
        _zanBtn.frame = CGRectMake(12, 6, 18, 18);
    }
}

@end
