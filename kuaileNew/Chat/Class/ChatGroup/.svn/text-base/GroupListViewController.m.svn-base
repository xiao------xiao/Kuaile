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

#import "GroupListViewController.h"

#import "EMSearchBar.h"
#import "SRRefreshView.h"
#import "BaseTableViewCell.h"
#import "EMSearchDisplayController.h"
#import "ChatViewController.h"
#import "PublicGroupListViewController.h"
#import "RealtimeSearchUtil.h"
#import "UIViewController+HUD.h"
#import "XYGroupCell.h"
#import "XYGroupInfoModel.h"
#import "ICECreateGroupViewController.h"
#import "XYGroupInfoViewController.h"
#import "XYGroupNewsCell.h"
#import "InvitationManager.h"
#import "ApplyViewController.h"
#import "XYCheckMoreCell.h"
#import "XYMoreFriendNotiController.h"


@interface GroupListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, IChatManagerDelegate, SRRefreshDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *groupNews;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) NSMutableArray *applyGroups;

@end


@implementation XYGroupInfoModel (search)

// 根据用户昵称进行搜索
- (NSString*)groupSubject {
    return self.owner;
}

@end


@implementation GroupListViewController

- (NSMutableArray *)applyGroups {
    if (_applyGroups == nil) {
        _applyGroups = [NSMutableArray array];
    }
    return _applyGroups;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = TZControllerBgColor;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    _groups = [NSMutableArray array];
    self.title = NSLocalizedString(@"群聊", @"群聊");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jiahao"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick)];
    
#warning 把self注册为SDK的delegate
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [self configTableView];
    [self searchController];
    [self getApplyEmtities];
//    [self loadGroupsDataSource];
    [self reloadDataSource];
//    didDismissGroupNoti
    [mNotificationCenter addObserver:self selector:@selector(didDismissGroup) name:@"didDismissGroupNoti" object:nil];
    [mNotificationCenter addObserver:self selector:@selector(didHandleTheApplyInMoreVc) name:@"didHandleTheAppleNoti" object:nil];
    [mNotificationCenter addObserver:self selector:@selector(didCreateGroup) name:@"didCreateGroupNoti" object:nil];
}

- (void)didCreateGroup {
    [self reloadDataSource];
}


- (void)didHandleTheApplyInMoreVc {
    [self getApplyEmtities];
}

- (void)getApplyEmtities {
    NSString *loginUserName = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    NSArray *applyEmtities = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginUserName];
    if (self.applyGroups.count) {
        [self.applyGroups removeAllObjects];
    }
    [self.applyGroups addObjectsFromArray:applyEmtities];
    [TZEaseMobManager syncEaseMobInfoWithModelArray:applyEmtities usernameKey:@"applicantUsername" WithCompletion:^(BOOL success) {
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)configTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = self.searchBar;
    [self.tableView addSubview:self.slimeView];
    [self.tableView registerCellByNibName:@"XYGroupCell"];
    [self.tableView registerCellByNibName:@"XYGroupNewsCell"];
    [self.tableView registerCellByClassName:@"XYCheckMoreCell"];
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak GroupListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
//            static NSString *CellIdentifier = @"ContactListCell";
            [tableView registerCellByNibName:@"XYGroupCell"];
//            XYGroupCell *cell = (XYGroupCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            XYGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYGroupCell"];
            
            // Configure the cell...
//            if (cell == nil) {
//                cell = [[XYGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            }
            
            XYGroupInfoModel *groupInfoModel = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSString *imageName = [UIImage imageNamed:@"groupPrivateHeader"];
            [cell.avaterView sd_setImageWithURL:TZImageUrlWithShortUrl(groupInfoModel.avatar) placeholderImage:imageName];
            cell.titleLabel.text = groupInfoModel.owner;
            cell.statusLabel.text = groupInfoModel.desc;
            
            NSString *lab = groupInfoModel.lab_name;
            CGFloat labW = [CommonTools sizeOfText:lab fontSize:13].width;
            cell.featherLabel.text = lab;
            cell.featherLabelConstraintW.constant = labW + 20;
            
            NSString *num = [NSString stringWithFormat:@"%@人",groupInfoModel.total_member];
            CGFloat feaW = [CommonTools sizeOfText:num fontSize:13].width;
            cell.numLabel.text = num;
            cell.numLabelConstraintW.constant = feaW + 20;
            
//            EMGroup *group = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
//            NSString *imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
//            cell.imageView.image = [UIImage imageNamed:imageName];
//            cell.textLabel.text = group.groupSubject;
            [cell addBottomSeperatorViewWithHeight:1];
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 90;
        }];
     
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
    
