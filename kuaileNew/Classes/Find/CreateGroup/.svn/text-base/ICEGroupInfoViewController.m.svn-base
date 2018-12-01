//
//  ICEGroupInfoViewController.m
//  kuaile
//
//  Created by ttouch on 15/10/21.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICEGroupInfoViewController.h"
#import "ContactSelectionViewController.h"
#import "ContactView.h"
#import "ICEModelGroupInfo.h"
#import "ICEUserInfoViewController.h"
#import "ChatViewController.h"
#import "MJPhotoBrowser.h"

#define kColOfRow 3
#define kContactSize 60

@interface ICEGroupInfoViewController () <IChatManagerDelegate, EMChooseViewDelegate, UIActionSheetDelegate>

@property (nonatomic) ICEGroupOccupantType occupantType;
@property (strong, nonatomic) EMGroup *chatGroup;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *chatButton;
@property (strong, nonatomic) UIButton *exitButton;
@property (strong, nonatomic) UIButton *joinButton;
@property (strong, nonatomic) UIButton *dissolveButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *addButton;

@property (nonatomic, strong) ICEModelGroupInfo *modelGroupInfo;
@end

@implementation ICEGroupInfoViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)configRigthItem {
    self.labGroupName.enabled = NO;
    self.labGroupDesc.enabled = NO;
    self.labGroupAddress.userInteractionEnabled = NO;
    self.imgViewGroupHead.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(actionRightItem)];
}
- (void)actionRightItem {
    self.labGroupName.enabled = YES;
    self.labGroupDesc.enabled = YES;
    self.labGroupAddress.userInteractionEnabled = YES;
    self.imgViewGroupHead.userInteractionEnabled = YES;
    for (ContactView *contactView in self.scrollView.subviews) {
        if ([contactView isKindOfClass:[ContactView class]]) {
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
            if (![contactView.remark isEqualToString:loginUsername]) {
                contactView.editing = YES;
            }
        }
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(actionRightItemTwo)];
    [self.labGroupName becomeFirstResponder];
}

- (void)actionRightItemTwo {
    [self configRigthItem];
    [self updateNewCroupInfo];
    for (ContactView *contactView in self.scrollView.subviews) {
        if ([contactView isKindOfClass:[ContactView class]]) {
            contactView.editing = NO;
        }
    }
}

- (IBAction)tapImage:(id)sender {
    [self configGroupImage];
}

- (void)configGroupImage {
    [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
        self.imgViewGroupHead.image = editedImage;
    }];
}

- (void)updateNewCroupInfo {
    NSDictionary *param = @{
                            @"group_id":self.chatGroup.groupId,
                            @"owner":self.labGroupName.text,
                            @"desc":self.labGroupDesc.text,
                            @"address":self.labGroupAddress.text,
                            };
    
    
    NSArray *file = @[
                      @{
                          @"file":self.imgViewGroupHead.image,
                          @"name":@"avatar.png",
                          @"key":@"avatar"
                          }
                      ];
    [ICEImporter uploadFilesWithUrl:ApiEditGroup params:param files:file];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:NO];
}

- (int)getNum {
    if (__kScreenWidth == 320) {
        return 3;
    } else if (__kScreenWidth == 375) {
        return 4;
    } else {
        return 5;
    }
}

- (void)registerNotifications {
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications {
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil group:(EMGroup *)chatGroup {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self = [self initWithGroup:chatGroup];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil groupID:(NSString *)chatGroupID {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self = [self initWithGroupId:chatGroupID];
    }
    return self;
}

- (instancetype)initWithGroup:(EMGroup *)chatGroup {
    self = [super init];
    if (self) {
        _chatGroup = chatGroup;
        _dataSource = [NSMutableArray array];
        _occupantType = ICEGroupOccupantTypeMember;
        [self registerNotifications];
    }
    return self;
}

- (instancetype)initWithGroupId:(NSString *)chatGroupId {
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:chatGroupId]) {
            chatGroup = group; break;
        }
    }
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:chatGroupId];
    }
    
    self = [self initWithGroup:chatGroup];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群资料";
    
    [self.viewGroupPeople addSubview:self.scrollView];
    [self.view addSubview:self.footerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupBansChanged) name:@"GroupBansChanged" object:nil];
    [self fetchGroupInfo];
    [self loadNetData];
}

