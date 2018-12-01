//
//  ICELoginViewController.m
//  ChatDemo-UI2.0
//
//  Created by ttouch on 15/9/9.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICELoginViewController.h"
#import "ICERegisterViewController.h"
#import "ICEForgetViewController.h"
#import "TZPopInputView.h"
#import "TZFillBaseInfoViewController.h"
#import "XYRegisterOneViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDK+InterfaceAdapter.h>
#import "XYForgetPasswordViewController.h"
#import <ShareSDK+Extension.h>

@interface ICELoginViewController () {
    BOOL _isEdit;
    SSDKUser * _sdUser;
    ShareType _stype;
}
@property (nonatomic, strong) TZPopInputView *inputView;

@property (weak, nonatomic) IBOutlet UIImageView *wechatLoginImage;
@property (weak, nonatomic) IBOutlet UILabel *wechatLoginTitle;
@property (weak, nonatomic) IBOutlet UIImageView *qqLoginImage;
@property (weak, nonatomic) IBOutlet UILabel *qqLoginTitle;
@end

@implementation ICELoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    NSString *username = [mUserDefaults objectForKey:@"user_username"];
    if (username && username.length > 0) {
        if (username.length <= 11) { self.textFieldPhone.text = username; }
    }
    self.leftNavImageName = @"navi_back";
//    self.btnSubmit.layer.cornerRadius = 2;
  
    [self configUITextField];
    [self configReigsterOrForgetBtn];
    [self configBtnLogin];
    [self configBtnSumbit];
    // 是否要隐藏左边按钮
    if (self.hideLeftButton) {  self.navigationItem.leftBarButtonItem = nil;  }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideTextHud];
}

- (void)didClickLeftNavAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configUITextField {
//    [self.view configTextFieldLeftView:self.textFieldPhone leftImgName:@"login_phone"];
//    [self.view configTextFieldLeftView:self.textFieldPassword leftImgName:@"login_mima"];
    
    [[self.textFieldPhone.rac_textSignal filter:^BOOL(NSString*username){
        return username.length >= 11;
    }] subscribeNext:^(NSString*username){
        self.textFieldPhone.text = [username substringToIndex:11];
    }];
    
    [[self.textFieldPassword.rac_textSignal filter:^BOOL(NSString*text){
        return text.length >= 18;
    }] subscribeNext:^(NSString*text){
        self.textFieldPassword.text = [text substringToIndex:18];
    }];
}

- (void)configReigsterOrForgetBtn {
    [[self.btnRegister rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        ICERegisterViewController *iCERegister = [[ICERegisterViewController alloc] init];
//        [self.navigationController pushViewController:iCERegister animated:YES];
        
        XYRegisterOneViewController *registerVc = [[XYRegisterOneViewController alloc] init];
        [self.navigationController pushViewController:registerVc animated:YES];
    }];
    [[self.btnForget rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        ICEForgetViewController *iCEForget = [[ICEForgetViewController alloc] init];
//        iCEForget.typeOfVc = ICEForgetViewControllerTypeForgetPassword;
//        iCEForget.navigationItem.title = @"忘记密码";
//        [self.navigationController pushViewController:iCEForget animated:YES];
//
        XYForgetPasswordViewController *forgetVc = [[XYForgetPasswordViewController alloc] init];
        forgetVc.titleText = @"忘记密码";
        [self.navigationController pushViewController:forgetVc animated:YES];
    }];
}

- (void)configBtnLogin {
    // 如果设备未安装QQ和微信，隐藏QQ、微信的登录按钮
    if (![QQApiInterface isQQInstalled]) {
        self.btnQQ.hidden = YES;
        self.qqLoginImage.hidden = YES;
        self.qqLoginTitle.hidden = YES;
    }
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        self.btnWeChat.hidden = YES;
        self.wechatLoginImage.hidden = YES;
        self.wechatLoginTitle.hidden = YES;
    }
    
    [[self.btnQQ rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self loginQQ];
    }];
    [[self.btnWeChat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self loginWeiChat];
    }];
    [[self.btnSina rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self loginSina];
    }];
}

