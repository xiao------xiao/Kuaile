//
//  ICESelfInfoViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/16.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICESelfInfoViewController.h"
#import "ICEHeadTableViewCell.h"
#import "ICEDescTableViewCell.h"
#import "ICEEditPwdViewController.h"
#import "ICESelfInfoModel.h"
#import "ICEForgetViewController.h"
#import "XYTipView.h"
#import "XYPhotoViewController.h"
#import "TZButtonsHeaderView.h"
#import "TZFindSnsCell.h"
#import "XYSelfCareViewController.h"
#import "XYEditUserViewController.h"
#import "XYUserInfoModel.h"
#import "ICEGiftView.h"
#import "TZFindSnsModel.h"
#import "ZYYSnsDetailController.h"
#import "XYNaviView.h"
#import "ChatViewController.h"
#import "XYChatSettingController.h"
#import "XYNaviView.h"
#import "ICEGiftView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK+InterfaceAdapter.h>
#import "TZFillBaseInfoViewController.h"
#import "YYKit.h"


@interface ICESelfInfoViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_cellDataArray;
    BOOL _showingTip;
    BOOL _canUnbindPhone;
    BOOL _isEditing;
    BOOL _firstEnterSns;
    NSInteger _index;
    NSInteger _page;
    NSInteger _totalPage;
    CGFloat _leftTotalH;
    CGFloat _rightTotalH;
    CGFloat _selectViewMaxY;
    CGFloat _HeaderViewMaxY;
    CGFloat _selecteViewH;
    CGFloat _rightTableViewH;
    BOOL _netFlag;
}
//@property (nonatomic, strong) ICESelfInfoModel *modelSelfInfo;
@property (nonatomic, strong) XYTipView *tipView;
@property (nonatomic, strong) ICEGiftView *shareView;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIImage *bgImg;

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) ICEHeadTableViewCell *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) TZButtonsHeaderView *selecteView;
@property (nonatomic, strong) TZButtonsBottomView *bottomView;
@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) XYUserInfoModel *infoModel;
@property (nonatomic, strong) NSMutableArray *userSns;

@property (nonatomic, assign) CGFloat scrollViewY;
@property (nonatomic, assign) CGFloat signRowH;
@property (nonatomic, strong) XYNaviView *navView;
@property (nonatomic, strong) UIScrollView *bigScrollView;

@property (nonatomic, strong, getter=getBackView)   UIView      *backView;
@property (nonatomic, strong, getter=getSheetView)  UIView      *sheetView;
@property (nonatomic, strong, getter=getGiftView)   ICEGiftView *giftView;

@end

@implementation ICESelfInfoViewController

- (NSMutableArray *)userSns {
    if (_userSns == nil) {
        _userSns = [NSMutableArray array];
    }
    return _userSns;
}

- (ICEGiftView *)shareView {
    if (_shareView == nil) {
        _shareView = [[ICEGiftView alloc] init];
        _shareView.frame = CGRectMake(0, mScreenHeight, mScreenWidth, 300);
        [_shareView setDidClickCancelBtnBlock:^{
            [UIView animateWithDuration:0.2 animations:^{
                _shareView.y = mScreenHeight;
            }];
        }];
        [self.view addSubview:_shareView];
    }
    return _shareView;
}

- (XYTipView *)tipView {
    if (!_tipView) {
        _tipView = [[XYTipView alloc] init];
        if (self.type == ICESelfInfoViewControllerTypeSelf) {
            _tipView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64);
        } else {
            _tipView.frame = CGRectMake(0, 64, mScreenWidth, mScreenHeight - 64);
        }
        _tipView.noCover = NO;
//        _tipView.titleLeftEdge = 5;
        _tipView.imageRightEdge = 10;
        NSArray *titles;
        NSArray *images;
        if (self.type == ICESelfInfoViewControllerTypeSelf) {
            titles = @[@"编辑",@"分享"];
            images = @[@"bianji",@"fenxiang"];
        } else {
            titles = @[@"分享"];
            images = @[@"fenxiang"];
        }
        _tipView.titleColor = TZGreyText150Color;
        _tipView.lineColor = [UIColor whiteColor];
        [_tipView configTipBtnsWithTitles:titles images:images];
        [_tipView setDidClickBtnBlock:^(NSInteger index) {
            if (self.type == ICESelfInfoViewControllerTypeSelf) {
                if (index == 0) { //编辑
                    XYEditUserViewController *editVc = [[XYEditUserViewController alloc] init];
                    editVc.model = _infoModel;
                    [self.navigationController pushViewController:editVc animated:YES];
                } else {//分享
                    NSLog(@"-----------------%f",self.shareView.y);
                    [UIView animateWithDuration:0.2 animations:^{
                        self.shareView.y = mScreenHeight - 64 - 300;
                    }];
//                    [self createshareView];
                }
            } else {
                if (index == 0) { // 分享
                   [self createshareView];
                }
            }
            _showingTip = NO;
            [self rightItemClick];
        }];
        [_tipView setDidClickCoverBtnBlock:^{
            _showingTip = NO;
            [self rightItemClick];
        }];
        [self.view addSubview:_tipView];
    }
    return _tipView;
}

