//
//  ICECreateGroupViewController.m
//  kuaile
//
//  Created by ttouch on 15/10/21.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICECreateGroupViewController.h"
#import "TZJobApplyView.h"
#import "ContactSelectionViewController.h"
#import "ICEModelGroupInfo.h"
#import "XYCreateGroupHeaderCell.h"
#import "XYDetailListCell.h"
#import "TZButtonsHeaderView.h"
#import "XYGroupTagViewController.h"
#import "XYConfigViewController.h"
#import "XYPhotoViewController.h"
#import "ICEGroupInfoViewController.h"
#import "XYGroupInfoViewController.h"
#import "XYGroupInfoModel.h"
#import "XYMapViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface ICECreateGroupViewController () <EMChooseViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic)AMapLocationManager *locationManager;//定位管理者


@property (nonatomic) BOOL isPublic;
@property (nonatomic) BOOL isMemberOn;
@property (nonatomic, strong) TZJobApplyView *createResume;
@property (nonatomic, strong) ICEModelGroupInfo *modelGroupInfo;
@property (nonatomic, strong) TZButtonsBottomView *createView;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *nature;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *avaterName;
@property (nonatomic, assign) NSInteger selTagIndex;
@property (nonatomic, assign) CGFloat introductionTextH;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *iconStr;

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) NSMutableArray *cellDetailTitles1;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (strong, nonatomic) ICELoginUserModel *model;




@end


@implementation ICECreateGroupViewController

- (CLGeocoder *)geocoder {
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)initData {
    _modelGroupInfo = [[ICEModelGroupInfo alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.navTitle.length > 0 ? self.navTitle : @"创建群组";
    self.introduction = @"请填写";
    self.model = [ICELoginUserModel sharedInstance];
    self.navigationItem.rightBarButtonItem = nil;
    self.view.backgroundColor = TZControllerBgColor;
    [self configTableView];
    [self configCreateBottomView];
    [self initData];
    
    if (!_infoModel) {
        [self configLocation];
    }
        
    
    
    
    
//    [self configJobApplyView];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - _createView.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerCellByNibName:@"XYCreateGroupHeaderCell"];
    [self.tableView registerCellByClassName:@"XYDetailListCell"];
    [self.tableView registerClass:[XYDetailListCell class] forCellReuseIdentifier:@"introduceCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [super configTableView];
    
    self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[@"请填写",@"请设置",@"请设置",@"请填写"]];
    
    if (_infoModel) {
        self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[_infoModel.owner,_infoModel.address,_infoModel.lab_name,_infoModel.desc]];
        self.groupName = _infoModel.owner;
        self.iconStr = _infoModel.avatar;
        self.location = _infoModel.address;
        self.lat = _infoModel.lat.doubleValue;
        self.lng = _infoModel.lng.doubleValue;
        self.nature = _infoModel.lab_name;
        self.introduction = _infoModel.desc;
        
    }
}


- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        //1.带逆地理信息的一次定位（返回坐标和地址信息）(百米)
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        //2.定位超时时间，最低2s，此处设置为2s
        _locationManager.locationTimeout = 2;
        //3.逆地理请求超时时间，最低2s，此处设置为2s
        _locationManager.reGeocodeTimeout = 2;
    }
    return _locationManager;
}

- (void)configLocation {
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        self.location = regeocode.POIName;
        self.lat = location.coordinate.latitude;
        self.lng = location.coordinate.longitude;

//        _currentLocationCoordinate = location.coordinate;
//        _regeocode = regeocode;
//        if (locationBlock) {
//            locationBlock(regeocode, location.coordinate, error.localizedDescription);
//        }
    }];
    
//    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
//    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];;
//    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error) {
//        if (!error && array.count > 0) {
//            CLPlacemark *placemark = [array objectAtIndex:0];
//            self.location = placemark.name;
//            self.lat = placemark.location.coordinate.latitude;
//            self.lng = placemark.location.coordinate.longitude;
//
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//    }];
}

