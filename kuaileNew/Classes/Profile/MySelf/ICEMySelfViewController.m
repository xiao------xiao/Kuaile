//
//  ICEMySelfViewController.m
//  hxjjyh
//
//  Created by ttouch on 15/8/19.
//  Copyright (c) 2015年 陈冰. All rights reserved.
//
#import "UIImage+YYAdd.h"
#import "ICEMySelfViewController.h"
#import "ICEMySelfHeadTableViewCell.h"
#import "ICEMySelfTableViewCell.h"

#import "ICESelfInfoViewController.h"
#import "ICEPointsViewController.h"
#import "TZResumeListViewController.h"
#import "ICECommissionViewController.h"
#import "ICEWageViewController.h"
#import "ICEGiftViewController.h"
#import "ICESettingViewController.h"
#import "ICEComMoneyViewController.h"
#import "TZCraeteResumeControllerNew.h"
#import "TZJobExpectController.h"
#import "ICEForgetViewController.h"
#import "XYSignHomeViewController.h"
#import "XYHomeInterViewController.h"
#import "ICEUserInfoViewController.h"
#import "XYResumeListViewController.h"
#import "XYSubscribeViewController.h"
#import "XYFaceCertifyViewController.h"
#import "XYSettingViewController.h"
#import "XYUserInfoModel.h"
#import "XYInquireWageViewController.h"

@interface ICEMySelfViewController () {
    NSInteger _pageIndex;
    ICEIdentVerifyType _verifyType;
    BOOL _netflag;
}
@property (nonatomic, copy) NSArray *cellTitles;
@property (nonatomic, copy) NSArray *cellImages;
@property (nonatomic, strong) UIView *codeCoverView;
@property (nonatomic, copy) NSString *sessonId;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIImageView *codeImgView;
@property (nonatomic, strong) UILabel *codeNameLabel;

@property (nonatomic, strong) ICELoginUserModel *userModel;
@property (nonatomic, strong) XYUserInfoModel *infoModel;

@end

@implementation ICEMySelfViewController


