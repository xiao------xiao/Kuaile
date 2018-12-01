//
//  XYSalaryDetailViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/28.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSalaryDetailViewController.h"
#import "XYDetailListCell.h"
#import "XYCheckMoreCell.h"
#import "XYMoreSalaryDetailViewController.h"
#import "XYSalaryDetailModel.h"

@interface XYSalaryDetailViewController (){
    NSArray *_titles;
//    NSArray *_subTitles;
    
}

@property (nonatomic, strong) XYSalaryDetailModel *model;

@end

@implementation XYSalaryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    [self loadDefaultSettingData];
    [self loadNetworkData];
}

- (void)loadNetworkData {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiSalaryList3 params:@{@"id" : self.id,@"sessionid":sessionId} success:^(NSDictionary *result) {
        _model = [XYSalaryDetailModel mj_objectWithKeyValues:result[@"data"]];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
        [self showErrorHUDWithError:msg];
    }];
}

- (void)loadDefaultSettingData {
    _titles = @[@"公司名称",@"工资月份",@"工号",@"姓名",@"身份证号",@"应发合计",@"扣款合计",@"实发合计"];
//    _subTitles = @[@"上海通渔信息科技有限公司",@"2017年1月",@"20122330902",@"赵四",@"425294479269464",@"4000",@"3393",@"74",@"4373"];
}

- (void)configTableView {
    self.needRefresh = NO;
    [super configTableView];
    [self.tableView registerCellByClassName:@"XYDetailListCell"];
    [self.tableView registerCellByClassName:@"XYCheckMoreCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _titles.count) {
        XYCheckMoreCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"XYCheckMoreCell"];
        [moreCell.button setTitle:@"点击查看详情" forState:0];
        CGFloat checkFont = 17;
        if (mScreenWidth < 375) checkFont = 15;
        moreCell.button.titleLabel.font = [UIFont systemFontOfSize:checkFont];
        [moreCell setDidClickBtnBlock:^{
            XYMoreSalaryDetailViewController *moreDetailVc = [[XYMoreSalaryDetailViewController alloc] init];
            moreDetailVc.model = _model;
            moreDetailVc.titleText = self.titleText;
            [self.navigationController pushViewController:moreDetailVc animated:YES];
        }];
        return moreCell;
    } else {
        XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
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
        cell.more.hidden = YES;
        CGFloat cellFont = 17;
        if (mScreenWidth < 375) cellFont = 15;
        cell.labelFont = cellFont;
        cell.subLabelFont = cellFont;
        [cell addBottomSeperatorViewWithHeight:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == _titles.count) {
//        XYMoreSalaryDetailViewController *moreDetailVc = [[XYMoreSalaryDetailViewController alloc] init];
//        [self.navigationController pushViewController:moreDetailVc animated:YES];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
