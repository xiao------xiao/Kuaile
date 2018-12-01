/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ApplyViewController.h"

#import "ApplyFriendCell.h"
#import "InvitationManager.h"
#import "TZAddFriendCell.h"
#import "XYCheckMoreCell.h"
#import "XYNewFriendDetailController.h"
#import "XYRecommendFriendModel.h"
#import "XYMoreFriendNotiController.h"
#import "ICESelfInfoViewController.h"
#import "TZAddFriendController.h"

static ApplyViewController *controller = nil;

/// 这个控制器居然是个单例...
@interface ApplyViewController ()<ApplyFriendCellDelegate,UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_resultEntities;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *noticeFriendLists;
@property (nonatomic, strong) NSArray *recommendFriendLists;
@property (nonatomic, strong) NSMutableArray *showAddFriends;
@property (nonatomic, strong) NSMutableArray *addedFriends;
@property (nonatomic, strong) NSArray *subAddFriends;
@end

@implementation ApplyViewController

- (NSMutableArray *)showAddFriends {
    if (_showAddFriends == nil) {
        _showAddFriends = [NSMutableArray array];
    }
    return _showAddFriends;
}

+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] init];
    });
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    self.title = NSLocalizedString(@"新的朋友", @"新的朋友");
    self.rightNavImageName = @"jiahao";

    [self configTableView];
    [self loadDataSourceFromLocalDB];
    [self loadFriendsData];
}

- (void)didClickRightNavAction {
    TZAddFriendController *vc = [TZAddFriendController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)configTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerCellByNibName:@"TZAddFriendCell"];
    [self.tableView registerCellByClassName:@"XYCheckMoreCell"];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    _resultEntities = [NSMutableArray array];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_resultEntities.count) {
        [self.dataSource removeObjectsInArray:_resultEntities];
        NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
        for (ApplyEntity *entity in _resultEntities) {
            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
        }
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
    }
}


- (void)loadFriendsData {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiRecommendNewFriendLists params:@{@"sessionid" : sessionId} success:^(NSDictionary *result) {
        self.noticeFriendLists = [XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"notice"]];
        self.recommendFriendLists = [XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"recommend"]];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
    }];
}

#pragma mark - getter