#pragma mark - 点击事件

- (void)configBtnSumbit {
    // 登录
    self.btnSubmit.layer.cornerRadius = 5;
    self.btnSubmit.clipsToBounds = YES;
    
//    [self.btnSubmit addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btnSubmit.rac_command = [[RACCommand alloc] initWithEnabled:[self validateLoginInputs] signalBlock:^RACSignal *(id input) {
        [self.view endEditing:NO];
        
        [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
        // 先登录自己家后台
        return [ICEImporter loginWithUsername:self.textFieldPhone.text password:self.textFieldPassword.text];
    }];
    @weakify(self);
    [self.btnSubmit.rac_command.executionSignals subscribeNext:^(RACSignal*subscribeSignal) {
        [subscribeSignal subscribeNext:^(id x) {
            @strongify(self);
            [self didLoginSuccessWithResult:x thirdLogin:NO];
        }];
    }];
    [self.btnSubmit.rac_command.errors subscribeNext:^(NSError *error) {
        [self showInfo:[NSString stringWithFormat:@"%@!",error.domain]];
    }];
}

- (void)loginAction {
    
    [self.view endEditing:NO];

    
    if (self.textFieldPassword.text.length == 0 || self.textFieldPhone.text.length == 0) {
        [self showHint:@"用户名或密码为空"];
        return;
    }
    
    if (self.textFieldPhone.text.length != 11) {
        [self showHint:@"请输入正确的手机号"];
        return;
    }
    if (self.textFieldPassword.text.length < 6) {
        [self showHint:@"密码必须大于等于6位"];
        return;
    }
    
    
    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    // 先登录自己家后台
    [ICEImporter loginWithUsername:self.textFieldPhone.text password:self.textFieldPassword.text];
}

- (RACSignal *)validateLoginInputs {
    
    return [RACSignal combineLatest:@[ self.textFieldPhone.rac_textSignal, self.textFieldPassword.rac_textSignal ] reduce:^id(NSString *username, NSString *password){
        return @(username.length > 0 && password.length > 5);
    }];
}

- (void)popViewCtrl {
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    // 登录成功
    userModel.hasLogin = YES;
    [self hideHud];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //同步二维码
    [TZUserManager syncUserQR];
}

#pragma mark - 第三方登录


- (void)loginQQ {
    
    [self showHudInView:self.view hint:@"请稍后..."];
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
         if (state == SSDKResponseStateSuccess) {
//             NSLog(@"uid=%@",user.uid);
//             NSLog(@"%@",user.credential);
//             NSLog(@"token=%@",user.credential.token);
//             NSLog(@"nickname=%@",user.nickname);
             [self beginThirdLoginWithType:ShareTypeQQSpace userInfo:user];
         } else {
             [self hideHud];
             NSLog(@"%@",error);
         }
     }];
}

- (void)loginWeiChat {
    [self showHudInView:self.view hint:@"请稍后..."];
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//        NSLog(@"loginWeiChat %d",result);
        if (result) {
            [self reloadStateWithType:ShareTypeWeixiSession];
        } else {
            [self hideHud];
        }
    }];
}

- (void)loginSina {
    [self showHudInView:self.view hint:@"请稍后..."];
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//        NSLog(@"loginSina %d",result);
        if (result) {
            [self reloadStateWithType:ShareTypeSinaWeibo];
        } else {
            [self hideHud];
        }
    }];
}

