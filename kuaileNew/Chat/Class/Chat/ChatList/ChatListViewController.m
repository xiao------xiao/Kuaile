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

#import "ChatListViewController.h"
#import "SRRefreshView.h"
#import "ChatListCell.h"
#import "EMSearchBar.h"
#import "NSDate+Category.h"
#import "RealtimeSearchUtil.h"
#import "ChatViewController.h"
#import "EMSearchDisplayController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "RobotManager.h"
#import "RobotChatViewController.h"
#import "TZJobDetailViewController.h"
#import "XYCommentLikeController.h"
#import "XYSystemMessageDetailController.h"

//----------------------------------------------------------------------
#import "ICEModelSysMess.h"
#import "ICESysMessTableViewCell.h"
#import "UIImage+MultiFormat.h"
#import "UIImageView+WebCache.h"
#import "ICESysInfoViewController.h"
#import "WZLBadgeImport.h"
#import "TZJobListViewController.h"
#import "TZNaviController.h"

#import "MessageModelManager.h"
#import "XYMessageModel.h"
#import "ORTimeTool.h"
#import "XYGroupInfoModel.h"
#import "EMConversation+Gropp.h"
#import "ICESysInfoViewController.h"


@implementation EMConversation (search)

//根据用户昵称,环信机器人名称,群名称进行搜索
- (NSString*)showName
{
    if (self.conversationType == eConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:self.chatter]) {
            return [[RobotManager sharedInstance] getRobotNickWithUsername:self.chatter];
        }
        return [TZEaseMobManager nickNameWithUsername:self.chatter];
    } else if (self.conversationType == eConversationTypeGroupChat) {
        if ([self.ext objectForKey:@"groupSubject"] || [self.ext objectForKey:@"isPublic"]) {
            return [self.ext objectForKey:@"groupSubject"];
        }
    }
    return self.chatter;
}

@end

@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchDisplayDelegate,SRRefreshDelegate, UISearchBarDelegate, IChatManagerDelegate,ChatViewControllerDelegate> {
    ORParentModel *_parentModel;
    NSArray<ORparentManageModel *> *_manageModels;
    BOOL _repeatPress;
    EMConversation *_happyCS;
    
    BOOL isT;
    NSDictionary *tUserInfo;
}

@property (strong, nonatomic) NSMutableArray        *dataSource;

@property (strong, nonatomic) UITableView           *tableView;
@property (nonatomic, strong) EMSearchBar           *searchBar;
@property (nonatomic, strong) SRRefreshView         *slimeView;
@property (nonatomic, strong) UIView                *networkStateView;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

//---------------------------------------------------------------------------

//@property (nonatomic, strong) UITableView *sysTableView;
@property (nonatomic, strong) NSMutableArray *sysCellDataAry;
@property (nonatomic, assign) NSInteger pageIndex;
//---------------------------------------------------------------------------

// orcode
@property (nonatomic, strong) NSMutableArray <EMConversation *>* conversions;
@property (nonatomic, strong) NSMutableArray <XYGroupInfoModel *>* groupInfos;


@end

@implementation ChatListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
        _conversions = [NSMutableArray array];
        _groupInfos = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [mNotificationCenter addObserver:self selector:@selector(messagecChanged:) name:kNotiSysMessageListchange object:nil];
        [mNotificationCenter addObserver:self selector:@selector(messagecChanged:) name:kNotiSysMessageListchangeJump object:nil];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageBarNoti:) name:@"kMessageBarNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginStateChanged:) name:KNOTIFICATION_LOGINCHANGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:@"kICELoginSuccessNotificationName" object:nil];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
//    [self configSegmentedControl];
//    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
//    [self removeEmptyConversationsFromDB];
    
    [self.view addSubview:self.searchBar];
//    [self.view addSubview:self.tableView];
//    [self.tableView addSubview:self.slimeView];
    [self networkStateView];
    
    [self searchController];
    
    //----------------------------------------------------------------
    self.sysCellDataAry = [[NSMutableArray alloc] init];
//    [self configSysTableView];
   
    
#pragma mark -- orcode
    
    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    
    NSLog(@"..%@", conversations);
    