//每次要显示的时候更新二维码的图片
-(void)reloadQRCodeImage{
    NSString *qrCode = [TZUserManager getUserQR];
    NSURL *imageurl = TZImageUrlWithShortUrl(qrCode);
    NSLog(@"zhangying imageurl --- %@",[imageurl description]);
    [_codeImgView sd_setImageWithURL:imageurl];
}
- (UIView *)codeCoverView {
    if (_codeCoverView == nil) {
        _codeCoverView = [[UIView alloc] init];
        _codeCoverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _codeCoverView.frame = self.view.window.bounds;
        _codeCoverView.layer.cornerRadius = 8;
        _codeCoverView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_codeCoverView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:self.codeCoverView];
        
//        _codeBtn = [[UIButton alloc] init];
//        _codeBtn.frame = CGRectMake(20, 120, mScreenWidth - 40, mScreenWidth - 80);
//        _codeBtn.contentMode = UIViewContentModeScaleAspectFill;
//        _codeBtn.clipsToBounds = YES;
//        [_codeBtn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
//        [_codeCoverView addSubview:_codeBtn];
        
        _codeImgView = [[UIImageView alloc] init];
        CGFloat imageViewH = 200;
        if (mScreenWidth < 375) {
            imageViewH = 150;
        }
        _codeImgView.frame = CGRectMake(60, imageViewH, mScreenWidth - 120, mScreenWidth - 120);
        _codeImgView.userInteractionEnabled = YES;
        NSString *qrCode = [TZUserManager getUserQR];
        NSURL *imageurl = TZImageUrlWithShortUrl(qrCode);
      
        [_codeImgView sd_setImageWithURL:imageurl];
        _codeImgView.contentMode = UIViewContentModeScaleAspectFit;
        _codeImgView.clipsToBounds = YES;
        [_codeCoverView addSubview:_codeImgView];
        
        UITapGestureRecognizer *noTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notap)];
        [_codeImgView addGestureRecognizer:noTap];
        
        CGFloat y = CGRectGetMaxY(_codeImgView.frame);
        _codeNameLabel = [[UILabel alloc] init];
        _codeNameLabel.frame = CGRectMake(60, y, mScreenWidth - 120, 40);
        _codeNameLabel.backgroundColor = [UIColor whiteColor];
        _codeNameLabel.textColor = TZColorRGB(74);
        NSString *name;
        if (self.userModel.nickname.length) {
            name = [NSString stringWithFormat:@"@%@",self.userModel.nickname];
        } else {
            name = [NSString stringWithFormat:@"@%@",self.userModel.username];
        }
        _codeNameLabel.textAlignment = NSTextAlignmentCenter;
        _codeNameLabel.text = name;
        _codeNameLabel.font = [UIFont boldSystemFontOfSize:16];
        [_codeCoverView addSubview:_codeNameLabel];
        [_codeCoverView bringSubviewToFront:_codeImgView];
    }
    return _codeCoverView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.infoModel = [TZUserManager getUserModel];
    XYUserInfoModel *mod = self.infoModel;
    if (!self.infoModel) {
        [TZUserManager syncUserModelWithCompletion:^(XYUserInfoModel *model) {
            self.infoModel = model;
            [self loadType:self.infoModel.verify];
        }];
    }
    [self loadType:self.infoModel.verify];
    [self.tableView reloadData];
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    [navigationBar setBackgroundImage:[self createImageWithColor:TZMainColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    self.tabBarItem.title = @"我";
    self.sessonId = [mUserDefaults objectForKey:@"sessionid"];
    self.userModel = [ICELoginUserModel sharedInstance];
    [TZUserManager getUserQR];
    [mNotificationCenter addObserver:self selector:@selector(bindPhoneSuccess) name:@"didBindPhoneNoti" object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [mNotificationCenter addObserver:self selector:@selector(bindPhoneSuccess) name:@"didEditUserInfoNoti" object:nil];

    }
    return self;
}


- (void)bindPhoneSuccess {
    
    if (_netflag) {
        return;
    }
    _netflag = YES;
    
    [TZUserManager syncUserModelWithCompletion:^(XYUserInfoModel *model) {
        _infoModel = [TZUserManager getUserModel];
        [self loadType:_infoModel.verify];
        _netflag = NO;
        [self.tableView reloadData];
    }];
   
}

/// 获取个人积分
//- (void)loadPointData {
//    RACSignal *sign = [ICEImporter getPoint];
//    [sign subscribeNext:^(id x) {
//        if (x[@"data"]) {
//            NSString *point = x[@"data"];
//            _currentPoint = point ? point : @"0";
//        }
//    }];
//}

- (void)configTableView {
    self.needHeaderRefresh = YES;
    [super configTableView];
    self.tableView.height = mScreenHeight - 49 - 64;
    _cellTitles = @[@"个人", @"积分签到", @"职位订阅", @"我的简历", @"工作面试", @"我的佣金", @"工资查询", @"分享邀请", @"软件设置"];
    _cellImages = @[@"myself_qzyx", @"icon_qd", @"icon_zwdy", @"icon_wdjl", @"icon_gzms", @"icon_wdyj", @"icon_gzcx",@"icon_fxyq", @"icon_rjsz"];
    self.cellMargins = @[@"0", @"0",@"8", @"0", @"0", @"8", @"0", @"8", @"0"];
    [self.tableView registerCellByNibName:@"ICEMySelfTableViewCell"];
    [self.tableView registerCellByNibName:@"ICEMySelfHeadTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cellTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ICEMySelfHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ICEMySelfHeadTableViewCell"];
        cell.model = self.infoModel;
        MJWeakSelf
        [cell setDidCheckCodeBlock:^{
            [weakSelf reloadQRCodeImage];
            weakSelf.codeCoverView.hidden = NO;
        }];
        [cell setDidClickVertifyBtnBlock:^(NSString *text){
            if ([self shouldPushBindPhoneVc]) return;

            XYFaceCertifyViewController *faceVc = [[XYFaceCertifyViewController alloc] init];
            [weakSelf.navigationController pushViewController:faceVc animated:YES];
        }];
        [cell setDidClickHeaderBtnsBlock:^(NSInteger btnTag){
            if (btnTag == 1) { // 薪资
                if ([self shouldPushBindPhoneVc]) return;
                [self pushSearchMoneyVc];
            } else if (btnTag == 2) { // 佣金
                if ([self shouldPushBindPhoneVc]) return;
                ICEComMoneyViewController *comMoneyVc = [[ICEComMoneyViewController alloc] init];
                [self.navigationController pushViewController:comMoneyVc animated:YES];
            } else if (btnTag == 3) { // 积分
                XYSignHomeViewController *signVc = [[XYSignHomeViewController alloc] init];
                [self.navigationController pushViewController:signVc animated:YES];
            }
        }];
        return cell;
    } else {
        ICEMySelfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ICEMySelfTableViewCell"];
        cell.imageView.image = [UIImage imageNamed:_cellImages[indexPath.section]];
        cell.labName.text = _cellTitles[indexPath.section];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 138;
    } else {
        return 40+8;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.row = indexPath.row;
    [self loadType:self.infoModel.verify];
    switch (indexPath.section) {
        case 0: { // 个人
            ICESelfInfoViewController *userVc = [[ICESelfInfoViewController alloc] init];
            userVc.type = ICESelfInfoViewControllerTypeSelf;
            [self.navigationController pushViewController:userVc animated:YES];
        } break;
        case 1: { // 积分签到
            XYSignHomeViewController *signVc = [[XYSignHomeViewController alloc] init];
            [self.navigationController pushViewController:signVc animated:YES];
        } break;
        case 2: { // 职业订阅
            XYSubscribeViewController *subscribeVc = [[XYSubscribeViewController alloc] init];
            [self.navigationController pushViewController:subscribeVc animated:YES];
        } break;
        case 3: { // 我的简历
            XYResumeListViewController *resumeListVc = [[XYResumeListViewController alloc] init];
            [self.navigationController pushViewController:resumeListVc animated:YES];
            
        } break;
        case 4: { // 我的面试
            XYHomeInterViewController *interViewVc = [[XYHomeInterViewController alloc] init];
            [self.navigationController pushViewController:interViewVc animated:YES];
        } break;
        case 5: { // 我的佣金 要判断是否绑定了手机号
            // 判断条件是是否身份证认证过
            ICEComMoneyViewController *comMoneyVc = [[ICEComMoneyViewController alloc] init];
            [self.navigationController pushViewController:comMoneyVc animated:YES];
//            [self pushMyMoneyVc];
        } break;
        case 6: { // 工资查询 要判断是否绑定了手机号
            if ([self shouldPushBindPhoneVc]) return;
            [self pushSearchMoneyVc];
        } break;
        case 7: { // 分享邀请
            ICEGiftViewController *iCEGift = [[ICEGiftViewController alloc] init];
            [self.navigationController pushViewController:iCEGift animated:YES];
        } break;
        case 8: { // 软件设置
            XYSettingViewController *settingVc = [[XYSettingViewController alloc] init];
            [self.navigationController pushViewController:settingVc animated:YES];
        } break;
        default:  break;
    }
}

#pragma mark - 私有方法

/** 获取是否审核状态 */
- (void)loadNetDataInfo {
    //    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    //    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:@{ @"uid" : userModel.uid }];
//        RACSignal *sign = [ICEImporter identificationvWithParams:param];
    //    [sign subscribeNext:^(id x) {
    //        NSString *strType = x[@"data"][@"verify"];
    //        [self loadType:strType];
    //    }];
    //    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    //    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)loadType:(NSString *)type {
    if ([type isEqualToString:@"0"]) {
        _verifyType = ICEIdentVerifyNoCheck;
    } else if ([type isEqualToString:@"1"]) {
        _verifyType = ICEIdentVerifyProceed;
    } else if ([type isEqualToString:@"2"]) {
        _verifyType = ICEIdentVerifyNotYet;
    } else if ([type isEqualToString:@"3"]) {
        _verifyType = ICEIdentVerifyPass;
    }
}

/// 检测是否需要去绑定手机号
- (BOOL)shouldPushBindPhoneVc {
//    NSString *phone = DEF_PERSISTENT_GET_OBJECT(DEF_USERNAME);
    if ([self.infoModel.is_bind isEqualToString:@"2"]) { // 没有绑定手机号
        XYInquireWageViewController *bindVc = [[XYInquireWageViewController alloc] init];
        bindVc.titleText = @"绑定手机号";
        bindVc.commitBtnText = @"绑定手机号";
        [self.navigationController pushViewController:bindVc animated:YES];
        return YES;
    }
    return NO;
}

/// 薪资查询
- (void)pushSearchMoneyVc {
//    _verifyType = ICEIdentVerifyProceed;
//    _verifyType = ICe
    switch (_verifyType) {
        case ICEIdentVerifyNoCheck: {
            XYFaceCertifyViewController *faceVc = [[XYFaceCertifyViewController alloc] init];
            [self.navigationController pushViewController:faceVc animated:YES];
            
        } break;
        case ICEIdentVerifyProceed: {
            ICECommissionViewController *iCECommission = [[ICECommissionViewController alloc] initWithNibName:@"ICECommissionViewController" bundle:nil commissionType:ICECommissionTypePassing];
            iCECommission.style = ICECommissionStyleWage;
            [self.navigationController pushViewController:iCECommission animated:YES];
        }  break;
        case ICEIdentVerifyNotYet: {
            ICECommissionViewController *iCECommission = [[ICECommissionViewController alloc] initWithNibName:@"ICECommissionViewController" bundle:nil commissionType:ICECommissionTypeNoPass];
            iCECommission.style = ICECommissionStyleWage;
            [self.navigationController pushViewController:iCECommission animated:YES];
        } break;
        case ICEIdentVerifyPass: {
            XYInquireWageViewController *bindVc = [[XYInquireWageViewController alloc] init];
            bindVc.phoneStr = _infoModel.username;
            bindVc.titleText = @"薪资查询";
            bindVc.commitBtnText = @"下一步";
            [self.navigationController pushViewController:bindVc animated:YES];
        } break;
        default: break;
    }
}

- (void)pushViewController:(ICECommissionViewController *)vc withStyle:(ICECommissionStyle)style {
    vc.style = style;
    [self.navigationController pushViewController:vc animated:YES];
}


- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)tap {
    self.codeCoverView.hidden = YES;
}

- (void)notap {
    
}

- (void)refreshDataWithHeader {
    
    
    if (_netflag) {
        return;
    }
    _netflag = YES;
    
    [TZUserManager syncUserModelWithCompletion:^(XYUserInfoModel *model) {
        _infoModel = [TZUserManager getUserModel];
        [self loadType:_infoModel.verify];
        _netflag = NO;
        [self.tableView endRefresh];

        [self.tableView reloadData];
    }];

    
//    NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
//    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView endRefresh];
//    });
}


@end
