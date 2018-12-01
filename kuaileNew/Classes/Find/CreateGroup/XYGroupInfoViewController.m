//
//  XYGroupInfoViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/4/13.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYGroupInfoViewController.h"
#import "XYGroupInfoHeaderCell.h"
#import "XYDetailListCell.h"
#import "XYFoundationCell.h"
#import "XYGroupInfoModel.h"
#import "XYNaviView.h"
#import "TZButtonsHeaderView.h"
#import "ChatViewController.h"
#import "GroupListViewController.h"
#import "ContactView.h"
#import "YYControl.h"
#import "ICESelfInfoViewController.h"
#import "XYCheckGroupMemberController.h"
#import "XYGroupTagViewController.h"
#import "XYGroupMemberAvatarView.h"
#import "XYAvatarHeightConfigTool.h"
#import "ContactSelectionViewController.h"
#import "XYUserInfoModel.h"
#import "XYMapViewController.h"
#import "XYRecommendFriendModel.h"
#import "ChatViewController.h"
#import "ProgressHUD.h"
#import "GroupListViewController.h"
#import "ICECreateGroupViewController.h"


@interface XYGroupInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,IChatManagerDelegate,EMChooseViewDelegate,UIActionSheetDelegate> {
    BOOL _isScreen;
    NSInteger _groupCount;
    BOOL _editedGroupName;
    BOOL _editedGroupDesc;
    BOOL _isDelete;
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) EMGroup *chatGroup;
@property (nonatomic, strong) XYNaviView *navView;
@property (nonatomic, strong) TZButtonsBottomView *bottomView;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, copy) NSString *iconPath;
@property (nonatomic, copy) NSString *bgPath;
@property (nonatomic, assign) NSInteger selTagIndex;
@property (nonatomic, copy) NSString *nature;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *groupDesc;
@property (strong, nonatomic) ICELoginUserModel *loginModel;
@property (nonatomic, assign) CGFloat avatarCellH;
@property (nonatomic, strong) NSArray *memberArray;
@property (nonatomic, copy) NSString *username;


@property (nonatomic, strong) NSMutableArray *menberNames;
@end

@implementation XYGroupInfoViewController


- (instancetype)initWithGroup:(EMGroup *)chatGroup {
    self = [super init];
    if (self) {
        _chatGroup = chatGroup;
        _dataSource = [NSMutableArray array];
        _occupantType = XYGroupOccupantTypeMember;
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.loginModel = [ICELoginUserModel sharedInstance];
    if (self.model) {
        [self judeGroupOccupantType];
        [self configNavView];
        [self loadGroupMemberData];
        [self jugeIsScreen];
        [self configTableViewDefaultData];
        [self configTableView];
//        [self configBottomView];
    }
    [self loadGroupInfoData];
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    self.username = [loginInfo objectForKey:kSDKUsername];
    self.isEditing = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [mNotificationCenter addObserver:self selector:@selector(didCreateGroup) name:@"didCreateGroupNoti" object:nil];
}

- (void)didCreateGroup {
    [self loadGroupInfoData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view bringSubviewToFront:_navView];
}

- (void)jugeIsScreen {
    NSArray *ignoredGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    if ([ignoredGroupIds containsObject:self.model.group_id]) { //已屏蔽
        _isScreen = YES;
    } else {
        _isScreen = NO;
    }
}



// 判断群组类型
- (void)judeGroupOccupantType {
    if (self.occupantType == XYGroupOccupantTypeOwner) {
        _occupantType = XYGroupOccupantTypeOwner;
        return;
    }
    if (self.model.is_join.integerValue == 1) { // 群成员
        _occupantType = XYGroupOccupantTypeMember;
    } else {
        _occupantType = XYGroupOccupantTypeJoin;
    }
    if (self.model.is_admin.integerValue == 1) {
        _occupantType = XYGroupOccupantTypeOwner;
    }
}

// 获取群成员
- (void)loadGroupMemberData {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiSnsGetGroupAllMembers params:@{@"sessionid":sessionId,@"gid":self.gid} success:^(NSDictionary *result) {
        self.memberArray = [XYGroupMemberModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        
        
        _menberNames = [self.memberArray mutableCopy];
        
        _groupCount = self.memberArray.count;
        NSInteger count = self.memberArray.count >= 20 ? 20 : self.memberArray.count;
        
        if (self.memberArray.count > 20) {
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 20)];
            self.memberArray = [self.memberArray objectsAtIndexes:set];
        }
    
        if (_occupantType == XYGroupOccupantTypeOwner) {
            XYUserInfoModel *model = [[XYUserInfoModel alloc] init];
            model.avatar = @"caozuo";
            model.username = @"添加";
            
            XYUserInfoModel *model1 = [[XYUserInfoModel alloc] init];
            model1.avatar = @"delete001";
            model1.username = @"移除";
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.memberArray];
            [array addObject:model];
            [array addObject:model1];
//            [array insertObject:model atIndex:self.memberArray.count];
//            [array insertObject:model1 atIndex:self.memberArray.count + 1];

            self.memberArray = array;
            
            self.avatarCellH = [XYAvatarHeightConfigTool configAvatarHeightWithAvatar:count + 2];
        } else {
            self.avatarCellH = [XYAvatarHeightConfigTool configAvatarHeightWithAvatar:count];
        }
        [self.tableView reloadData];
        [self.tableView endRefresh];
        [self hideHud];
    } failure:^(NSString *msg) {
        [self hideHud];
        [self.tableView endRefresh];
    }];
}

