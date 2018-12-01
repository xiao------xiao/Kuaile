//
//  ICEForgetViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICEForgetViewController.h"
#import "ICEForgetSecondViewController.h"
#import "ICERegisterViewController.h"

@interface ICEForgetViewController ()<UITextFieldDelegate> {
    ICEROFType _type;
    NSString *_currentCode;
}
@property (nonatomic, copy) NSString *sessionID;
@end

@implementation ICEForgetViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _type = rofTypeForget;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUITextField];
    [self configBtnSumbit];
    [self configBtnSmsCode];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.btnSubmit.enabled = NO;
    self.btnSubmit.backgroundColor = kCOLOR_BIANKUANG;

    if (_phone) {
        self.textFieldPhone.text = _phone;
        self.textFieldPhone.userInteractionEnabled = NO;
        self.btnSmsCode.enabled = YES;
        self.btnSmsCode.backgroundColor = kCOLOR_MAIN;
    }
}

- (void)configUITextField {
    self.textFieldPhone.delegate = self;
    self.textFieldSmsCheck.delegate = self;
    [self.view configTextFieldLeftView:self.textFieldPhone leftImgName:@"login_phone"];
    [self.view configTextFieldLeftView:self.textFieldSmsCheck leftImgName:@"login_phone"];
    
    [[self.textFieldPhone.rac_textSignal filter:^BOOL(NSString*username){
        [self refreshBtnSmsCodeStates];
        return username.length >= 11;
    }] subscribeNext:^(NSString*username){
        self.textFieldPhone.text = [username substringToIndex:11];
    }];
    
    [[self.textFieldSmsCheck.rac_textSignal filter:^BOOL(NSString*username){
        [self refreshBtnSmsCodeStates];
        return username.length >= 4;
    }] subscribeNext:^(NSString*username){
        self.textFieldSmsCheck.text = [username substringToIndex:4];
    }];
}