-(void)createshareView {
//    [self showSheet];
//    [self showPhotoActionSheet];
    [self configGiftBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == ICESelfInfoViewControllerTypeSelf) {
        self.title = @"我的主页";
    }
    _showingTip = YES;
    _index = 0;
    _firstEnterSns = YES;
    _page = 1;
    _totalPage = [[mUserDefaults objectForKey:@"sns_totalPage"] integerValue];
    UIImage *itemImage;
    if (self.type == ICESelfInfoViewControllerTypeOther) {
        [self loadFriendUserInfoData];
        itemImage = [UIImage imageNamed:@"分享-8 copy"];
    } else {
        [self loadNetWorkData];
        itemImage = [UIImage imageNamed:@"cz"];
    }
    if (self.type == ICESelfInfoViewControllerTypeOther) {
        [self configNavView];
    }
    
//    self.leftNavImageName = @"back";
    
    [self configBigScrollView];
    [self configHeaderView];
    [self configSelectView];
    [self configScrollView];
    [self configTableView];
    [self configDatePickerView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:itemImage style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    //修改用户信息
    [mNotificationCenter addObserver:self selector:@selector(didEditUserInfo) name:@"didEditUserInfoNoti" object:nil];
    [mNotificationCenter addObserver:self selector:@selector(handleAttentionAction) name:@"handAttentionNoti" object:nil];
    [mNotificationCenter addObserver:self selector:@selector(didUpdateUserInfo) name:@"didUpdateMemberInfo" object:nil];
    
    [mNotificationCenter addObserver:self selector:@selector(loadInfo) name:@"needRefreshFindVcNoti" object:nil];

    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _bigScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    

}

- (void)loadInfo {
    [self loadSnsData];
    [self loadFriendUserInfoData];
}

- (void)didClickLeftNavAction {
    
    BOOL flag;
    
    if (self.navigationController.viewControllers.count < 2) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    for (int i = 0 ; i < self.navigationController.viewControllers.count - 1; i ++) {
        UIViewController *v1 = self.navigationController.viewControllers[i];
        UIViewController *v2 = self.navigationController.viewControllers[i + 1];

        if (![v1 isKindOfClass:[ICESelfInfoViewController class]] && [v2 isKindOfClass:[ICESelfInfoViewController class]]) {
            [self.navigationController popToViewController:v1 animated:YES];
            break;
        }
    }
    
    
}

- (void)handleAttentionAction {
    [self loadFriendUserInfoData];
}

- (void)configBigScrollView {
    _bigScrollView = [[UIScrollView alloc] init];
    _bigScrollView.delegate = self;
    _bigScrollView.tag = 100;
    _bigScrollView.backgroundColor = [UIColor whiteColor];
    _bigScrollView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight);
    [self.view addSubview:_bigScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.type == ICESelfInfoViewControllerTypeOther) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [self.view bringSubviewToFront:_bottomView];
    [self.view bringSubviewToFront:_navView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.type == ICESelfInfoViewControllerTypeOther) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)configNavView {
    _navView = [[XYNaviView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 64)];
    _navView.bgView.hidden = YES;
    _navView.rightImage = @"分享-8 copy";
    _navView.title = self.nickName;
    _navView.titleLabel.hidden = YES;
    _navView.backgroundColor = [UIColor clearColor];
    MJWeakSelf
    [_navView setDidClickBackBtnBlock:^{
        [self didClickLeftNavAction];
//        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [_navView setDidClickRightBarBtnBlock:^(BOOL selected){
        [self rightItemClick];
    }];
    [self.view addSubview:_navView];
    
//    _navView = [[XYNaviView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 64)];
//    _navView.title = self.titleText;
//    _navView.bgView.hidden = YES;
//
//    MJWeakSelf
//    [_navView setDidClickBackBtnBlock:^{
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    }];
//    [_navView setDidClickRightBarBtnBlock:^(BOOL selected){
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
//    }];
//    [self.view addSubview:_navView];
}


// 修改用户信息之后再次获取用户信息
- (void)didEditUserInfo {
    [TZUserManager syncUserModelWithCompletion:^(XYUserInfoModel *model) {
        self.infoModel = model;
        _headerView.model = self.infoModel;
        [self loadTableViewData];
        [self.tableView reloadData];
    }];
}

- (void)didUpdateUserInfo {
    [_bottomView removeFromSuperview];
    [self configBottmView];
}