//    _repeatPress = NO;
    [self loadSysMegData];
    
    
#pragma mark -----11111111
    _conversions = [[[EaseMob sharedInstance].chatManager conversations] mutableCopy];
//    [self.tableView reloadData];
    [self loadGroupInfo];
    
}

- (void)loadGroupInfo {
    if (_conversions.count < 1) return;
    
    
    
    
    
    NSMutableString *group_ids = [NSMutableString string];
    NSMutableString *chart_ids = [NSMutableString string];


    for (int i = 0; i < _conversions.count; i++) {
        EMConversation *group = _conversions[i];
        
        if (!group.latestMessage) {
            [_conversions removeObject:group];
            i --;
            continue;
        }
        
        if ([group.chatter isEqualToString:@"ttouch"]) {
            _happyCS = group;
            [_conversions removeObject:group];
            i --;
            continue;
        }
        
        if (group.conversationType == eConversationTypeGroupChat) {
            [group_ids appendString:[NSString stringWithFormat:@",%@",group.chatter]];
        }else {
            [chart_ids appendString:[NSString stringWithFormat:@",%@",group.chatter]];

        }

    }
    if (chart_ids.length > 0) {
        [chart_ids deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    [TZEaseMobManager syncEaseMobInfoWithUsernames:chart_ids WithCompletion:^(BOOL success) {
        
    }];
    
//    for (EMGroup *group in self.dataSource) {
//        [group_ids appendString:[NSString stringWithFormat:@",%@",group.groupId]];
//    }
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
//    params[@"group_ids"] = group_ids;
//    [TZHttpTool postWithURL:ApiGroupsInfo params:params success:^(NSDictionary *result) {
//        NSArray *groupArr = [XYGroupInfoModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
//        self.groups = [NSMutableArray arrayWithArray:groupArr];
//        [TZUserManager syncUserGroups:result[@"data"]];
//        NSIndexSet *set = [NSIndexSet indexSetWithIndex:1];
//        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView endRefresh];
//    } failure:^(NSString *msg) {
//        [self.tableView endRefresh];
//    }];

    
    
    if (group_ids.length > 0) {
        [group_ids deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    params[@"group_ids"] = group_ids;
    [TZHttpTool postWithURL:ApiGroupsInfo params:params success:^(NSDictionary *result) {
        self.groupInfos = [XYGroupInfoModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        for (XYGroupInfoModel *gmode in self.groupInfos) {
            for (EMConversation *csation in _conversions) {
                if ([gmode.group_id isEqualToString:csation.chatter]) {
                    csation.groupName = gmode.owner;
                    csation.groupAvator = gmode.avatar;
                    csation.gid = gmode.gid;
                    csation.is_admin = gmode.is_admin;
                    break;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
//        [self.tableView reloadData];
    } failure:^(NSString *msg) {
//        [self showHint:msg];

//        [self.tableView endRefresh];
    }];

}

- (void)loadSysMegData {
    
    if (![ICELoginUserModel sharedInstance].isLogin) {
        return;
    }
    
    
    if (_repeatPress) {
        return;
    }
    _repeatPress = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _repeatPress = NO;
    });
    
    
    [TZHttpTool postWithURL:ApiDeletefetMessageList params:@{@"sessionid" : [mUserDefaults objectForKey:@"sessionid"],@"ban_mid" : [ORParentModel getMids]} success:^(NSDictionary *result) {
        
        NSLog(@"1111111 new aaa%@",result);
        
        if ([result[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            _parentModel = [ORParentModel modelWithJSON:result[@"data"]];
            
            _manageModels = [ORparentManageModel manageModelWith:_parentModel isLocal:NO];
            
        }else {
            _parentModel = [ORParentModel model];
            
            _manageModels = [ORparentManageModel manageModelWith:_parentModel isLocal:NO];

        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
            if (isT) {
                isT = NO;
                
                NSInteger datatype = [tUserInfo[@"data_type" ] integerValue];
                NSIndexPath *indexpath;
                switch (datatype) {
                    case 301:
                        indexpath = [NSIndexPath indexPathForRow:4 inSection:0];
                        break;
                    case 303:
                        indexpath = [NSIndexPath indexPathForRow:4 inSection:0];
                        break;
                    case 302:
                        indexpath = [NSIndexPath indexPathForRow:5 inSection:0];
                        break;
                    case 401:
                        indexpath = [NSIndexPath indexPathForRow:2 inSection:0];
                        break;
                    case 201:
                        indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
                        break;
                    default:
                        indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
                        break;
                }
                
                [self tableView:self.tableView didSelectRowAtIndexPath:indexpath];
            }
            
        });
        
        
    } failure:^(NSString *msg) {
        if ([UIViewController currentViewController] == self || [UIViewController currentViewController] == self.navigationController) {
            [self showHint:msg];
        }
    }];

}

#pragma mark -- getui noti
- (void)messagecChanged:(NSNotification *)notif {
    NSDictionary *dic = notif.userInfo;
    
    NSLog(@"getui: %@",dic);
    
    if (!dic) {
        return;
    }
    
//    if ([mUserDefaults boolForKey:@"Foreground"]) {
//        isT = YES;
//    }
    
    if ([notif.name isEqualToString:kNotiSysMessageListchangeJump]) {
        isT = YES;
    }else {
        isT = NO;
    }
    
    
    
    tUserInfo = dic;
    
//    _repeatPress = NO;
    [self loadSysMegData];
    
    
//    NSLog(@"d %@", dic[@"content"]);
//    
//    NSLog(@"a %@", dic[@"title"]);
//    NSLog(@"as %@", dic);
    
}


- (void)messageBarNoti:(NSNotification *)noti {
    [self loadNetData:YES];
}

- (void)didLogin:(NSNotification *)noti {
    
    [self loadSysMegData];
}


- (void)didLoginStateChanged:(NSNotification *)noti {
    
    UISegmentedControl *contrl = (UISegmentedControl *)self.navigationItem.titleView;
    [contrl clearBadge];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    if (_manageModels.count <= 0 || _manageModels[0].isReadNil) {
        _manageModels = [ORparentManageModel manageModelWith:[ORParentModel readData] isLocal:YES];
    }

//    [self loadDataSource];
//    [self refreshDataSource];
    [self registerNotifications];
    [self configTabBarItemNoti];
//    
//    _conversions = [[[EaseMob sharedInstance].chatManager conversations] mutableCopy];
//    [self.tableView reloadData];
//    
//    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
//    
//    //2017022715450668877
//    
//    NSLog(@"....%@", conversations);
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
    
    
}

- (void)removeEmptyConversationsFromDB {
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations deleteMessages:YES append2Chat:NO];
    }
}

- (void)removeChatroomConversationsFromDB {
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (conversation.conversationType == eConversationTypeChatRoom) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations deleteMessages:YES append2Chat:NO];
    }
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
    }
    
    return _slimeView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 55)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJWeakSelf
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadNetData:NO];
        }];
        [_tableView registerCellByClassName:@"ChatListCell"];
        [_tableView registerCellByClassName:@"BaseTableViewCell"];
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"systemCell"];
        
        [self.view addSubview:_tableView];
        [_tableView addSubview:self.slimeView];
    }
    
    return _tableView;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak ChatListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ChatListCell";
            ChatListCell *cell = (ChatListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            // Configure the cell...
            if (cell == nil) {
                cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.name = conversation.chatter;
            if (conversation.conversationType == eConversationTypeChat) {
                cell.name = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
                cell.placeholderImage = TZPlaceholderAvaterImage;
            }
            else{
                NSString *imageName = @"groupPublicHeader";
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:conversation.chatter]) {
                        cell.name = group.groupSubject;
                        imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                        break;
                    }
                }
                cell.placeholderImage = [UIImage imageNamed:imageName];
            }
            
            [TZHttpTool postWithURL:ApiDeletefetAvatar params:@{@"usernames" : conversation.chatter} success:^(NSDictionary *result) {
                NSArray *datas = result[@"data"];
                if (datas.count > 0) {
                    cell.imageURL = [NSURL URLWithString:result[@"data"][0][@"avatar"]];
                    [cell.imageView sd_setImageWithURL:cell.imageURL placeholderImage:cell.placeholderImage];
                }
                
            } failure:^(NSString *msg) {
                NSLog(@"%@", msg);
            }];

        
            cell.detailMsg = [weakSelf subTitleMessageByConversation:conversation];
            cell.time = [weakSelf lastMessageTimeByConversation:conversation];
            cell.unreadCount = [weakSelf unreadMessageCountByConversation:conversation];
            if (indexPath.row % 2 == 1) {
                cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
            }else{
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            ChatViewController *chatController;
            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
                chatController = [[RobotChatViewController alloc] initWithChatter:conversation.chatter
                                                                 conversationType:conversation.conversationType];
                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
            }else {
                chatController = [[ChatViewController alloc] initWithChatter:conversation.chatter
                                                            conversationType:conversation.conversationType];
                chatController.title = [conversation showName];
            }
            [weakSelf.navigationController pushViewController:chatController animated:YES];
        }];
    }
    
    return _searchController;
}

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