// 直接调用后台接口,已废弃
//- (void)fetchGroupInfo {
//    __weak typeof(self) weakSelf = self;
//    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
//    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_chatGroup.groupId completion:^(EMGroup *group, EMError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf hideHud];
//            if (!error) {
//                weakSelf.chatGroup = group;
//                [weakSelf reloadDataSource];
//            } else {
//                [weakSelf showHint:error.description];
//            }
//        });
//    } onQueue:nil];
//}

- (void)loadGroupInfoData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    params[@"gid"] = self.gid;
    params[@"lat"] = [mUserDefaults objectForKey:@"latitude"];
    params[@"lng"] = [mUserDefaults objectForKey:@"longitude"];
    [TZHttpTool postWithURL:ApiSnsGroupInfo params:params success:^(NSDictionary *result) {
        self.model = [XYGroupInfoModel mj_objectWithKeyValues:result[@"data"]];
        [self judeGroupOccupantType];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self configNavView];
        });
        if (self.model.members.count > 20) {
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 20)];
            self.memberArray = [self.model.members objectsAtIndexes:set];
        }
        [self jugeIsScreen];
        [self loadGroupMemberData];
        [self configTableViewDefaultData];
        [self configTableView];
        [self configBottomView:_model.is_admin.integerValue is_join:_model.is_join.integerValue];
//        [self reloadDataSource];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
    }];
}

- (void)registerNotifications {
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications {
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)configTableViewDefaultData {
    self.cellTitles3 = @[@"群    号",@"创建于",@"群位置",@"群标签"];
    if (self.model) {
        NSString *groupNum = self.model.group_id;
        NSString *create_time = self.model.created;
        NSString *address = self.model.address;
        NSString *group_label = self.model.lab_name;
        self.cellDetailTitles3 = [NSMutableArray arrayWithArray:@[groupNum,create_time,address,group_label]];
    }
}

- (void)configNavView {
    _navView = [[XYNaviView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 64)];
    _navView.title = self.titleText;
    _navView.bgView.hidden = YES;
    if (_occupantType == XYGroupOccupantTypeOwner) {
        _navView.rightBarbtnNormalTitle = @"编辑";
        _navView.rightBarbtnSelectedTitle = @"保存";
    } else {
        _navView.rightBarbutton.hidden = YES;
    }
    MJWeakSelf
    [_navView setDidClickBackBtnBlock:^{
        
        __block BOOL flag = NO;
        [weakSelf.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[GroupListViewController class]]) {
                flag = YES;
                [weakSelf.navigationController popToViewController:obj animated:YES];
            }
        }];
        
        if (!flag) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }

    }];
    [_navView setDidClickRightBarBtnBlock:^(BOOL selected){
        
        ICECreateGroupViewController *vc = [[ICECreateGroupViewController alloc] init];
        vc.infoModel = weakSelf.model;
        vc.navTitle = @"编辑群组";
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
//        if (selected) { // 编辑
//            weakSelf.isEditing = YES;
//            [self.tableView reloadData];
//        } else { // 保存
//            weakSelf.isEditing = NO;
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            XYGroupInfoHeaderCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//            cell.avatarView.userInteractionEnabled = NO;
//            [self saveGroupInfo];
//        }
    }];
    [self.view addSubview:_navView];
}