- (void)fetchGroupInfo {
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_chatGroup.groupId completion:^(EMGroup *group, EMError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!error) {
                weakSelf.chatGroup = group;
                [weakSelf reloadDataSource];
            } else {
                [weakSelf showHint:error.description];
            }
        });
    } onQueue:nil];
}

- (ICEModelGroupInfo *)modelGroupInfo {
    if (_modelGroupInfo == nil) {
        _modelGroupInfo = [[ICEModelGroupInfo alloc] init];
    }
    return _modelGroupInfo;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, kContactSize)];
        _scrollView.tag = 0;
        
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kContactSize - 10, kContactSize - 10)];
        [_addButton setImage:[UIImage imageNamed:@"group_participant_add"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"group_participant_addHL"] forState:UIControlStateHighlighted];
        [_addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scrollView;
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] init];
        _footerView.frame = CGRectMake(0, __kScreenHeight - 50 - 64, __kScreenWidth, 50);
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __kScreenHeight, 1)];
        lineView.backgroundColor = __kColorFromRGB(0xDDDDDD);
        [_footerView addSubview:lineView];
        if (self.occupantType == ICEGroupOccupantTypeOwner) {
            [_footerView addSubview:self.chatButton];
            [_footerView addSubview:self.dissolveButton];
            [self configRigthItem];
        } else if (self.occupantType == ICEGroupOccupantTypeJoin) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(settingBtnClick)];
            [_footerView addSubview:self.joinButton];
        } else  {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(settingBtnClick)];
            [_footerView addSubview:self.chatButton];
            [_footerView addSubview:self.exitButton];
        }
    }
    return _footerView;
}

- (UIButton *)dissolveButton {
    if (_dissolveButton == nil) {
        _dissolveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dissolveButton.layer.cornerRadius = 5;
        _dissolveButton.layer.masksToBounds = YES;
        _dissolveButton.frame = CGRectMake(  __kScreenWidth/2.0+(__kScreenWidth/2-100)/2.0 , (50-33)/2.0, 100, 33);
        [_dissolveButton setTitle:NSLocalizedString(@"group.destroy", @"dissolution of the group") forState:UIControlStateNormal];
        [_dissolveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dissolveButton addTarget:self action:@selector(dissolveAction) forControlEvents:UIControlEventTouchUpInside];
        [_dissolveButton setBackgroundColor:__kColorFromRGB(0xFF896F)];
    }
    return _dissolveButton;
}

- (UIButton *)chatButton {
    if (_chatButton == nil) {
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chatButton.layer.cornerRadius = 5;
        _chatButton.layer.masksToBounds = YES;
        _chatButton.frame = CGRectMake((__kScreenWidth/2.0-100)/2.0, (50-33)/2.0, 100, 33);
        [_chatButton setTitle:NSLocalizedString(@"发送消息", @"发送消息") forState:UIControlStateNormal];
        [_chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_chatButton addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
        [_chatButton setBackgroundColor:__kColorFromRGB(0x50B2F5)];
    }
    return _chatButton;
}

- (UIButton *)exitButton {
    if (_exitButton == nil) {
        _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitButton.layer.cornerRadius = 5;
        _exitButton.layer.masksToBounds = YES;
        _exitButton.frame = CGRectMake(  __kScreenWidth/2.0+(__kScreenWidth/2-100)/2.0 , (50-33)/2.0, 100, 33);
        [_exitButton setTitle:NSLocalizedString(@"group.leave", @"quit the group") forState:UIControlStateNormal];
        [_exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
        [_exitButton setBackgroundColor:__kColorFromRGB(0xFF896F)];
    }
    return _exitButton;
}

- (UIButton *)joinButton {
    if (_joinButton == nil) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinButton.layer.cornerRadius = 5;
        _joinButton.layer.masksToBounds = YES;
        _joinButton.frame = CGRectMake((__kScreenWidth-200)/2.0, (50-33)/2.0, 200, 33);
        [_joinButton setTitle:NSLocalizedString(@"group.join", @"join the group") forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_joinButton addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
        [_joinButton setBackgroundColor:__kColorFromRGB(0x50B2F5)];
    }
    return _joinButton;
}

// 加入群组聊天
- (void)chatAction {
    NSLog(@"群组聊天");
    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:_chatGroup.groupId isAttented:NO isGroup:YES];
    chatController.title = _chatGroup.groupSubject;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)goToUserInfo:(UITapGestureRecognizer *)tapGest {
    ContactView *contactView = (ContactView *)tapGest.view;
    ICEUserInfoViewController *iCEUserInfo = [[ICEUserInfoViewController alloc] init];
    iCEUserInfo.userName = contactView.remark;
    [self.navigationController pushViewController:iCEUserInfo animated:YES];
}

- (void)addContact:(id)sender {
    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] initWithBlockSelectedUsernames:_chatGroup.occupants];
    selectionController.delegate = self;
    [self.navigationController pushViewController:selectionController animated:YES];
}

