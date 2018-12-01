//
//  XYContactViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/6/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYContactViewController.h"
#import "XYContactModel.h"
#import "XYContactCell.h"

@interface XYContactViewController ()

@end

@implementation XYContactViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机通讯录";
    [self configTableView];
    [self loadNetworkData];
}

- (void)configTableView {
    self.needRefresh = NO;
    [super configTableView];
    [self.tableView registerCellByNibName:@"XYContactCell"];
    self.tableView.rowHeight = 70;
}

- (void)loadNetworkData {
    NSString *phone = [mUserDefaults objectForKey:@"phone"];
    if ([self.phoneStr isEqualToString:phone]) {
        self.models = [TZUserManager getUserContact];
        [self.tableView configNoDataTipViewWithCount:self.models.count tipText:@"暂无数据"];
        [self.tableView reloadData];
        return;
    }
    NSString *p = self.phoneStr;
    NSLog(@"%@",p);
    [mUserDefaults setObject:self.phoneStr forKey:@"phone"];
    [mUserDefaults synchronize];
    if (self.phoneStr == nil && self.phoneStr.length < 1) return;
    NSString *sessionid = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiGetContact params:@{@"mobiles":self.phoneStr,@"sessionid":sessionid} success:^(NSDictionary *result) {
        NSArray *array = [XYContactModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        BOOL needAdd = NO;
        for (XYContactModel *model in array) {
            for (NSDictionary *dict in self.contacts) {
                if ([dict[@"phone"] isEqualToString:model.mobile]) {
                    model.name = dict[@"name"];
                    needAdd = YES; break;
                }
            }
            if (needAdd) {
                [self.models addObject:model];
            }
        }
        if (self.models.count) {
            [TZUserManager syncUserContact:self.models];
        }
        [self.tableView configNoDataTipViewWithCount:self.models.count tipText:@"暂无数据"];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYContactModel *model = self.models[indexPath.row];
    XYContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYContactCell"];
    cell.model = model;
    if (model.is_attention.integerValue == 1) {
        cell.type = XYContactCellTypeAddDone;
    } else {
        cell.type = XYContactCellTypeAdd;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addBottomSeperatorViewWithHeight:1];
    MJWeakSelf
    [cell setDidClickAddBtnBlock:^{
        if (model.is_attention.integerValue == 1) {
            model.is_attention = @"0";
        } else {
            model.is_attention = @"1";
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        XYContactModel *model1 = model;
        [self.models replaceObjectAtIndex:indexPath.row withObject:model];
        [TZUserManager syncUserContact:self.models];
        [weakSelf checkAttentionStatusWithBuddyName:model.mobile];
    }];
    return cell;
}

- (void)checkAttentionStatusWithBuddyName:(NSString *)buddyName {
    if (buddyName && buddyName.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
        params[@"username"] = buddyName;
        [TZHttpTool postWithURL:ApiSnsConcernUser params:params success:^(NSDictionary *result) {
            [self showSuccessHUDWithStr:result[@"msg"]];
            [mNotificationCenter postNotificationName:@"didAddFriendNoti" object:nil];
            // 加好友添加积分
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"uid": userModel.uid }];
            RACSignal *sign = [ICEImporter addFriendsIntegralWithParams:params];
        } failure:^(NSString *msg) {
        }];
    }
}






@end
