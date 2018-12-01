//
//  XYCheckGroupMemberController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/4/21.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCheckGroupMemberController.h"
#import "XYGroupInfoModel.h"
#import "XYUserInfoModel.h"
#import "BaseTableViewCell.h"
#import "ICESelfInfoViewController.h"

@interface XYCheckGroupMemberController ()

@end

@implementation XYCheckGroupMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看群成员";
//    [self loadNetworkData];
}

//- (void)loadNetworkData {
//    if (!self.gid) return;
//    NSString *sessionid = [mUserDefaults objectForKey:@"sessionid"];
//    [TZHttpTool postWithURL:ApiSnsGetGroupAllMembers params:@{@"sessionid":sessionid,@"gid":self.gid} success:^(NSDictionary *result) {
//        self.models = [XYGroupMemberModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
//        [self.tableView reloadData];
//        [self.tableView endRefresh];
//    } failure:^(NSString *msg) {
//        [self.tableView endRefresh];
//    }];
//}

- (void)configTableView {
    self.needRefresh = NO;
    [super configTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerCellByClassName:@"BaseTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.models.count;
    return self.memberArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    XYGroupMemberModel *model = self.models[indexPath.row];
    XYUserInfoModel *model = self.memberArr[indexPath.row];
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseTableViewCell"];
    cell.imageView.layer.cornerRadius = 20;
    [cell.imageView sd_setImageWithURL:TZImageUrlWithShortUrl(model.avatar) placeholderImage:TZPlaceholderAvaterImage];
    cell.textLabel.text = model.nickname;
    [cell addBottomSeperatorViewWithHeight:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XYUserInfoModel *model = self.memberArr[indexPath.row];
    
    ICESelfInfoViewController *infoVc = [[ICESelfInfoViewController alloc] init];
    if ([[TZUserManager getUserModel].uid isEqualToString:model.uid]) {
        infoVc.type = ICESelfInfoViewControllerTypeSelf;
    } else {
        infoVc.type = ICESelfInfoViewControllerTypeOther;
        infoVc.otherUsername = model.username;
        infoVc.nickName = model.nickname;
    }
    [self.navigationController pushViewController:infoVc animated:YES];

}

@end
