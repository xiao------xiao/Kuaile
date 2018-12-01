//
//  XYSalaryTableView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/28.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSalaryTableView.h"
#import "XYSalaryListCell.h"
#import "TZAddFrindTableView.h"
#import "XYSalaryListViewController.h"
#import "XYInComeModel.h"

@implementation XYSalaryTableView

- (instancetype)init {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYSalaryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYSalaryListCell"];
    XYInComeListModel *model = self.models[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDidClickCheckBtnBlock:^{
        XYSalaryListViewController *salaryListVc = [[XYSalaryListViewController alloc] init];
        salaryListVc.titleText = model.company;
        salaryListVc.ids = model.ids;
        [[UIViewController currentViewController].navigationController pushViewController:salaryListVc animated:YES];
        
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
