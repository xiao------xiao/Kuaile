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

#import "MainTabViewController.h"

#import "UIViewController+HUD.h"
#import "ChatListViewController.h"
#import "ContactsViewController.h"
#import "ApplyViewController.h"
#import "ChatViewController.h"
#import "EMCDDeviceManager.h"
#import "RobotManager.h"
#import <ShareSDK/ShareSDK.h>

//------------------------------------------------------------------------
#import "ZYHomeViewController.h"
#import "ICEMySelfViewController.h"
#import "ICEFindViewController.h"
#import "TZFindHomeController.h"
#import "WZLBadgeImport.h"
#import "TZJobListViewController.h"
#import "TZJobListScreeningView.h"
#import "ICESysInfoViewController.h"
#import "XYUserInfoModel.h"
#import "XYRecommendFriendModel.h"
#import "TZJobDetailViewController.h"
#import <ShareSDK+InterfaceAdapter.h>
#import <AddressBookUI/AddressBookUI.h>
#import "EMCallManagerDelegate.h"
//------------------------------------------------------------------------

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface MainTabViewController () <UIAlertViewDelegate, IChatManagerDelegate, EMCallManagerDelegate> {
    ContactsViewController *_contactsVC;  //朋友界面
    ChatListViewController *_chatListVC;    //消息界面
    //---------------------------------------------------------------------------
    // 主页视图控制器
    ZYHomeViewController *_tZHomePage;  //主页面
    ICEMySelfViewController *_iCEMySelf; //我的界面
    TZFindHomeController *_iCEFind;  //发现界面
    //---------------------------------------------------------------------------
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation MainTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = NSLocalizedString(@"title.conversation", @"Conversations");
    
    // 获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    // [self didUnreadMessagesCountChanged];
#warning 把self注册为SDK的delegate
    [self registerNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callOutWithChatter:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callControllerClose:) name:@"callControllerClose" object:nil];
    [mNotificationCenter addObserver:self selector:@selector(mainMessagecChanged:) name:kNotiSysMessageListchange object:nil];
    [mNotificationCenter addObserver:self selector:@selector(mainMessagecChanged:) name:kNotiSysMessageListchangeJump object:nil];

    // 保存图片失败/成功的通知
    [mNotificationCenter addObserver:self selector:@selector(didSaveImageSuccess) name:@"didSaveImageSuccess" object:nil];
    [mNotificationCenter addObserver:self selector:@selector(didSaveImageFailure) name:@"didSaveImageFailure" object:nil];
    
    //登录成功
    [mNotificationCenter addObserver:self selector:@selector(didLoginSuccess) name:@"kICELoginSuccessNotificationName" object:nil];
    // 设置4个标签栏视图控制器
    [self setupSubviews];
    self.selectedIndex = 0;
    
    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
    
    [self configTabBarItemNoti];
    
    NSString *session1 = [mUserDefaults objectForKey:@"sessionid"];
    //同步个人信息
    [TZUserManager syncUserModel];
    //同步公司福利
    [TZUserManager syncCompanyWelfare];
    // 生活服务城市
    [TZUserManager syncCityModelArray];
    //版本gengxin
    [TZUserManager syncAppVersion];
    
    
    if (![TZUserManager isLoginNoPresent]) {
        UIApplication *application = [UIApplication sharedApplication];
        [application setApplicationIconBadgeNumber:0];
        _chatListVC.tabBarItem.badgeValue = nil;

    }
    
}

- (void)didLoginSuccess {
    //同步个人信息
    [TZUserManager syncUserModel];
    // 用户佣金余额
    [TZUserManager syncUserCommission];
}

- (void)didSaveImageSuccess {
    [[UIViewController currentViewController] showInfo:@"图片已保存到本机相册"];
}

- (void)didSaveImageFailure {
    [[UIViewController currentViewController] showInfo:@"图片保存失败"];
}

- (void)dealloc {
    [self unregisterNotifications];
    [mNotificationCenter removeObserver:self];
}