//获取他人信息
- (void)loadFriendUserInfoData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    params[@"lat"] = [mUserDefaults objectForKey:@"latitude"];
    params[@"lng"] = [mUserDefaults objectForKey:@"longitude"];
    if (self.otherUsername && self.otherUsername.length) {
        params[@"username"] = self.otherUsername;
    } else if (self.uid && self.uid.length) {
        params[@"uid"] = self.uid;
    }
    NSString *ss = self.otherUsername;
    NSLog(@"%@",params);
    [TZHttpTool postWithURL:ApiDeletefetOtherInfo params:params success:^(NSDictionary *result) {
        XYUserInfoModel *model = [XYUserInfoModel mj_objectWithKeyValues:result[@"data"]];
        _headerView.model = model;
        self.infoModel = model;
        [self configBottmView];
        [self loadTableViewData];
        [self.tableView reloadData];
    } failure:^(NSString *msg) {
    }];
}

//获取用户信息
- (void)loadNetWorkData {
    self.infoModel = [TZUserManager getUserModel];
    _headerView.model = self.infoModel;
    [self.tableView configNoDataTipViewWithCount:1];
    [self loadTableViewData];
    [self.tableView reloadData];
}

- (void)or_changeContentSizeAndRightTableFrame {
    
    
    if (self.userSns.count == 0) {
        _rightTableViewH = mScreenHeight - _selectViewMaxY;
    } else {
        _rightTableViewH = mScreenHeight - 64 - _selecteViewH;
    }
    
    CGRect rect = _rightTableView.frame;
    rect.size.height = _rightTableViewH;
    _rightTableView.frame = rect;
    
    if (self.type == ICESelfInfoViewControllerTypeOther) {
        if (self.userSns.count == 0) {
            [_bigScrollView setContentSize:CGSizeMake(0, _leftTotalH)];
        } else {
            [_bigScrollView setContentSize:CGSizeMake(0, _rightTableViewH  + _selectViewMaxY - 18)];
        }
    } else {
        if (self.userSns.count == 0) {
            [_bigScrollView setContentSize:CGSizeMake(0, _leftTotalH)];
        } else {
            [_bigScrollView setContentSize:CGSizeMake(0, _rightTableViewH  + _selectViewMaxY + 64)];
        }
    }

}

// 获取用户帖子
- (void)loadUserSnsData {
    NSArray *arary = [TZUserManager getUserSns];
    [self.userSns addObjectsFromArray:[TZUserManager getUserSns]];
    [self rightTableView];
    [self.rightTableView configNoDataTipViewWithCount:self.userSns.count tipText:@"暂无帖子"];
    [self or_changeContentSizeAndRightTableFrame];
    
    [self.rightTableView reloadData];
    [self loadSnsData];
}

- (void)loadTableViewData {
    _cellDataArray = @[@"昵称",@"家乡",@"现居地",@"情感状态",@"个性签名"];
    NSString *nick = self.infoModel.nickname;
    NSString *phone = self.infoModel.username;
    NSString *hometown;
    NSString *address;
    NSString *sex;
    NSString *emotionStatus;
    hometown = (_infoModel.hometown && _infoModel.hometown.length > 0) ? _infoModel.hometown : @"未填写";
    address = (_infoModel.address && _infoModel.address.length > 0) ? _infoModel.address : @"未填写";
    if ([_infoModel.gender isEqualToString:@"0"]) { sex = @"男"; }
    else if ([_infoModel.gender isEqualToString:@"1"]) { sex = @"女"; }
    else { sex = @"未选择"; }
    NSInteger emotionInt = _infoModel.emotional_state.integerValue;//情感状态1保密2单身3热恋中4已婚
    if (emotionInt == 1) { emotionStatus = @"保密"; }
    else if (emotionInt == 2) { emotionStatus = @"单身";}
    else if (emotionInt == 3) { emotionStatus = @"热恋中"; }
    else if (emotionInt == 4) { emotionStatus = @"已婚"; }
    else { emotionStatus = @"未选择"; }
    NSString *birthday = (_infoModel.birthday && _infoModel.birthday.length > 0) ? [[ICETools standardTime:_infoModel.birthday] substringToIndex:10] : @"未选择";
    NSString *signature = (_infoModel.sign && _infoModel.sign.length > 0) ? _infoModel.sign : @"未填写";
    CGFloat signFont;
    if (mScreenWidth < 375) {
        signFont = 14;
    } else {
        signFont = 16;
    }
    self.signRowH = [CommonTools sizeOfText:signature fontSize:signFont].height + 45;
    self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[nick, hometown, address, emotionStatus, signature]];
}

