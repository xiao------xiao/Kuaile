//
//  ICEMoneyDetailViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICEMoneyDetailViewController.h"
#import "ICEMoneyTableViewCell.h"
#import "ICEModelMoney.h"

@interface ICEMoneyDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *cellDataArray;
@end

@implementation ICEMoneyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佣金明细";
    [self configTableView];
    [self loadNetWorkData:NO];
}

- (NSMutableArray *)cellDataArray {
    if (_cellDataArray == nil) {
        _cellDataArray = [[NSMutableArray alloc] init];
    }
    return _cellDataArray;
}

// 网络数据，请求网络
- (void)loadNetWorkData:(BOOL)isUp {
    RACSignal *sign = [ICEImporter commissionLog];
    [sign subscribeNext:^(id x) {
        self.cellDataArray = [ICEModelMoney mj_objectArrayWithKeyValuesArray:x[@"data"]];
        [self.tableView reloadData];
    }];
}

- (void)configTableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 34;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"iCEMoneyTableViewCell";
    ICEMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEMoneyTableViewCell" owner:self options:nil] lastObject];
    }
    [cell loadDataWith:_cellDataArray[indexPath.row]];
    return cell;
}

@end
