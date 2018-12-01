//
//  TZSegmentTableViewController.m
//  yishipi
//
//  Created by ttouch on 16/9/26.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "TZSegmentTableViewController.h"

@interface TZSegmentTableViewController ()

@end

@implementation TZSegmentTableViewController

- (void)viewDidLoad {
    self.notConfigTableViewRightAway = YES;
    [super viewDidLoad];
    self.models2 = [NSMutableArray array];
    
    [self configScrollView];
    [self configTableView2];
}

#pragma mark - ConfigUI

- (void)setSegmentTitles:(NSArray *)segmentTitles {
    _segmentTitles = segmentTitles;
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:segmentTitles];
        _segmentControl.tintColor = TZMainColor;
        _segmentControl.selectedSegmentIndex = 0;
        _segmentControl.frame = CGRectMake(80, 8, mScreenWidth - 160, 30);
        [_segmentControl addTarget:self action:@selector(didSegmentControlValueChange:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = _segmentControl;
    }
}

- (void)configScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(__kScreenWidth * 2, 0);
    [self.view addSubview:_scrollView];
}

- (void)configTableView2 {
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, __kScreenWidth, __kScreenHeight - 64 - 49);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView  = [UIView new];
    self.tableView.backgroundColor = TZControllerBgColor;
    [self.scrollView addSubview:self.tableView];
    [self configRefresh];
    
    self.tableView2 = [[UITableView alloc] init];
    self.tableView2.frame = CGRectMake(__kScreenWidth, 0, __kScreenWidth, __kScreenHeight - 64 - 49);
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView2.tableFooterView = [UIView new];
    self.tableView2.backgroundColor = TZControllerBgColor;
    [self.scrollView addSubview:self.tableView2];
    [self configRefres2];
}

- (void)configRefres2 {
    if (self.needHeaderRefresh2 || self.needRefresh2) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithHeader2)];
        self.tableView2.mj_header = header;
    }
    if (self.needRefresh2) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithFooter2)];
        self.tableView2.mj_footer = footer;
    }
}

- (void)refreshDataWithFooter2 {
    _page2 ++;
    if (_page2 > _totalPage2) {
        [self.tableView2.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self loadNetworkData2];
    }
}

- (void)refreshDataWithHeader2 {
    _page2 = 1;
    [self loadNetworkData2];
}

- (void)loadNetworkData2 {
    
}

#pragma mark - UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView == self.tableView ? self.models.count : self.models2.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        if (offsetX > __kScreenWidth / 2) {
            _segmentControl.selectedSegmentIndex = 1;
        } else {
            _segmentControl.selectedSegmentIndex = 0;
        }
        [self didSegmentControlValueChange:_segmentControl];
    }
}

/// segmentcontrol值改变事件
- (void)didSegmentControlValueChange:(UISegmentedControl*)segmentControl {
    if (segmentControl.selectedSegmentIndex == 0) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        if (!self.models.count) {
            [self loadNetworkData];
        }
    } else if (segmentControl.selectedSegmentIndex == 1) {
        [_scrollView setContentOffset:CGPointMake(__kScreenWidth, 0) animated:YES];
        if (!self.models2.count) {
            [self loadNetworkData2];
        }
    }
}

@end
