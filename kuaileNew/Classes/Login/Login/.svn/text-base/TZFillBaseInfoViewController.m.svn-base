//
//  TZFillBaseInfoViewController.m
//  kuaile
//
//  Created by ttouch on 16/3/25.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import "TZFillBaseInfoViewController.h"
#import <ShareSDK/ShareSDK.h>
//#import <QZoneConnection/ISSQZoneApp.h>
#import "WXApi.h"
#import "TZPopInputView.h"
#import "ICEForgetViewController.h"
#import <ShareSDK+InterfaceAdapter.h>
#import "XYFoundationCell.h"
#import "XYDetailListCell.h"
#import "XYInquireWageViewController.h"

/// 第三方登录用户，提示填写用户基本信息控制器
@interface TZFillBaseInfoViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSArray *_cellTitles;
    NSMutableArray *_cellDetailTitles;
    
    NSInteger _section;
    NSInteger _row;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *nickNameFiled;
#pragma mark - 修改头像
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (copy, nonatomic) NSString *allWord;
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) UITextField *nameField;
@end

@implementation TZFillBaseInfoViewController

- (UITextField *)nickNameFiled {
    if (_nickNameFiled == nil) {
        UITextField *textFiled = [[UITextField alloc] init];
        textFiled.frame = CGRectMake(100, 0, mScreenWidth - 130, 50);
        textFiled.textAlignment = NSTextAlignmentRight;
        textFiled.placeholder = @"请填写昵称";
        textFiled.text = _nickname;
        textFiled.font = [UIFont systemFontOfSize:15];
        textFiled.textColor = __kColorWithRGBA1(128, 128, 128);
        _nickNameFiled = textFiled;
    }
    return _nickNameFiled;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.frame = CGRectMake(mScreenWidth - 100, 5, 70, 70);
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = __kColorWithRGBA1(242, 242, 242);
    self.navigationItem.title = @"设置基本信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStyleDone target:self action:@selector(skipBtnClick)];
    self.leftNavImageName = @"back_w";
    [self configTableView];
    [self loadUserNameData];
    [self configStartAppBtn];
}

- (void)loadUserNameData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"网名汉字.txt" ofType:nil];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    self.allWord = [[NSString alloc] initWithData:data encoding:NSUTF16StringEncoding];
}

- (void)getRandomUserName {
    NSUInteger length = self.allWord.length;
    NSString *firstword = [self.allWord substringWithRange:NSMakeRange(arc4random_uniform(length - 1), 1)];
    NSString *secondword = [self.allWord substringWithRange:NSMakeRange(arc4random_uniform(length - 1), 1)];
    NSString *thirdword = [self.allWord substringWithRange:NSMakeRange(arc4random_uniform(length - 1), 1)];
    NSString *appendStr = [NSString stringWithFormat:@"%@%@%@",firstword,secondword,thirdword];
    [self refreshCellDetailNamesWith:appendStr];
}

