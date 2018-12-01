//
//  ICERegisterViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICERegisterViewController.h"
#import "XYFinishRegisterViewController.h"
#import "XYShowCallView.h"

@interface ICERegisterViewController () {
    ICEROFType _type;
}

@property (nonatomic, copy) NSString *sessionID;
@end

@implementation ICERegisterViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _type = rofTypeRegister;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置密码";
    [self configUITextField];
//    [self configBtnSmsCode];
    [self configBtnSubmit];
    [self configBtnProssion];
}

- (void)configUITextField {
    
//    self.textFieldPassword.layer.cornerRadius = 3;
//    self.textFieldPassword.clipsToBounds = YES;
//    self.textFieldPwdCheck.layer.cornerRadius = 3;
//    self.textFieldPwdCheck.clipsToBounds = YES;
//    self.textFieldSmsCheck.layer.cornerRadius = 3;
//    self.textFieldSmsCheck.clipsToBounds = YES;
//    self.btnSmsCode.layer.cornerRadius = 3;
//    self.btnSmsCode.clipsToBounds = YES;
    self.btnSubmit.layer.cornerRadius = TZCornerRadios_7;
    self.btnSubmit.layer.masksToBounds = YES;
    self.btnSubmit.titleLabel.textColor = color_white;
    self.btnSubmit.titleLabel.font = fontBig;
    [self.btnSubmit setBackgroundColor:color_main_disabled forState:UIControlStateDisabled];
    
     [self.btnSubmit setBackgroundColor:color_main forState:UIControlStateNormal];
//    self.phoneLabel.text = [NSString stringWithFormat:@"请输入%@收到的短信验证码",self.phone];
//    [self.view configTextFieldLeftView:self.textFieldSmsCheck leftImgName:@"login_phone"];
    [self.view configTextFieldLeftView:self.textFieldPassword leftImgName:@"login_mima"];
    [self.view configTextFieldLeftView:self.textFieldPwdCheck leftImgName:@"login_mima"];
    
//    [[self.textFieldPhone.rac_textSignal filter:^BOOL(NSString*username){
//        return username.length >= 11;
//    }] subscribeNext:^(NSString*username){
//        self.textFieldPhone.text = [username substringToIndex:11];
//    }];
    
//    [[self.textFieldSmsCheck.rac_textSignal filter:^BOOL(NSString*username){
//        return username.length >= 4;
//    }] subscribeNext:^(NSString*username){
//        self.textFieldSmsCheck.text = [username substringToIndex:4];
//    }];
    
    [[self.textFieldPassword.rac_textSignal filter:^BOOL(NSString*text){
        return text.length >= 18;
    }] subscribeNext:^(NSString*text){
        self.textFieldPassword.text = [text substringToIndex:18];
    }];
    
    [[self.textFieldPwdCheck.rac_textSignal filter:^BOOL(NSString*text){
        return text.length >= 18;
    }] subscribeNext:^(NSString*text){
        self.textFieldPassword.text = [text substringToIndex:18];
    }];
}

- (void)configBtnProssion {
    self.btnPresssion.hidden = YES;
    self.btnPresssionInfo.hidden = YES;
    
//    [self.btnPresssion setImage:[UIImage imageNamed:@"def"] forState:UIControlStateNormal];
//    [self.btnPresssion setImage:[UIImage imageNamed:@"sel"] forState:UIControlStateSelected];
//    
//    [[self.btnPresssion rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
//        x.selected = !x.selected;
//    }];
//    
//    [[self.btnPresssionInfo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [self pushWebVcWithFilename:@"im.html" title:@"使用条款和隐私政策"];
//    }];
    
}

// 验证码
//- (void)configBtnSmsCode {
//    // 验证码
//    self.btnSmsCode.rac_command = [[RACCommand alloc] initWithEnabled:@YES signalBlock:^RACSignal *(id input) {
//        [self showPopTipView:@"验证码已发送!" showInView:self.btnSmsCode];
//        [self enableSmsCode];
//        return [ICEImporter smsWithPhone:self.phone type:@"1"];
//    }];
//    [self.btnSmsCode.rac_command.errors subscribeNext:^(NSError *error) {
//        [self showInfo:[NSString stringWithFormat:@"%@!",error.domain]];
//    }];
//}



- (IBAction)connectBtnClick:(id)sender {
    self.callView.hidden = NO;
}



