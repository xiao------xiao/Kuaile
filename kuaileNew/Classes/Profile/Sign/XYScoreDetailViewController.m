//
//  XYScoreDetailViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/17.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYScoreDetailViewController.h"
#import "XYCommontView.h"
#import "XYScoreDetailCell.h"
#import "XYPointTaskModel.h"

@interface XYScoreDetailViewController (){
    NSArray *_models;
}

@property (nonatomic, strong) UILabel *covertLabel;

@end

@implementation XYScoreDetailViewController

- (UILabel *)covertLabel {
    if (_covertLabel == nil) {
        _covertLabel = [[UILabel alloc] init];
        _covertLabel.size = CGSizeMake(100, 21);
        _covertLabel.textAlignment = NSTextAlignmentRight;
        _covertLabel.font = [UIFont systemFontOfSize:13];
        _covertLabel.textColor = TZMainColor;
    }
    return _covertLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分明细";
    [self loadNetworkData];
}

- (void)loadNetworkData {
    NSString *sessionid = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiPointDetailList params:@{@"sessionid" : sessionid} success:^(NSDictionary *result) {
        _models = [XYPointDetailModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"content"]];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
    }];
}

- (void)configTableView {
    self.needRefresh = YES;
    self.tableViewStyle = UITableViewStyleGrouped;
    [super configTableView];
    self.tableView.rowHeight = 60;
    [self.tableView registerCellByNibName:@"XYScoreDetailCell"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XYCommontView *view = [[XYCommontView alloc] init];
    view.frontText = @"近2个月积分记录";
    view.fontSize = 14;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYScoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYScoreDetailCell"];
    cell.model = _models[indexPath.row];
    return cell;
}

@end