- (void)mainMessagecChanged:(NSNotification *)notif {
    
    
    [self setupUnreadMessageCount];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 99) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            } onQueue:nil];
        }
    } else if (alertView.tag == 100) { // 账号在其他地方登陆，注销回主页
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        // 注销掉第三方登录授权
        ShareType shareType = [[mUserDefaults objectForKey:@"ShareType"] intValue];
        [ShareSDK cancelAuthWithType:shareType];
        self.selectedIndex = 0;
        [self.selectedViewController popViewControllerAnimated:YES];
    } else if (alertView.tag == 101) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

#pragma mark - private

- (void)registerNotifications {
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications {
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)configTabBarItemNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configTabBarItem:) name:kNotiTabBarItemShowNum object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configTabBarItemSS:) name:kNotiTabBarItemShowNumSS object:nil];
}

/** 设置通知栏小红点 */
- (void)configTabBarItem:(NSNotification *)noti {
//    NSNumber *show = noti.object;
//    UITabBarItem *firstItem = self.tabBar.items[3];
//    firstItem.badgeCenterOffset = CGPointMake(-50, 8);
//    if ([show boolValue]) {
//        [firstItem showBadge];
//    }
}

- (void)configTabBarItemSS:(NSNotification *)noit {
    UITabBarItem *item = self.tabBar.items[3];
    [item clearBadge];
}