- (void)configBottomView:(NSInteger)is_admin is_join:(NSInteger)is_join {
    _bottomView = [[TZButtonsBottomView alloc] init];
    _bottomView.frame = CGRectMake(0, mScreenHeight - 50, mScreenWidth, 50);
    _bottomView.leftMargin = 50;
    MJWeakSelf;
    if (_occupantType == XYGroupOccupantTypeOwner) {
        _bottomView.titles = @[@"发消息",@"解散群"];
        _bottomView.bgColors = @[TZColor(33, 196, 252),TZColor(253, 125, 121)];
        
        __weak typeof(_model) weakModel = _model;
        [_bottomView setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
            //
            if (index==0) {
                ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:weakModel.group_id isAttented:NO isGroup:YES];
                chatController.title = weakModel.owner;
                chatController.gid = weakModel.gid;
                chatController.groupInfoModel = weakModel;
                [weakSelf.navigationController pushViewController:chatController animated:YES];
            }else {
//                 [self dismissGroupActionInMob];
               [weakSelf sendHttpToDismissGroupAction];
            }
            
        }];
    } else if (_occupantType == XYGroupOccupantTypeJoin) { // 申请加群
        _bottomView.titles = @[@"申请加群"];
        _bottomView.bgColors = @[TZColor(33, 196, 252)];
        [_bottomView setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
            [weakSelf applyToJoinGroupInMob];
        }];
    } else { // 退出群
        _bottomView.titles = @[@"退出群"];
        _bottomView.bgColors = @[TZColor(253, 125, 121)];
        [_bottomView setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
            [weakSelf leaveGroup];
        }];
    }
    [self.view addSubview:_bottomView];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 50) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerCellByNibName:@"XYGroupInfoHeaderCell"];
    [self.tableView registerCellByClassName:@"XYDetailListCell"];
    [self.tableView registerCellByClassName:@"XYFoundationCell"];
    [self.tableView registerCellByClassName:@"XYGroupMemberAvatarView"];
    [self.tableView registerClass:[XYDetailListCell class] forCellReuseIdentifier:@"memberCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.view addSubview:self.tableView];
    [super configTableView];
//    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_occupantType == XYGroupOccupantTypeJoin) {
        return 3;
    } else {
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_occupantType == XYGroupOccupantTypeJoin) {
        if (section == 0) {
            return 5;
        } else if (section == 2){
            return 2;
        } else {
            return 1;
        }
    } else {
        if (section == 2) {
            return self.cellTitles3.count;
        } else if (section == 4){
            return 2;
        } else {
            return 1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_occupantType == XYGroupOccupantTypeJoin) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return 280;
        } else if (indexPath.section == 2 && indexPath.row == 1) {
            return self.avatarCellH;
        } else {
            return 44;
        }
    } else {
        if (indexPath.section == 0) {
            return 280;
        } else if (indexPath.section == 4 && indexPath.row == 1){
            return self.avatarCellH;
        } else {
            return 44;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.00001;
    } else {
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
//- (IBAction)action_changeBeij:(id)sender {
//    MJWeakSelf
//    [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
//        weakSelf.model.bgImg = editedImage;
//        [weakSelf.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
//        [weakSelf updataHeadImg:editedImage isIcon:NO];
//    }];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_occupantType == XYGroupOccupantTypeJoin) {
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell"];
                cell.haveAccessoryBtn = YES;
                cell.text = @"群成员";
                cell.accessoryBtnText = [NSString stringWithFormat:@"%zd人",_groupCount];
                cell.accessoryBtnTextColor = TZColorRGB(150);
                cell.labelFont = 16;
                if (mScreenWidth < 375) {
                    cell.labelFont = 15;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addBottomSeperatorViewWithHeight:1];
                return cell;
            } else {
                XYGroupMemberAvatarView *avatarCell = [tableView dequeueReusableCellWithIdentifier:@"XYGroupMemberAvatarView"];
                avatarCell.avatars = self.memberArray;
                avatarCell.selectionStyle = UITableViewCellSelectionStyleNone;
                MJWeakSelf
                [avatarCell setDidClickAddAvatarBlock:^(XYGroupMemberModel *model){
                    [weakSelf pushUserInfoVcWithUserModel:model];
                }];
                return avatarCell;
            }
            
        } else {
            if (indexPath.section == 0 && indexPath.row == 0) {
                XYGroupInfoHeaderCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"XYGroupInfoHeaderCell"];
                headCell.model = self.model;
                
                if (_occupantType == XYGroupOccupantTypeOwner) {
                    headCell.distanceLabel.hidden = YES;
                    headCell.changeBtn.hidden = NO;
                } else {
                    headCell.distanceLabel.hidden = NO;
                    headCell.changeBtn.hidden = YES;
                }
                headCell.selectionStyle = UITableViewCellSelectionStyleNone;
                MJWeakSelf
                __weak typeof(headCell) weakHeadCell = headCell;
                
                [headCell setDidChangeBgAvatarBlock:^{ //换背景
                    __strong typeof(weakHeadCell) strongHeadCell = weakHeadCell;
                    [TZImagePickerTool selectImageForEditFrom:weakSelf complete:^(UIImage *origionImg, UIImage *editedImage) {
                        strongHeadCell.bgAvatarView.image = editedImage;
                        [weakSelf updataHeadImg:editedImage isIcon:NO];
                    }];
                }];
                [headCell addBottomSeperatorViewWithHeight:1];
                headCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return headCell;
            } else {
                
                if (indexPath.section == 0) {
                    XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
//                    cell.showAvatar_label = NO;
                    cell.labelTextColor = TZColorRGB(150);
                    cell.subLabelTextColor = TZColorRGB(74);
                    cell.labelFont = 16;
                    cell.subLabelFont = 16;
                    if (mScreenWidth < 375) {
                        cell.labelFont = 15;
                        cell.subLabelFont = 15;
                    }
                    if (indexPath.row == 3) {
                        cell.more.hidden = NO;
                    } else {
                        cell.more.hidden = YES;
                    }
                    if (indexPath.row == 4) {
                        cell.subLabelBgColor = TZColor(0, 175, 255);
                        cell.subLabelFont = 14;
                        cell.calculateTextWidth = YES;
                    } else {
                        cell.calculateTextWidth = NO;
                    }
                    cell.text = self.cellTitles3[indexPath.row - 1];
                    cell.subText = self.cellDetailTitles3[indexPath.row - 1];
                    [cell addBottomSeperatorViewWithHeight:1];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                } else {
                    static NSString *cellID = @"cell1";
                    XYDetailListCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
                    if (cell1 == nil) {
                        cell1 = [[XYDetailListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                    }
                    cell1.showAvatar_label = YES;
                    cell1.subLabelTextColor = TZColorRGB(74);
                    cell1.subLabelFont = 16;
                    if (mScreenWidth < 375) {
                        cell1.subLabelFont = 15;
                    }
                    cell1.text = @"群   主";
                    XYGroupMemberModel *memberModel = self.model.members[0];
                    if (memberModel) {
                        [cell1.avatar sd_setImageWithURL:TZImageUrlWithShortUrl(memberModel.avatar) placeholderImage:TZPlaceholderAvaterImage];
                        if (memberModel.nickname.length > 0) {
                            cell1.subText = memberModel.nickname;
                        }else {
                            cell1.subText = memberModel.username;
                        }
                    } else {
                        [cell1.avatar sd_setImageWithURL:TZImageUrlWithShortUrl(self.model.avatar) placeholderImage:TZPlaceholderAvaterImage];
                        cell1.subText = self.model.owner;
                    }
                    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell1;
                }
            }
        }
        
    } else {
        if (indexPath.section == 0) {
            XYGroupInfoHeaderCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"XYGroupInfoHeaderCell"];
            headCell.model = self.model;
            if (self.isEditing) {
                headCell.avatarView.userInteractionEnabled = YES;
                headCell.titleField.userInteractionEnabled = YES;
                headCell.descView.delegate = self;
                [headCell.titleField addTarget:self action:@selector(titleFieldDidEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
                [headCell.titleField addTarget:self action:@selector(titleFieldDidBeginEdit:) forControlEvents:UIControlEventEditingDidBegin];
                headCell.descView.userInteractionEnabled = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [headCell.descView becomeFirstResponder];
                });
            }
            if (_occupantType == XYGroupOccupantTypeOwner) {
                headCell.distanceLabel.hidden = YES;
                headCell.changeBtn.hidden = NO;
            } else {
                headCell.distanceLabel.hidden = NO;
                headCell.changeBtn.hidden = YES;
            }
            headCell.selectionStyle = UITableViewCellSelectionStyleNone;
            MJWeakSelf
            __weak typeof(headCell) weak_headCell = headCell;
            [headCell setDidChangeBgAvatarBlock:^{ //换背景
                [TZImagePickerTool selectImageForEditFrom:weakSelf complete:^(UIImage *origionImg, UIImage *editedImage) {
                    weak_headCell.bgAvatarView.image = editedImage;
                    [weakSelf updataHeadImg:editedImage isIcon:NO];
                }];
            }];
            [headCell setDidChangeAvatarBlock:^{
                [weakSelf.view endEditing:YES];
                [TZImagePickerTool selectImageForEditFrom:weakSelf complete:^(UIImage *origionImg, UIImage *editedImage) {
                    weak_headCell.avatarView.image = editedImage;
                    [weakSelf updataHeadImg:editedImage isIcon:YES];
                }];
            }];
            return headCell;
        } else if (indexPath.section == 1) {
            XYFoundationCell *screenCell = [tableView dequeueReusableCellWithIdentifier:@"XYFoundationCell"];
            screenCell.type = XYFoundationCellTypeSwitch;
            if (_isScreen) {
                screenCell.swit.on = YES;
            } else {
                screenCell.swit.on = NO;
            }
            screenCell.labelText = @"屏蔽群消息";
            screenCell.labelTextColor = TZColorRGB(150);
            MJWeakSelf
            [screenCell setSwitValueChangeBlock:^(BOOL isOn){
                [weakSelf screenGroupActionWithSwitValue:isOn];
            }];
            screenCell.labelFont = 16;
            if (mScreenWidth < 375) screenCell.labelFont = 15;
            screenCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return screenCell;
        } else if (indexPath.section == 4){
            if (indexPath.row == 0) {
                XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell"];
                cell.haveAccessoryBtn = YES;
                cell.text = @"群成员";
                cell.accessoryBtnText = [NSString stringWithFormat:@"%zd人",_groupCount];
                cell.accessoryBtnTextColor = TZColorRGB(150);
                cell.labelFont = 16;
                if (mScreenWidth < 375) {
                    cell.labelFont = 15;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addBottomSeperatorViewWithHeight:1];
                return cell;
            } else {
                XYGroupMemberAvatarView *avatarCell = [tableView dequeueReusableCellWithIdentifier:@"XYGroupMemberAvatarView"];
                if (_occupantType == XYGroupOccupantTypeOwner) {
                    avatarCell.haveAddAvatar = YES;
                }
                avatarCell.avatars = self.memberArray;
                MJWeakSelf
                [avatarCell setDidClickAddAvatarBlock:^(XYGroupMemberModel *model){
                    [weakSelf pushUserInfoVcWithUserModel:model];
                }];
                avatarCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return avatarCell;
            }
            
        } else {
            XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
            if (indexPath.section == 2) {
                cell.showAvatar_label = NO;
                cell.labelTextColor = TZColorRGB(150);
                cell.subLabelTextColor = TZColorRGB(74);
                cell.labelFont = 16;
                cell.subLabelFont = 16;
                if (mScreenWidth < 375) {
                    cell.labelFont = 15;
                    cell.subLabelFont = 15;
                }
                if (indexPath.row == 2) {
                    cell.more.hidden = NO;
                } else {
                    cell.more.hidden = YES;
                }
                if (indexPath.row == 3) {
                    cell.subLabelBgColor = TZColor(0, 175, 255);
                    cell.subLabelFont = 14;
                    cell.calculateTextWidth = YES;
                } else {
                    cell.calculateTextWidth = NO;
                }
                cell.text = self.cellTitles3[indexPath.row];
                cell.subText = self.cellDetailTitles3[indexPath.row];
                [cell addBottomSeperatorViewWithHeight:1];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            } else {
                static NSString *cellID = @"cell1";
                XYDetailListCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
                if (cell1 == nil) {
                    cell1 = [[XYDetailListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell1.showAvatar_label = YES;
                cell1.subLabelTextColor = TZColorRGB(74);
                cell1.subLabelFont = 16;
                if (mScreenWidth < 375) {
                    cell1.subLabelFont = 15;
                }
                cell1.text = @"群   主";
                XYGroupMemberModel *memberModel = self.model.members[0];
                if (memberModel) {
                    [cell1.avatar sd_setImageWithURL:TZImageUrlWithShortUrl(memberModel.avatar) placeholderImage:TZPlaceholderAvaterImage];
                    if (memberModel.nickname.length > 0) {
                        cell1.subText = memberModel.nickname;
                    }else {
                        cell1.subText = memberModel.username;
                    }
                } else {
                    [cell1.avatar sd_setImageWithURL:TZImageUrlWithShortUrl(self.model.avatar) placeholderImage:TZPlaceholderAvaterImage];
                    cell1.subText = self.model.owner;
                }
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell1;
            }
        }
    }
}

- (void)updataHeadImg:(UIImage *)image isIcon:(BOOL)isIcon {
    if (!image) return;
    NSArray *fileArr = @[
                         @{
                             @"file": image,
                             @"name" : @"headImage.png",
                             @"key" : @"avatar"
                             }
                         ];
    [self showTextHUDWithPleaseWait];
    RACSignal *signal = [ICEImporter uploadFilesWithUrl:ApiSnsUploadGroupAvatar params:@{ @"avatar": @"headImage" } files:fileArr];
    [signal subscribeNext:^(NSDictionary *result) {
        [self hideTextHud];
        if (isIcon) {
            NSString *iconStr = [ApiSystemImage stringByAppendingString:result[@"data"]];
            self.iconPath = iconStr;
        } else {
            self.bgPath = [ApiSystemImage stringByAppendingString:result[@"data"]];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
            params[@"gid"] = self.gid;
            NSString *bgStr = [ApiSystemImage stringByAppendingString:result[@"data"]];
            params[@"background"] = bgStr;
            [TZHttpTool postWithURL:ApiEditGroup params:params success:^(NSDictionary *result) {
                
            } failure:^(NSString *msg) {
                [self showErrorHUDWithError:msg];
            }];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_occupantType == XYGroupOccupantTypeJoin) {
        if (indexPath.section == 1) {
            [self pushUserInfoVc];
        } else if (indexPath.section == 2 && indexPath.row == 0) {
            [self pushCheckGroupVc];
        } else if (indexPath.section == 0 && indexPath.row == 3) {
            [self pushMapVc];
        }
    } else {
        if (indexPath.section == 3) {
            [self pushUserInfoVc];
        } else if (indexPath.section == 4 && indexPath.row == 0) {
            [self pushCheckGroupVc];
        } else if (indexPath.section == 2 && indexPath.row == 3) {
            if (self.isEditing) {
                [self pushGroupLabelVcWithIndexPath:indexPath];
            }
        } else if (indexPath.section == 2 && indexPath.row == 2) {
            [self pushMapVc];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)editBtnClick {
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 100) {
        _navView.bgView.hidden = NO;
    } else {
        _navView.bgView.hidden = YES;
    }
}

#pragma mark -------- praite 

- (void)pushGroupLabelVcWithIndexPath:(NSIndexPath *)indexPath {
    XYGroupTagViewController *tagVc = [[XYGroupTagViewController alloc] init];
    tagVc.index = self.selTagIndex;
    MJWeakSelf
    [tagVc setDidClickRightBtnBlock:^(NSString *tag, NSInteger index) {
        XYDetailListCell *tagCell = [self.tableView cellForRowAtIndexPath:indexPath];
        tagCell.subLabelBgColor = TZColor(0, 175, 255);
        tagCell.subLabelFont = 14;
        tagCell.calculateTextWidth = YES;
        tagCell.subText = tag;
        weakSelf.nature = tag;
        weakSelf.selTagIndex = index;
    }];
    [self.navigationController pushViewController:tagVc animated:YES];
}

- (void)pushUserInfoVc {
    ICESelfInfoViewController *infoVc = [[ICESelfInfoViewController alloc] init];
    if (_occupantType == XYGroupOccupantTypeOwner) {
        infoVc.type = ICESelfInfoViewControllerTypeSelf;
    } else {
        infoVc.type = ICESelfInfoViewControllerTypeOther;
    }
    XYGroupMemberModel *memberModel = self.model.members[0];
    infoVc.otherUsername = memberModel.username;
    [self.navigationController pushViewController:infoVc animated:YES];
}

- (void)pushMapVc {
    XYMapViewController *mapVc = [[XYMapViewController alloc] init];
    mapVc.type = XYMapViewControllerTypeShow;
    mapVc.titleText = @"群位置";
    mapVc.lat = self.model.lat.doubleValue;
    mapVc.lng = self.model.lng.doubleValue;
    [self.navigationController pushViewController:mapVc animated:YES];
}

- (void)pushCheckGroupVc {
    XYCheckGroupMemberController *checkGroupMemberVc = [[XYCheckGroupMemberController alloc] init];
    checkGroupMemberVc.gid = self.model.gid;
    if (_occupantType == XYGroupOccupantTypeOwner) {
        NSMutableArray *allMemberArr = [NSMutableArray arrayWithArray:[self.menberNames copy]];
//        [allMemberArr removeLastObject];
//        self.memberArray = allMemberArr;
    }
    checkGroupMemberVc.memberArr = [self.menberNames copy];
    [self.navigationController pushViewController:checkGroupMemberVc animated:YES];
}

#pragma mark ---- 

- (void)saveGroupInfo {
    [self.view endEditing:YES];
    if (_editedGroupName) {
        if (self.groupName.length < 1 || [CommonTools isBlankString:self.groupName]) {
            [self showAlertViewWithTitle:@"提示" message:@"未修改群名称"];
            return;
        }
    } else {
        self.groupName = self.model.owner;
    }
    if (_editedGroupDesc) {
        if (self.groupDesc.length < 1 || [CommonTools isBlankString:self.groupDesc]) {
            [self showAlertViewWithTitle:@"提示" message:@"未修改群简介"];
            return;
        }
    } else {
        self.groupDesc = self.model.desc;
    }
    if (!self.bgPath || !self.bgPath.length) {
        [self showAlertViewWithTitle:@"提示" message:@"未修改群背景"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    params[@"gid"] = self.gid;
    params[@"avatar"] = self.iconPath;
    params[@"background"] = self.bgPath;
    params[@"owner"] = self.groupName;
    params[@"address"] = self.model.address;
    params[@"lng"] = self.model.lng;
    params[@"lat"] = self.model.lat;
    NSString *nature = self.nature.length ? self.nature : self.model.lab_name;
    params[@"labs"] = self.nature;
    params[@"desc"] = self.groupDesc;
    [TZHttpTool postWithURL:ApiEditGroup params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"保存成功"];
    } failure:^(NSString *msg) {
        [self showErrorHUDWithError:@"保存失败"];
    }];
}

#pragma mark --------- Mob Method

/// 解散群
- (void)dismissGroupActionInMob {
    [self showHudInView:self.view hint:NSLocalizedString(@"group.destroy", @"dissolution of the group")];
    MJWeakSelf
    [[EaseMob sharedInstance].chatManager asyncDestroyGroup:self.model.group_id completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
        [weakSelf hideHud];
        if (error) {
            [weakSelf showHint:NSLocalizedString(@"group.destroyFail", @"dissolution of group failure")];
        } else{ // 先调环信再调后台接口
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didDismissGroupNoti" object:nil];
            [self sendHttpToDismissGroupAction];
            
        }
    } onQueue:nil];
}

- (void)sendHttpToDismissGroupAction {
    
    [TZHttpTool postWithURL:ApiDelGroup params:@{@"group_id" : self.model.group_id} success:^(NSDictionary *result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didDismissGroupNoti" object:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.pushFromChatVc) {
                NSArray *vcArr = self.navigationController.viewControllers;
                [self.navigationController popToViewController:vcArr[0] animated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    } failure:^(NSString *msg) {
        [self showSuccessHUDWithStr:msg];
    }];
}

/// 申请加群
- (void)applyToJoinGroupInMob {
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
        NSString *messageStr;
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
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf showHint:error.description];
        }
    } onQueue:nil];
}