- (void)beginThirdLoginWithType:(ShareType)type userInfo:(SSDKUser *)userInfo{
    /// 该第三方登录来的uid是否存在
    
    _sdUser = userInfo;
    _sdUser.icon = userInfo.rawData[@"figureurl_qq_2"];
    _stype = type;
    NSString *userInfo_uid = [mUserDefaults objectForKey:[userInfo uid]];
    userInfo_uid = nil;
    if (userInfo_uid) { // 存在的话，直接给登录
        [self postThirdLoginWithUserInfo:userInfo type:type username:@"0"];
    } else { // 不存在的话，说明是第一次使用第三方登录，去设置基本信息界面
        // 如果本地不存在，再向后台确认一下
        NSString *openid = userInfo.credential.token;
        if (!openid) {
            openid = userInfo.uid;
        }
        [TZHttpTool postWithURL:ApiAuthHaveLogin params:@{@"authid_qq":openid} success:^(NSDictionary *result) {
            DLog(@"验证有没有第三方登陆过 %@ %@", result, result[@"msg"]);
            // have_login 1 登录过 2 没登录过
            if ([result[@"data"][@"have_login"] integerValue] == 2) {
//                [self pushFillBaseInfoVcWithUserInfo:userInfo type:type];
//                return;
                _isEdit = YES;
            }else {
                _isEdit = NO;
            }
            [self postThirdLoginWithUserInfo:userInfo type:type username:result[@"data"][@"have_login"]];
        } failure:^(NSString *msg) {
            [self hideHud];
        }];
    }
}

/// ShareSDK 3.3.0之前用这个方法是OK，之后QQ的不OK了，QQ的走上面的方法
- (void)reloadStateWithType:(ShareType)type{
    //现实授权信息，包括授权ID、授权有效期等。
    //此处可以在用户进入应用的时候直接调用，如授权信息不为空且不过期可帮用户自动实现登录。
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:type];
    [ShareSDK getUserInfoWithType:type  authOptions:nil result:^(BOOL result, id userInfo, id error) {
        _sdUser = userInfo;
        _stype = type;
        [self hideHud];

        if (result) {
            // 判断授权信息和是否过期
            if (credential && [self isValidDate:[credential expired]] && userInfo) {
                /// 该第三方登录来的uid是否存在
                NSString *userInfo_uid = [[NSUserDefaults standardUserDefaults] objectForKey:[userInfo uid]];
                userInfo_uid = nil;
                if (userInfo_uid) {

                    // 存在的话，直接给登录
                    [self postThirdLoginWithUserInfo:userInfo type:type username:@"0"];
                } else { // 不存在的话，说明是第一次使用第三方登录，去设置基本信息界面
                    // 如果本地不存在，再向后台确认一下
                    NSString *openid = [self getOpenidWithType:type userInfo:userInfo];
                    [TZHttpTool postWithURL:ApiAuthHaveLogin params:@{@"authid_qq":openid} success:^(NSDictionary *result) {
                        DLog(@"验证有没有第三方登陆过 %@ %@", result, result[@"msg"]);
                        // have_login 1 登录过 2 没登录过
                        if ([result[@"data"][@"have_login"] integerValue] == 2) {
                            //                [self pushFillBaseInfoVcWithUserInfo:userInfo type:type];
                            //                return;
                            _isEdit = YES;
                        }else {
                            _isEdit = NO;
                        }
                        [self postThirdLoginWithUserInfo:userInfo type:type username:@"0"];
                    } failure:^(NSString *msg) {
                        
                    }];
                }
            }
        } else {
            NSLog(@"出现错误,错误码:%zd,错误描述:%@", [error errorCode], [error errorDescription]);
        }
    }];
}

/// 向后台请求 第三方登录
- (void)postThirdLoginWithUserInfo:(id)userInfo type:(ShareType)type username:(NSString *)username{
    // 第三方登录
    NSString *authtype = @"1"; // QQ
    NSString *authid;
    NSString *icon;
    if (type == ShareTypeWeixiSession) {
        authtype = @"2";
        authid = [userInfo sourceData][@"openid"];
        icon = [userInfo profileImage];
    } else if (type == ShareTypeSinaWeibo) {
        authtype = @"3";
        authid = [userInfo sourceData][@"idstr"];
        icon = [userInfo profileImage];
    } else {
        SSDKUser *user = userInfo;
        authid = user.credential.token;
        if (!authid) {
            authid = [user uid];
        }
        icon = user.icon;
    }
//    [self showHudInView:self.view hint:@"请稍后"];
//    username ? username : [userInfo uid]
    [[ICEImporter loginWithUsername:@"" nickname:[userInfo nickname] authid:authid authtype:authtype avatar:icon] subscribeNext:^(id result) {
        if ([result[@"status"] isEqual:@(0)]) {
            [self showInfo:result[@"msg"]];
        } else {

            [self didLoginSuccessWithResult:(NSDictionary *)result thirdLogin:YES];
            [mUserDefaults setObject:@"1" forKey:@"thirdLogin"];
            [mUserDefaults setObject:@(type) forKey:@"ShareType"];
            [mUserDefaults setObject:[userInfo uid] forKey:[userInfo uid]];
            [mUserDefaults synchronize];
        }
    }];
}