- (void)configHeaderView {
    _headerView = [[ICEHeadTableViewCell alloc] init];
    
    if (self.type == ICESelfInfoViewControllerTypeSelf) {
        if (mScreenWidth < 375) {
            _headerView.frame = CGRectMake(0, 0, mScreenWidth, 250);
        } else {
            _headerView.frame = CGRectMake(0, 0, mScreenWidth, 270);
        }
        _headerView.avatarTopMarginConstraintH.constant = 30;
        _headerView.distance_timeLabel.hidden = YES;
    } else {
        if (mScreenWidth < 375) {
            _headerView.frame = CGRectMake(0, 0, mScreenWidth, 320);
        } else {
            _headerView.frame = CGRectMake(0, 0, mScreenWidth, 350);
        }
        _headerView.changeBtn.hidden = YES;
    }
//    _headerView.model = self.infoModel;
    
    [TZUserManager syncUserModelWithCompletion:^(XYUserInfoModel *model) {
        _headerView.model = model;
    }];
    
    MJWeakSelf
    [_headerView setBlockEditHeadImg:^{
        
        if (self.infoModel.avatar) {
            XYPhotoViewController *photoVc = [[XYPhotoViewController alloc] init];
            NSURL *imgUrl = [NSURL URLWithString:self.infoModel.avatar];
            NSData *data = [NSData dataWithContentsOfURL:imgUrl];
            UIImage *currentIcon = [UIImage imageWithData:data];
            if (self.type != ICESelfInfoViewControllerTypeSelf) {
                photoVc.isOther = YES;
            }
            photoVc.currentIcon = currentIcon;
            //            [photoVc setDidSelecteAvatarBlock:^(UIImage *selectedAvatar){
            //                [weakSelf.headerView.imgHeadBtn setBackgroundImage:selectedAvatar forState:0];
            //            }];
            [self.navigationController pushViewController:photoVc animated:YES];

        }else {
            if (self.type == ICESelfInfoViewControllerTypeSelf) {
                
                [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
                    weakSelf.icon = editedImage;
                    [weakSelf.headerView.imgHeadBtn setBackgroundImage:editedImage forState:0];
                    [weakSelf updataHeadImg:editedImage isIcon:YES];
                }];
                
            }

        }
        
        
    }];
    [_headerView setDidClickChangeBtnBlock:^{ //换背景
        [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
            weakSelf.bgImg = editedImage;
            [weakSelf.headerView.coverBtn setBackgroundImage:editedImage forState:0];
            [weakSelf updataHeadImg:editedImage isIcon:NO];
        }];
    }];
    
    [_headerView setDidClickAttentionBtnBlock:^{ // 关注
        if (![TZUserManager isLogin]) return;

        if (weakSelf.type == ICESelfInfoViewControllerTypeSelf) {
            XYSelfCareViewController *careVc = [[XYSelfCareViewController alloc] init];
            careVc.type = @"1";
            [weakSelf.navigationController pushViewController:careVc animated:YES];
        }
    }];
    
    [_headerView setDidClickTieBtnBlock:^{
        [_selecteView btnClick:_selecteView.myTieBtn];
    }];
    
    [_headerView setDidClickFanBtnBlock:^{
        if (![TZUserManager isLogin]) return;
        
        if (weakSelf.type == ICESelfInfoViewControllerTypeSelf) {
            XYSelfCareViewController *careVc = [[XYSelfCareViewController alloc] init];
            careVc.type = @"2";
            [weakSelf.navigationController pushViewController:careVc animated:YES];
        }
    }];
    
    [_bigScrollView addSubview:_headerView];
    
    
    
}