#pragma mark - EMChooseViewDelegate
- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources {
    NSInteger maxUsersCount = _chatGroup.groupSetting.groupMaxUsersCount;
    if (([selectedSources count] + _chatGroup.groupOccupantsCount) > maxUsersCount) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"group.maxUserCount", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    [self showHudInView:self.view hint:NSLocalizedString(@"group.addingOccupant", @"add a group member...")];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *source = [NSMutableArray array];
        for (EMBuddy *buddy in selectedSources) {
            [source addObject:buddy.username];
        }
        
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
        NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join group \'%@\'"), username, weakSelf.chatGroup.groupSubject];
        EMError *error = nil;
        weakSelf.chatGroup = [[EaseMob sharedInstance].chatManager addOccupants:source toGroup:weakSelf.chatGroup.groupId welcomeMessage:messageStr error:&error];
        if (!error) {
            [weakSelf reloadDataSource];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                [weakSelf showHint:error.description];
            });
        }
    });
    
    return YES;
}

- (void)reloadDataSource {
    [self.dataSource removeAllObjects];
    
    self.occupantType = ICEGroupOccupantTypeMember;
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if ([self.chatGroup.owner isEqualToString:loginUsername]) {
        self.occupantType = ICEGroupOccupantTypeOwner;
    }
    
    if (self.occupantType != ICEGroupOccupantTypeOwner) {
        for (NSString *str in self.chatGroup.members) {
            if ([str isEqualToString:loginUsername]) {
                self.occupantType = ICEGroupOccupantTypeMember;  break;
            }
        }
    }
    
    if (![self isJoined:self.chatGroup]) {
        self.occupantType = ICEGroupOccupantTypeJoin;
    }
    
    [self.dataSource addObjectsFromArray:self.chatGroup.occupants];
    
    // 去请求我们服务器存储的昵称
    [TZEaseMobManager syncEaseMobInfoWithModelArray:self.dataSource usernameKey:nil WithCompletion:^(BOOL success) {
        [self refreshUI];
    }];
    [self refreshUI];
}

- (void)refreshUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshScrollView];
        [self refreshFooterView];
        [self hideHud];
    });
}

- (void)refreshScrollView {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.addButton removeFromSuperview];
    
    BOOL showAddButton = NO;
    if (self.occupantType == ICEGroupOccupantTypeOwner) {
        [self.scrollView addSubview:self.addButton];
        showAddButton = YES;
    }
    else if (self.chatGroup.groupSetting.groupStyle == eGroupStyle_PrivateMemberCanInvite && self.occupantType == ICEGroupOccupantTypeMember) {
        [self.scrollView addSubview:self.addButton];
        showAddButton = YES;
    }
    
    int num = [self getNum];
    int tmp = ([self.dataSource count] + 1) % num;
    int row = (int)([self.dataSource count] + 1) / num;
    row += tmp == 0 ? 0 : 1;
    self.scrollView.tag = row;