#pragma mark - 私有方法

/// 登录成功后 1.储存数据 2. 登录环信
- (void)didLoginSuccessWithResult:(NSDictionary *)x thirdLogin:(BOOL)thirdLogin{
    // 保存对象信息
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
//    NSLog(@"%@",x);
    [userModel setValueWithDict:x];
    
    userModel.sessionid = x[@"sessionid"];
    
    [TZUserManager setUserModelWithDict:x[@"data"]]; // ORCode
    
    [ICEImporter setSessionID:x[@"sessionid"]];

    
    // 解析环信的用户名和密码
    NSString *password = self.textFieldPassword.text;
    if (thirdLogin || password.length < 1 || userModel.authid_qq.length > 0) {
//        if (thirdLogin || password.length < 1){
        password = @"123456";
    }
    NSString *easemobUsername = userModel.phone;
    if (easemobUsername.length < 2) {
        easemobUsername = userModel.username;
    }
    
    [mUserDefaults setObject:password forKey:DEF_USERPWD];
    [mUserDefaults setObject:userModel.username forKey:DEF_USERNAME];
    [mUserDefaults setObject:easemobUsername forKey:@"easeMobUsername"]; // 存储环信的用户名
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 登录成功后再登录环信后台
    [TZEaseMobManager loginEaseMobWithUsername:easemobUsername password:password completion:^(BOOL success) {
        [mNotificationCenter postNotificationName:@"kICELoginSuccessNotificationName" object:nil];
        [self hideHud];
//        [TZUserManager syncUserModel];

//        [self pushFillBaseInfoVcWithUserInfo:_sdUser type:_stype];

        if (_isEdit) {
            [self pushFillBaseInfoVcWithUserInfo:_sdUser type:_stype];
        }else {
            [self popViewCtrl];

        }
        
    }];
    
    
}

// 是第一次使用第三方登录，去设置基本信息界面
- (void)pushFillBaseInfoVcWithUserInfo:(id)userInfo type:(ShareType)type {
    TZFillBaseInfoViewController *fillBaseInfoVc = [[TZFillBaseInfoViewController alloc] init];
    fillBaseInfoVc.password = self.textFieldPassword.text;
    fillBaseInfoVc.userInfo = userInfo;
    // 第三方登录头像
    NSString *icon;
    if (type == ShareTypeWeixiSession || type == ShareTypeSinaWeibo) {
        icon = [userInfo profileImage];
    } else {
        SSDKUser *user = userInfo;
        icon = user.icon;
    }
    fillBaseInfoVc.avatar = icon;
    fillBaseInfoVc.username = @"0";
    fillBaseInfoVc.shareType = type;
    fillBaseInfoVc.nickname = [userInfo nickname];
    [self.navigationController pushViewController:fillBaseInfoVc animated:YES];
}

- (BOOL)isValidDate:(NSDate *)date {
    NSString *time1 = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
    NSString *time2 = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    BOOL isValid = (time1.integerValue - time2.integerValue) > 0;
    return isValid;
}

/// 第三方登录 获取openid
- (NSString *)getOpenidWithType:(ShareType)type userInfo:(id)userInfo{
    NSString *openid;
    if (type == ShareTypeWeixiSession) {
        openid = [userInfo sourceData][@"openid"];
    } else if (type == ShareTypeSinaWeibo) {
        openid = [userInfo sourceData][@"idstr"];
    } else {
        SSDKUser *user = userInfo;
        openid = user.credential.token;
        if (!openid) {
            openid = [user uid];
        }
    }
    return openid;
}

@end