#pragma mark - private

- (NSMutableArray *)loadDataSource {
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:^(EMConversation *obj1, EMConversation* obj2){
        EMMessage *message1 = [obj1 latestMessage];
        EMMessage *message2 = [obj2 latestMessage];
        if(message1.timestamp > message2.timestamp) {
            return(NSComparisonResult)NSOrderedAscending;
        } else {
            return(NSComparisonResult)NSOrderedDescending;
        }
    }];
    
#pragma mark -- 11111
    _conversions = [[[EaseMob sharedInstance].chatManager conversations] mutableCopy];
    [self loadGroupInfo];
    [self loadSysMegData];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
    
    // 去请求我们服务器存储的昵称
    [TZEaseMobManager syncEaseMobInfoWithModelArray:conversations usernameKey:@"chatter" WithCompletion:^(BOOL success) {
        [_tableView reloadData];
    }];

    ret = [[NSMutableArray alloc] initWithArray:sorte];
    
    
    
    
    [self.tableView endRefresh];
    
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                if ([[RobotManager sharedInstance] isRobotMenuMessage:lastMessage]) {
                    ret = [[RobotManager sharedInstance] getRobotMenuMessageDigest:lastMessage];
                } else {
                    ret = didReceiveText;
                }
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - TableViewDelegate & TableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //   return self.dataSource.count + self.sysCellDataAry.count;
//    return 6 + self.dataSource.count;
    
    return 6 + _conversions.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([tableView isEqual:self.sysTableView]) {
//        ICESysMessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ICESysMessTableViewCell"];
//        [cell loadDataModel:self.sysCellDataAry[indexPath.row]];
//        return cell;
//    } else {

    /*
     
     @"comment_notice" : [XYMessageModel class],
     @"account_notice" : [XYMessageModel class],
     @"reply_notice" : [XYMessageModel class],
     @"system_notice" : [XYMessageModel class],
     @"work_notice" : [XYMessageModel class],
     @"zan_notice" : [XYMessageModel class]};
     
     */
    
    
    if (indexPath.row < 4) {
        
        
        ChatListCell *systemCell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
        systemCell.placeholderImage = [UIImage imageNamed:@[@"xitong",@"gongzuo",@"zhanghao",@"kefu"][indexPath.row]];
        systemCell.name = @[@"系统消息",@"工作通知",@"账号消息",@"开心客服"][indexPath.row];
        
        if ( [_manageModels count] > 0) {
            
            XYMessageModel *model = _manageModels[indexPath.row].lastModel;
            
            if (model.create_at) {
                systemCell.time = [ORTimeTool timeShortStr:model.create_at.integerValue];
            }else {
                systemCell.time = @"";
            }
            
            systemCell.unreadCount = _manageModels[indexPath.row].unreadCount;
            systemCell.detailMsg = model.title;
        }
        
        if (indexPath.row == 3) {
            //开心客户
            systemCell.hpCSonversation = _happyCS;
        }
        
        systemCell.isSystemCell = YES;
        [systemCell addBottomSeperatorViewWithHeight:1];
        return systemCell;
    } else if (indexPath.row == 4 || indexPath.row == 5) {
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseTableViewCell"];
        cell.username = indexPath.row == 4 ? @"评论" : @"点赞";
        cell.imageView.image = indexPath.row == 4 ? [UIImage imageNamed:@"pinlun"] : [UIImage imageNamed:@"dianzan"];
        
        if ([_manageModels count] > 0) {
            cell.unreadCount = _manageModels[indexPath.row].unreadCount;
        }

        cell.isSystemCell = YES;
        [cell addBottomSeperatorViewWithHeight:1];
        return cell;
    } else {
        ChatListCell *chatCell = [tableView dequeueReusableCellWithIdentifier:@"ChatListCell"];
        chatCell.placeholderImage = [UIImage imageNamed:@"zhanghao"];
        chatCell.conversation = _conversions[indexPath.row - 6];
//        _conversions[1].conversationType
//        chatCell.model = [MessageModelManager modelWithMessage:[_conversions[indexPath.row - 6] latestMessage]];
//        chatCell.name = @"刘能";
//        chatCell.time = @"2012/2/10";
//        chatCell.unreadCount = 10;
//        chatCell.detailMsg = @"有时间下次聊";
        chatCell.isSystemCell = NO;
        [chatCell addBottomSeperatorViewWithHeight:1];
        return chatCell;
        
        
//        ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatListCell"];
//        EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
//        cell.name = conversation.chatter;
//        if (conversation.conversationType == eConversationTypeChat) {
//            cell.name = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
//            cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
//            cell.imageURL = [NSURL URLWithString:[TZEaseMobManager avatarWithUsername:conversation.chatter]];
//        } else {
//            NSString *strImg = [ApiTeamAvatar stringByAppendingString:conversation.chatter];
//            cell.imageURL = [NSURL URLWithString:strImg];
//            NSString *imageName = @"groupPublicHeader";
//            if (![conversation.ext objectForKey:@"groupSubject"] || ![conversation.ext objectForKey:@"isPublic"]) {
//                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//                for (EMGroup *group in groupArray) {
//                    if ([group.groupId isEqualToString:conversation.chatter]) {
//                        cell.name = group.groupSubject;
//                        imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
//                        
//                        NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
//                        [ext setObject:group.groupSubject forKey:@"groupSubject"];
//                        [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
//                        conversation.ext = ext;
//                        break;
//                    }
//                }
//            } else {
//                cell.name = [conversation.ext objectForKey:@"groupSubject"];
//                imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
//            }
//            cell.placeholderImage = [UIImage imageNamed:imageName];
//        }
//        cell.detailMsg = [self subTitleMessageByConversation:conversation];
//        cell.time = [self lastMessageTimeByConversation:conversation];
//        cell.unreadCount = [self unreadMessageCountByConversation:conversation];
//        cell.contentView.backgroundColor = [UIColor whiteColor];
//        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([tableView isEqual:self.sysTableView]) {
    return 60;
//    } else {
//        return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_manageModels.count > 0 && indexPath.row < 6) {
        _manageModels[indexPath.row].unreadCount = 0;
        ChatListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.unreadCount = 0;
        [ORparentManageModel unreadCountsWith:_manageModels];
    }
    
    if (indexPath.row == 0) {
        [self pushSystemMessageControllerWithTitle:@"系统消息"];
        [_parentModel saveDataWithType:@"system_notice"];
    } else if (indexPath.row == 1) {
        [self pushSystemMessageControllerWithTitle:@"工作通知"];
        [_parentModel saveDataWithType:@"work_notice"];
    } else if (indexPath.row == 2) {
        [self pushSystemMessageControllerWithTitle:@"账号消息"];
        [_parentModel saveDataWithType:@"account_notice"];
    } else if (indexPath.row == 3) {
        ChatViewController *chatVc = [[ChatViewController alloc] initWithChatter:@"ttouch" conversationType:eConversationTypeChat];
//        ChatViewController *serviceVc = [[ChatViewController alloc] init];
        chatVc.titleText = @"开心客服";
        [self.navigationController pushViewController:chatVc animated:YES];
    } else if (indexPath.row == 4) {
        [self pushViewControllerWithTitle:@"评论"];
        [_parentModel saveDataWithType:@"comment_notice"];
    } else if (indexPath.row == 5) {
        [self pushViewControllerWithTitle:@"点赞"];
        [_parentModel saveDataWithType:@"zan_notice"];
    } else if (indexPath.row > 5) {
        
        
//        NSString *string;
//        NSDictionary *dic = [[EaseMob sharedInstance].chatManager loginInfo];
//        if ([dic[@"username"] isEqualToString:@"18323221892"] ) {
//            string = @"2017022715450668877";
//        }else {
//            string = @"18323221892";
//        }
        
        
        
        ChatListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.unreadCount = 0;
        
        ChatViewController *chatVc = [[ChatViewController alloc] initWithChatter:_conversions[indexPath.row - 6].chatter conversationType:_conversions[indexPath.row-6].conversationType];
        
//        chatController.title = model.owner;
        chatVc.gid = _conversions[indexPath.row-6].gid;
        chatVc.is_admin = _conversions[indexPath.row-6].is_admin;
        chatVc.title = cell.textLabel.text;
        chatVc.delelgate = self;
        [self.navigationController pushViewController:chatVc animated:YES];
        
        
    }
//    if (indexPath.row < 4) {
//        ICEModelSysMess *model = self.sysCellDataAry[indexPath.row];
//        if (![model.aclass isEqualToString:@"0"]) {
//            TZJobListViewController *jobListVc = [[TZJobListViewController alloc] initWithNibName:@"TZJobListViewController" bundle:nil];
//            jobListVc.type = TZJobListViewControllerTypeNoti;
//            jobListVc.salary = model.salary;
//            jobListVc.laid = model.aclass;
//            jobListVc.address = model.address;
//            jobListVc.isFromHotJob = [model.is_hot boolValue];
//            [jobListVc showBack];
//            [self.navigationController pushViewController:jobListVc animated:YES];
//        } else if ([model.title isEqualToString:@"职位推荐"]) {
//            NSString *is_mess = model.is_mess;
//            if ([is_mess rangeOfString:@","].location != NSNotFound) { // 有多个职位，去列表页
//                TZJobListViewController *jobListVc = [[TZJobListViewController alloc] initWithNibName:@"TZJobListViewController" bundle:nil];
//                jobListVc.type = TZJobListViewControllerTypeGetui;
//                jobListVc.is_mess = is_mess;
//                [jobListVc showBack];
//                [self.navigationController pushViewController:jobListVc animated:YES];
//                return;
//            } else { // 单个职位，去详情页
//                // 跳转到详情控制器
//                TZJobDetailViewController *detailVc = [[TZJobDetailViewController alloc] initWithNibName:@"TZJobDetailViewController" bundle:nil];
//                detailVc.recruit_id = is_mess;
//                [self.navigationController pushViewController:detailVc animated:YES];
//                return;
//            }
//        } else {
//            ICESysInfoViewController *iCESysInfo = [[ICESysInfoViewController alloc] initWithNibName:@"ICESysInfoViewController" bundle:[NSBundle mainBundle]];
//            iCESysInfo.strSysInfo = model.content;
//            [self.navigationController pushViewController:iCESysInfo animated:YES];
//        }
//    }
//    else {
//        EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
//        
//        ChatViewController *chatController;
//        NSString *title = conversation.chatter;
//        if (conversation.conversationType != eConversationTypeChat) {
//            if ([[conversation.ext objectForKey:@"groupSubject"] length]) {
//                title = [conversation.ext objectForKey:@"groupSubject"];
//            } else {
//                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//                for (EMGroup *group in groupArray) {
//                    if ([group.groupId isEqualToString:conversation.chatter]) {
//                        title = group.groupSubject;
//                        break;
//                    }
//                }
//            }
//        } else if (conversation.conversationType == eConversationTypeChat) {
//            title = [TZEaseMobManager nickNameWithUsername:conversation.chatter];
//        }
//        
//        NSString *chatter = conversation.chatter;
//        if ([[RobotManager sharedInstance] isRobotWithUsername:chatter]) {
//            chatController = [[RobotChatViewController alloc] initWithChatter:chatter conversationType:conversation.conversationType];
//            chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:chatter];
//        } else {
//            chatController = [[ChatViewController alloc] initWithChatter:chatter conversationType:conversation.conversationType];
//            chatController.title = title;
//        }
//        chatController.delelgate = self;
//        [self.navigationController pushViewController:chatController animated:YES];
//    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < 6) {
        return NO;
    }
    
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 4) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            DLog(@"%ld", indexPath.row);
            ICEModelSysMess *model = self.sysCellDataAry[indexPath.row];
            [self postDeleteInfo:model.message_id];
            [self.sysCellDataAry removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            EMConversation *converation = [_conversions objectAtIndex:indexPath.row-6];
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
            [_conversions removeObjectAtIndex:indexPath.row - 6];
//            [self.dataSource removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }

    }
}