/// 确认
- (void)configBtnSumbit {
    [[self.btnSubmit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.view endEditing:YES];
        if (_typeOfVc == ICEForgetViewControllerTypeForgetPassword) { // 忘记密码
            [self pushViewCtrl];
        } else if (_typeOfVc == ICEForgetViewControllerTypeBindPhone) { // 绑定手机号
            [TZHttpTool postWithURL:ApiBindPhone params:@{@"username":self.textFieldPhone.text,@"uid":_uid,@"code":self.textFieldSmsCheck.text} success:^(id json) {
                [self showHint:@"绑定成功"];
                [mUserDefaults setObject:self.textFieldPhone.text forKey:kSDKUsername];
                [mUserDefaults setObject:self.textFieldPhone.text forKey:DEF_USERNAME];
                [mUserDefaults synchronize];
                ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
                userModel.phone = self.textFieldPhone.text;
                userModel.username = self.textFieldPhone.text;
                userModel.is_bind = @"1";
                if (self.didBindPhoneSuccessHandle) {
                    self.didBindPhoneSuccessHandle(self.textFieldPhone.text);
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *error) {
                [self showHint:error];
            }];
        } else if (_typeOfVc == ICEForgetViewControllerTypeUnbindPhone) { // 解绑手机号
            [TZHttpTool postWithURL:ApiUnbindPhone params:@{@"uid":_uid,@"code":self.textFieldSmsCheck.text} success:^(id json) {
                [self showHint:@"解绑成功"];
                NSDictionary *data = (NSDictionary *)json;
                [mUserDefaults setObject:data[@"data"] forKey:kSDKUsername];
                [mUserDefaults setObject:data[@"data"] forKey:DEF_USERNAME];
                // [mUserDefaults setObject:data[@"123456"] forKey:DEF_USERPWD];
                [mUserDefaults synchronize];
                ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
                userModel.phone = data[@"data"];
                userModel.username = data[@"data"];
                userModel.is_bind = @"2";
                if (self.didUnbindPhoneSuccessHandle) {
                    self.didUnbindPhoneSuccessHandle();
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *error) {
                [self showHint:error];
            }];
        } else if (_typeOfVc == ICEForgetViewControllerTypeVerifyPhone) { /// 第三方登录时，验证手机号
            if (_currentCode.intValue == self.textFieldSmsCheck.text.intValue) {
                if (self.didVerifyPhoneSuccessHandle) {
                    self.didVerifyPhoneSuccessHandle(self.textFieldPhone.text);
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self showInfo:@"验证码输入错误"];
            }
        }
    }];
}

- (RACSignal *)validateLoginInputs {
    return [RACSignal combineLatest:@[ self.textFieldPhone.rac_textSignal, self.textFieldSmsCheck.rac_textSignal, RACObserve(self, sessionID) ] reduce:^id(NSString *username, NSString *smsCode, NSString *sessionid){
        if (username.length > 0 && smsCode.length == 4) {
            self.btnSubmit.backgroundColor = kCOLOR_MAIN;
            return @YES;
        } else {
            self.btnSubmit.backgroundColor = kCOLOR_BIANKUANG;
            return @NO;
        }
    }];
}

- (void)pushViewCtrl {
    ICEForgetSecondViewController *forgetSecond = [[ICEForgetSecondViewController alloc] initWithNibName:@"ICEForgetSecondViewController" bundle:[NSBundle mainBundle]];
    forgetSecond.strPhone = self.textFieldPhone.text;
    forgetSecond.strSmsCode = self.textFieldSmsCheck.text;
    forgetSecond.strSessionId = self.sessionID;
    [self.navigationController pushViewController:forgetSecond animated:YES];
}

// 验证码
- (void)configBtnSmsCode {
    // 验证码
    self.btnSmsCode.enabled = NO;
    self.btnSmsCode.backgroundColor = kCOLOR_BIANKUANG;
    [self.btnSmsCode addTarget:self action:@selector(btnSmsCodeClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (RACSignal *)validateSmsCode {
    return [RACSignal combineLatest:@[self.textFieldPhone.rac_textSignal,] reduce:^id(NSString *username) {
        if ([ICETools isMobileNumber:username]) {
            self.btnSmsCode.backgroundColor = kCOLOR_MAIN;
            self.btnSubmit.enabled = YES;
            return @YES;
        } else {
            if (username.length >= 11) {
                [self.view endEditing:YES];
                [self showPopTipView:@"您输入的手机号码不正确!" showInView:self.textFieldPhone];
            }
            self.btnSmsCode.backgroundColor = kCOLOR_BIANKUANG;
            self.btnSubmit.backgroundColor = kCOLOR_BIANKUANG;
            self.btnSubmit.enabled = NO;
            return @NO;
        }
    }];
}

#pragma mark - 点击事件

- (void)btnSmsCodeClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![ICETools isMobileNumber:self.textFieldPhone.text]) {
        [self showInfo:@"手机号输入不合法"];return;
    }
    self.btnSmsCode.userInteractionEnabled = NO;
    if (_typeOfVc == ICEForgetViewControllerTypeForgetPassword) {
        [self sendSmSCodeWithType:@"2"];
    } else if (_typeOfVc == ICEForgetViewControllerTypeVerifyPhone) {
        [self sendSmSCodeWithType:@"1"];
    } else if (_typeOfVc == ICEForgetViewControllerTypeBindPhone) {
        [self sendSmSCodeWithType:@"5"];
    } else {
        [self sendSmSCodeWithType:@"0"]; // type传0，后台就不检测手机号是否是用户 用于解绑
    }
}

- (void)startSmsCodeBtnTime {
    __block NSInteger timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.btnSmsCode.backgroundColor = kCOLOR_MAIN;
                self.btnSmsCode.userInteractionEnabled = YES;
                self.btnSmsCode.enabled = YES;
                [self.btnSmsCode setTitle:@"验证码" forState:UIControlStateNormal];
            });
        } else {
            self.btnSmsCode.userInteractionEnabled = NO;
            NSInteger seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2ld秒", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.btnSmsCode setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)sendSmSCodeWithType:(NSString *)type {
    [[ICEImporter smsWithPhone:self.textFieldPhone.text type:type] subscribeNext:^(NSDictionary *result) {
        self.btnSmsCode.userInteractionEnabled = YES;
        DLog(@"获取验证码 %@ %@", result, result[@"data"]);
        self.sessionID = result[@"sessionid"];
        _currentCode = result[@"data"];
        [self.btnSmsCode setTitle:@"60秒" forState:UIControlStateNormal];
        [self startSmsCodeBtnTime];
        [self showPopTipView:@"验证码已发送!" showInView:self.btnSmsCode];
    }];
}

#pragma mark - 私有方法

- (void)refreshBtnSmsCodeStates {
    if (self.textFieldPhone.text.length < 11) {
        self.btnSmsCode.enabled = NO;
        self.btnSmsCode.backgroundColor = kCOLOR_BIANKUANG;
        self.btnSubmit.enabled = NO;
    } else {
        self.btnSmsCode.enabled = YES;
        self.btnSmsCode.backgroundColor = kCOLOR_MAIN;
        if (self.textFieldSmsCheck.text.length >= 4) {
            self.btnSubmit.enabled = YES;
            self.btnSubmit.backgroundColor = kCOLOR_MAIN;
        } else {
            self.btnSubmit.enabled = NO;
            self.btnSubmit.backgroundColor = kCOLOR_BIANKUANG;
        }
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self refreshBtnSmsCodeStates];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self refreshBtnSmsCodeStates];
}

@end