- (void)configBottmView {
    
    NSInteger attenStr = self.infoModel.is_attention.integerValue;
     __block BOOL isAttention = attenStr == 1 ? YES : NO;
    if (![TZUserManager isLoginNoPresent]) {
        isAttention = NO;
    }
    _bottomView = [[TZButtonsBottomView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.btnY = 5;
    _bottomView.showHeadLine = YES;
    _bottomView.frame = CGRectMake(0, mScreenHeight - 46, mScreenWidth, 46);
    _bottomView.images = @[@"pinjia",@"",@"icon_rjsz"];//pin_def
    if (isAttention) {
        _bottomView.titles = @[@"聊天",@"已关注",@"设置"];
        _bottomView.bgColors = @[TZColor(1, 196, 255),TZColorRGB(200),TZColor(1, 196, 255)];
        [_bottomView setBtnTitleColor:TZGreyText74Color bgColor:TZColorRGB(200) forIndex:1];
    } else {
        _bottomView.titles = @[@"聊天",@"+关注",@"设置"];
        _bottomView.bgColors = @[TZColor(1, 196, 255),TZColor(70, 175, 255),TZColor(1, 196, 255)];
    }
    _bottomView.fontSizes = @[@14,@14,@14];
    MJWeakSelf
    [_bottomView setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        if ([TZUserManager isLogin]) {
            
            if (index == 0) {
                if (isAttention) {
                    NSString *phone = weakSelf.infoModel.phone;
                    NSString *chatter = phone.length ? phone : weakSelf.infoModel.username;
                    ChatViewController *chatVc = [[ChatViewController alloc] initWithChatter:chatter isAttented:isAttention isGroup:NO];
                    chatVc.title = weakSelf.infoModel.nickname;
                    [weakSelf.navigationController pushViewController:chatVc animated:YES];
                } else {
                    [self showAlertViewWithTitle:@"提示" message:@"关注之后才能聊天哦"];
                }
            } else if (index == 1) {
                
                if (_netFlag) {
                    return ;
                }
                
                _netFlag = YES;
                
                NSInteger fans = self.infoModel.fans_num.integerValue;
                NSInteger attentions = self.infoModel.attention_num.integerValue;
                if (isAttention) {
                    [_bottomView setBtnTitleColor:[UIColor whiteColor] bgColor:TZColor(70, 175, 255) forIndex:1];
                    [_bottomView setBtnTitle:@"+关注" forIndex:1];
                    isAttention = NO;
                    attentions -= 1;
                    fans -= 1;
                    if (_addBlock) {
                        _addBlock(NO);
                    }
                } else {
                    
                    if (_addBlock) {
                        _addBlock(YES);
                    }
                    
                    [_bottomView setBtnTitleColor:TZGreyText74Color bgColor:TZColorRGB(240) forIndex:1];
                    [_bottomView setBtnTitle:@"已关注" forIndex:1];
                    isAttention = YES;
                    attentions += 1;
                    fans += 1;
                }
                self.infoModel.fans_num = [NSString stringWithFormat:@"%zd",fans];
                self.infoModel.attention_num = [NSString stringWithFormat:@"%zd",attentions];
                _headerView.model = self.infoModel;
                [weakSelf checkAttentionStatusWithBuddyName:weakSelf.infoModel.uid];
                
//                [weakSelf loadFriendUserInfoData];
            } else {
                XYChatSettingController *setVc = [[XYChatSettingController alloc] init];
                setVc.name = self.infoModel.username;
                [weakSelf.navigationController pushViewController:setVc animated:YES];
            }
        }
    }];
    [self.view addSubview:_bottomView];
}

- (void)checkAttentionStatusWithBuddyName:(NSString *)buddyName {
    if (buddyName && buddyName.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
        params[@"buid"] = buddyName;
        [TZHttpTool postWithURL:ApiSnsConcernUser params:params success:^(NSDictionary *result) {
            _netFlag = NO;
            [self showSuccessHUDWithStr:result[@"msg"]];
            [mNotificationCenter postNotificationName:@"didAddFriendNoti" object:nil];
            // 加好友添加积分
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"uid": userModel.uid }];
            RACSignal *sign = [ICEImporter addFriendsIntegralWithParams:params];
        } failure:^(NSString *msg) {
            _netFlag = NO;
        }];
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
    RACSignal *signal = [ICEImporter uploadFilesWithUrl:ApiUploadPersonImg params:@{ @"avatar": @"headImage" } files:fileArr];
    [signal subscribeNext:^(NSDictionary *result) {
        [self hideTextHud];
        NSLog(@"%@",result);
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
        NSString *str = [ApiSystemImage stringByAppendingString:result[@"data"]];
        userModel.avatar = str;
        if (isIcon) {
            userModel.avatar = str;
            params[@"avatar"] = str;
        } else {
            userModel.background = str;
            params[@"background"] = str;
        }
        [TZHttpTool postWithURL:ApiEditUser params:params success:^(NSDictionary *result) {
            [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];

        } failure:^(NSString *msg) {
            
            [self showErrorHUDWithError:msg];
        }];
    }];
}

- (void)configSelectView {
    _HeaderViewMaxY = CGRectGetMaxY(_headerView.frame);
    _selecteViewH = 50;
    _selecteView = [[TZButtonsHeaderView alloc] init];
    _selecteView.frame = CGRectMake(0, _HeaderViewMaxY, mScreenWidth, _selecteViewH);
    if (self.type == ICESelfInfoViewControllerTypeSelf) {
        _selecteView.titles = @[@"个人资料",@"我的帖子"];
    } else {
        _selecteView.titles = @[@"TA的资料",@"TA的帖子"];
    }
    _selecteView.fontSizes = @[@16,@16];
    _selecteView.showLines = NO;
    _selecteView.boldFont = 16;
    _selecteView.changeFontWhenSelected = YES;
    _selecteView.selectBtnIndex = 0;
    [_selecteView setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        if (index == 1) {
            [_scrollView setContentOffset:CGPointMake(mScreenWidth, 0)];
        } else {
            [_scrollView setContentOffset:CGPointMake(0, 0)];
        }
    }];
    [_bigScrollView addSubview:_selecteView];
}

- (void)configScrollView {
    self.scrollViewY = CGRectGetMaxY(_selecteView.frame);
    CGFloat height = self.type == ICESelfInfoViewControllerTypeOther ? 46 : 64;
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.tag = 101;
    _scrollView.frame = CGRectMake(0, self.scrollViewY, mScreenWidth, mScreenHeight);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView setContentSize:CGSizeMake(mScreenWidth * 2, 0)];
    [_bigScrollView addSubview:_scrollView];
}

