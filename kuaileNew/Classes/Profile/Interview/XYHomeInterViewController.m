//
//  XYHomeInterViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/20.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYHomeInterViewController.h"
#import "ChatListCell.h"
#import "XYInterViewNoticeController.h"
#import "XYMessageModel.h"

@interface XYHomeInterViewController ()
@property (nonatomic, strong) XYMessageModel *firstInterViewModel;
@property (nonatomic, strong) XYMessageModel *firstNotiModel;
@end

@implementation XYHomeInterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作面试";
    [self loadNetworkData];
}

- (void)loadNetworkData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    params[@"ban_mid"] = [ORParentModel getMids];
    params[@"data_type"] = @"201,203";
    [TZHttpTool postWithURL:ApiInterViewMessage params:params success:^(NSDictionary *result) {
        self.models = [XYMessageModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        for (int i = 0; i < self.models.count; i++) {
            XYMessageModel *model = self.models[i];
            if ([model.data_type isEqualToString:@"203"]) { // 面试历史
                self.firstInterViewModel = model;
            } else if ([model.data_type isEqualToString:@"201"]) { // 工作通知
                self.firstNotiModel = model;
            }
        }
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
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerCellByClassName:@"ChatListCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatListCell"];
    cell.placeholderImage = [UIImage imageNamed:@[@"文本",@"个人"][indexPath.row]];
    if (indexPath.row == 0) {
        cell.detailMsg = self.firstNotiModel.content;
        cell.time = self.firstNotiModel.time;
    } else {
        cell.detailMsg = self.firstInterViewModel.content;
        cell.time = self.firstInterViewModel.time;
    }
    cell.name = @[@"录用通知",@"面试历史"][indexPath.row];
    cell.isSystemCell = YES;
    [cell addBottomSeperatorViewWithHeight:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self pushXYInterViewNoticeControllerWithTitle:@"录用通知"];
    } else {
        [self pushXYInterViewNoticeControllerWithTitle:@"面试历史"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)pushXYInterViewNoticeControllerWithTitle:(NSString *)title {
    XYInterViewNoticeController *noticeVc = [[XYInterViewNoticeController alloc] init];
    noticeVc.titleText = title;
    [self.navigationController pushViewController:noticeVc animated:YES];
}



@end
