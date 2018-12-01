//
//  XYSelfCareViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/9.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSelfCareViewController.h"
#import "TZAddFriendCell.h"
#import "XYRecommendFriendModel.h"

@interface XYSelfCareViewController ()

@end

@implementation XYSelfCareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.type.integerValue == 1 ? @"关注的人" : @"我的粉丝";
    self.page = 1;
    [self loadNetworkData];
}

- (void)loadNetworkData {
    NSString *sessionid = [mUserDefaults objectForKey:@"sessionid"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = sessionid;
    params[@"type"] = self.type;
    params[@"page"] = @(self.page);
    [TZHttpTool postWithURL:ApiAttentionList params:params success:^(NSDictionary *result) {
        NSArray *array = [XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"friend"]];
        self.totalPage = [result[@"data"][@"count_page"] integerValue];
        if (self.page == 1) {
            [self.models removeAllObjects];
        }
        [self.models addObjectsFromArray:array];
        [self.tableView configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
        [self.tableView endRefresh];
    }];
}

- (void)configTableView {
    self.needRefresh = YES;
    [super configTableView];
    self.tableView.rowHeight = 70;
    [self.tableView registerCellByNibName:@"TZAddFriendCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZAddFriendCell"];
    cell.recommendFriendMode = self.models[indexPath.row];
    cell.moreView.hidden = YES;
    cell.timeLabel.hidden = YES;
    cell.fromLabel.hidden = YES;
    cell.distanceLabel.hidden = YES;
    cell.type = TZAddFriendCellTypeBothAttention;
    [cell addBottomSeperatorViewWithHeight:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshDataWithHeader {
    [super refreshDataWithHeader];
}

- (void)refreshDataWithFooter {
    [super refreshDataWithFooter];
}


@end
