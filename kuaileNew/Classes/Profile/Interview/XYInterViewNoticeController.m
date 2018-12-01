//
//  XYInterViewNoticeController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/20.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYInterViewNoticeController.h"
#import "TZOrderMessageCell.h"
#import "XYMessageModel.h"

@interface XYInterViewNoticeController ()

@end

@implementation XYInterViewNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    [self configTableView];
    [self loadNetworkData];
}

- (void)loadNetworkData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    if ([self.titleText isEqualToString:@"面试历史"]) {
        params[@"data_type"] = @"203";
    } else {
        params[@"data_type"] = @"201";
    }
    params[@"ban_mid"] = [ORParentModel getMids];
    [TZHttpTool postWithURL:ApiInterViewMessage params:params success:^(NSDictionary *result) {
        self.models = [XYMessageModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        [self.tableView configNoDataTipViewWithCount:self.models.count tipText:@"暂无通知"];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
    }];
}

- (void)configTableView {
    self.needRefresh = NO;
    [super configTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerCellByNibName:@"TZOrderMessageCell"];
    self.tableView.rowHeight = 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZOrderMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZOrderMessageCell"];
    XYMessageModel *model = self.models[indexPath.row];
    [cell loadModelData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