- (void)pushSystemMessageControllerWithTitle:(NSString *)title {
    XYSystemMessageDetailController *messageVc = [[XYSystemMessageDetailController alloc] init];
    messageVc.titleText = title;
    [self.navigationController pushViewController:messageVc animated:YES];
}

- (void)pushViewControllerWithTitle:(NSString *)title {
    XYCommentLikeController *vc = [[XYCommentLikeController alloc] init];
    vc.titleText = title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)postDeleteInfo:(NSString *)messageID {
    [TZHttpTool postWithURL:ApiDeleteMessage params:@{ @"message_id": messageID } success:^(NSDictionary *result) {
        
    } failure:^(NSString *msg) {
    
    }];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.conversions searchText:(NSString *)searchText collationStringSelector:@selector(showName) selector2:@selector(username) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate

// 刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView {
    [self refreshDataSource];
//    [self loadSysMegData];
    [_slimeView endRefresh];
}

#pragma mark - IChatMangerDelegate

- (void)didUnreadMessagesCountChanged {
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error {
    [self refreshDataSource];
}

#pragma mark - registerNotifications
- (void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - public

- (void)refreshDataSource {
    self.dataSource = [self loadDataSource];
//    [_tableView reloadData];
    [self hideHud];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        _tableView.tableHeaderView = _networkStateView;
    } else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)networkChanged:(EMConnectionState)connectionState {
    if (connectionState == eEMConnectionDisconnected) {
        _tableView.tableHeaderView = _networkStateView;
    } else{
        _tableView.tableHeaderView = nil;
    }
}

//- (void)selectSystemNewsSegment {
//    UISegmentedControl *contrl = (UISegmentedControl *)self.navigationItem.titleView;
//    contrl.selectedSegmentIndex = 1;
//    [self Selectbutton:contrl];
//}

//- (void)selectConversationSegment {
//    UISegmentedControl *contrl = (UISegmentedControl *)self.navigationItem.titleView;
//    contrl.selectedSegmentIndex = 0;
//    [self Selectbutton:contrl];
//}

- (void)willReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages {
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
}

#pragma mark - ChatViewControllerDelegate
- (NSString *)avatarWithChatter:(NSString *)chatter {
    if (chatter == [[EaseMob sharedInstance].chatManager loginInfo][@"username"]) {
        return [ICELoginUserModel sharedInstance].avatar;
    }else {
        return [TZEaseMobManager avatarWithUsername:chatter];
    }
}

#pragma mark - 陈冰 20151028 在消息页面添加一个 分段选择器用于区分聊天消息和系统消息
- (void)configSegmentedControl {
    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(80.0f, 8.0f, 200.0f, 30.0f) ];
    [segmentedControl insertSegmentWithTitle:@"消息" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"系统" atIndex:1 animated:YES];
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(Selectbutton:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
}

- (void)configTabBarItemNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configTabBarItem:) name:kNotiTabBarItemShowNum object:nil];
}