// 配置底部标签栏
- (void)setupSubviews {
    // 主页视图控制器
    _tZHomePage = [[ZYHomeViewController alloc] init];
//    [self addChildVc:_tZHomePage title:NSLocalizedString(@"title.homePage", @"HomePage") image:@"home_def" selectedImage:@"home_sel" tag:0];
    [self addChildVc:_tZHomePage title:NSLocalizedString(@"首页", @"首页") image:@"home_def" selectedImage:@"home_sel" tag:0];
    // 通讯录
    _contactsVC = [[ContactsViewController alloc] init];
//    [self addChildVc:_contactsVC title:NSLocalizedString(@"title.addressbook", @"AddressBook") image:@"friend_def" selectedImage:@"friend_sel" tag:1];
    [self addChildVc:_contactsVC title:NSLocalizedString(@"朋友", @"朋友") image:@"friend_def" selectedImage:@"friend_sel" tag:1];
    // 发现
    _iCEFind = [[TZFindHomeController alloc] init];
    [self addChildVc:_iCEFind title:nil image:@"find_def" selectedImage:@"find_sel" tag:1];
    _iCEFind.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    // 消息
    _chatListVC = [[ChatListViewController alloc] init];
//    [self addChildVc:_chatListVC title:NSLocalizedString(@"title.conversation", @"conversation") image:@"message_def" selectedImage:@"message_sel" tag:2];
    [self addChildVc:_chatListVC title:NSLocalizedString(@"消息", @"消息") image:@"message_def" selectedImage:@"message_sel" tag:2];
    // 个人中心
    _iCEMySelf = [[ICEMySelfViewController alloc] init];
//    [self addChildVc:_iCEMySelf title:NSLocalizedString(@"title.mySelf", @"MySelf") image:@"me_def" selectedImage:@"me_sel" tag:3];
    [self addChildVc:_iCEMySelf title:NSLocalizedString(@"我的", @"我的") image:@"me_def" selectedImage:@"me_sel" tag:3];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage tag:(NSInteger)tag {
    childVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:tag];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:12], NSFontAttributeName,kCOLOR_WENZHI,NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:12],
                                        NSFontAttributeName,kCOLOR_MAIN,NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateSelected];
    TZNaviController *nav = [[TZNaviController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

// 统计未读消息数
- (void)setupUnreadMessageCount {
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (EMConversation *conversation in conversations) {
        if (![igGroupIds containsObject:conversation.chatter]) {
            unreadCount += conversation.unreadMessagesCount;
        }
    }
//    unreadCount = 23;
    
    unreadCount += [[mUserDefaults objectForKey:@"unread"] integerValue];
    
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)setupUntreatedApplyCount {
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    if (_contactsVC) {
        if (unreadCount > 0) {
            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _contactsVC.tabBarItem.badgeValue = nil;
        }
    }
}

- (void)networkChanged:(EMConnectionState)connectionState {
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

- (void)didLogoutSuccess {
    self.selectedIndex = 0;
}

#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList {
    [self setupUnreadMessageCount];
    [_chatListVC refreshDataSource];
}

// 未读消息数量变化回调
- (void)didUnreadMessagesCountChanged {
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages {
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineCmdMessages {
    
}

- (BOOL)needShowNotification:(NSString *)fromChatter {
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}

// 收到消息回调
- (void)didReceiveMessage:(EMMessage *)message {
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    
    [mNotificationCenter postNotificationName:@"kMessageBarNotification" object:nil];
    
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                [self playSoundAndVibration];  break;
            case UIApplicationStateInactive:
                [self playSoundAndVibration];  break;
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message]; break;
            default: break;
        }
#endif
    }
}

- (void)didReceiveCmdMessage:(EMMessage *)message {
    // [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    // 保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message {
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    // 发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; // 触发通知的时间
    
    if (options) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text: {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }  break;
            case eMessageBodyType_Image: {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }  break;
            case eMessageBodyType_Location: {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            } break;
            case eMessageBodyType_Voice: {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            } break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            } break;
            default: break;
        }
        
        NSString *title = [TZEaseMobManager nickNameWithUsername:message.from];
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    NSString *groupSenderName = [TZEaseMobManager nickNameWithUsername:message.groupSenderName];
                    NSString *strMess = groupSenderName;
                    if ([ICETools isMobileNumber:groupSenderName]) {
                        strMess = [NSString stringWithFormat:@"%@****%@", [message.groupSenderName substringToIndex:3], [message.groupSenderName substringFromIndex:8]];
                    }
                    title = [NSString stringWithFormat:@"%@(%@)", strMess, group.groupSubject];
                    break;
                }
            }
        }  else if (message.messageType == eMessageTypeChatRoom)  {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName) {
                NSString *strMess = message.groupSenderName;
                if ([ICETools isMobileNumber:message.groupSenderName]) {
                    strMess = [NSString stringWithFormat:@"%@****%@", [message.groupSenderName substringToIndex:3], [message.groupSenderName substringFromIndex:8]];
                }
                title = [NSString stringWithFormat:@"%@(%@)", strMess, chatroomName];
            }
        }
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    } else{
        // notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
        return;
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    // 发送通知
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    if (error) {
        NSString *hintText = NSLocalizedString(@"reconnection.retry", @"Fail to log in your account, is try again... \nclick 'logout' button to jump to the login page \nclick 'continue to wait for' button for reconnection successful");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"reconnection.wait", @"continue to wait")
                                                  otherButtonTitles:NSLocalizedString(@"logout", @"Logout"),
                                  nil];
        alertView.tag = 99;
        [alertView show];
        [_chatListVC isConnect:NO];
    }
}

#pragma mark - IChatManagerDelegate 好友变化

- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message {
    
#pragma mark ---- 接受到好友申请直接同意加好友，不能拒绝加好友请求
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
    if (isSuccess && !error) {
        NSLog(@"发送同意成功");
        // 获取个人信息
        [TZHttpTool postWithURL:ApiGetPerson params:@{@"username" : username} success:^(NSDictionary *result) {
            XYRecommendFriendModel *infoModel = [XYRecommendFriendModel mj_objectWithKeyValues:result[@"data"]];
            [[ApplyViewController shareController] didAddNewApply:infoModel];
        } failure:^(NSString *msg) {
            
        }];
    }
    

#pragma mark ----- 接收到好友申请需要用户同意，用户可以拒绝
//    if (!message) {
//        message = [NSString stringWithFormat:@"备注:无"];
//    } else {
//        message = [NSString stringWithFormat:@"备注:%@",message];
//    }
//    [[ICEImporter getPerson:username] subscribeNext:^(NSDictionary *result) {
//        [self playSoundAndVibration];
//        NSString *content = nil;
//        NSDictionary *dic;
//        if ([result[@"status"] isEqual:@(1)]) {
//            NSString *nickname = result[@"data"][@"nickname"];
//            content = [NSString stringWithFormat:@"%@ 申请加你为好友",nickname];
//            dic = @{@"title":nickname, @"username":username, @"applyMessage":[NSString stringWithFormat:@"%@ %@",content,message],@"avatar":result[@"data"][@"avatar"], @"applyStyle":@(ApplyStyleFriendResult)};
//        } else {
//            content = [NSString stringWithFormat:@"%@ 申请加你为好友",username];
//            dic = @{@"title":username, @"username":username, @"applyMessage":[NSString stringWithFormat:@"%@ %@",content,message], @"applyStyle":@(ApplyStyleFriendResult)};
//        }
//        [[ApplyViewController shareController] addNewApply:dic];
//        [_contactsVC reloadApplyView];
//        [self setupUntreatedApplyCount];
//    }];
}

- (void)_removeBuddies:(NSArray *)userNames
{
    [[EaseMob sharedInstance].chatManager removeConversationsByChatters:userNames deleteMessages:YES append2Chat:YES];
    [_chatListVC refreshDataSource];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    ChatViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[ChatViewController class]] && [userNames containsObject:[(ChatViewController *)viewController chatter]])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    if (chatViewContrller) {
        [viewControllers removeObject:chatViewContrller];
        [self.navigationController setViewControllers:viewControllers animated:YES];
    }
}

- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd {
    if (!isAdd) {
        NSMutableArray *deletedBuddies = [NSMutableArray array];
        for (EMBuddy *buddy in changedBuddies) {
            if ([buddy.username length]) {
                [deletedBuddies addObject:buddy.username];
            }
        }
        if (![deletedBuddies count]) {
            return;
        }
        
        [self _removeBuddies:deletedBuddies];
    } else {
        // clear conversation
        NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
        NSMutableArray *deleteConversations = [NSMutableArray arrayWithArray:conversations];
        NSMutableDictionary *buddyDic = [NSMutableDictionary dictionary];
        for (EMBuddy *buddy in buddyList) {
            if ([buddy.username length]) {
                [buddyDic setObject:buddy forKey:buddy.username];
            }
        }
        for (EMConversation *conversation in conversations) {
            if (conversation.conversationType == eConversationTypeChat) {
                if ([buddyDic objectForKey:conversation.chatter]) {
                    [deleteConversations removeObject:conversation];
                }
            } else {
                [deleteConversations removeObject:conversation];
            }
        }
        if ([deleteConversations count] > 0) {
            NSMutableArray *deletedBuddies = [NSMutableArray array];
            for (EMConversation *conversation in deleteConversations) {
                if (![[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
                    [deletedBuddies addObject:conversation.chatter];
                }
            }
            if ([deletedBuddies count] > 0) {
                [self _removeBuddies:deletedBuddies];
            }
        }
    }
    [_contactsVC reloadDataSource];
}

- (void)didRemovedByBuddy:(NSString *)username {
    [self _removeBuddies:@[username]];
    [_contactsVC reloadDataSource];
}

- (void)didAcceptedByBuddy:(NSString *)username {
    [_contactsVC reloadDataSource];
    // 获取个人信息
    [TZHttpTool postWithURL:ApiGetPerson params:@{@"username" : username} success:^(NSDictionary *result) {
        XYRecommendFriendModel *infoModel = [XYRecommendFriendModel mj_objectWithKeyValues:result[@"data"]];
        [[ApplyViewController shareController] didAddNewApply:infoModel];
    } failure:^(NSString *msg) {
        
    }];
    
//    [[ICEImporter getPerson:username] subscribeNext:^(NSDictionary *result) {
//        [self playSoundAndVibration];
//        NSString *message = nil;
//        NSDictionary *dic;
//        if ([result[@"status"] isEqual:@(1)]) {
//            NSString *nickname = result[@"data"][@"nickname"];
//            message = [NSString stringWithFormat:@"%@ 同意了你的好友请求",nickname];
//            dic = @{@"title":nickname, @"username":username, @"applyMessage":message,@"avatar":result[@"data"][@"avatar"], @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriendResult]};
//        } else {
//            message = [NSString stringWithFormat:@"%@ 同意了你的好友请求",username];
//            dic = @{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriendResult]};
//        }
//        [[ApplyViewController shareController] addNewApply:dic];
//        [_contactsVC reloadApplyView];
//        [self setupUntreatedApplyCount];
//    }];
}
#pragma mark --- 因为不需要用户处理好友申请了，所以就不需要下面的代理方法了
//- (void)didRejectedByBuddy:(NSString *)username {
//    [[ICEImporter getPerson:username] subscribeNext:^(NSDictionary *result) {
//        [self playSoundAndVibration];
//        NSString *message = nil;
//        NSDictionary *dic;
//        if ([result[@"status"] isEqual:@(1)]) {
//            NSString *nickname = result[@"data"][@"nickname"];
//            message = [NSString stringWithFormat:@"%@ 拒绝了你的好友请求",nickname];
//            dic = @{@"title":nickname, @"username":username, @"applyMessage":message,@"avatar":result[@"data"][@"avatar"], @"applyStyle":@(ApplyStyleFriendResult)};
//        } else {
//            message = [NSString stringWithFormat:@"%@ 拒绝了你的好友请求",username];
//            dic = @{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":@(ApplyStyleFriendResult)};
//        }
//        [[ApplyViewController shareController] addNewApply:dic];
//        [_contactsVC reloadApplyView];
//        [self setupUntreatedApplyCount];
//    }];
//}

- (void)didAcceptBuddySucceed:(NSString *)username
{
    [_contactsVC reloadDataSource];
}

#pragma mark - IChatManagerDelegate 群组变化

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
#endif
    
    [_contactsVC reloadGroupView];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!error) {
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
#endif
        [_contactsVC reloadGroupView];
    }
}

