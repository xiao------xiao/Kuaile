//
//  SingleTableViewController.h
//  ZYYAplicationDemo
//
//  Created by 一盘儿菜 on 16/5/5.
//  Copyright © 2016年 zyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZTableViewController : TZBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, assign) BOOL canEditRow;
@property (nonatomic, assign) BOOL notConfigTableViewRightAway;
/// UITableView的模型数组
@property (nonatomic, strong) NSMutableArray *models;
/// cell的间距，默认为0
@property (nonatomic, assign) NSInteger cellMargin;
@property (nonatomic, copy) NSArray *cellMargins;
/// 让第一个cell的间距是0
@property (nonatomic, assign) BOOL firstMarginZero;

- (void)prepareData  NS_REQUIRES_SUPER;
- (void)configTableView  NS_REQUIRES_SUPER;

/// 需要上下拉刷新
@property (nonatomic, assign) BOOL needRefresh;
/// 只需要下拉刷新
@property (nonatomic, assign) BOOL needHeaderRefresh;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;

- (void)refreshDataWithFooter;
- (void)refreshDataWithHeader;
- (void)loadNetworkData;
- (void)configRefresh;

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger section;


@end
