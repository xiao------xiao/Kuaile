//
//  ZM_NewFeatureController.m
//  ZM_MiniSupply
//
//  Created by 谭真 on 16/1/26.
//  Copyright © 2016年 上海宅米贸易有限公司. All rights reserved.
//

#import "TZNewFeatureController.h"

@interface TZNewFeatureController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation TZNewFeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configScrollView];
    [self configPageControl];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(mScreenWidth * 4, mScreenHeight);
    [self.view addSubview:_scrollView];
    
    CGFloat x = 0;
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"newFeature_%zd",i + 1]];
        // imageView.contentMode = UIViewContentModeScaleAspectFill;
        // imageView.clipsToBounds = YES;
        x = i * mScreenWidth;
        imageView.frame = CGRectMake(x, 0, mScreenWidth, mScreenHeight);
        [_scrollView addSubview:imageView];
        
        if (i == 3) {
            imageView.userInteractionEnabled = YES;
            UIButton *beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            beginBtn.frame = CGRectMake(100, mScreenHeight - 150, mScreenWidth - 200, 150);
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
    [self.view addSubview:_pageControl];
}

#pragma mark - 点击事件

- (void)beginUseNewApplicationBtnClick {
    if (self.startUseNewApplication) {
        self.startUseNewApplication();
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    NSInteger page = (offSet.x + mScreenWidth / 2) / mScreenWidth;
    _pageControl.currentPage = page;
    
    if (offSet.x >= mScreenWidth * 3 + 25) {
        if (self.startUseNewApplication) {
            self.startUseNewApplication();
        }
    }
}

@end
