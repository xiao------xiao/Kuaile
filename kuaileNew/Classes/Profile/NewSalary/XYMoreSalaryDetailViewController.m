//
//  XYMoreSalaryDetailViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/28.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYMoreSalaryDetailViewController.h"
#import "XYDetailListCell.h"
#import "XYSalaryDetailModel.h"

@interface XYMoreSalaryDetailViewController (){
    NSArray *_titles;

}

@end

@implementation XYMoreSalaryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    [self loadDefaultSettingData];
}

- (void)loadDefaultSettingData {
//    _titles = @[@"公司名称",@"工资月份",@"工        号",@"姓         名",@"身份证号",@"基本工资",@"应发合计",@"扣款合计",@"实发合计",@"年    奖",@"全  勤  奖",@"补贴合计",@"交通补贴",@"住房补贴",@"加班合计",@"中夜班费",@"奖       金",@"季  度   奖",@"年  终  奖"];
    
    _titles = @[@"公司名称",@"工资月份",@"工号",@"姓名",@"身份证号",@"应发合计",@"扣款合计",@"实发合计"];
    [self.tableView reloadData];
}

- (void)configTableView {
    self.needRefresh = NO;
    [super configTableView];
    [self.tableView registerCellByClassName:@"XYDetailListCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count + self.model.extra_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
    if (indexPath.row < _titles.count) {
        cell.text = _titles[indexPath.row];
        NSString *text;
        if (indexPath.row == 0) {
            text = _model.company_name;
        } else if (indexPath.row == 1) {
            text = _model.salary_month;
        } else if (indexPath.row == 2) {
            text = _model.job_number;
        } else if (indexPath.row == 3) {
            text = _model.name;
        } else if (indexPath.row == 4) {
            text = _model.id_number;
        } else if (indexPath.row == 5) {
            text = _model.really_salary;
        } else if (indexPath.row == 6) {
            text = _model.should_salary;
        } else {
            text = _model.withhold_count;
        }
        cell.subText = text;
    } else {
        if (self.model.extra_data.count > 0) {
            XYSalaryDetailExtraModel *extraModel = _model.extra_data[indexPath.row - _titles.count];
            cell.text = extraModel.key;
            cell.subText = extraModel.value;
        }
    }
    cell.more.hidden = YES;
    cell.subLabelX = mScreenWidth * 0.4;
    CGFloat cellFont = 17;
    if (mScreenWidth < 375) cellFont = 15;
    cell.labelFont = cellFont;
    cell.subLabelFont = cellFont;
    [cell addBottomSeperatorViewWithHeight:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end