- (void)editGroup {
    if (self.netFlag) {
        return;
    }
    
    if (!self.iconStr || self.iconStr.length < 1) {
        [self showInfo:@"请设置群头像"]; return;
    }
    self.groupName = self.cellDetailTitles2[0];
    if (!self.groupName || self.groupName.length < 1 || [self.groupName isEqualToString:@"请填写"]) {
        [self showInfo:@"请填写群名称"]; return;
    }
    
    
    
    if (!self.location || self.location.length < 1 || [self.location isEqualToString:@"请设置"]) {
        [self showInfo:@"请设置群地点"]; return;
    }
    if (!self.nature || self.nature.length < 1 || [self.nature isEqualToString:@"请设置"]) {
        [self showInfo:@"请设置群标签"]; return;
    }
    if (!self.introduction || self.introduction.length < 1 || [self.introduction isEqualToString:@"请填写"]) {
        [self showInfo:@"请填写群简介"]; return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = self.model.sessionid;
    params[@"owner"] = self.groupName;
    params[@"avatar"] = self.iconStr;
    params[@"address"] = self.location;
    params[@"desc"] = self.introduction;
    params[@"labs"] = self.nature;
    if (self.lat && self.lng) {
        params[@"lng"] = @(self.lng);
        params[@"lat"] = @(self.lat);
    } else {
        params[@"lng"] = @([[mUserDefaults objectForKey:@"longitude"] doubleValue]);
        params[@"lat"] = @([[mUserDefaults objectForKey:@"latitude"] doubleValue]);
    }
    params[@"gid"] = _infoModel.gid;
    params[@"background"] = _infoModel.background;

    
    self.netFlag = YES;
    
    
    
    [TZHttpTool postWithURL:ApiEditGroup params:params success:^(NSDictionary *result) {
        if ([result[@"status"] integerValue] == 1) {
            [self showSuccessHUDWithStr:@"修改成功"];
            [mNotificationCenter postNotificationName:@"didCreateGroupNoti" object:nil];

            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSString *msg) {
        self.netFlag = NO;
        [self showErrorHUDWithError:msg];
    }];
}

// 创建群组
- (void)createGroup {
    
    if (self.netFlag) {
        return;
    }
    
    if (!self.iconStr || self.iconStr.length < 1) {
        [self showInfo:@"请设置群头像"]; return;
    }
    self.groupName = self.cellDetailTitles2[0];
    if (!self.groupName || self.groupName.length < 1 || [self.groupName isEqualToString:@"请填写"]) {
        [self showInfo:@"请填写群名称"]; return;
    }
    if (!self.location || self.location.length < 1 || [self.location isEqualToString:@"请设置"]) {
        [self showInfo:@"请设置群地点"]; return;
    }
    if (!self.nature || self.nature.length < 1 || [self.nature isEqualToString:@"请设置"]) {
        [self showInfo:@"请设置群标签"]; return;
    }
    if (!self.introduction || self.introduction.length < 1 || [self.introduction isEqualToString:@"请填写"]) {
        [self showInfo:@"请填写群简介"]; return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = self.model.sessionid;
    params[@"owner"] = self.groupName;
    params[@"avatar"] = self.iconStr;
    params[@"address"] = self.location;
    params[@"desc"] = self.introduction;
    params[@"labs"] = self.nature;
    if (self.lat && self.lng) {
        params[@"lng"] = @(self.lng);
        params[@"lat"] = @(self.lat);
    } else {
        params[@"lng"] = @([[mUserDefaults objectForKey:@"longitude"] doubleValue]);
        params[@"lat"] = @([[mUserDefaults objectForKey:@"latitude"] doubleValue]);
    }
    
    self.netFlag = YES;
    
    [TZHttpTool postWithURL:ApiSnsCreateGroup params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"创建成功"];
//        self.netFlag = NO;
        [mNotificationCenter postNotificationName:@"didCreateGroupNoti" object:nil];
        XYGroupInfoModel *model = [XYGroupInfoModel mj_objectWithKeyValues:result[@"data"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XYGroupInfoViewController *groupInfoVc = [[XYGroupInfoViewController alloc] initWithGroupId:model.group_id];
            groupInfoVc.model = model;
            groupInfoVc.gid = model.gid;
            groupInfoVc.titleText = @"群资料";
            groupInfoVc.occupantType = XYGroupOccupantTypeOwner;
            [self.navigationController pushViewController:groupInfoVc animated:YES];
        });
    } failure:^(NSString *msg) {
        self.netFlag = NO;
        [self showErrorHUDWithError:@"创建失败"];
    }];
}

#pragma mark -- 创建群的网络接口
- (void)configCreateBottomView {
    _createView = [[TZButtonsBottomView alloc] init];
    _createView.frame = CGRectMake(25, mScreenHeight - 50 - 64 - 70, mScreenWidth - 50, 50);
    _createView.backgroundColor = [UIColor clearColor];
    _createView.titles = @[@"创建"];
    if (_infoModel) {
        _createView.titles = @[@"完成修改"];
    }
    _createView.bgColors = @[TZColor(0, 198, 255)];
    MJWeakSelf
    
    __weak XYGroupInfoModel *weakInfoModel = _infoModel;
    [_createView setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        if (weakInfoModel) {
            [weakSelf editGroup];
        }else {
            [weakSelf createGroup];
        }
    }];
    [self.view addSubview:_createView];
}