/// 屏蔽群
- (void)screenGroupActionWithSwitValue:(BOOL) isOn{
//    NSString *title = @"开启消息免打扰";
//   
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:title, nil];
//    [sheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
//        if (x.integerValue == 0) {
//            if ([title isEqualToString:@"开启消息免打扰"]) {
//                [[EaseMob sharedInstance].chatManager asyncIgnoreGroupPushNotification:self.model.group_id isIgnore:YES];
//                [self showInfo:@"开启消息免打扰成功"];
//            } else {
//                [[EaseMob sharedInstance].chatManager asyncIgnoreGroupPushNotification:self.model.group_id isIgnore:NO];
//                [self showInfo:@"关闭消息免打扰成功"];
//            }
//        }
//    }];
//    [sheet showInView:self.view];
    
    if (isOn) { // 屏蔽
         [[EaseMob sharedInstance].chatManager asyncIgnoreGroupPushNotification:self.model.group_id isIgnore:YES];
    } else {
         [[EaseMob sharedInstance].chatManager asyncIgnoreGroupPushNotification:self.model.group_id isIgnore:NO];
    }
}

/// UITextField && UItextView

- (void)titleFieldDidEndEdit:(UITextField *)field {
    self.groupName = field.text;
}

- (void)titleFieldDidBeginEdit:(UITextField *)field {
    _editedGroupName = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _editedGroupDesc = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.groupDesc = textView.text;
}

