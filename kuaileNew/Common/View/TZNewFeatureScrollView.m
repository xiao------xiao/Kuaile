//
//  TZNewFeatureScrollView.m
//  housekeep
//
//  Created by ttouch on 16/7/1.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZNewFeatureScrollView.h"

@interface TZNewFeatureScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation TZNewFeatureScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configScrollView];
        [self configPageControl];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(mScreenWidth * 4, mScreenHeight);
    [self addSubview:_scrollView];
    
    CGFloat x = 0;
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        if (mScreenHeight == 480) {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"newFeature4s_%zd",i + 1]];
        } else {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"newFeature_%zd",i + 1]];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        x = i * mScreenWidth;
        imageView.frame = CGRectMake(x, 0, mScreenWidth, mScreenHeight);
        [_scrollView addSubview:imageView];
        
        if (i == 3) {
            imageView.userInteractionEnabled = YES;
            UIButton *beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            beginBtn.frame = CGRectMake(100, mScreenHeight - 250, mScreenWidth - 200, 250);
            [beginBtn addTarget:self action:@selector(beginUseNewApplicationBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:beginBtn];
        }
    }
}

- (void)configPageControl {
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((mScreenWidth - 120) / 2, mScreenHeight - 50, 120, 50)];
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = TZMainColor;
    _pageControl.pageIndicatorTintColor = TZColor(200, 200, 200);
    [self addSubview:_pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _pageControl.frame = CGRectMake((mScreenWidth - 120) / 2, mScreenHeight - 50, 120, 50);
}

#pragma mark - 点击事件

- (void)beginUseNewApplicationBtnClick {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.7;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.0;
            self.mj_x = -mScreenWidth;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [mNotificationCenter postNotificationName:@"checkIsHaveLocation" object:nil];
        }];
    }];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    NSInteger page = (offSet.x + mScreenWidth / 2) / mScreenWidth;
    _pageControl.currentPage = page;
    
    if (offSet.x >= mScreenWidth * 3) {
        CGFloat margin = offSet.x - mScreenWidth * 3;
        self.alpha = (80 - margin) / 80.0;
    }
    if (offSet.x >= mScreenWidth * 3 + 80) {
        [self removeFromSuperview];
        [mNotificationCenter postNotificationName:@"checkIsHaveLocation" object:nil];
    }
}

@end