//- (RACSignal *)validateLoginInputs {
//    return [RACSignal combineLatest:@[self.textFieldPhone.rac_textSignal] reduce:^id(NSString *username) {
//        if ([ICETools isMobileNumber:username]) {
//            self.btnSmsCode.backgroundColor = kCOLOR_MAIN;
//            return @YES;
//        } else {
//            if (username.length >= 11) {
//                [self showPopTipView:@"您输入的手机号码不正确!" showInView:self.textFieldPhone];
//            }
//            self.btnSmsCode.backgroundColor = kCOLOR_BIANKUANG;
//            self.btnSubmit.backgroundColor = kCOLOR_BIANKUANG;
//            self.btnSubmit.enabled = NO;
//            return @NO;
//        }
//    }];
//}



// 提交按钮
- (void)configBtnSubmit {
    // 下一步
    @weakify(self);
    self.btnSubmit.rac_command = [[RACCommand alloc] initWithEnabled:[self validateBtnNextStep] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.view endEditing:YES];
        [self showHudInView:self.view hint:@"注册中..."];
        // 回调网络请求信号
        return [ICEImporter registerWithUsername:self.phone password:self.textFieldPassword.text smsCode:self.code];
    }];
    [self.btnSubmit.rac_command.executionSignals subscribeNext:^(RACSignal*subscribeSignal) {
        [subscribeSignal subscribeNext:^(id x) {
            @strongify(self);
            DLog(@"info %@",x);
            [mUserDefaults setObject:self.textFieldPassword.text forKey:@"password"];
            [mUserDefaults setObject:self.phone forKey:@"phone"];
            
            
            [[ICEImporter loginWithUsername:self.phone password:self.textFieldPassword.text] subscribeNext:^(id x) {
                @strongify(self);
                [self didLoginSuccessWithResult:x thirdLogin:NO];

            }];
            
        }];
    }];
    [self.btnSubmit.rac_command.errors subscribeNext:^(NSError *error) {
        DLog(@"Login error: %@", error.domain);
        [self showInfo:[NSString stringWithFormat:@"%@!",error.domain]];
    }];
}

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
        //        [TZUserManager syncUserModel];
        
        //        [self pushFillBaseInfoVcWithUserInfo:_sdUser type:_stype];
        
//        if (_isEdit) {
//            [self pushFillBaseInfoVcWithUserInfo:_sdUser type:_stype];
//        }else {
//            [self popViewCtrl];
//            
//        }
        [self showInfo:@"注册成功"];


        XYFinishRegisterViewController *finishVc = [[XYFinishRegisterViewController alloc] init];
        [self.navigationController pushViewController:finishVc animated:YES];

    }];
    
    
}
- (RACSignal *)validateBtnNextStep {
    return [RACSignal
            combineLatest:@[
                            self.textFieldPassword.rac_textSignal,
                            self.textFieldPwdCheck.rac_textSignal,
                            RACObserve(self.btnPresssion, selected)
                            ]
            reduce:^id(NSString *password, NSString *checkPwd)
            {
                if (password.length == checkPwd.length) {
                    if ( ![password isEqualToString:checkPwd]) {
                        [self showPopTipView:@"确认密码输入不一致！" showInView:self.textFieldPwdCheck];
                        self.btnSubmit.enabled = NO;
                        
                        
                        return @NO;
                    } else {
                        if (password.length > 5 ) {
                            self.btnSubmit.enabled = YES;
                            
                            
                            return @YES;
                        } else {
                            self.btnSubmit.enabled = NO;
                            
                            
                            return @NO;
                        }
                    }
                } else {
                    self.btnSubmit.enabled = NO;
                    
                    return @NO;
                }
            }];
}

//- (RACSignal *)validateBtnNextStep {
//    return [RACSignal
//            combineLatest:@[
//                            self.textFieldPassword.rac_textSignal,
//                            self.textFieldPwdCheck.rac_textSignal,
//                            RACObserve(self.btnPresssion, selected)
//                            ]
//            reduce:^id(NSString *password, NSString *checkPwd , NSNumber *select)
//            {
//                if (password.length == checkPwd.length) {
//                        if ( ![password isEqualToString:checkPwd]) {
//                            [self showPopTipView:@"确认密码输入不一致！" showInView:self.textFieldPwdCheck];
//                            self.btnSubmit.backgroundColor = color_main_disabled;
//
//                            return @NO;
//                        } else {
//                            if (password.length > 5 && [select boolValue]) {
//                                self.btnSubmit.backgroundColor = kCOLOR_MAIN;
//
//                                return @YES;
//                            } else {
//                                self.btnSubmit.backgroundColor = TZColorRGB(238);
//
//                                return @NO;
//                            }
//                        }
//                } else {
//                    self.btnSubmit.backgroundColor = TZColorRGB(238);
//                    [self.btnSubmit setTitleColor:TZColorRGB(191) forState:0];
//                    return @NO;
//                }
//            }];
//}


@end