#pragma mark - EMChooseViewDelegate
- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources {
//    NSInteger maxUsersCount = _chatGroup.groupSetting.groupMaxUsersCount;
    NSInteger maxUsersCount = 200;
    if (([selectedSources count] + _chatGroup.groupOccupantsCount) > maxUsersCount) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"group.maxUserCount", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    NSString *hint = _isDelete ? @"移除组成员..." : NSLocalizedString(@"group.addingOccupant", @"add a group member...");
    
    [self showHudInView:self.view hint:hint];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *source = [NSMutableArray array];
        NSMutableString *usernames = [NSMutableString string];
        NSMutableString *alertText = [NSMutableString string];

        for (int i = 0 ; i < selectedSources.count; i ++) {
            XYRecommendFriendModel *buddy = selectedSources[i];
            XYGroupMemberModel *buddy1 = selectedSources[i];

            __block BOOL flag = NO;
            
            if (!_isDelete) {
                [self.memberArray enumerateObjectsUsingBlock:^(XYGroupMemberModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.username isEqualToString:buddy.username] || [obj.username isEqualToString:buddy.phone]) {
                        flag = YES;
                        *stop = YES;
                    }
                }];

            }
            
            if (flag) {
//                [ProgressHUD show:[NSString stringWithFormat:@"%@已存在",buddy.nickname]];
//                [self showHint:[NSString stringWithFormat:@"%@已存在",buddy.nickname]];
                NSString *str = buddy.nickname.length > 0 ? buddy.nickname : buddy.username;
                [alertText appendString:str];
                continue;
            }
            
            
            if (_isDelete) {
                [source addObject:buddy1.user_huanxin];
                [usernames appendFormat:[NSString stringWithFormat:@",%@",buddy.uid]];

            } else {
                if (buddy.phone.length > 0) {
                    [source addObject:buddy.phone];
                    [usernames appendFormat:[NSString stringWithFormat:@",%@",buddy.phone]];
                    
                }else {
                    [source addObject:buddy.username];
                    [usernames appendFormat:[NSString stringWithFormat:@",%@",buddy.username]];
                }
            }
            
            
           
            
            
        }
        