/// 删除所有系统消息
- (void)deleteAllSysMessClick {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该页所有系统消息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
        if (x.integerValue == 1) {
            NSMutableString *message_ids = [NSMutableString string];
            for (NSInteger i = 0; i < self.sysCellDataAry.count; i++) {
                ICEModelSysMess *model = self.sysCellDataAry[i];
                [message_ids appendString:model.message_id];
                if (i < (self.sysCellDataAry.count - 1))  [message_ids appendString:@","];
            }
            [self postDeleteInfo:message_ids];
            [self.sysCellDataAry removeAllObjects];
            [self.tableView reloadData];
            [self.tableView.header beginRefreshing];
        }
    }];
    [alertView show];
}

/** 设置通知栏小红点 */
- (void)configTabBarItem:(NSNotification *)noti {
    NSNumber *show = noti.object;
    UISegmentedControl *contrl = (UISegmentedControl *)self.navigationItem.titleView;
    contrl.badgeCenterOffset = CGPointMake(8, 8);
    if ([show boolValue]) {
        [contrl showBadge];
    }
    [self.tableView.header beginRefreshing];
}

//- (void)Selectbutton:(UISegmentedControl *)segment {
//    NSInteger Index = segment.selectedSegmentIndex;
//    switch (Index) {
//        case 0: {
//            DLog(@"消息");
//            [self.view insertSubview:self.sysTableView atIndex:0];
//            self.navigationItem.rightBarButtonItem = nil;
//        }  break;
//        case 1: {
//            DLog(@"系统");
//            [self.view insertSubview:self.sysTableView atIndex:999];
//            [self.sysTableView.header beginRefreshing];
//            UISegmentedControl *contrl = (UISegmentedControl *)self.navigationItem.titleView;
//            [contrl clearBadge];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotiTabBarItemShowNumSS object:nil];
//            // 显示右上角的 一键删除系统消息 按钮
//            if (self.sysCellDataAry.count > 0) {
//                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全删" style:UIBarButtonItemStyleDone target:self action:@selector(deleteAllSysMessClick)];
//            }
//        } break;
//        default: break;
//    }
//}

