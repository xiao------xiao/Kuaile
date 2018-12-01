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

#import "ContactsViewController.h"

#import "BaseTableViewCell.h"
#import "RealtimeSearchUtil.h"
#import "ChineseToPinyin.h"
#import "EMSearchBar.h"
#import "SRRefreshView.h"
#import "EMSearchDisplayController.h"
#import "AddFriendViewController.h"
#import "ApplyViewController.h"
#import "GroupListViewController.h"
#import "MyChatroomListViewController.h"
#import "ChatroomListViewController.h"
#import "RobotListViewController.h"
#import "ICEUserInfoViewController.h"

#import "TZAddFriendController.h"
#import "ICECreateGroupViewController.h"
#import "ChatViewController.h"
#import "XYRecommendFriendModel.h"

@implementation XYRecommendFriendModel (search)

// 根据用户昵称进行搜索
- (NSString*)showName {
    if (self.nickname && self.nickname.length) {
        return self.nickname;
    } else {
        return self.username;
    }
}

// 根据用户手机号进行搜索
- (NSString*)showPhone {
    return self.username;
}

@end

@interface ContactsViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIActionSheetDelegate, BaseTableCellDelegate, SRRefreshDelegate, IChatManagerDelegate> {
    NSIndexPath *_currentLongPressIndex;
}

@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@property (strong, nonatomic) UILabel *unapplyCountLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) GroupListViewController *groupController;

@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (nonatomic, strong) TZButtonsCornerView *buttonsView;
@end

@implementation ContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
        _contactsSource = [NSMutableArray array];
        _sectionTitles = [NSMutableArray array];
        [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
        [mNotificationCenter addObserver:self selector:@selector(addFriendSuccess) name:@"didUpdateMemberInfo" object:nil];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"朋友";
    self.rightNavImageName = @"jiahao";
    
    [self searchController];
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self.view addSubview:self.searchBar];
    
    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height);
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    
    [self loadFriendDatas];
//    [self reloadDataSource];
    [self cover];
 
    // 添加好友
    [mNotificationCenter addObserver:self selector:@selector(addFriendSuccess) name:@"didAddFriendNoti" object:nil];
    
}

- (void)loadFriendDatas {
    [self.dataSource removeAllObjects];
    NSArray *sortArray = [self sortDataArray:[TZUserManager getUserFriends]];
    [self.dataSource addObjectsFromArray:sortArray];
    [self.tableView reloadData];
    
    [self reloadDataSource];
}

- (void)addFriendSuccess {
    [self reloadDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadApplyView];
}

- (void)dealloc {
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - getter

- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"搜索", @"搜索");
    }
    return _searchBar;
}