- (void)configUITableView {
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNetWorkData];
    }];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadNetWorkData];
    }];
}

- (void)configTableView {
    if (self.type == ICESelfInfoViewControllerTypeSelf) {
        _selectViewMaxY = CGRectGetMaxY(_selecteView.frame);
    } else {
        _selectViewMaxY = CGRectGetMaxY(_selecteView.frame) + 64;
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 50 * 4 + self.signRowH) style:UITableViewStylePlain];
    self.tableView.tag = 102;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [_scrollView addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerCellByNibName:@"ICEDescTableViewCell"];
    [super configTableView];
    if (self.type == ICESelfInfoViewControllerTypeSelf) {
        _leftTotalH = CGRectGetMaxY(self.tableView.frame) + 20 + _selectViewMaxY + 64;
    } else {
        _leftTotalH = CGRectGetMaxY(self.tableView.frame) + _selectViewMaxY;
    }
    [_bigScrollView setContentSize:CGSizeMake(0, _leftTotalH)];
}

- (UITableView *)rightTableView {
    if (_rightTableView == nil) {
        if (self.type == ICESelfInfoViewControllerTypeSelf) {
            if (self.userSns.count == 0) {
                _rightTableViewH = mScreenHeight - _selectViewMaxY;
            } else {
                _rightTableViewH = mScreenHeight - 64 - _selecteViewH;
            }
        } else {
            if (self.userSns.count == 0) {
                _rightTableViewH = mScreenHeight - _selectViewMaxY;
            } else {
                _rightTableViewH = mScreenHeight - 64 - _selecteViewH - 46;
            }
        }
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(mScreenWidth, 0, mScreenWidth, _rightTableViewH) style:UITableViewStylePlain];
        _rightTableView.tag = 103;
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        [_scrollView addSubview:_rightTableView];
        _rightTableView.scrollEnabled = NO;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.tableFooterView = [UIView new];
        _rightTableView.sectionFooterHeight = 0;
//        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithHeader)];
//        _rightTableView.mj_header = header;
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithFooter)];
        _rightTableView.mj_footer = footer;
        [_rightTableView registerCellByNibName:@"TZFindSnsCell"];
    }
    return _rightTableView;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tableView == tableView) {
        return _cellDataArray.count;
    } else {
        return self.userSns.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView == tableView) {
        ICEDescTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ICEDescTableViewCell"];
        if (indexPath.row == 1) {
            
        }
        cell.labNameStr.font = [UIFont systemFontOfSize:16];
        cell.labDescStr.font = [UIFont systemFontOfSize:16];
        if (mScreenWidth < 375) {
            cell.labNameStr.font = [UIFont systemFontOfSize:14];
            cell.labDescStr.font = [UIFont systemFontOfSize:14];
        }
        cell.labDescStr.text = self.cellDetailTitles2[indexPath.row];
        cell.labNameStr.text = _cellDataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        TZFindSnsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZFindSnsCell"];
        TZFindSnsModel *model = self.userSns[indexPath.row];
        cell.model = model;
        cell.careBtn.hidden = YES;
        cell.delegate = self;
        MJWeakSelf
        cell.blockClickZanReload = ^(NSString *msg) {
            [weakSelf showInfo:msg];
            [weakSelf.rightTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
        };

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView == tableView) {
        if (indexPath.row == 4) {
            return self.signRowH;
        } else {
            return 50;
        }
    } else {
        TZFindSnsModel *model = self.userSns[indexPath.row];
        return model.totalHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView != tableView) {
        ZYYSnsDetailController *snsDetailVc = [[ZYYSnsDetailController alloc] init];
        TZFindSnsModel *model = self.userSns[indexPath.row];
        snsDetailVc.model = model;
        MJWeakSelf;
        [snsDetailVc setRefreshUIBlock:^{
            [weakSelf.tableView reloadData];
        }];
        [snsDetailVc setRefreshDeleteUIBlock:^(TZFindSnsModel *model, NSString *sid) {
            [self FindSnsCelldelegate:self sidID:sid removeArray:model];
        }];
        [self.navigationController pushViewController:snsDetailVc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -- private 

- (void)rightItemClick {
    [self createshareView];
    if (self.type == ICESelfInfoViewControllerTypeSelf) {
        if (_showingTip) {
            self.tipView.hidden = NO;
            _showingTip = NO;
        } else {
            self.tipView.hidden = YES;
            _showingTip = YES;
        }
    } else {
        [self.shareView class];
        [UIView animateWithDuration:0.2 animations:^{
            if (self.type == ICESelfInfoViewControllerTypeOther) {
                self.shareView.y = mScreenHeight - 300;
            }
        }];
    }
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 101) {
        CGFloat x = scrollView.contentOffset.x;
        NSInteger index = x / mScreenWidth + 0.5;
        if (index == 1) {
            _selecteView.selectBtnIndex = 1;
            if (self.type == ICESelfInfoViewControllerTypeSelf) {
                if (_firstEnterSns) {
                    [self loadUserSnsData];
                }
                _firstEnterSns = NO;
            } else {
                if (_firstEnterSns) {
                    [self loadSnsData];
                }
                _firstEnterSns = NO;
            }
        } else{
            _selecteView.selectBtnIndex = 0;
            self.tableView.scrollEnabled = NO;
            _bigScrollView.scrollEnabled = YES;
        }
    } else {
        CGFloat offsetY = scrollView.contentOffset.y;
        // 改变导航栏
        if (scrollView.tag == 100) {
            if (offsetY >= 64) {
                _navView.bgView.hidden = NO;
                _navView.titleLabel.hidden = NO;
            } else {
                _navView.bgView.hidden = YES;
                _navView.titleLabel.hidden = YES;
            }
        }
        // 当偏移量超过_HeaderViewMaxY时，让rightTableView能够滚动
        CGFloat needScrollTableY = _HeaderViewMaxY;
        if (self.type == ICESelfInfoViewControllerTypeOther) {
            needScrollTableY = _HeaderViewMaxY - 64;
        }
        if (offsetY >= needScrollTableY) {
            self.rightTableView.scrollEnabled = YES;
            _bigScrollView.scrollEnabled = NO;
        }
        
        // 当当前滚动的为rightTableView时且偏移量接近0时，不让rightTableView滚动
        if ((scrollView.tag == 103 && offsetY <= 0) || (scrollView.tag == 102 && offsetY <= 0)) {
            self.rightTableView.scrollEnabled = NO;
            _bigScrollView.scrollEnabled = YES;
        }
    }
    NSInteger tag = scrollView.tag;
}



// 上拉加载
- (void)refreshDataWithFooter {
    _page ++;
    if (_page > _totalPage) {
        [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self loadSnsData];
    }
}

- (void)loadSnsData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(_page);
    if (self.type == ICESelfInfoViewControllerTypeSelf) {
        params[@"uid"] = [mUserDefaults objectForKey:@"userUid"];
    } else {
        params[@"uid"] = self.infoModel.uid;
    }
    
    params[@"sessionid"] = @"";
    
    [TZHttpTool postWithURL:ApiSnsUserList params:params success:^(NSDictionary *result) {

        if (_page == 1) {
            [self.userSns removeAllObjects];
        }
        
        NSArray * dictArray = result[@"data"][@"sns"];
        
        NSMutableArray *aar = [NSMutableArray array];
        [dictArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TZFindSnsModel *model = [TZFindSnsModel modelWithDictionary:obj];
            [aar addObject:model];
        }];

        
        NSArray *snses = [TZFindSnsModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"sns"]];
        [self.userSns addObjectsFromArray:aar];
        _totalPage = [result[@"data"][@"count_page"] integerValue];
        [self.rightTableView configNoDataTipViewWithCount:self.userSns.count tipText:@"暂无帖子"];
        
        [self or_changeContentSizeAndRightTableFrame];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rightTableView reloadData];
            [self.rightTableView endRefresh];
        });
        
    } failure:^(NSString *msg) {
        [self.rightTableView endRefresh];
        if (self.type == ICESelfInfoViewControllerTypeSelf) {
            if (self.userSns.count == 0) {
                [_bigScrollView setContentSize:CGSizeMake(0, _leftTotalH)];
            } else {
                [_bigScrollView setContentSize:CGSizeMake(0, _rightTableViewH + 5 + _selectViewMaxY + 64)];
            }
        }
    }];
}

