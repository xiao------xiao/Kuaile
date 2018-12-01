//
//  XYMoreFriendNotiController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYMoreFriendNotiController.h"
#import "TZAddFriendCell.h"
#import "XYRecommendFriendModel.h"
#import "XYGroupNewsCell.h"
#import "InvitationManager.h"
#import "ApplyViewController.h"
#import "ICESelfInfoViewController.h"

@interface XYMoreFriendNotiController ()
@property (nonatomic, strong) NSMutableArray *models;
@end

@implementation XYMoreFriendNotiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    if (self.type == XYMoreFriendNotiControllerTypeFriend) {
        self.title = @"更多好友通知";
        [self loadNetworkData];
    } else {
        self.title = @"更多群认证消息";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [mNotificationCenter postNotificationName:@"test" object:nil];
}

- (void)loadNetworkData {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiRecommendMoreFriendLists params:@{@"sessionid":sessionId,@"page":@(self.page)} success:^(NSDictionary *result) {
        if (self.page == 1) {
            [self.models removeAllObjects];
        }
        [self.models addObjectsFromArray:[XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"friend"]]];
        self.totalPage = [result[@"data"][@"count_page"] integerValue];
        [self.tableView configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
        [self.tableView configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
    }];
}

- (void)configTableView {
    if (self.type == XYMoreFriendNotiControllerTypeFriend) {
        self.needRefresh = YES;
    } else {
        self.needRefresh = NO;
    }
    [super configTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (self.type == XYMoreFriendNotiControllerTypeGroups) {
        self.tableView.rowHeight = 150;
        [self.tableView registerCellByNibName:@"XYGroupNewsCell"];
    } else {
        self.tableView.rowHeight = 60;
        [self.tableView registerCellByNibName:@"TZAddFriendCell"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == XYMoreFriendNotiControllerTypeFriend) {
        return self.models.count;
    } else {
        return self.addFriends.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == XYMoreFriendNotiControllerTypeFriend) {
        TZAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZAddFriendCell"];
        cell.moreView.hidden = YES;
        cell.timeLabel.hidden = YES;
        cell.distanceLabel.hidden = YES;
        XYRecommendFriendModel *notiModel = self.models[indexPath.row];
        cell.recommendFriendMode = notiModel;
        //    if (notiModel.isconcern) {
        cell.type = TZAddFriendCellTypeBothAttention;
        //    } else {
        //        cell.type = TZAddFriendCellTypeNoAttention;
        //    }
        //    [cell setDidAttentionBlock:^{
        //        //关注
        //    }];
        [cell addBottomSeperatorViewWithHeight:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        XYGroupNewsCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"XYGroupNewsCell"];
        ApplyEntity *entity = [self.addFriends objectAtIndex:indexPath.row];
        newCell.groupName.text = entity.groupSubject;
        //        NSString *strImg = [ApiTeamAvatar stringByAppendingString:group.groupId];
        [newCell.groupAvatar sd_setImageWithURL:TZImageUrlWithShortUrl(entity.avatar) placeholderImage:[UIImage imageNamed:@"groupPublicHeader"]];
        newCell.message.text = entity.reason;
        newCell.peopleName.text = entity.applicantUsername;
        
        [newCell setDoGroupNewsBlock:^(BOOL add){
            if (add) { // 添加
                [self applyCellAddFriendAtIndexPath:indexPath];
            } else { // 拒绝
                [self applyCellRefuseFriendAtIndexPath:indexPath];
            }
        }];
        newCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [newCell addBottomSeperatorViewWithHeight:1];
        return newCell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == XYMoreFriendNotiControllerTypeFriend) {

    XYRecommendFriendModel *model = self.models[indexPath.row];
    
    ICESelfInfoViewController *friendVc = [[ICESelfInfoViewController alloc] init];
    friendVc.type = ICESelfInfoViewControllerTypeOther;
    friendVc.otherUsername = model.username;
    friendVc.nickName = model.nickname;
    [self.navigationController pushViewController:friendVc animated:YES];
    }
}

#pragma mark - ApplyFriendCellDelegate

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.addFriends count]) {
        [mNotificationCenter postNotificationName:@"didHandleTheAppleNoti" object:nil];
        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
        
        ApplyEntity *entity = [self.addFriends objectAtIndex:indexPath.row];
        ApplyStyle applyStyle = [entity.style intValue];
        EMError *error;
        BOOL isSuccess=NO;
        
        /*if (applyStyle == ApplyStyleGroupInvitation) {
         [[EaseMob sharedInstance].chatManager acceptInvitationFromGroup:entity.groupId error:&error];
         }
         else */if (applyStyle == ApplyStyleJoinGroup)
         {
             [[EaseMob sharedInstance].chatManager acceptApplyJoinGroup:entity.groupId groupname:entity.groupSubject applicant:entity.applicantUsername error:&error];
         }
         else if(applyStyle == ApplyStyleFriend){
             isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:entity.applicantUsername error:&error];
         }
        if (!isSuccess) {
            NSLog(@"同意好友请求操作失败");
        }
        [self hideHud];
        if (!error) {
            [self.addFriends removeObject:entity];
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
            [self.tableView reloadData];
        }
        else{
            [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
}

- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.addFriends count]) {
        [mNotificationCenter postNotificationName:@"didHandleTheAppleNoti" object:nil];
        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
        ApplyEntity *entity = [self.addFriends objectAtIndex:indexPath.row];
        ApplyStyle applyStyle = [entity.style intValue];
        EMError *error;
        BOOL isSuccess=NO;
        if (applyStyle == ApplyStyleGroupInvitation) {
            [[EaseMob sharedInstance].chatManager rejectInvitationForGroup:entity.groupId toInviter:entity.applicantUsername reason:@""];
        }
        else if (applyStyle == ApplyStyleJoinGroup)
        {
            [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:entity.groupId groupname:entity.groupSubject toApplicant:entity.applicantUsername reason:nil];
        }
        else if(applyStyle == ApplyStyleFriend){
            isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:entity.applicantUsername reason:@"" error:&error];
        }
        if (!isSuccess) {
            NSLog(@"拒绝好友请求操作失败");
        }
        [self hideHud];
        if (!error) {
            [self.addFriends removeObject:entity];
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
            
            [self.tableView reloadData];
        }
        else{
            [self showHint:NSLocalizedString(@"rejectFail", @"reject failure")];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
}

- (void)refreshDataWithHeader {
    [super refreshDataWithHeader];
}

- (void)refreshDataWithFooter {
    [super refreshDataWithFooter];
}


@end