//- (void)configSysTableView {
//    self.sysTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, __kScreenWidth, __kScreenHeight - 68)];
//    self.sysTableView.tableFooterView = [[UIView alloc] init];
//    self.sysTableView.delegate = self;
//    self.sysTableView.dataSource = self;
//    [self.view addSubview:self.sysTableView];
//    [self.view insertSubview:self.sysTableView atIndex:0];
//    [self.sysTableView registerCellByNibName:@"ICESysMessTableViewCell"];
//    __weak __typeof(self) weakSelf = self;
//    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//    self.sysTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadNetData:YES];
//    }];
//    // 马上进入刷新状态
//    [self.sysTableView.header beginRefreshing];
//    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//    self.sysTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf loadNetData:NO];
//    }];
//}

- (void)loadNetData:(BOOL)isUp {
//    UISegmentedControl *contrl = (UISegmentedControl *)self.navigationItem.titleView;
//    if (contrl.selectedSegmentIndex == 1) {
//        [contrl clearBadge];
//    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiTabBarItemShowNumSS object:nil];
//    
//    if (isUp) {
//        _pageIndex = 1;
//    } else {
//        _pageIndex++;
//    }
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"page" : @(_pageIndex) }];
//    RACSignal *sign = [ICEImporter getMessagesWithParams:params];
//    [sign subscribeNext:^(id x) {
//        if ((_pageIndex-1) < [x[@"data"][@"count_page"] integerValue]) {
//            if (isUp) {
//                [self.sysCellDataAry removeAllObjects];
//            }
//            NSArray *array = [ICEModelSysMess mj_objectArrayWithKeyValuesArray:x[@"data"][@"messages"]];
//            [self.sysCellDataAry addObjectsFromArray:array];
//            [self.tableView reloadData];
//        }
//        [self.tableView endRefresh];
//    } error:^(NSError *error) {
//        [self.tableView endRefresh];
//    }];
    
    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    
    NSLog(@"..%@", conversations);
    
    
    [self loadSysMegData];
    
    [self.tableView endRefresh];
    
}

@end