- (void)configGiftBtn {
    [[self.shareView.btnQQ rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeQQ];
    }];
    [[self.shareView.btnWeChat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeWeixiSession];
    }];
    [[self.shareView.btnSina rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeSinaWeibo];
    }];
    [[self.shareView.btnQzone rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeQQSpace];
    }];
    [[self.shareView.btnWeChatFriend rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeWeixiTimeline];
    }];
    [[self.shareView.btnCancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self cancelAnimation:^{
            [self.backView removeFromSuperview];
        }];
    }];
}


- (void)shareButtonClickHandler:(ShareType)type
{
    UIImage *shareImage = [UIImage imageNamed:@"Icon-40"];
    
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ApiShare,self.model.uid]];
//    NSURL *shareURL = [NSURL URLWithString:@"tongyu.com.cn://tongyu.com.cn"];
    
//    NSURL *shareURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/开心工作/id1068849473?mt=8"];
    
    NSString *shareContent = @"我正在使用开心工作APP，找工作，赢大奖，享服务。";
    // v3.3.0版 分享
    if (type == ShareTypeSinaWeibo) {
        shareContent = [shareContent stringByAppendingString:shareURL.absoluteString];
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:shareContent
                                     images:shareImage
                                        url:shareURL
                                      title:@"[有人@你] 下载开心工作APP，开开心心找工作"
                                       type:SSDKContentTypeAuto];
    [shareParams SSDKSetupWeChatParamsByText:@"我正在使用开心工作APP，找工作，赢大奖，享服务。" title:@"[有人@你] 下载开心工作APP，开开心心找工作" url:shareURL thumbImage:shareImage image:shareImage musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    NSInteger typeInt = type;
    SSDKPlatformType shareType = typeInt;
    if (shareType == SSDKPlatformTypeSinaWeibo) {
        [self cancelAnimation:^{
            [self.backView removeFromSuperview];
        }];
        BOOL ret = [ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo];
        if (ret) {
            [[UIViewController currentViewController] showTextHUDWithStr:@"分享中..."];
        }
    }
    [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            [[UIViewController currentViewController] showSuccessHUDWithStr:@"分享成功"];
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"uid": userModel.uid }];
            [ICEImporter shareIntegralWithParams:params];
        } else if (state == SSDKResponseStateFail) {
            NSLog(@"分享失败! %@",error);
            [[UIViewController currentViewController] showErrorHUDWithError:@"分享失败"];
        } else if (state == SSDKResponseStateCancel) {
            NSLog(@"取消分享 %@",userData);
        }
        [[UIViewController currentViewController] hideTextHud];
        [self cancelAnimation:^{
            [self.backView removeFromSuperview];
        }];
    }];
}
- (void)showSheet {
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    [self.backView addSubview:self.sheetView];
    [self.sheetView addSubview:self.giftView];
}
/** 显示 */
- (void)showPhotoActionSheet {
    CGRect frame = self.sheetView.frame;
    
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - 300;
    [UIView animateWithDuration:.25f animations:^{
        self.sheetView.frame = frame;
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
        DLog(@"完成");
    }];
}