- (UILabel *)unapplyCountLabel
{
    if (_unapplyCountLabel == nil) {
        _unapplyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 5, 20, 20)];
        _unapplyCountLabel.textAlignment = NSTextAlignmentCenter;
        _unapplyCountLabel.font = [UIFont systemFontOfSize:11];
        _unapplyCountLabel.backgroundColor = [UIColor redColor];
        _unapplyCountLabel.textColor = [UIColor whiteColor];
        _unapplyCountLabel.layer.cornerRadius = _unapplyCountLabel.frame.size.height / 2;
        _unapplyCountLabel.hidden = YES;
        _unapplyCountLabel.clipsToBounds = YES;
    }
    
    return _unapplyCountLabel;
}

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

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    
    return _tableView;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak ContactsViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
        
            XYRecommendFriendModel *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            // cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
            cell.placeHolderImage = @"默认头像预览";
            cell.usernameNick = buddy.nickname;
            [cell.imageView sd_setImageWithURL:buddy.avatar placeholderImage:[UIImage imageNamed:@"默认头像预览"]];
            [cell addBottomSeperatorViewWithHeight:1];
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            XYRecommendFriendModel *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
            if (loginUsername && loginUsername.length > 0) {
                if ([loginUsername isEqualToString:buddy.username]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    return;
                }
            }
            
            [weakSelf.searchController.searchBar endEditing:YES];
            NSString *chatter = buddy.phone.length ? buddy.phone : buddy.username;
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:chatter isAttented:YES isGroup:NO];
            chatVC.title = buddy.nickname;
            [weakSelf.navigationController pushViewController:chatVC animated:YES];
        }];
    }
    
    return _searchController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else{
        if (self.dataSource.count>0) {
            return [[self.dataSource objectAtIndex:(section - 1)] count];
        }else return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell;
    if (indexPath.section == 0) {
        cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
        if (cell == nil) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
        }
        cell.placeHolderImage = @[@"xpy",@"qlt"][indexPath.row];
        cell.username = @[@"新的朋友", @"群聊"][indexPath.row];
        [cell addSubview:self.unapplyCountLabel];
        cell.imageView.layer.cornerRadius = 5;
    } else {
        static NSString *CellIdentifier = @"ContactListCell";
        cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        cell.indexPath = indexPath;
       
        XYRecommendFriendModel *buddy = [[self.dataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        cell.usernameNick = buddy.nickname;
        cell.imageView.layer.cornerRadius = 20;
        [cell.imageView sd_setImageWithURL:TZImageUrlWithShortUrl(buddy.avatar) placeholderImage:TZPlaceholderAvaterImage options:SDWebImageRefreshCached];
        
//        XYFriendModel *model = [[self.dataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
//        cell.placeHolderImage = @"chatListCellHead.png";
//        cell.usernameNick = model.username;
//        cell.imageView.layer.cornerRadius = 20;
    
    }
    [cell addBottomSeperatorViewWithHeight:1];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        XYRecommendFriendModel *buddy = [[self.dataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        if ([buddy.username isEqualToString:loginUsername]) { // 如果是自己
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notDeleteSelf", @"can't delete self") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        // 直接调用后台接口
        [TZHttpTool postWithURL:ApiSnsConcernUser params:@{@"sessionid":[mUserDefaults objectForKey:@"sessionid"],@"buid":buddy.uid} success:^(NSDictionary *result) {
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:buddy.username deleteMessages:YES append2Chat:YES];
            [self showSuccessHUDWithStr:@"删除成功"];
            [tableView beginUpdates];
            [[self.dataSource objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
            [self.contactsSource removeObject:buddy];
            [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView  endUpdates];
        } failure:^(NSString *msg) {
            [self showErrorHUDWithError:@"删除失败"];
            [tableView reloadData];
        }];
        
//        EMError *error = nil;
//        [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:&error];
//        if (!error) {
//            [[EaseMob sharedInstance].chatManager removeConversationByChatter:buddy.username deleteMessages:YES append2Chat:YES];
//            
//            [tableView beginUpdates];
//            [[self.dataSource objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
//            [self.contactsSource removeObject:buddy];
//            [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView  endUpdates];
//        } else{
//            [self showHint:[NSString stringWithFormat:NSLocalizedString(@"deleteFailed", @"Delete failed:%@"), error.description]];
//            [tableView reloadData];
//        }
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || [[self.dataSource objectAtIndex:(section - 1)] count] == 0) {
        return 0;
    } else {
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *array = self.dataSource;
    if (section == 0 || [[self.dataSource objectAtIndex:(section - 1)] count] == 0) {
        return nil;
    }
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:TZColorRGB(246)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
    [contentView addSubview:label];
    return contentView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray * existTitles = [NSMutableArray array];
    // section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.sectionTitles count]; i++) {
        if ([[self.dataSource objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
//    NSString *str = @"#";
    NSString *str1 = @"↑";
    [existTitles insertObject:str1 atIndex:0];
//    [existTitles insertObject:str atIndex:1];
    return existTitles;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[ApplyViewController shareController] animated:YES];
        } else if (indexPath.row == 1) {
//            if (_groupController == nil) {
//                _groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
//            } else{
//                [_groupController reloadDataSource];
//            }
            _groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:_groupController animated:YES];
        }
//        else if (indexPath.row == 2) {
//            ChatroomListViewController *controller = [[ChatroomListViewController alloc] initWithStyle:UITableViewStylePlain];
//            [self.navigationController pushViewController:controller animated:YES];
//        } else if (indexPath.row == 3) {
//            RobotListViewController *controller = [[RobotListViewController alloc] initWithStyle:UITableViewStylePlain];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
    }
    else{
        XYRecommendFriendModel *buddy = [[self.dataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if (loginUsername && loginUsername.length > 0) {
            if ([loginUsername isEqualToString:buddy.username]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
        }
//        ICEUserInfoViewController *iCEUserInfo = [[ICEUserInfoViewController alloc] init];
//        iCEUserInfo.userName = buddy.username;
//        [self.navigationController pushViewController:iCEUserInfo animated:YES];
        
        
        NSString *chatter = buddy.phone.length ? buddy.phone : buddy.username;
        ChatViewController *chatView = [[ChatViewController alloc] initWithChatter:chatter isAttented:YES isGroup:NO];
        chatView.title = buddy.nickname;
        [self.navigationController pushViewController:chatView animated:YES];
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
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:(NSString *)searchText collationStringSelector:@selector(showName) selector2:@selector(x) resultBlock:^(NSArray *results) {
        [weakSelf.searchController.resultsSource removeAllObjects];
        [weakSelf.searchController.resultsSource addObjectsFromArray:results];
        [weakSelf.searchController.searchResultsTableView reloadData];
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex && _currentLongPressIndex) {
        XYRecommendFriendModel *buddy = [[self.dataSource objectAtIndex:(_currentLongPressIndex.section - 1)] objectAtIndex:_currentLongPressIndex.row];
        [self hideHud];
        [self showHudInView:self.view hint:NSLocalizedString(@"wait", @"Pleae wait...")];
        
        __weak typeof(self) weakSelf = self;
        [[EaseMob sharedInstance].chatManager asyncBlockBuddy:buddy.username relationship:eRelationshipBoth withCompletion:^(NSString *username, EMError *error){
            typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf hideHud];
            if (!error) {
                // 由于加入黑名单成功后会刷新黑名单，所以此处不需要再更改好友列表
            } else {
                [strongSelf showHint:error.description];
            }
        } onQueue:nil];
    }
    _currentLongPressIndex = nil;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate

// 刷新列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView {
//    __weak ContactsViewController *weakSelf = self;
//    [[[EaseMob sharedInstance] chatManager] asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
//        [weakSelf.slimeView endRefresh];
//    } onQueue:nil];
    [self reloadDataSource];
}

#pragma mark - BaseTableCellDelegate

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row >= 1) {
        // 群组，聊天室
        return;
    }
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    XYRecommendFriendModel *buddy = [[self.dataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    if ([buddy.username isEqualToString:loginUsername]) {
        return;
    }
    
    _currentLongPressIndex = indexPath;
}

#pragma mark - private

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray {
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (XYRecommendFriendModel *buddy in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:buddy.nickname];
//        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:[TZEaseMobManager nickNameWithUsername:buddy.username]];
        if (firstLetter.length > 0) {
            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            NSMutableArray *array = [sortedArray objectAtIndex:section];
            [array addObject:buddy];
        }
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(XYRecommendFriendModel *obj1, XYRecommendFriendModel *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:[TZEaseMobManager nickNameWithUsername:obj1.username]];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:[TZEaseMobManager nickNameWithUsername:obj2.username]];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    return sortedArray;
}

#pragma mark - dataSource

- (void)reloadDataSource {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [TZHttpTool postWithURL:ApiGetFriendsList params:@{@"sessionid":sessionId} success:^(NSDictionary *result) {
            [self.dataSource removeAllObjects];
            [self.contactsSource removeAllObjects];
            
            NSArray *buddyList = [XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList];
            for (XYRecommendFriendModel *buddy in buddyList) {
                //            if (![blockList containsObject:buddy.nickname]) {
                //                [self.contactsSource addObject:buddy];
                //            }
                [self.contactsSource addObject:buddy];
            }
            //        // 去请求我们服务器存储的昵称
                    [TZEaseMobManager syncEaseMobInfoWithModelArray:self.contactsSource usernameKey:@"username" WithCompletion:^(BOOL success) {
            
                    }];

            // 存储
            [TZUserManager syncUserFriends:result[@"data"]];
            [self.dataSource addObjectsFromArray:[self sortDataArray:buddyList]];
            NSArray *ar = self.dataSource;
            [self.tableView reloadData];
            [self.tableView endRefresh];
            [self.slimeView endRefresh];
        } failure:^(NSString *msg) {
            [self.tableView endRefresh];
            [self.slimeView endRefresh];
        }];
    });
}

//- (void)reloadDataSource {
//    [self.dataSource removeAllObjects];
//    [self.contactsSource removeAllObjects];
//    
//    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
//    NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList];
//    for (EMBuddy *buddy in buddyList) {
//        if (![blockList containsObject:buddy.username]) {
//            [self.contactsSource addObject:buddy];
//        }
//    }
//    // 去请求我们服务器存储的昵称
//    [TZEaseMobManager syncEaseMobInfoWithModelArray:self.contactsSource usernameKey:@"username" WithCompletion:^(BOOL success) {
//        [_tableView reloadData];
//    }];
//    
//    [self.dataSource addObjectsFromArray:[self sortDataArray:self.contactsSource]];
//    [_tableView reloadData];
//}

#pragma mark - action

- (void)reloadApplyView {
    NSInteger count = [[[ApplyViewController shareController] dataSource] count];
    if (count == 0) {
        self.unapplyCountLabel.hidden = YES;
    } else {
        NSString *tmpStr = [NSString stringWithFormat:@"%i", (int)count];
        CGSize size = [tmpStr sizeWithFont:self.unapplyCountLabel.font constrainedToSize:CGSizeMake(50, 20) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect rect = self.unapplyCountLabel.frame;
        rect.size.width = size.width > 20 ? size.width : 20;
        self.unapplyCountLabel.text = tmpStr;
        self.unapplyCountLabel.frame = rect;
        self.unapplyCountLabel.hidden = NO;
    }
}

- (void)reloadGroupView {
    [self reloadApplyView];
    
    if (_groupController) {
        [_groupController reloadDataSource];
    }
}

- (void)didClickRightNavAction {
    if (self.buttonsView.alpha <= 0) {
        self.cover.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            _buttonsView.alpha = 1.0;
        }];
    } else {
        [self coverBtnClick];
    }
}

- (void)coverBtnClick {
    [super coverBtnClick];
    self.buttonsView.alpha = 0;
}

#pragma mark - EMChatManagerBuddyDelegate

- (void)didUpdateBlockedList:(NSArray *)blockedList {
    [self reloadDataSource];
}

#pragma mark - Get 

- (TZButtonsCornerView *)buttonsView {
    if (!_buttonsView) {
        _buttonsView = [[TZButtonsCornerView alloc] initWithFrame:CGRectMake(mScreenWidth - 106, 0, 106, 88)];
        [_buttonsView setTitles:@[@"加好友",@"新建群"]];
        [_buttonsView setImages:@[@"more_jiahaoyou",@"more_jianqun"]];
        _buttonsView.alpha = 0;
        [_buttonsView.layer addStandardShadow];
        for (TZBaseButton *button in _buttonsView.btnArr) {
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        }
        MJWeakSelf
        [_buttonsView setDidClickButtonWithIndex:^(TZBaseButton *button, NSInteger index) {
            if (index == 0) {
                TZAddFriendController *vc = [TZAddFriendController new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                ICECreateGroupViewController *createChatroom = [[ICECreateGroupViewController alloc] init];
                [weakSelf.navigationController pushViewController:createChatroom animated:YES];
            }
            [weakSelf coverBtnClick];
        }];
        [self.view addSubview:_buttonsView];
    }
    return _buttonsView;
}

@end