#warning 陈冰 20151022 scrollView 的高度固定掉
    self.scrollView.frame = CGRectMake(10, 5, __kScreenWidth - 110, 123);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, row * kContactSize);
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    
    int i = 0;
    int j = 0;
    BOOL isEditing = self.addButton.hidden ? YES : NO;
    BOOL isEnd = NO;
    for (i = 0; i < row; i++) {
        for (j = 0; j < num; j++) {
            NSInteger index = i * num + j;
            if (index < [self.dataSource count]) {
                NSString *username = [self.dataSource objectAtIndex:index];
                ContactView *contactView = [[ContactView alloc] initWithFrame:CGRectMake(j * kContactSize, i * kContactSize, kContactSize, kContactSize)];
                contactView.index = i * num + j;
                contactView.remark = username;
                if (![username isEqualToString:loginUsername]) {
                    contactView.editing = isEditing;
                }
                
#warning 陈冰 20151113 添加点击手势
                UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToUserInfo:)];
                [contactView addGestureRecognizer:tapPress];
                // T人的点击事件
                MJWeakSelf
                __weak typeof(contactView) weak_contactView = contactView;
                
                [contactView setDeleteContact:^(NSInteger index) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    __weak typeof(weakSelf) weak_Self = weakSelf;
                    
                    [strongSelf showAlertViewWithMessage:[NSString stringWithFormat:@"确定要移除 %@ 吗？",weak_contactView.nickName] okBtnHandle:^{
                        __strong typeof(weak_Self) strongSelf = weak_Self;
                        [strongSelf showHudInView:strongSelf.view hint:NSLocalizedString(@"group.removingOccupant", @"deleting member...")];
                        NSArray *occupants = [NSArray arrayWithObject:[strongSelf.dataSource objectAtIndex:index]];
                        [[EaseMob sharedInstance].chatManager asyncRemoveOccupants:occupants fromGroup:strongSelf.chatGroup.groupId completion:^(EMGroup *group, EMError *error) {
                            [strongSelf hideHud];
                            if (!error) {
                                strongSelf.chatGroup = group;
                                [strongSelf.dataSource removeObjectAtIndex:index];
                                [strongSelf refreshScrollView];
                            } else{
                                [strongSelf showHint:error.description];
                            }
                        } onQueue:nil];
                    }];
                }];
                [self.scrollView addSubview:contactView];
            } else {
                if(showAddButton && index == self.dataSource.count) {
                    self.addButton.frame = CGRectMake(j * kContactSize + 5, i * kContactSize + 10, kContactSize - 10, kContactSize - 10);
                }
                isEnd = YES;
                break;
            }
        }
        if (isEnd) {
            break;
        }
    }
    //  [self.tableView reloadData];
}

- (void)refreshFooterView {
    if (self.occupantType == ICEGroupOccupantTypeOwner) {
        [self configRigthItem];
        [_exitButton removeFromSuperview];
        [_footerView addSubview:self.chatButton];
        [_footerView addSubview:self.dissolveButton];
    } else if (self.occupantType == ICEGroupOccupantTypeJoin) {
        [_exitButton removeFromSuperview];
        [_chatButton removeFromSuperview];
        
        [_footerView addSubview:self.joinButton];
    } else{
        [_dissolveButton removeFromSuperview];
        
        [_footerView addSubview:self.chatButton];
        [_footerView addSubview:self.exitButton];
    }
}

- (void)groupBansChanged {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:self.chatGroup.occupants];
    [self refreshScrollView];
}

- (void)tapView:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        if (self.addButton.hidden) {
            [self setScrollViewEditing:NO];
        }
    }
}

- (void)setScrollViewEditing:(BOOL)isEditing {
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    
    for (ContactView *contactView in self.scrollView.subviews) {
        if ([contactView isKindOfClass:[ContactView class]]) {
            if ([contactView.remark isEqualToString:loginUsername]) {
                continue;
            }
            [contactView setEditing:isEditing];
        }
    }
    self.addButton.hidden = isEditing;
}

// 解散群组
- (void)dissolveAction {
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"group.destroy", @"dissolution of the group")];
    [[EaseMob sharedInstance].chatManager asyncDestroyGroup:_chatGroup.groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
        [weakSelf hideHud];
        if (error) {
            [weakSelf showHint:NSLocalizedString(@"group.destroyFail", @"dissolution of group failure")];
        } else{
            [self dissolveToSys];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
            [self performSelector:@selector(popViewCtrl) withObject:nil afterDelay:1.5f];
        }
    } onQueue:nil];
    //  [[EaseMob sharedInstance].chatManager asyncLeaveGroup:_chatGroup.groupId];
}

- (void)dissolveToSys {
    NSDictionary *param = @{ @"group_id" : _chatGroup.groupId };
    [TZHttpTool postWithURL:ApiDelGroup params:param success:^(NSDictionary *result) {
        
    } failure:^(NSString *msg) {
        
    }];
}

/// 设置
- (void)settingBtnClick {
    NSString *title = @"开启消息免打扰";
    NSArray *ignoredGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    if ([ignoredGroupIds containsObject:_chatGroup.groupId]) {
        title = @"关闭消息免打扰";
    }
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:title, nil];
    [sheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
       if (x.integerValue == 0) {
            if ([title isEqualToString:@"开启消息免打扰"]) {
                [[EaseMob sharedInstance].chatManager asyncIgnoreGroupPushNotification:_chatGroup.groupId isIgnore:YES];
                [self showInfo:@"开启消息免打扰成功"];
            } else {
                [[EaseMob sharedInstance].chatManager asyncIgnoreGroupPushNotification:_chatGroup.groupId isIgnore:NO];
                [self showInfo:@"关闭消息免打扰成功"];
            }
        }
    }];
    [sheet showInView:self.view];
}

