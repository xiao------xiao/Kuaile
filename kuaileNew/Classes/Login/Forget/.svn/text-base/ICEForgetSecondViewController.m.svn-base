//
//  ICEForgetSecondViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/15.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICEForgetSecondViewController.h"

@interface ICEForgetSecondViewController ()

@end

@implementation ICEForgetSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    [self configBtnSubmit];
    [self.view configTextFieldLeftView:self.textFieldPassword leftImgName:@"login_mima"];
    [self.view configTextFieldLeftView:self.textFieldPwdCheck leftImgName:@"login_mima"];
}

// 提交按钮
- (void)configBtnSubmit {
    // 下一步
    @weakify(self);
    self.btnSubmit.rac_command = [[RACCommand alloc] initWithEnabled:[self validateBtnNextStep] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.view endEditing:YES];
        [self showHudInView:self.view hint:@"密码修改中..."];
        // 回调网络请求信号
        return [ICEImporter frogetWithUsername:self.strPhone password:self.textFieldPassword.text smsCode:self.strSmsCode sessionID:self.strSessionId];
    }];
    [self.btnSubmit.rac_command.executionSignals subscribeNext:^(RACSignal*subscribeSignal) {
        [subscribeSignal subscribeNext:^(id x) {
            @strongify(self);
            [self showInfo:@"密码修改成功"];
            [self performSelector:@selector(pustViewController) withObject:nil afterDelay:1.5f];
        }];
    }];
    [self.btnSubmit.rac_command.errors subscribeNext:^(NSError *error) {
        [self showInfo:[NSString stringWithFormat:@"%@!",error.domain]];
    }];
}

- (RACSignal *)validateBtnNextStep {
    return [RACSignal
            combineLatest:@[
                            self.textFieldPassword.rac_textSignal,
                            self.textFieldPwdCheck.rac_textSignal,
                            ]
            reduce:^id(NSString *password, NSString *checkPwd)
            {
                if (password.length == checkPwd.length && password.length >5) {
                    if (![password isEqualToString:checkPwd]) {
                        [self showPopTipView:@"确认密码输入不一致！" showInView:self.textFieldPwdCheck];
                        self.btnSubmit.backgroundColor = kCOLOR_BIANKUANG;
                        return @NO;
                    } else {
                        self.btnSubmit.backgroundColor = kCOLOR_MAIN;
                        return @YES;
                    }
                } else {
                    self.btnSubmit.backgroundColor = kCOLOR_BIANKUANG;
                    return @NO;
                }
            }];
}

- (void)pustViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