/** 隐藏 */
- (void)cancelAnimation:(void (^)(void))comple {
    CGRect frame = self.sheetView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:.25f animations:^{
        self.sheetView.frame = frame;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        if (comple) {
            comple();
        }
        [self.backView removeFromSuperview];
    }];
}

#pragma mark - Getters And Setters
- (ICEGiftView *)getGiftView {
    if (_giftView == nil) {
        _giftView = [[ICEGiftView alloc] init];
        _giftView.frame = CGRectMake(0, 0, __kScreenWidth, 300);
    }
    return _giftView;
}
/** 底板SheetView*/
- (UIView *)getSheetView{
    if (_sheetView == nil) {
        CGRect frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 300);
        _sheetView = [[UIView alloc] initWithFrame:frame];
        _sheetView.backgroundColor = [UIColor lightGrayColor];
    }
    return _sheetView;
}

- (UIView *)getBackView{
    if (_backView == nil) {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _backView = [[UIView alloc] initWithFrame:frame];
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _backView.alpha = 0;
    }
    return _backView;
}


#pragma mark -- 跳转到详情页面
-(void)FindSnsCelldelegate:(TZFindSnsCell *)cell removeArray:(TZFindSnsModel *)model {
    if (![TZUserManager isLogin]) return;
    ZYYSnsDetailController *vc = [[ZYYSnsDetailController alloc] init];
    vc.model = model;
    
    MJWeakSelf;
    [vc setRefreshUIBlock:^{
        [weakSelf.tableView reloadData];
    }];
    [vc setRefreshDeleteUIBlock:^(TZFindSnsModel *model, NSString *sid) {
        [self FindSnsCelldelegate:self sidID:sid removeArray:model];
    }];
    [[UIViewController currentViewController].navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 删除帖子接口请求
-(void)FindSnsCelldelegate:(TZFindSnsCell *)cell sidID:(NSString *)sid removeArray:(TZFindSnsModel *)model{
    NSInteger inde=0;
    for (int i = 0; i < self.userSns.count; i ++ ) {
        TZFindSnsModel *mm = self.userSns[i];
        if ([mm.sid isEqualToString:model.sid]) {
            [self.userSns removeObject:mm];
            
            inde = i;
            break;
        }
    }
    [self.rightTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:inde inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    _headerView.tiesLabel.text = [NSString stringWithFormat:@"%ld", self.userSns.count];
    NSString * str = [mUserDefaults objectForKey:@"sessionid"];
    NSMutableDictionary * params = @{@"sid":@(sid.integerValue),@"sessionid":str};
    [TZHttpTool postWithURL:ApiSnsDel params:params success:^(NSDictionary *result) {
        [self showInfo:@"删除成功"];
        [ORParentModel removeMsgWithID:sid];
        [TZUserManager syncUserModel];
        [mNotificationCenter postNotificationName:kNotiSysMessageListchange object:nil userInfo:@{@"or":@"1"}];
    } failure:^(NSString *msg) {
        [self showInfo:msg];
    }];
}


@end
