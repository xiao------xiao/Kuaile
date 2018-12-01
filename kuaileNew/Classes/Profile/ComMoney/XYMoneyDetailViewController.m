//
//  XYMoneyDetailViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/24.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYMoneyDetailViewController.h"
#import "XYMoneyDetailCell.h"
#import "XYDetailListCell.h"
#import "XYMoneyDetailModel.h"

@interface XYMoneyDetailViewController ()


@end

@implementation XYMoneyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佣金明细";
    [self loadNetworkData];
}


- (void)loadNetworkData {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiCommissionLog params:@{@"sessionid" : sessionId} success:^(NSDictionary *result) {
        self.models = [XYMoneyDetailModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        [self.tableView configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
        [self.tableView configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
    }];
}

- (void)configTableView {
    self.needRefresh = NO;
    [super configTableView];
    [self.tableView registerCellByClassName:@"XYDetailListCell"];
    [self.tableView registerCellByNibName:@"XYMoneyDetailCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        XYDetailListCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
        headerCell.text = @"日期";
        headerCell.subText = @"金额";
        headerCell.more.hidden = YES;
        headerCell.labelTextColor = TZColor(6, 191, 252);
        headerCell.subLabelTextColor = TZColor(6, 191, 252);
        headerCell.labelX = 8;
        headerCell.hideMoreView = YES;
        [headerCell addBottomSeperatorViewWithHeight:1];
        return headerCell;
    } else {
        XYMoneyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYMoneyDetailCell"];
        XYMoneyDetailModel *model = self.models[indexPath.row - 1];
        cell.model = model;
        [cell addBottomSeperatorViewWithHeight:1];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