- (void)configTableView {
    _cellTitles = @[@"修改头像",@"用户昵称",@"手机号"];
    _cellDetailTitles = [NSMutableArray arrayWithObjects:_avatar,_nickname ? _nickname : @"请填写昵称",@"绑定手机", nil];
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, mScreenWidth, 80 + 50 * 2);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [_tableView registerCellByClassName:@"XYFoundationCell"];
    [_tableView registerCellByClassName:@"XYDetailListCell"];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (void)configStartAppBtn {
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(60, CGRectGetMaxY(_tableView.frame) + 20, mScreenWidth - 120, 44);
    startBtn.backgroundColor = __kNaviBarColor;
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn setTitle:@"进入开心工作" forState:UIControlStateNormal];
    startBtn.layer.cornerRadius = 5;
    startBtn.clipsToBounds = YES;
    startBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *ID = @"fillBaseinfo_cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.detailTextLabel.textColor = __kColorWithRGBA1(128, 128, 128);
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
//    }
//    cell.textLabel.text = _cellTitles[indexPath.row];
//    if (indexPath.row == 0) {
//        [cell addSubview:self.avatarImageView];
//        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_avatar]] placeholderImage:TZPlaceholderAvaterImage];
//    } else {
//        if (indexPath.row != 1) cell.detailTextLabel.text = _cellDetailTitles[indexPath.row];
//    }
//    if (indexPath.row == 1) {
//        [cell addSubview:self.nickNameFiled];
//        _nickNameFiled.text = _nickname;
//    }
//    return cell;
    
    if (indexPath.row == 0) {
        XYFoundationCell *avaterCell = [tableView dequeueReusableCellWithIdentifier:@"XYFoundationCell"];
        avaterCell.type = XYFoundationCellTypeAvater;
        avaterCell.haveMoreView = YES;
        avaterCell.isRoundCornor = YES;
        avaterCell.labelText = _cellTitles[indexPath.row];
        if (self.icon) {
            avaterCell.avater.image = self.icon;
        } else {
            [avaterCell.avater sd_setImageWithURL:TZImageUrlWithShortUrl(_avatar) placeholderImage:TZPlaceholderAvaterImage];
        }
        if (mScreenWidth < 375) {
            avaterCell.label.font = [UIFont boldSystemFontOfSize:14];
        } else {
            avaterCell.label.font = [UIFont boldSystemFontOfSize:16];
        }
        avaterCell.label.textColor = TZColorRGB(171);
        [avaterCell addBottomSeperatorViewWithHeight:1];
        return avaterCell;
    } else {
        XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
        cell.text = _cellTitles[indexPath.row];
        cell.subText = _cellDetailTitles[indexPath.row];
        if (indexPath.row == 1) {
            cell.hidden = NO;
            cell.haveAccessoryBtn = YES;
            cell.accessoryBtnText = @"换一个";
            cell.accessoryBtnFont = 15;
            cell.accessoryBtnTextColor = TZColor(6, 191, 252);
            [cell setDidClickAccessoryBtnBlock:^{
                _row = 1;
                [self getRandomUserName];
            }];
        }else {
            cell.haveAccessoryBtn = NO;
            cell.accessoryBtnText = @"";
            cell.accessoryBtn.hidden = YES;
        }
        if (mScreenWidth < 375) {
            cell.label.font = [UIFont boldSystemFontOfSize:14];
            cell.subLabelFont = 14;
        } else {
            cell.label.font = [UIFont boldSystemFontOfSize:16];
            cell.subLabelFont = 16;
        }
        cell.labelTextColor = TZColorRGB(171);
        cell.subLabelTextColor = TZColorRGB(193);
        [cell addBottomSeperatorViewWithHeight:1];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _row = indexPath.row;
    _section = indexPath.section;
    switch (indexPath.row) {
        case 0: [self avatarBtnClick]; break;
        case 1: {
            [self editNickName];
        } break;
        case 2: {
//            ICEForgetViewController *iCEForget = [[ICEForgetViewController alloc] init];
//            iCEForget.navigationItem.title = @"绑定手机号";
//            iCEForget.typeOfVc = ICEForgetViewControllerTypeVerifyPhone;
//            [iCEForget setDidVerifyPhoneSuccessHandle:^(NSString *phone) {
//                [self refreshCellDetailNamesWith:phone];
//            }];
//            [self.navigationController pushViewController:iCEForget animated:YES];
            
            XYInquireWageViewController *vc = [XYInquireWageViewController new];
            vc.titleText = @"绑定手机号";
            vc.commitBtnText = @"绑定手机号";
            MJWeakSelf
            [vc setDidCommitSuccessBlock:^(NSString *phone){
//                _row = 1;
                _username = phone;
                [self refreshCellDetailNamesWith:phone];
            }];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        default: break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/** 编辑昵称 */
- (void)editNickName {
    UIAlertView *nameAlertView = [UIAlertView alertViewWithTitle:@"请输入昵称" message:nil delegate:self];
    self.nameField = [nameAlertView textFieldAtIndex:0];
    if (![_cellDetailTitles[1] isEqualToString:@"请填写昵称"]) {
        self.nameField.text = _cellDetailTitles[1];
    }
    [[nameAlertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
        if (x.integerValue == 1) {
            [self refreshCellDetailNamesWith:self.nameField.text];
            //            if(self.nameField.text.length) {
            //                // 设置推送设置
            //                MJWeakSelf
            //                [[EaseMob sharedInstance].chatManager setApnsNickname:self.nameField.text];
            //                [weakSelf.tableView reloadData];
            //                [self editSelfInfo:@"nickname" value:self.nameField.text];
            //            }
        }
    }];
    [nameAlertView show];
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, mScreenWidth, 40);
    header.backgroundColor = __kColorWithRGBA1(242, 242, 242);
    
    UILabel *tipLable = [[UILabel alloc] init];
    tipLable.frame = CGRectMake(12, 0, mScreenWidth - 24, 40);
    tipLable.text =  @"设置头像和昵称,让朋友们更方便认识自己。";
    tipLable.font = [UIFont systemFontOfSize:14];
    tipLable.textColor = [UIColor darkGrayColor];
    
    [header addSubview:tipLable];
    return header;
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 80 : 50;
}

#pragma mark - 点击事件

- (void)didClickLeftNavAction {
    [self popViewCtrl];
}


- (void)skipBtnClick {
    
    [self popViewCtrl];
    return;
    
    _nickname = _cellDetailTitles[1];
    _username = [_cellDetailTitles[2] rangeOfString:@"手机"].location !=  NSNotFound ? _username : _cellDetailTitles[2];
    [self postThirdLoginWithUsername:_username];
}

- (void)done {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    if (self.icon) {
        params[@"avatar"] = _avatar;
    }
    
    _nickname = _cellDetailTitles[1];
    if (_nickname.length < 1) {
        [self showInfo:@"请输入昵称"]; return;
    }
    params[@"nickname"] = _cellDetailTitles[1];
    //    if ([self.cellDetailTitles1[1] isEqualToString:@"请选择"])   { [self showAlertView]; return;}
    //    else { params[@"phone"] = self.cellDetailTitles1[1];}
    
       [TZHttpTool postWithURL:ApiEditUser params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"保存成功"];
        [TZUserManager syncUserModel];
       
        [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self popViewCtrl];
        });
    } failure:^(NSString *msg) {
        [self showErrorHUDWithError:msg];
    }];
}