//
//- (void)configLab {
//    _groupTypeLabel.text = NSLocalizedString(@"group.create.private", @"public group");
//    _groupMemberLabel.text = NSLocalizedString(@"group.create.unallowedOccupantInvite", @"don't allow group members to invite others");
//}

//- (void)configSwitch {
//    [_switchControl addTarget:self action:@selector(groupTypeChange:) forControlEvents:UIControlEventValueChanged];
//    [_groupMemberSwitch addTarget:self action:@selector(groupMemberChange:) forControlEvents:UIControlEventValueChanged];
//}

//- (void)configJobApplyView {
//    _createResume = [[TZJobApplyView alloc] init];
//    [_createResume.button setTitle:@"创建" forState:UIControlStateNormal];
//    [_createResume.button addTarget:self action:@selector(addContacts:) forControlEvents:UIControlEventTouchUpInside];
//    _createResume.frame = CGRectMake(0, __kScreenHeight - 50 - 64, __kScreenWidth, 50);
//    [self.view addSubview:_createResume];
//}

//- (void)configImageView {
//    [[self.tamImage rac_gestureSignal] subscribeNext:^(id x) {
//        [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
//            self.imgGroup.image = editedImage;
//        }];
//    }];
//}

//- (void)addContacts:(id)sender {
//    if (self.textFieldGroupName.text.length == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"group.create.inputName", @"please enter the group name") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//        [alertView show];
//        return;
//    }
//    
//    [self.view endEditing:YES];
//    
//    _modelGroupInfo.owner = self.textFieldGroupName.text;
//    _modelGroupInfo.desc = self.textFieldGroupDesc.text;
//    _modelGroupInfo.group_permissions = _switchControl.isOn ? @"1" : @"0";
//    _modelGroupInfo.user_permissions = _groupMemberSwitch.isOn ? @"1" : @"0";
//    
//    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] init];
//    selectionController.delegate = self;
//    [self.navigationController pushViewController:selectionController animated:YES];
//}

