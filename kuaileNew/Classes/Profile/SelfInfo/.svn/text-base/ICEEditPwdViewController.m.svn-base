//
//  ICEEditPwdViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/18.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICEEditPwdViewController.h"
#import "TZNaviController.h"
#import "ApplyViewController.h"
#import "AppDelegate.h"

@interface ICEEditPwdViewController ()

@end

@implementation ICEEditPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self configUITextField];
    [self configBtnSubmit];
}

- (void)configUITextField {
    UIImageView *imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
    imgPwd.image = [UIImage imageNamed:@"login_mima"];
    imgPwd.contentMode = UIViewContentModeCenter;
    self.textFieldOldPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.textFieldOldPwd.leftViewMode = UITextFieldViewModeAlways;
    [self.textFieldOldPwd.leftView addSubview:imgPwd];
    
    UIImageView *imgNPwd = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
    imgNPwd.image = [UIImage imageNamed:@"login_mima"];
    imgNPwd.contentMode = UIViewContentModeCenter;
    self.textFieldNewPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.textFieldNewPwd.leftViewMode = UITextFieldViewModeAlways;
    [self.textFieldNewPwd.leftView addSubview:imgNPwd];
    
    UIImageView *imgCPwd = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
    imgCPwd.image = [UIImage imageNamed:@"login_mima"];
    imgCPwd.contentMode = UIViewContentModeCenter;
    self.textFieldCheckPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.textFieldCheckPwd.leftViewMode = UITextFieldViewModeAlways;
    [self.textFieldCheckPwd.leftView addSubview:imgCPwd];
    
    [[self.textFieldOldPwd.rac_textSignal filter:^BOOL(NSString*username){
        return username.length >= 18;
    }] subscribeNext:^(NSString*username){
        self.textFieldOldPwd.text = [username substringToIndex:11];
    }];
    
    [[self.textFieldNewPwd.rac_textSignal filter:^BOOL(NSString*text){
        return text.length >= 18;
    }] subscribeNext:^(NSString*text){
        self.textFieldNewPwd.text = [text substringToIndex:18];
    }];
    
    [[self.textFieldCheckPwd.rac_textSignal filter:^BOOL(NSString*text){
        return text.length >= 18;
    }] subscribeNext:^(NSString*text){
        self.textFieldCheckPwd.text = [text substringToIndex:18];
    }];
}

// 提交按钮
- (void)configBtnSubmit {
    // 下一步
    @weakify(self);
    self.btnSubmit.rac_command = [[RACCommand alloc] initWithEnabled:[self validateBtnNextStep] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.view endEditing:YES];
        [self showHudInView:self.view hint:@"修改中..."];
        // 回调网络请求信号
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        return [ICEImporter passwordWithOldPwd:self.textFieldOldPwd.text newPwd:self.textFieldNewPwd.text uid:userModel.uid userName:DEF_PERSISTENT_GET_OBJECT(DEF_USERNAME)];
    }];
    [self.btnSubmit.rac_command.executionSignals subscribeNext:^(RACSignal*subscribeSignal) {
        [subscribeSignal subscribeNext:^(id x) {
            @strongify(self);
            DLog(@"info %@",x);
            [self showInfo:@"密码修改成功，请重新登录!"];
            [TZEaseMobManager logoutEaseMob];
            // 保存新密码
            DEF_PERSISTENT_SET_OBJECT(self.textFieldNewPwd.text, DEF_USERPWD);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }];
    }];
    [self.btnSubmit.rac_command.errors subscribeNext:^(NSError *error) {
        DLog(@"Login error: %@", error.domain);
        [self showInfo:[NSString stringWithFormat:@"%@!",error.domain]];
    }];
}

- (RACSignal *)validateBtnNextStep {
    return [RACSignal combineLatest:@[
                            self.textFieldCheckPwd.rac_textSignal,
                            self.textFieldNewPwd.rac_textSignal,
                            self.textFieldOldPwd.rac_textSignal
                            ]
            reduce:^id(NSString *checkPwd, NSString *newPwd, NSString *olePwd) {
                if (newPwd.length == checkPwd.length) {
                    if ( ![newPwd isEqualToString:checkPwd]) {
                        [self showPopTipView:@"确认密码输入不一致！" showInView:self.textFieldNewPwd];
                        self.btnSubmit.backgroundColor = kCOLOR_BIANKUANG;
                        return @NO;
                    } else {
                        if (checkPwd.length > 5 && newPwd.length > 5 && olePwd.length > 5) {
                            self.btnSubmit.backgroundColor = kCOLOR_MAIN;
                            return @YES;
                        } else {
                            self.btnSubmit.backgroundColor = kCOLOR_BIANKUANG;
                            return @NO;
                        }
                    }
                } else {
                    self.btnSubmit.backgroundColor = kCOLOR_BIANKUANG;
                    return @NO;
                }
            }];
}

@end