- (void)startBtnClick:(UIButton *)sender {
    
    _nickname = _cellDetailTitles[1];
    if (_nickname.length < 1) {
        [self showInfo:@"请输入昵称"]; return;
    }
    
    [self done];
    return;
    
    NSString *bindPhone = _cellDetailTitles[2];
    _username = bindPhone.length ? bindPhone : _username;
    [self postThirdLoginWithUsername:_username];
}

/// 选择新头像
- (void)avatarBtnClick {
    [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
//        [_avatarImageView setImage:editedImage];
        self.icon = editedImage;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self updataHeadImg:editedImage];
    }];
}

- (void)updataHeadImg:(UIImage *)image {
    NSArray *fileArr = @[@{ @"file": image, @"name" : @"headImage.png", @"key" : @"avatar" } ];
    [[ICEImporter uploadFilesWithUrl:ApiUploadImage params:nil files:fileArr] subscribeNext:^(id result) {
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        NSString *str = [ApiSystemImage stringByAppendingString:result[@"data"]];
        _avatar = str;
        userModel.avatar = str;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_avatar]] placeholderImage:TZPlaceholderAvaterImage];
    }];
}

/// 向后台请求 第三方登录
- (void)postThirdLoginWithUsername:(NSString *)username{
    // 第三方登录
    NSString *authtype = @"1"; // QQ
    NSString *authid;
    if (_shareType == ShareTypeWeixiSession) {
        authtype = @"2";
        authid = [_userInfo sourceData][@"openid"];
    } else if (_shareType == ShareTypeSinaWeibo) {
        authtype = @"3";
        authid = [_userInfo sourceData][@"idstr"];
    } else {
        SSDKUser *user = _userInfo;
        authid = user.credential.token;
        if (!authid) {
            authid = [user uid];
        }
    }
    [self showHudInView:self.view hint:@"请稍后"];
    [[ICEImporter loginWithUsername:username ? username : @"" nickname:_nickname authid:authid authtype:authtype avatar:_avatar] subscribeNext:^(id result) {
        // 记录第三方登录的type
        [mUserDefaults setObject:@(_shareType) forKey:@"ShareType"];
        [mUserDefaults synchronize];
        if ([result[@"status"] isEqual:@(0)]) {
            [self showInfo:result[@"msg"]];
        } else {
            [self didLoginSuccessWithResult:(NSDictionary *)result thirdLogin:YES];
            [[NSUserDefaults standardUserDefaults] setObject:[_userInfo uid] forKey:[_userInfo uid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];
            
        }
    }];
}

#pragma mark - 私有方法


/// 登录成功后 1.储存数据 2. 登录环信
- (void)didLoginSuccessWithResult:(NSDictionary *)x thirdLogin:(BOOL)thirdLogin{
    // 保存对象信息
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    [userModel setValueWithDict:x];

    NSString *password = self.password;
    if (thirdLogin || password.length < 1) {
        password = @"123456";
    }
    NSString *easemobUsername = userModel.phone;
    if (easemobUsername.length < 2) {
        easemobUsername = userModel.username;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:DEF_USERPWD];
    [[NSUserDefaults standardUserDefaults] setObject:userModel.username forKey:DEF_USERNAME];
    [mUserDefaults setObject:easemobUsername forKey:@"easeMobUsername"]; // 存储环信的用户名
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 登录成功后再登录环信后台
    [TZEaseMobManager loginEaseMobWithUsername:easemobUsername password:password completion:^(BOOL success) {
        [self popViewCtrl];
    }];
}

#pragma  mark - private

- (void)popViewCtrl {
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    // 登录成功
    userModel.hasLogin = YES;
    [self hideHud];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshCellDetailNamesWith:(NSString *)name {
    if (!name) return;
    [_cellDetailTitles replaceObjectAtIndex:_row withObject:name];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