//        for (XYRecommendFriendModel *buddy in selectedSources) {
//            if ([source containsObject:buddy.username]) {
//                continue;
//            }
//            [source addObject:buddy.username];
//            [usernames appendFormat:[NSString stringWithFormat:@",%@",buddy.username]];
//        }
        

        if (alertText.length > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                [weakSelf showHint:@"加入失败，包含已有成员"];
            });
            return ;
        }
        
        if (usernames.length > 1) {
            [usernames deleteCharactersInRange:NSMakeRange(0, 1)];
        }else {
//            [self hideHud];
            [self hideHud];
            return;
        }
        
        
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
        NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join group \'%@\'"), username, weakSelf.chatGroup.groupSubject];
        EMError *error = nil;
        
        if (!_isDelete) {
           
            weakSelf.chatGroup = [[EaseMob sharedInstance].chatManager addOccupants:source toGroup:weakSelf.chatGroup.groupId welcomeMessage:messageStr error:&error];
            if (!error) {
                [weakSelf addOccupantsWithUserNames:usernames];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideHud];
                    [weakSelf showHint:error.description];
                });
            }
        }else {
            
            weakSelf.chatGroup = [[EaseMob sharedInstance].chatManager removeOccupants:source fromGroup:weakSelf.chatGroup.groupId error:&error];
//            weakSelf.chatGroup = [[EaseMob sharedInstance].chatManager removeOccupants:@[@"13544444444"] fromGroup:@"22704720773121" error:&error];

            
            if (!error) {
                [weakSelf addOccupantsWithUserNames:usernames];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideHud];
                    [weakSelf showHint:error.description];
                });
            }
        }
        
    });
    
    return YES;
}