//            EMGroup *group = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];

            XYGroupInfoModel *model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:model.group_id isAttented:NO isGroup:YES];
            chatController.title = model.owner;
            chatController.gid = model.gid;
            [weakSelf.navigationController pushViewController:chatController animated:YES];
            
        }];
    }
    
    return _searchController;
}

- (void)addGroupNewApply:(NSDictionary *)dictionary
{
    NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (dictionary && [dictionary count] > 0) {
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        ApplyGroupStyle style = [[dictionary objectForKey:@"applyStyle"] intValue];
        
        if (applyUsername && applyUsername.length > 0) {
            for (int i = ((int)[self.applyGroups count] - 1); i >= 0; i--) {
                ApplyEntity *oldEntity = [self.applyGroups objectAtIndex:i];
                ApplyGroupStyle oldStyle = [oldEntity.style intValue];
                // 已存在该条申请，覆盖并拿到最前面来
                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername]) {
                    if(style != ApplyGroupStyleFriend || style!= ApplyGroupStyleFriendResult)
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
                    [self.applyGroups removeObject:oldEntity];
                    [self.applyGroups insertObject:oldEntity atIndex:0];
                    [[InvitationManager sharedInstance] addInvitation:oldEntity loginUser:loginUsername];
                    [self.tableView reloadData];
                    return;
                }
            }
            
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupname, @"groupId":groupId, @"username":username, @"groupname":groupname, @"applyMessage":reason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
            
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
            
            [self.applyGroups insertObject:newEntity atIndex:0];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.applyGroups.count > 3 ? 4 : self.applyGroups.count;
    } else {
        return self.groups.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row > 2) {
            return 44;
        } else {
            return 150;
        }
    } else {
        return 90;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.applyGroups.count) {
            return 30;
        } else {
            return 0.00001;
        }
    } else {
        return 30;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = TZColorRGB(246);
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = TZColorRGB(152);
    label.textAlignment = NSTextAlignmentLeft;
    if (section == 0) {
        label.text = @"  群认证消息";
        if (self.applyGroups.count > 0) {
            return label;
        } else {
            return nil;
        }
    } else {
        label.text = @"  群聊";
        return label;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"GroupCell";
//    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    // Configure the cell...
//    if (cell == nil) {
//        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//                cell.textLabel.text = NSLocalizedString(@"group.create.group",@"Create a group");
//                cell.imageView.image = [UIImage imageNamed:@"group_creategroup"];
//                break;
//            case 1:
//                cell.textLabel.text = NSLocalizedString(@"group.create.join",@"Join public group");
//                cell.imageView.image = [UIImage imageNamed:@"group_joinpublicgroup"];
//                break;
//            default:
//                break;
//        }
//    } else {
//        EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
//        NSString *imageName = @"group_header";
//        //        NSString *imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
//        cell.imageView.image = [UIImage imageNamed:imageName];
//        NSString *strImg = [ApiTeamAvatar stringByAppendingString:group.groupId];
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:strImg] placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageRefreshCached];
//        
//        if (group.groupSubject && group.groupSubject.length > 0) {
//            cell.textLabel.text = group.groupSubject;
//        }
//        else {
//            cell.textLabel.text = group.groupId;
//        }
//    }
//    return cell;

    if (indexPath.section == 0) {
        if (indexPath.row > 2) {
            XYCheckMoreCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"XYCheckMoreCell"];
            moreCell.button.titleLabel.font = [UIFont systemFontOfSize:14];
            [moreCell setDidClickBtnBlock:^{
                XYMoreFriendNotiController *moreNotiVc = [[XYMoreFriendNotiController alloc] init];
                moreNotiVc.type = XYMoreFriendNotiControllerTypeGroups;
                moreNotiVc.addFriends = self.applyGroups;
                [self.navigationController pushViewController:moreNotiVc animated:YES];
            }];
            [moreCell configButtonWithImg:@"genduo" text:@"查看更多"];
            moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [moreCell addBottomSeperatorViewWithHeight:1];
            return moreCell;
        } else {
            NSArray *array = self.applyGroups;
            XYGroupNewsCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"XYGroupNewsCell"];
            ApplyEntity *entity = [self.applyGroups objectAtIndex:indexPath.row];
            newCell.groupName.text = entity.groupSubject;
            //        NSString *strImg = [ApiTeamAvatar stringByAppendingString:group.groupId];
            
            newCell.message.text = entity.reason;
            NSString *avatar = [TZEaseMobManager avatarWithUsername:entity.applicantUsername];
            NSString *nickname = [TZEaseMobManager nickNameWithUsername:entity.applicantUsername];
            newCell.peopleName.text = nickname;
            [newCell.groupAvatar sd_setImageWithURL:TZImageUrlWithShortUrl(avatar) placeholderImage:[UIImage imageNamed:@"groupPublicHeader"]];
            [newCell setDoGroupNewsBlock:^(BOOL add){
                if (add) { // 添加
                    [self applyCellAddFriendAtIndexPath:indexPath];
                } else { // 拒绝
                    [self applyCellRefuseFriendAtIndexPath:indexPath];
                }
            }];
            [newCell addBottomSeperatorViewWithHeight:2];
            newCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return newCell;
        }
    
    } else {
        XYGroupInfoModel *model = self.groups[indexPath.row];
        XYGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYGroupCell"];
        cell.groupInfoModel = model;
        [cell addBottomSeperatorViewWithHeight:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - ApplyFriendCellDelegate

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
 if (indexPath.row < [self.applyGroups count]) {
     [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];

     ApplyEntity *entity = [self.applyGroups objectAtIndex:indexPath.row];
     ApplyStyle applyStyle = [entity.style intValue];
     EMError *error;
     BOOL isSuccess=NO;

     /*if (applyStyle == ApplyStyleGroupInvitation) {
         [[EaseMob sharedInstance].chatManager acceptInvitationFromGroup:entity.groupId error:&error];
     }
     else */
     if (applyStyle == ApplyStyleJoinGroup)
     {
         [[EaseMob sharedInstance].chatManager acceptApplyJoinGroup:entity.groupId groupname:entity.groupSubject applicant:entity.applicantUsername error:&error];
         if (!error) {
             [self requestJoinGroup:entity.groupId huanxin:entity.applicantUsername];
         }
     }
     else if(applyStyle == ApplyStyleFriend){
        isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:entity.applicantUsername error:&error];
     }
     if (!isSuccess) {
         NSLog(@"同意好友请求操作失败");
     }
     [self hideHud];
     if (!error) {
         [self.applyGroups removeObject:entity];
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
-(void)requestJoinGroup:(NSInteger)groupId huanxin:(NSString *)huanxin {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"gid"] = [NSString stringWithFormat:@"%@",groupId];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    params[@"huanxinId"] = huanxin;
    [TZHttpTool postWithURL:ApiSnsGetjoinGroup params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"同意"];
    } failure:^(NSString *msg) {
        [self showSuccessHUDWithStr:msg];
    }];
    
}
- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath
{
     if (indexPath.row < [self.applyGroups count]) {
         [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
         ApplyEntity *entity = [self.applyGroups objectAtIndex:indexPath.row];
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
             [self.applyGroups removeObject:entity];
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

         


#pragma mark - Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//                [self createGroup];
//                break;
//            case 1:
//                [self showPublicGroupList];
//                break;
//            default:
//                break;
//        }
//    } else {
//        EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
//        ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:group.groupId isGroup:YES];
//        chatController.title = group.groupSubject;
//        [self.navigationController pushViewController:chatController animated:YES];
//    }
    if (indexPath.section == 1) {
//        self.selectedRow = indexPath.row;
        XYGroupInfoModel *model = self.groups[indexPath.row];
        ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:model.group_id isAttented:NO isGroup:YES];
        chatController.title = model.owner;
        chatController.gid = model.gid;
        chatController.groupInfoModel = model;
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.groups searchText:(NSString *)searchText collationStringSelector:@selector(groupSubject) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = self.searchBar;
}

#pragma mark - SRRefreshDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *group, EMError *error) {
        if (!error) {
//            [self.groups removeAllObjects];
//            [self.groups addObjectsFromArray:group];
            [self reloadDataSource];
            [self getApplyEmtities];
//            [self.tableView reloadData];
        }
    } onQueue:nil];
    
    [_slimeView endRefresh];
}

