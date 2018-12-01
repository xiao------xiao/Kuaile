//
//  XYScoreTaskViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/17.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYScoreTaskViewController.h"
#import "XYScoreTaskCell.h"
#import "XYCommontView.h"
#import "XYFundamentTabViewController.h"
#import "XYPointTaskModel.h"


@interface XYScoreTaskViewController (){
    NSArray *_dailyArr;
    NSMutableArray *_finishArr;
    NSArray *_memberArr;
}

@end

@implementation XYScoreTaskViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分任务";
    [self loadNetworkData];
}

- (void)loadNetworkData {
    NSString *sessionid = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiPointTaskList params:@{@"sessionid":sessionid} success:^(NSDictionary *result) {
        _dailyArr = [XYPointTaskSingleModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"daily"]];
        _finishArr = [NSMutableArray arrayWithArray:[XYPointTaskSingleModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"finish"]]];
        _memberArr = [XYPointTaskSingleModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"new_member"]];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
    }];
}

- (void)receiveTaskActionWithModel:(XYPointTaskSingleModel *)model {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    params[@"mid"] = @(model.mid.integerValue);
    [TZHttpTool postWithURL:ApiReceive params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"领取成功"];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        [TZUserManager syncUserModel];;
    } failure:^(NSString *msg) {
        [self showErrorHUDWithError:@"领取失败"];
    }];
}

- (void)configTableView {
    self.needRefresh = YES;
    self.tableViewStyle = UITableViewStyleGrouped;
    [super configTableView];
    self.tableView.rowHeight = 60;
    [self.tableView registerCellByNibName:@"XYScoreTaskCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _finishArr.count;
    } else if (section == 1) {
        return _dailyArr.count;
    } else {
        return _memberArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (_finishArr.count == 0) { return 0.0001;}
        else { return 34;}
    } else if (section == 1) {
        if (_dailyArr.count == 0) { return 0.0001;}
        else { return 34;}
    } else {
        if (_memberArr.count == 0) { return 0.0001; }
        else { return 34; }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XYCommontView *view = [[XYCommontView alloc] init];
    if (section == 0) {
        if (_finishArr.count) {
            view.frontText = @"完成任务";
        } else {
            view.frontText = @"";
        }
    } else if (section == 1) {
        if (_dailyArr.count) {
            view.frontText = @"每日任务";
        } else {
            view.frontText = @"";
        }
    } else {
        if (_dailyArr.count) {
            view.frontText = @"新手任务";
        } else {
            view.frontText = @"";
        }
    }
    view.fontSize = 14;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYScoreTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYScoreTaskCell"];
    if (indexPath.section == 0) {
        XYPointTaskSingleModel *model = _finishArr[indexPath.row];
        NSInteger isReceive = model.is_receive.integerValue;
        NSInteger status = model.is_finish.integerValue;
        if (isReceive == 1) { // 表示已经领取奖励
            cell.type = XYScoreTaskCellTypeButtonDone;
        } else if (status == 1 && isReceive != 1) {
            cell.type = XYScoreTaskCellTypeButton;
        }
        cell.model = model;
        MJWeakSelf
        [cell setReceiveRewardBlock:^{
            model.is_receive = @"1";
            [weakSelf receiveTaskActionWithModel:model];
        }];
    } else if (indexPath.section == 1) {
        XYPointTaskSingleModel *model = _dailyArr[indexPath.row];
        NSInteger isReceive = model.is_receive.integerValue;
        NSInteger status = model.is_finish.integerValue;
        if (isReceive == 1) { // 已经领取任务
            
        } else {
            cell.type = XYScoreTaskCellTypeLabe;
            NSString *title = [NSString stringWithFormat:@"%@/%@",model.finish_num,model.need_num];
            [cell.rewardBtn setTitle:title forState:UIControlStateNormal];
            cell.rewardBtn.enabled = NO;
        }
        cell.model = model;
    } else {
        XYPointTaskSingleModel *model = _memberArr[indexPath.row];
        NSInteger status = model.is_finish.integerValue;
        if (status == 1) {
            cell.type = XYScoreTaskCellTypeButtonDone;
        } else {
            cell.type = XYScoreTaskCellTypeButtonDoing;
        }
        cell.model = model;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





@end
