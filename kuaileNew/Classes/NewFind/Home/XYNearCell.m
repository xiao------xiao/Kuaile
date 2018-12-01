//
//  XYNearCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/13.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYNearCell.h"
#import "XYAvaterView.h"
#import "TZFindSnsModel.h"



@implementation XYNearCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setDefaultSetting];
    }
    return self;
}
- (void)setDefaultSetting {
//    self.backgroundColor = TZColorRGB(246);
    self.containerViews = [NSMutableArray array];
    self.imgCornerRadius = 35;
}


- (void)configButtonWithImages:(NSArray *)images titles:(NSArray *)titles ages:(NSArray *)ages gender:(NSArray *)gender {
 
    if (self.containerViews.count) return;
    NSInteger maxCount = 0;
    if (images.count >= titles.count) { maxCount = images.count;
    } else { maxCount = titles.count;}
    
    for (int i = 0; i < maxCount; i++) {
        _avaterView = [[XYAvaterView alloc] init];
        _avaterView.backgroundColor = [UIColor whiteColor];
//        _avaterView.tag = 100 + i;
        
        CGFloat r = self.imgCornerRadius;
        _avaterView.imgCornerRadius = self.imgCornerRadius;
        _avaterView.hideSexbtn = self.hideSexBtn;
        _avaterView.fontSize = 14;
        _avaterView.imgViewY = self.imgViewY;
        [_avaterView configAvaterViewWithImage:images[i] title:titles[i] ages:ages[i] gender:gender[i]];
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_avaterView addSubview:btn];
        
        [self.contentView addSubview:_avaterView];
        [self.containerViews addObject:_avaterView];
    }
}

- (void)btnClick:(UIButton *)btn {
    if (self.XYNearCellViewBlock) {
        self.XYNearCellViewBlock(btn.tag);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.containerWidth) self.containerWidth = (self.width - 3)/4.0;
    CGFloat containViewW = self.containerWidth;
    CGFloat containViewX = 0;
    NSInteger count = self.containerViews.count;
    for (int i = 0; i < count; i++) {
        UIView *view = self.containerViews[i];
        containViewX = (containViewW + 1) * (i%count);
        view.frame = CGRectMake(containViewX, 0, containViewW, self.height);
        
        for (UIView *sub in view.subviews) {
            if ([sub isKindOfClass:[UIButton class]]) {
                sub.frame = view.bounds;
            }
        }
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = TZColorRGB(246);
        lineView.frame = CGRectMake(containViewW - 1, 0, 1, self.height);
        [view addSubview:lineView];
    }
}

@end
