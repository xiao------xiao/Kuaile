//
//  XYJobCommentViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/5/18.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYJobCommentViewController.h"
#import "XYJobCommentModel.h"
#import "XYJobCommentCell.h"

@interface XYJobCommentViewController ()
@property (nonatomic, strong) NSMutableArray *jobComments;
@end

@implementation XYJobCommentViewController

- (NSMutableArray *)jobComments {
    if (_jobComments == nil) {
        _jobComments = [NSMutableArray array];
    }
    return _jobComments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职位评论";
    [self configTableView];
    [self loadNetworkData];
}

- (void)loadNetworkData {
    [TZHttpTool postWithURL:ApiJobCommentList params:@{@"recruit_id":self.recruit_id,@"page":@(self.page)} success:^(NSDictionary *result) {
        NSArray *array = [XYJobCommentModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"comment"]];
        self.totalPage = [result[@"data"][@"count_page"] integerValue];
        if (self.page == 1) [self.jobComments removeAllObjects];
        [self.jobComments addObjectsFromArray:array];
        [self.tableView configNoDataTipViewWithCount:self.jobComments.count tipText:@"暂无相关内容"];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
    }];
}

- (void)configTableView {
    self.needRefresh = YES;
    [super configTableView];
    [self.tableView registerCellByNibName:@"XYJobCommentCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark -- UITableViewDataSource & UItableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jobComments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYJobCommentModel *model = self.jobComments[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYJobCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYJobCommentCell"];
    XYJobCommentModel *model = self.jobComments[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addBottomSeperatorViewWithHeight:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)refreshDataWithHeader {
    [super refreshDataWithHeader];
}

- (void)refreshDataWithFooter {
    [super refreshDataWithFooter];
}

@end