// 退出群组
- (void)exitAction {
//    DLog(@"退出群组");
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"group.leave", @"quit the group")];
    [[EaseMob sharedInstance].chatManager asyncLeaveGroup:_chatGroup.groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
        [weakSelf hideHud];
        if (error) {
            [weakSelf showHint:NSLocalizedString(@"group.leaveFail", @"exit the group failure")];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
            [self performSelector:@selector(popViewCtrl) withObject:nil afterDelay:1.5f];
        }
    } onQueue:nil];
    //  [[EaseMob sharedInstance].chatManager asyncLeaveGroup:_chatGroup.groupId];
}

- (void)didIgnoreGroupPushNotification:(NSArray *)ignoredGroupList error:(EMError *)error {
    // todo
    NSLog(@"ignored group list:%@.", ignoredGroupList);
}

#pragma mark - 获取群资料
- (void)loadNetData {
    RACSignal *sign = [ICEImporter getGroupInfoWith:_chatGroup.groupId];
    [sign subscribeNext:^(id x) {
        self.modelGroupInfo = [ICEModelGroupInfo objectWithKeyValues:x[@"data"]];
        [self loadInfo];
    }];
}

- (void)loadInfo {
    [self.imgViewGroupHead sd_setImageWithURL:[NSURL URLWithString:self.modelGroupInfo.avatar] placeholderImage:[UIImage imageNamed:@"qun"]];
    self.imgViewGroupHead.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageHeadView:)];
    [self.imgViewGroupHead addGestureRecognizer:tap];

    NSString *ownername = [NSString stringWithFormat:@"%@****%@", [_chatGroup.owner substringToIndex:3],[_chatGroup.owner substringFromIndex:7]];
    self.labGroupName.text = self.modelGroupInfo.owner;
    self.labGroupDesc.text = self.modelGroupInfo.desc;
    self.labGroupNum.text = self.modelGroupInfo.group_id;
    self.labGroupAddress.text = self.modelGroupInfo.address;
    self.labGroupHost.text = ownername;
}

/// 点击头像，预览大图
- (void)tapImageHeadView:(UITapGestureRecognizer *)tap {
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.srcImageView = self.imgViewGroupHead;
    photo.url = [NSURL URLWithString:self.modelGroupInfo.avatar];
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    photoBrowser.photos = @[photo];
    [photoBrowser show];
}

#pragma mark - TZJobApplyViewDelegate

- (void)jobApplyDidClickButton {

}

#pragma mark - action

- (BOOL)isJoined:(EMGroup *)group {
    if (group) {
        NSArray *groupList = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *tmpGroup in groupList) {
            if (tmpGroup.isPublic == group.isPublic && [group.groupId isEqualToString:tmpGroup.groupId]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)joinAction {
    [self showMessageAlertView];
}

- (void)showMessageAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"saySomething", @"say somthing") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

#pragma mark - alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        UITextField *messageTextField = [alertView textFieldAtIndex:0];
        
        NSString *messageStr = @"";
        if (messageTextField.text.length > 0) {
            messageStr = messageTextField.text;
        }
        
        [self applyJoinGroup:_chatGroup.groupId withGroupname:_chatGroup.groupSubject message:messageStr];
    }
}

- (void)applyJoinGroup:(NSString *)groupId withGroupname:(NSString *)groupName message:(NSString *)message {
    [self showHudInView:self.view hint:NSLocalizedString(@"group.sendingApply", @"send group of application...")];
    __weak typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncApplyJoinPublicGroup:groupId withGroupname:groupName message:message completion:^(EMGroup *group, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            [weakSelf showHint:NSLocalizedString(@"group.sendApplyRepeat", @"application has been sent")];
            [self performSelector:@selector(popViewCtrl) withObject:nil afterDelay:1.5f];
        }
        else{
            [weakSelf showHint:error.description];
        }
    } onQueue:nil];
}

- (void)popViewCtrl {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendMessageUser:(NSString *)userName {
    ICEUserInfoViewController *userInfoCtrl = [[ICEUserInfoViewController alloc] init];
    userInfoCtrl.userName = userName;
    [self.navigationController pushViewController:userInfoCtrl animated:YES];
}
@end
