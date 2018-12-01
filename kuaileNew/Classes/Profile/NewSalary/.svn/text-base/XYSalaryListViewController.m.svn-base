//
//  XYSalaryDetailViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/28.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSalaryListViewController.h"
#import "XYDetailListCell.h"
#import "XYSalaryDetailViewController.h"
#import "XYSalaryListModel.h"


@interface XYSalaryListViewController ()
@property (nonatomic, strong) NSArray *models;
@end

@implementation XYSalaryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    [self loadNetworkData];
}

- (void)loadNetworkData {
    [TZHttpTool postWithURL:ApiSalaryList2 params:@{@"ids":self.ids} success:^(NSDictionary *result) {
        self.models = [XYSalaryListModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
        [self showErrorHUDWithError:msg];
    }];
}

- (void)configTableView {
    self.needRefresh = YES;
    [super configTableView];
    self.tableView.rowHeight = 50;
    [self.tableView registerCellByClassName:@"XYDetailListCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
    XYSalaryListModel *model = self.models[indexPath.row];
    cell.subLabel.hidden = YES;
    NSString *str = [NSString stringWithFormat:@"%@ 薪资",model.salary_month];
    cell.text = str;
    cell.labelX = 12;
    cell.labelFont = 17;
    if (mScreenWidth < 375) cell.labelFont = 15;
    [cell addBottomSeperatorViewWithHeight:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XYSalaryDetailViewController *salaryDetailVc = [[XYSalaryDetailViewController alloc] init];
    XYSalaryListModel *model = self.models[indexPath.row];
    salaryDetailVc.titleText = [NSString stringWithFormat:@"%@ 薪资",model.salary_month];
    salaryDetailVc.id = model.ID;
    [self.navigationController pushViewController:salaryDetailVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end
