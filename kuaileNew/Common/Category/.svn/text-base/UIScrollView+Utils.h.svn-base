//
//  UIScrollView+Utils.h
//  刷刷
//
//  Created by 谭真 on 16/4/16.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Utils)

/// 结束上下拉刷新
- (void)endRefresh;
- (void)endRefreshAndReloadData;

/// 根据模型个数，来配置 暂无数据 的tipView;
- (void)configNoDataTipViewWithCount:(NSInteger)count;
- (void)configNoDataTipViewWithCount:(NSInteger)count tipText:(NSString *)tipText;

#pragma mark - 显示暂无数据

/// 显示无数据tipView
- (void)showNoData;
/// 显示无数据,有图片的
- (void)showNoDataWithimageName:(NSString*)name tipText:(NSString *)tipText;
/// 隐藏无数据tipView
- (void)hideNoData;

@end