- (void)addOccupantsWithUserNames:(NSString *)userNames {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *api = _isDelete ? ApiSnsGetRemoveGroup : ApiSnsGetjoinGroup;
    
    params[@"sessionid"] = sessionId;
    params[@"gid"] = self.gid;
    
    NSString *key = _isDelete ? @"uid" : @"huanxinId";
    
    params[key] = userNames;

    [TZHttpTool postWithURL:api params:params success:^(NSDictionary *result) {
        [self loadGroupMemberData];
        [mNotificationCenter postNotificationName:@"didCreateGroupNoti" object:nil];
        [self showHint:result[@"msg"]];

    } failure:^(NSString *msg) {
        [self showHint:msg];
    }];
}


- (void)reloadDataSource {
//    [self.dataSource removeAllObjects];
//
//    NSArray *array = self.chatGroup.occupants;
//    [self.dataSource addObjectsFromArray:self.chatGroup.occupants];
    
   
}

#pragma mark - action

// 退出群组
- (void)leaveGroup {
//    DLog(@"退出群组");
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"group.leave", @"quit the group")];
    [[EaseMob sharedInstance].chatManager asyncLeaveGroup:_chatGroup.groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
        [weakSelf hideHud];
        if (error) {
            [weakSelf showHint:NSLocalizedString(@"group.leaveFail", @"exit the group failure")];
        } else {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
            params[@"gid"] = self.gid;
            [TZHttpTool postWithURL:ApiQuitGroup params:params success:^(NSDictionary *result) {
                [self showSuccessHUDWithStr:@"退出成功"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.pushFromChatVc) {
                        NSArray *vcArr = self.navigationController.viewControllers;
                        [self.navigationController popToViewController:vcArr[0] animated:YES];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                });
            } failure:^(NSString *msg) {
                
            }];
        }
    } onQueue:nil];
}

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

- (void)pushUserInfoVcWithUserModel:(XYGroupMemberModel *)model {
    if ([model.username isEqualToString:@"添加"]) { // 添加好友入群
        _isDelete = NO;

        ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] initWithBlockSelectedUsernames:_chatGroup.occupants];
        selectionController.delegate = self;
        [self.navigationController pushViewController:selectionController animated:YES];
    } else  if ([model.username isEqualToString:@"移除"]) { // 添加好友入群
        
        NSMutableArray *aa = [self.menberNames mutableCopy];
        [aa removeFirstObject];
//        [_memberArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//        }];
        _isDelete = YES;
        ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] init];
        selectionController.memberDatas  = aa;
        selectionController.delegate = self;
        [self.navigationController pushViewController:selectionController animated:YES];
    } else {
        ICESelfInfoViewController *infoVc = [[ICESelfInfoViewController alloc] init];
        if ([self.loginModel.uid isEqualToString:model.uid]) {
            infoVc.type = ICESelfInfoViewControllerTypeSelf;
        } else {
            infoVc.type = ICESelfInfoViewControllerTypeOther;
            infoVc.otherUsername = model.username;
            infoVc.nickName = model.nickname;
        }
        [self.navigationController pushViewController:infoVc animated:YES];
    }
}


@end