- (void)didReceiveGroupRejectFrom:(NSString *)groupId
                          invitee:(NSString *)username
                           reason:(NSString *)reason
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.beRefusedToAdd", @"you are shameless refused by '%@'"), username];
    TTAlertNoTitle(message);
}


- (void)didReceiveAcceptApplyToJoinGroup:(NSString *)groupId
                               groupname:(NSString *)groupname
{
//    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed to join the group of \'%@\'"), groupname];
//    [self showHint:message];
}

#pragma mark - IChatManagerDelegate 收到聊天室邀请

- (void)didReceiveChatroomInvitationFrom:(NSString *)chatroomId inviter:(NSString *)username message:(NSString *)message {
    message = [NSString stringWithFormat:NSLocalizedString(@"chatroom.somebodyInvite", @"%@ invite you to join chatroom \'%@\'"), username, chatroomId];
    [self showHint:message];
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 100;
        alertView.delegate = self;
        [alertView show];
        
    } onQueue:nil];
}

- (void)didRemovedFromServer {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
    } onQueue:nil];
}

- (void)didServersChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)didAppkeyChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
        } else {
            [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
        }
    }
}

#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        [chatController hideImagePicker];
    }
//    else if(_chatListVC)
//    {
//        [self.navigationController popToViewController:self animated:NO];
//        [self setSelectedViewController:_chatListVC];
//    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMMessageType)type
{
    EMConversationType conversatinType = eConversationTypeChat;
    switch (type) {
        case eMessageTypeChat:
            conversatinType = eConversationTypeChat;
            break;
        case eMessageTypeGroupChat:
            conversatinType = eConversationTypeGroupChat;
            break;
        case eMessageTypeChatRoom:
            conversatinType = eConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(NSDictionary *)userInfo {
    TZNaviController *naviVc = (TZNaviController *)self.selectedViewController;
    if (userInfo[@"payload"]) {
        userInfo = userInfo[@"payload"];
    }
    if (userInfo) {
        // 求职意向的推送
        if ([[userInfo objectForKey:@"class"] integerValue] > 0) {
            DLog(@"您关注的求职意向有消息了");
            TZJobListViewController *jobListVc = [[TZJobListViewController alloc] init];
            jobListVc.type = TZJobListViewControllerTypeNoti;
            jobListVc.salary = [userInfo objectForKey:@"salary"];
            jobListVc.laid = [userInfo objectForKey:@"class"];
            jobListVc.address = [userInfo objectForKey:@"address"];
            jobListVc.isFromHotJob = [[userInfo objectForKey:@"is_hot"] boolValue];
            [jobListVc showBack];
            TZNaviController *vCtrl = [[TZNaviController alloc] initWithRootViewController:jobListVc];
            [self presentViewController:vCtrl animated:YES completion:nil];
            return;
            // 抽奖提醒 系统消息
        } else if ([[userInfo objectForKey:@"title"] isEqualToString:@"抽奖提醒"] || [[userInfo objectForKey:@"title"] isEqualToString:@"系统消息"] || [[userInfo objectForKey:@"title"] isEqualToString:@"限时抢购"]  || [[userInfo objectForKey:@"title"] isEqualToString:@"积分兑换"]) {
            self.selectedIndex = 3;
//            [_chatListVC selectSystemNewsSegment];
            ICESysInfoViewController *iCESysInfo = [[ICESysInfoViewController alloc] init];
            iCESysInfo.strSysInfo = userInfo[@"content"];
            TZNaviController *vCtrl = [[TZNaviController alloc] initWithRootViewController:iCESysInfo];
            [self presentViewController:vCtrl animated:YES completion:nil];
            return;
        } else if ([[userInfo objectForKey:@"title"] isEqualToString:@"职位推荐"]) {
            NSString *is_mess = userInfo[@"is_mess"];
            if ([is_mess rangeOfString:@","].location != NSNotFound) { // 有多个职位，去列表页
                TZJobListViewController *jobListVc = [[TZJobListViewController alloc] init];
                jobListVc.type = TZJobListViewControllerTypeGetui;
                jobListVc.is_mess = [userInfo objectForKey:@"is_mess"];
                [jobListVc showBack];
                TZNaviController *vCtrl = [[TZNaviController alloc] initWithRootViewController:jobListVc];
                [self presentViewController:vCtrl animated:YES completion:nil];
                return;
            } else { // 单个职位，去详情页
                // 跳转到详情控制器
                TZJobDetailViewController *detailVc = [[TZJobDetailViewController alloc] init];
                detailVc.recruit_id = is_mess;
                [detailVc showBack];
                TZNaviController *vCtrl = [[TZNaviController alloc] initWithRootViewController:detailVc];
                [self presentViewController:vCtrl animated:YES completion:nil];
                return;
            }
        }
        if (!userInfo[kConversationChatter]) return;
        // 会话消息
        self.selectedIndex = 3;
        naviVc = (TZNaviController *)self.selectedViewController;
//        [_chatListVC selectConversationSegment];
        if ([naviVc.topViewController isKindOfClass:[ChatViewController class]]) {
            ChatViewController *chatController = (ChatViewController *)naviVc.topViewController;
            [chatController hideImagePicker];
        } else {
            // push当前会话的控制器
            [naviVc popToRootViewControllerAnimated:NO];
            NSString *conversationChatter = userInfo[kConversationChatter];
            EMMessageType messageType = [userInfo[kMessageType] intValue];
            ChatViewController *chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
            switch (messageType) {
                case eMessageTypeGroupChat: {
                    NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                    for (EMGroup *group in groupArray) {
                        if ([group.groupId isEqualToString:conversationChatter]) {
                            chatViewController.title = group.groupSubject; break;
                        }
                    }
                } break;
                default: chatViewController.title = conversationChatter;  break;
            }
            [naviVc pushViewController:chatViewController animated:NO];
        }
    } else if (_chatListVC) {
        self.selectedIndex = 3;
    }
}

@end