#pragma mark -- UITableViewDatasource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 170;
    } else {
        if (indexPath.row == 3) {
            if (self.introductionTextH && self.introductionTextH > 40) {
//                CGFloat d = self.introductionTextH;
                return self.introductionTextH;
            } else {
                return 40;
            }
        } else {
            return 40;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XYCreateGroupHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"XYCreateGroupHeaderCell"];
        MJWeakSelf
        
        __weak XYCreateGroupHeaderCell *weakcell = headerCell;
        
        __weak typeof(_infoModel) weak_infoModel = _infoModel;
        
        [headerCell setDidClickAvaterViewBlock:^{
//            if (self.icon) {
//                XYPhotoViewController *photoVc = [[XYPhotoViewController alloc] init];
//                photoVc.currentIcon = self.icon;
//                [self.navigationController pushViewController:photoVc animated:YES];
//            } else {
            
                [TZImagePickerTool selectImageForEditFrom:weakSelf complete:^(UIImage *origionImg, UIImage *editedImage) {
                    weakcell.avaterView.image = editedImage;
                    weakSelf.icon = editedImage;
                    [weakSelf updataHeadImg:editedImage isIcon:YES];
                }];
//            }
        }];
        
        if (_infoModel) {
            [headerCell.avaterView sd_setImageWithURL:_infoModel.avatar placeholderImage:nil];
        }
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return headerCell;
    } else {
        if (indexPath.row == 3) {
            XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"introduceCell"];
            cell.text = @"群简介";
            cell.subText = self.introduction && self.introduction.length ? self.introduction : self.cellDetailTitles2[indexPath.row];;
            cell.labelFont = 15;
            cell.subLabelFont = 15;
            if (mScreenWidth < 375) {
                cell.labelFont = 13;
                cell.subLabelFont = 13;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            XYDetailListCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
            detailCell.text = @[@"群名称",@"群地点",@"群标签"][indexPath.row];
            detailCell.subText = self.cellDetailTitles2[indexPath.row];
            [detailCell addBottomSeperatorViewWithHeight:1];
            detailCell.labelFont = 15;
            detailCell.subLabelFont = 15;
            if (mScreenWidth < 375) {
                detailCell.labelFont = 13;
                detailCell.subLabelFont = 13;
            }
            detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return detailCell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
//            XYConfigViewController *nicknameVc = [[XYConfigViewController alloc] init];
//            nicknameVc.titleText = @"群名称";
//            nicknameVc.type = XYConfigViewControllerTypeTextField;
//            nicknameVc.placeText = self.groupName;
//            MJWeakSelf
//            [nicknameVc setDidClickConformBtnBlock:^(NSString *text) {
//                XYDetailListCell *nicknameCell = [tableView cellForRowAtIndexPath:indexPath];
//                nicknameCell.subText = text;
//                weakSelf.groupName = text;
//            }];
//            [self.navigationController pushViewController:nicknameVc animated:YES];
            
            UIAlertView *nameView = [UIAlertView alertViewWithTitle:@"请输入群名称" message:nil delegate:self];
            self.nameField = [nameView textFieldAtIndex:0];
            self.nameField.keyboardType = UIKeyboardTypeDefault;
            if (![self.cellDetailTitles1[0] isEqualToString:@"未填写"]) {
                self.nameField.text = self.cellDetailTitles1[0];
            }
            [[nameView rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
                if (x.integerValue == 1) {
                    [self refreshCellDetailNamesWithText:self.nameField.text];
                }
            }];
            [nameView show];
        } else if (indexPath.row == 1) {
//            self.selectView.labTitle.text = @"期望工作区域";
//            [self showPopSelectViewWithArray:[TZCitisManager getCitis]];
            
            XYMapViewController *mapVc = [[XYMapViewController alloc] init];
            mapVc.type = XYMapViewControllerTypeCanHandle;
            mapVc.titleText = @"选择群地点";
            NSString *search = self.location;
            if (search.length) {
                mapVc.searchWord = search;
            }
            [mapVc setDidSelecteAddressBlock:^(NSString *address){
                self.location = address;
                [self refreshCellDetailNamesWithText:address];
                [self geocoderActionWithAddressText:address];
            }];
            mapVc.lat = self.lat;
            mapVc.lng = self.lng;
            [self.navigationController pushViewController:mapVc animated:YES];
        } else if (indexPath.row == 2) {
            XYGroupTagViewController *tagVc = [[XYGroupTagViewController alloc] init];
            tagVc.index = self.selTagIndex;
            MJWeakSelf
            [tagVc setDidClickRightBtnBlock:^(NSString *tag, NSInteger index) {
                XYDetailListCell *tagCell = [tableView cellForRowAtIndexPath:indexPath];
                tagCell.subLabelBgColor = TZColor(0, 175, 255);
                tagCell.subLabelFont = 14;
                tagCell.calculateTextWidth = YES;
                tagCell.subText = tag;
                weakSelf.nature = tag;
                weakSelf.selTagIndex = index;
            }];
            [self.navigationController pushViewController:tagVc animated:YES];
        } else {
            XYConfigViewController *introductionVc = [[XYConfigViewController alloc] init];
            introductionVc.titleText = @"群简介";
            introductionVc.type = XYConfigViewControllerTypeTextView;
            if ([self.introduction isEqualToString:@"请填写"]) {
                introductionVc.placeText = nil;
            } else {
                introductionVc.placeText = self.introduction;
            }
            MJWeakSelf
            [introductionVc setDidClickConformBtnBlock:^(NSString *text) {
                XYDetailListCell *introductionCell = [tableView cellForRowAtIndexPath:indexPath];
//                introductionCell.subText = text;
//                weakSelf.groupName = text;
                weakSelf.introduction = text;
                weakSelf.introductionTextH = [CommonTools sizeOfText:text fontSize:14].height + 40;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [self.navigationController pushViewController:introductionVc animated:YES];
        }
    }
    self.row = indexPath.row;
    self.section = indexPath.section;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshCellDetailNamesWithText:(NSString *)text {
    [self.cellDetailTitles2 replaceObjectAtIndex:self.row withObject:text];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.row inSection:self.section];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
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
    RACSignal *signal = [ICEImporter uploadFilesWithUrl:ApiUploadPersonImg params:@{ @"avatar": @"headImage" } files:fileArr];
    [signal subscribeNext:^(NSDictionary *result) {
        [self hideTextHud];
        NSLog(@"%@",result);
//        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        //        NSString *str = [ApiSystemImage stringByAppendingString:result[@"data"][@"avatar"]];
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
        self.iconStr = [ApiSystemImage stringByAppendingString:result[@"data"]];
//        se
//        userModel.avatar = str;
//        if (isIcon) {
//            self.iconStr = str;
////            userModel.avatar = str;
//            params[@"avatar"] = str;
//        } else {
////            userModel.background = str;
//            params[@"background"] = str;
//        }
//        [TZHttpTool postWithURL:ApiEditUser params:params success:^(NSDictionary *result) {
////            [self showHint:@"修改成功"];
//        } failure:^(NSString *msg) {
//            [self showErrorHUDWithError:msg];
//        }];
    }];
}

#pragma mark - EMChooseViewDelegate

- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources {
    NSInteger maxUsersCount = 200;
    if ([selectedSources count] > (maxUsersCount - 1)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"group.maxUserCount", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    [self showHudInView:self.view hint:NSLocalizedString(@"group.create.ongoing", @"create a group...")];
    
    NSMutableArray *source = [NSMutableArray array];
    for (EMBuddy *buddy in selectedSources) {
        [source addObject:buddy.username];
    }
    
    EMGroupStyleSetting *setting = [[EMGroupStyleSetting alloc] init];
    setting.groupMaxUsersCount = maxUsersCount;
    
    if (_isPublic) {
        if(_isMemberOn) {
            setting.groupStyle = eGroupStyle_PublicOpenJoin;
        } else{
            setting.groupStyle = eGroupStyle_PublicJoinNeedApproval;
        }
    } else{
        if(_isMemberOn) {
            setting.groupStyle = eGroupStyle_PrivateMemberCanInvite;
        } else{
            setting.groupStyle = eGroupStyle_PrivateOnlyOwnerInvite;
        }
    }
    
    NSDictionary *params = @{ @"owner": self.groupName};
    [TZHttpTool postWithURL:ApiSensitive params:params success:^(NSDictionary *result) {
        __weak ICECreateGroupViewController *weakSelf = self;
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
        NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join groups \'%@\'"), username, self.groupName];
        [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:self.groupName description:self.introduction invitees:source initialWelcomeMessage:messageStr styleSetting:setting completion:^(EMGroup *group, EMError *error) {
            DLog(@"组的ID %@", group.groupId);
            // 环信群组ID
            _modelGroupInfo.group_id = group.groupId;
            ICELoginUserModel *model = [ICELoginUserModel sharedInstance];
            _modelGroupInfo.uid = model.uid;
            _modelGroupInfo.grouper = model.username;
            _modelGroupInfo.address = self.location;
            NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
            NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
            if (latitude != nil && longitude != nil ) {
                _modelGroupInfo.lng = longitude;
                _modelGroupInfo.lat = latitude;
            } else {
                _modelGroupInfo.lng = @"";
                _modelGroupInfo.lat = @"";
            }
            NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                           initWithDictionary: @{
                                                                 @"grouper" : _modelGroupInfo.grouper,
                                                                 @"lng": _modelGroupInfo.lng,
                                                                 @"lat": _modelGroupInfo.lat,
                                                                 @"uid": _modelGroupInfo.uid,
                                                                 @"group_id": _modelGroupInfo.group_id,
                                                                 @"address": _modelGroupInfo.address,
                                                                 @"owner": _modelGroupInfo.owner,
                                                                 @"avatar": @"groupImg",
                                                                 @"group_permissions": _modelGroupInfo.group_permissions,
                                                                 @"user_permissions": _modelGroupInfo.user_permissions,
                                                                 @"desc" : _modelGroupInfo.desc
                                                                 }];
            NSArray *fileArr = @[
                                 @{
//                                     @"file":self.imgGroup.image,
                                     @"file":self.avaterName,
                                     @"name" : @"imgGroup.png",
                                     @"key" : @"avatar"
                                     }
                                 ];
            // 环信群组创建后调用后台接口
            RACSignal *signal = [ICEImporter createGroupWithParams:params files:fileArr];
            [weakSelf hideHud];
            [signal subscribeNext:^(id x) {
                
            } completed:^{
                if (group && !error) {
                    [weakSelf showHint:NSLocalizedString(@"group.create.success", @"create group success")];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
        } onQueue:nil];
    } failure:^(NSString *msg) {
        [self hideTextHud];
        [self showInfo:msg];
    }];
    return YES;
}

#pragma mark - action
// 地理编码
- (void)geocoderActionWithAddressText:(NSString *)addressText{
    if (!addressText && addressText.length) return;
    
    [self.geocoder geocodeAddressString:NotNullStr(addressText) completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0 || error != nil) {
            return;
        }
        CLPlacemark *placeMark = [placemarks firstObject];
        NSLog(@"%@ %f %f",placeMark.name,placeMark.location.coordinate.latitude,placeMark.location.coordinate.longitude);
        self.lat = placeMark.location.coordinate.latitude;
        self.lng = placeMark.location.coordinate.longitude;
    }];
}

//- (void)groupTypeChange:(UISwitch *)control {
//    _isPublic = control.isOn;
//    
//    [_groupMemberSwitch setOn:NO animated:NO];
//    [self groupMemberChange:_groupMemberSwitch];
//    
//    if (control.isOn) {
//        _groupTypeLabel.text = NSLocalizedString(@"group.create.public", @"public group");
//    } else{
//        _groupTypeLabel.text = NSLocalizedString(@"group.create.private", @"private group");
//    }
//}

//- (void)groupMemberChange:(UISwitch *)control {
//    if (_isPublic) {
//        if(control.isOn) {
//            _groupMemberLabel.text = NSLocalizedString(@"group.create.open", @"random join");
//        } else{
//            _groupMemberLabel.text = NSLocalizedString(@"group.create.needApply", @"you need administrator agreed to join the group");
//        }
//    } else {
//        if(control.isOn) {
//            _groupMemberLabel.text = NSLocalizedString(@"group.create.allowedOccupantInvite", @"allows group members to invite others");
//        } else {
//            _groupMemberLabel.text = NSLocalizedString(@"group.create.unallowedOccupantInvite", @"don't allow group members to invite others");
//        }
//    }
//    _isMemberOn = control.isOn;
//}


@end