#pragma mark - IChatManagerDelegate

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error
{
    if (!error) {
        [self reloadDataSource];
    }
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self reloadDataSource];
}

#pragma mark - data

- (void)loadGroupsDataSourc {
    if (self.groups.count) {
        [self.groups removeAllObjects];
    }
    NSArray *groupArr = [TZUserManager getUserGroups];
    [self.groups addObjectsFromArray:groupArr];
    if (self.groups.count < 1 || groupArr == nil) {
        [self reloadDataSource];
    }
}



- (void)reloadDataSource {
    [self.dataSource removeAllObjects];
    NSMutableArray *rooms = [[[EaseMob sharedInstance].chatManager groupList] mutableCopy];
    
    [rooms enumerateObjectsUsingBlock:^(EMGroup *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj.occupants);
    }];
    
    [self.dataSource addObjectsFromArray:rooms];
    //拼接群环信id
    if (self.dataSource.count < 1) {
        [self.groups removeAllObjects];
        [TZUserManager syncUserGroups:self.groups];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:1];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
    }
    NSMutableString *group_ids = [NSMutableString string];
    for (EMGroup *group in self.dataSource) {
        [group_ids appendString:[NSString stringWithFormat:@",%@",group.groupId]];
    }
    [group_ids deleteCharactersInRange:NSMakeRange(0, 1)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    params[@"group_ids"] = group_ids;
    //    ;

    [TZHttpTool postWithURL:ApiGroupsInfo params:params success:^(NSDictionary *result) {
        NSArray *groupArr = [XYGroupInfoModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        self.groups = [NSMutableArray arrayWithArray:groupArr];
        [TZUserManager syncUserGroups:result[@"data"]];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:1];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self showHint:msg];
        [self.tableView endRefresh];
    }];
    
}

#pragma mark - action

- (void)showPublicGroupList
{
    PublicGroupListViewController *publicController = [[PublicGroupListViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:publicController animated:YES];
}

- (void)createGroup {
#warning 陈冰 20151021 创建群组
    ICECreateGroupViewController *createChatroom = [[ICECreateGroupViewController alloc] init];
    [self.navigationController pushViewController:createChatroom animated:YES];
}

- (void)rightBarButtonItemClick {
    ICECreateGroupViewController *createChatroom = [[ICECreateGroupViewController alloc] init];
    [self.navigationController pushViewController:createChatroom animated:YES];
}

- (void)didDismissGroup {
//    XYGroupInfoModel *model = self.groups[self.selectedRow];
//    [self.groups removeObject:model];
//    [TZUserManager syncUserGroups:self.groups];
//    [self.tableView reloadData];
    [self reloadDataSource];

}


@end
