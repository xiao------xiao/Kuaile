//
//  SingleTableViewController.m
//  ZYYAplicationDemo
//
//  Created by 一盘儿菜 on 16/5/5.
//  Copyright © 2016年 zyy. All rights reserved.
//

#import "TZTableViewController.h"

@interface TZTableViewController ()

@end

@implementation TZTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.tableViewStyle) {
        self.tableViewStyle = UITableViewStylePlain;
    }
    [self prepareData];
    // 允许晚一会再配置tableView
    if (!self.notConfigTableViewRightAway) {
        [self configTableView];
    }
}

- (void)prepareData {
    self.models = [NSMutableArray array];
    self.cellMargin = 0;
    _page = 1;
    _totalPage = 1;
}

- (void)configTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, __kScreenWidth, __kScreenHeight - 64) style:self.tableViewStyle];
    [self.tableView registerCellByClassName:@"UITableViewCell"];
    self.tableView.backgroundColor = TZControllerBgColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    [self configRefresh];
}

- (void)configRefresh {
    if (self.needHeaderRefresh || self.needRefresh) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithHeader)];
        self.tableView.mj_header = header;
    }
    if (self.needRefresh) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithFooter)];
        self.tableView.mj_footer = footer;
    }
}

- (void)refreshDataWithFooter {
    _page ++;
    if (_page > _totalPage) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self loadNetworkData];
    }
}

- (void)refreshDataWithHeader {
    _page = 1;
    [self loadNetworkData];
}

- (void)loadNetworkData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView endRefresh];
    });
}

- (void)didUpdateMemberInfo {
    [super didUpdateMemberInfo];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSoure

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.cellMargins.count > section) {
        self.cellMargin = [self.cellMargins[section] integerValue];
    }
    if (section == 0) {
        return self.firstMarginZero ? 0 : self.cellMargin;
    }
    return self.cellMargin;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.canEditRow;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
