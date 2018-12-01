//
//  UIScrollView+Utils.m
//  刷刷
//
//  Created by 谭真 on 16/4/16.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import "UIScrollView+Utils.h"

@implementation UIScrollView (Utils)

/// 结束上下拉刷新
- (void)endRefresh {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)endRefreshAndReloadData {
    [self endRefresh];
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        [tableView reloadData];
    }
}

/// 根据模型个数，来配置 暂无数据 的tipView;
- (void)configNoDataTipViewWithCount:(NSInteger)count {
    [self configNoDataTipViewWithCount:count tipText:@"暂无相关内容"];
}

- (void)configNoDataTipViewWithCount:(NSInteger)count tipText:(NSString *)tipText {
    if (count) {
        [self hideNoData];
    } else {
        [self showNoDataWithTipText:tipText];
    }
}

#pragma mark - 显示暂无数据

/// 显示无数据tipView
- (void)showNoData {
    [self showNoDataWithimageName:nil tipText:@"暂无相关内容"];
}

- (void)showNoDataWithTipText:(NSString *)tipText {
    [self showNoDataWithimageName:nil tipText:tipText];
}

/// 显示不固定的图片
- (void)showNoDataWithimageName:(NSString*)name tipText:(NSString *)tipText{
    
    [self hideNoData];
    
    NSString *imageName = name == nil ? @"nodata":name;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.tag = 1234;
    CGFloat imgViewY = 0;
    if (self.height < mScreenHeight - 64 - 49) {
        imgViewY = self.height / 2.0 - 60;
    } else {
        imgViewY = self.height / 2 - 110;
    }
    imgView.frame = CGRectMake(mScreenWidth / 2 - 80, imgViewY, 160, 160);
    imgView.contentMode = UIViewContentModeCenter;
    imgView.image = [UIImage imageNamed:imageName];
    [self addSubview:imgView];
    [self bringSubviewToFront:imgView];
    
    CGFloat labelY = CGRectGetMaxY(imgView.frame) - 60;
    UILabel *lable = [[UILabel alloc] init];
    lable.text = tipText;
    lable.tag = 12345;
    lable.frame = CGRectMake(30, labelY, mScreenWidth - 60, 30);
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = TZColorRGB(198);
    lable.font = [UIFont systemFontOfSize:16];
    [self addSubview:lable];
    [self bringSubviewToFront:lable];
}

/// 隐藏无数据tipView
- (void)hideNoData {
    if ([self viewWithTag:1234]) {
        [[self viewWithTag:1234] removeFromSuperview];
    }
    if ([self viewWithTag:12345]) {
        [[self viewWithTag:12345] removeFromSuperview];
    }
}

@end
