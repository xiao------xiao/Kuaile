//
//  XYCollectedJobViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/22.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCollectedJobViewController.h"
#import "XYJobCell.h"
#import "TZJobModel.h"
#import "TZJobDetailViewController.h"
@interface XYCollectedJobViewController ()

@end

@implementation XYCollectedJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    self.rightNavTitle = @"编辑";
    self.page = 1;
    [self loadNetworkData];
    [mNotificationCenter addObserver:self selector:@selector(loadNetworkData) name:@"collectDidChange" object:nil];
    
}

- (void)loadNetworkData {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = sessionId;
    params[@"page"] = @(self.page);
    NSString *API;
    if (self.type == XYCollectedJobViewControllerTypeApply) {   // 投递记录数据
        API = ApiPostLog;
    } else if (self.type == XYCollectedJobViewControllerTypeCollect) { // 收藏职位数据
        API = ApiViewFav;
    }
    __block NSArray *array = [NSArray array];
    [TZHttpTool postWithURL:API params:params success:^(NSDictionary *result) {
        NSDictionary *dict = result;
        if (self.type == XYCollectedJobViewControllerTypeCollect) {
            array = [TZJobModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"favorites"]];
        } else {
            array = [TZJobModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"result"]];
        }
        if (self.page == 1) [self.models removeAllObjects];
        [self.models addObjectsFromArray:array];
        if (self.models.count == 0) self.rightNavTitle = @"";
        self.totalPage = [result[@"data"][@"count_page"] integerValue];
        [self.tableView configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        if (self.models.count == 0) self.rightNavTitle = @"";
        [self.models removeAllObjects];
        [self.tableView configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    }];
    
}

// 删除投递记录&取消收藏
- (void)deleteDataWithRow:(NSInteger)deleteRow {
    TZJobModel *model = self.models[deleteRow];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *sessionid = [mUserDefaults objectForKey:@"sessionid"];
    params[@"sessionid"] = sessionid;
    if (self.type == XYCollectedJobViewControllerTypeApply) {
        params[@"deliver_id"] = model.deliver_id;
        [TZHttpTool postWithURL:ApiDeleteDeliverLog params:params success:^(NSDictionary *result) {
            [self showSuccessHUDWithStr:@"删除成功"];
            [self.models removeObject:model];
            [self.tableView reloadData];
            if (self.models.count == 0) {
                self.rightNavTitle = @"";
            }
            [self.tableView configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
        } failure:^(NSString *msg) {
            
        }];
    } else {
        params[@"recruit_id"] = model.recruit_id;
        [TZHttpTool postWithURL:ApiSnsDelFav params:params success:^(NSDictionary *result) {
             [self showSuccessHUDWithStr:@"取消成功"];
            [self.models removeObject:model];
            [self.tableView reloadData];
            if (self.models.count == 0) {
                self.rightNavTitle = @"";
            }
            [self.tableView configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
        } failure:^(NSString *msg) {
             
        }];
    }
}

- (void)configTableView {
    self.needRefresh = YES;
    [super configTableView];
    [self.tableView registerCellByNibName:@"XYJobCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark -- UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == XYCollectedJobViewControllerTypeCollect) {
        return 115;
    } else {
        return 130;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYJobCell"];
    if (self.type == XYCollectedJobViewControllerTypeCollect) {
        cell.timeLabelConstraint.constant = 0;
        cell.deleteBtnHConstraint.constant = 115;
        cell.deleteBtnWConstraint.constant = 100;
        [cell.deleteBtn setTitle:@"取消收藏" forState:0];
    } else {
        cell.deleteBtnHConstraint.constant = 130;
        cell.deleteBtnWConstraint.constant = 60;
        [cell.deleteBtn setTitle:@"删除" forState:0];
    }
    TZJobModel *model = self.models[indexPath.row];
    cell.model = model;
    [cell setDidClickDeleteBtnBlock:^{
        [self deleteDataWithRow:indexPath.row];
    }];
    [cell addBottomSeperatorViewWithHeight:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([self.title isEqualToString:@"职位收藏"]) {
        TZJobModel *model =self.models[indexPath.row];

        TZJobDetailViewController *jobVC = [[TZJobDetailViewController alloc] init];
        jobVC.recruit_id = model.recruit_id;
        [self.navigationController pushViewController:jobVC animated:YES];
    }
}

#pragma mark -- private

- (void)didClickRightNavAction {
    if ([self.rightNavTitle isEqualToString:@"编辑"]) {
//        [self.tableView setEditing:YES];
        for (TZJobModel *model in self.models) {
            model.edit = YES;
        }
        self.rightNavTitle = @"完成";
    } else if ([self.rightNavTitle isEqualToString:@"完成"]) {
        self.rightNavTitle = @"编辑";
//        [self.tableView setEditing:NO];
        for (TZJobModel *model in self.models) {
            model.edit = NO;
        }
    }
    [self.tableView reloadData];
}




@end