- (NSMutableArray *)addedFriends {
    if (_addedFriends == nil) {
        _addedFriends = [NSMutableArray array];
    }
    return _addedFriends;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSString *)loginUsername
{
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    return [loginInfo objectForKey:kSDKUsername];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.noticeFriendLists.count) {
            return 30;
        } else {
            return 0.00001;
        }
    } else {
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.noticeFriendLists.count >= 3 ? 4 : self.noticeFriendLists.count;
    } else {
        return self.recommendFriendLists.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = TZColorRGB(246);
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = TZColorRGB(152);
    label.textAlignment = NSTextAlignmentLeft;
    if (section == 0) {
        if (self.noticeFriendLists.count) {
            label.text = @"  好友通知";
            return label;
        } else {
            return nil;
        }
    } else {
        label.text = @"  好友推荐";
        return label;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"ApplyFriendCell";
//    ApplyFriendCell *cell = (ApplyFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    // Configure the cell...
//    if (cell == nil) {
//        cell = [[ApplyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.delegate = self;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    cell.addButton.hidden = NO;
//    cell.refuseButton.hidden = NO;
//
//    if(self.dataSource.count > indexPath.row)
//    {
//        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
//        entity.showApplicationUsername = entity.applicantUsername;
//        if (entity.applicantUsername.length == 11) {
//            NSString *phone = entity.applicantUsername;
//            entity.showApplicationUsername = [NSString stringWithFormat:@"%@****%@",[phone substringToIndex:3],[phone substringFromIndex:7]];
//        }
//        
//        if (entity) {
//            cell.indexPath = indexPath;
//            ApplyStyle applyStyle = [entity.style intValue];
//            if (applyStyle == ApplyStyleGroupInvitation) {
//                cell.titleLabel.text = NSLocalizedString(@"title.groupApply", @"Group Notification");
//                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
//            }
//            else if (applyStyle == ApplyStyleJoinGroup)
//            {
//                cell.titleLabel.text = NSLocalizedString(@"title.groupApply", @"Group Notification");
//                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
//            }
//            else if(applyStyle == ApplyStyleFriend){
//                cell.titleLabel.text = entity.applicantNick ? entity.applicantNick : entity.showApplicationUsername;
//                [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:entity.avatar] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
//            } else {
//                cell.titleLabel.text = entity.applicantNick ? entity.applicantNick : entity.showApplicationUsername;
//                [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:entity.avatar] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
//                cell.addButton.hidden = YES;
//                cell.refuseButton.hidden = YES;
//                if (![_resultEntities containsObject:entity]) {
//                    [_resultEntities addObject:entity];
//                }
//            }
//            cell.contentLabel.text = entity.reason;
//        }
//    }
//    return cell;

    if (indexPath.section == 0 && indexPath.row == 3) {
        XYCheckMoreCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"XYCheckMoreCell"];
        moreCell.button.titleLabel.font = [UIFont systemFontOfSize:14];
        [moreCell setDidClickBtnBlock:^{
            XYMoreFriendNotiController *moreNotiVc = [[XYMoreFriendNotiController alloc] init];
            moreNotiVc.type == XYMoreFriendNotiControllerTypeFriend;
//            moreNotiVc.addFriends = self.subAddFriends;
            [self.navigationController pushViewController:moreNotiVc animated:YES];
        }];
        [moreCell configButtonWithImg:@"genduo" text:@"查看更多"];
        moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return moreCell;
  
    } else {
        TZAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZAddFriendCell"];
        cell.moreView.hidden = YES;
        cell.timeLabel.hidden = YES;
        cell.distanceLabel.hidden = YES;
        if (indexPath.section == 0) { // 通知
            XYRecommendFriendModel *notiModel = self.noticeFriendLists[indexPath.row];
            cell.recommendFriendMode = notiModel;
            cell.type = TZAddFriendCellTypeBothAttention;
        } else { // 推荐
            XYRecommendFriendModel *recommendModel = self.recommendFriendLists[indexPath.row];
            cell.recommendFriendMode = recommendModel;
            if (recommendModel.isconcern) {
                cell.type = TZAddFriendCellTypeBothAttention;
            }else {
                cell.type = TZAddFriendCellTypeNoAttention;
            }
            [cell setDidAttentionBlock:^{ //关注
                recommendModel.isconcern = !recommendModel.isconcern;
                [self checkAttentionStatusWithBuddyName:recommendModel.username];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }
        
        [cell addBottomSeperatorViewWithHeight:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
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
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            return 35;
        } else {
            return 64;
        }
    } else {
        return 64;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row < 3) {
            XYRecommendFriendModel *model = self.noticeFriendLists[indexPath.row];

            ICESelfInfoViewController *friendVc = [[ICESelfInfoViewController alloc] init];
            friendVc.type = ICESelfInfoViewControllerTypeOther;
            friendVc.otherUsername = model.username;
            friendVc.nickName = model.nickname;
            [self.navigationController pushViewController:friendVc animated:YES];
        }
    } else {
        ICESelfInfoViewController *friendVc = [[ICESelfInfoViewController alloc] init];
        MJWeakSelf
        friendVc.addBlock = ^(BOOL isadd) {
            XYRecommendFriendModel *model = self.recommendFriendLists[indexPath.row];
            model.isconcern = isadd;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [mNotificationCenter postNotificationName:@"didAddFriendNoti" object:nil];

        };
        friendVc.type = ICESelfInfoViewControllerTypeOther;
        XYRecommendFriendModel *remodel = self.recommendFriendLists[indexPath.row];
        friendVc.otherUsername = remodel.username;
        friendVc.nickName = remodel.nickname;
        [self.navigationController pushViewController:friendVc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark --- 改为调用后台接口
// 已经添加自己的人
//- (void)didAddNewApply:(XYRecommendFriendModel *)friendModel {
//    [self.addedFriends addObject:friendModel];
//    NSInteger count = self.addedFriends.count > 5 ? 5 : self.addedFriends.count;
//    for (int i = 0; i < count; i++) {
//        XYRecommendFriendModel *model = self.addedFriends[i];
//        [self.showAddFriends addObject:model];
//    }
//    if (self.addedFriends.count > 20) {
//        NSArray *allAddFriends = [NSArray arrayWithArray:self.addedFriends];
//        self.subAddFriends = [allAddFriends subarrayWithRange:NSMakeRange(0, 19)];
//    }
//}

#pragma notice  ---- 因为不需要用户处理好友申请，所以不需要下面的方法了
//#pragma mark - ApplyFriendCellDelegate
//
//- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row < [self.dataSource count]) {
//        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
//        
//        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
//        ApplyStyle applyStyle = [entity.style intValue];
//        EMError *error;
//        BOOL isSuccess;
//        
//        /*if (applyStyle == ApplyStyleGroupInvitation) {
//            [[EaseMob sharedInstance].chatManager acceptInvitationFromGroup:entity.groupId error:&error];
//        }
//        else */if (applyStyle == ApplyStyleJoinGroup)
//        {
//            [[EaseMob sharedInstance].chatManager acceptApplyJoinGroup:entity.groupId groupname:entity.groupSubject applicant:entity.applicantUsername error:&error];
//        }
//        else if(applyStyle == ApplyStyleFriend){
//           isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:entity.applicantUsername error:&error];
//        }
//        if (!isSuccess) {
//            NSLog(@"同意好友请求操作失败");
//        }
//        [self hideHud];
//        if (!error) {
//            [self.dataSource removeObject:entity];
//            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
//            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
//            [self.tableView reloadData];
//        }
//        else{
//            [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
//        }
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
//}

//- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row < [self.dataSource count]) {
//        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
//        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
//        ApplyStyle applyStyle = [entity.style intValue];
//        EMError *error;
//        BOOL isSuccess;
//        if (applyStyle == ApplyStyleGroupInvitation) {
//            [[EaseMob sharedInstance].chatManager rejectInvitationForGroup:entity.groupId toInviter:entity.applicantUsername reason:@""];
//        }
//        else if (applyStyle == ApplyStyleJoinGroup)
//        {
//            [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:entity.groupId groupname:entity.groupSubject toApplicant:entity.applicantUsername reason:nil];
//        }
//        else if(applyStyle == ApplyStyleFriend){
//            isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:entity.applicantUsername reason:@"" error:&error];
//        }
//        if (!isSuccess) {
//            NSLog(@"拒绝好友请求操作失败");
//        }
//        [self hideHud];
//        if (!error) {
//            [self.dataSource removeObject:entity];
//            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
//            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
//            
//            [self.tableView reloadData];
//        }
//        else{
//            [self showHint:NSLocalizedString(@"rejectFail", @"reject failure")];
//        }
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
//}

#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{
    NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (dictionary && [dictionary count] > 0) {
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        ApplyStyle style = [[dictionary objectForKey:@"applyStyle"] intValue];
        
        if (applyUsername && applyUsername.length > 0) {
            for (int i = ((int)[_dataSource count] - 1); i >= 0; i--) {
                ApplyEntity *oldEntity = [_dataSource objectAtIndex:i];
                ApplyStyle oldStyle = [oldEntity.style intValue];
                // 已存在该条申请，覆盖并拿到最前面来
                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername]) {
                    if(style != ApplyStyleFriend || style!= ApplyStyleFriendResult)
                    {
                        NSString *newGroupid = [dictionary objectForKey:@"groupname"];
                        if (newGroupid || [newGroupid length] > 0 || [newGroupid isEqualToString:oldEntity.groupId]) {
                            break;
                        }
                    }
                    oldEntity.reason = [dictionary objectForKey:@"applyMessage"];
                    if ([dictionary objectForKey:@"avatar"]) {
                        oldEntity.avatar = dictionary[@"avatar"];
                    }
                    [[InvitationManager sharedInstance] removeInvitation:oldEntity loginUser:loginUsername];
                    [_dataSource removeObject:oldEntity];
                    [_dataSource insertObject:oldEntity atIndex:0];
                    [[InvitationManager sharedInstance] addInvitation:oldEntity loginUser:loginUsername];
                    [self.tableView reloadData];
                    return;
                }
            }
            
            // 新的申请
            ApplyEntity * newEntity= [[ApplyEntity alloc] init];
            newEntity.applicantUsername = [dictionary objectForKey:@"username"];
            newEntity.style = [dictionary objectForKey:@"applyStyle"];
            newEntity.reason = [dictionary objectForKey:@"applyMessage"];
            
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginName = [loginInfo objectForKey:kSDKUsername];
            newEntity.receiverUsername = loginName;
            
            NSString *groupId = [dictionary objectForKey:@"groupId"];
            newEntity.groupId = (groupId && groupId.length > 0) ? groupId : @"";
            if ([dictionary objectForKey:@"avatar"]) {
                newEntity.avatar = dictionary[@"avatar"];
            }
            NSString *groupSubject = [dictionary objectForKey:@"groupname"];
            newEntity.groupSubject = (groupSubject && groupSubject.length > 0) ? groupSubject : @"";
            
            [[InvitationManager sharedInstance] addInvitation:newEntity loginUser:loginUsername];
            
            [_dataSource insertObject:newEntity atIndex:0];
            [self.tableView reloadData];
        }
    }
}

- (void)loadDataSourceFromLocalDB
{
    [_dataSource removeAllObjects];
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginName = [loginInfo objectForKey:kSDKUsername];
    if(loginName && [loginName length] > 0)
    {
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        [self.dataSource addObjectsFromArray:applyArray];
        
        [self.tableView reloadData];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)clear
{
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
}

@end
