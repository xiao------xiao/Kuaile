//
//  ICEWageViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICEWageViewController.h"

@interface ICEWageViewController ()

@end

@implementation ICEWageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工资查询";
    [self configBtnSmsCode];
    [self configBtnSubmit];
    [self configTextField];
}

- (void)configTextField {
    [[self.textFieldSmsCheck.rac_textSignal
      filter:^BOOL(NSString*username){
          return username.length >= 4;
      }]
     subscribeNext:^(NSString*username){
         self.textFieldSmsCheck.text = [username substringToIndex:4];
     }];
}

// 提交按钮
- (void)configBtnSubmit {
    // 下一步
    @weakify(self);
    self.btnSubmit.rac_command = [[RACCommand alloc] initWithEnabled:[self validateBtnNextStep] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.view endEditing:YES];
        [self showHudInView:self.view hint:@"申请提交中..."];
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
        [parmas setValue:userModel.username forKey:@"phone"];
        [parmas setValue:self.textFieldSmsCheck.text forKey:@"code"];
        // 回调网络请求信号
        return [ICEImporter salaryQueryWithParam:parmas];
    }];
    [self.btnSubmit.rac_command.executionSignals subscribeNext:^(RACSignal*subscribeSignal) {
        [subscribeSignal subscribeNext:^(id x) {
            @strongify(self);
            [self showInfo:@"查询申请提交成功"];
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
                            self.textFieldSmsCheck.rac_textSignal
                            ]
            reduce:^id(NSString *smscheck)
            {
                if (smscheck.length >= 4) {
                    self.btnSubmit.backgroundColor = kCOLOR_MAIN;
                    return @(YES);
                } else {
                    self.btnSubmit.backgroundColor = kCOLOR_BIANKUANG;
                    return @(NO);
                }
            }];
}

- (void)pustViewController {
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    NSString *apiURL = [ApiSalaryList stringByAppendingString:userModel.uid];
    [self pushWebVcWithUrl:apiURL title:@"工资查询"];
}

// 验证码
- (void)configBtnSmsCode {
    // 验证码
    [[self.btnSmsCode rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        self.btnSmsCode.enabled = NO;
        [[ICEImporter smsWithPhone:userModel.username type:@"3"] subscribeNext:^(id x) {
            [self enableSmsCode];
        } error:^(NSError *error) {
            self.btnSmsCode.enabled = YES;
        }];
    }];
}

- (void)enableSmsCode {
    self.btnSmsCode.userInteractionEnabled = NO;
    [self.btnSmsCode setTitle:@"60秒" forState:UIControlStateNormal];
    
    __block NSInteger timeout = 59; // 倒计时时间
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
                [self.btnSmsCode setTitle:@"验证码" forState:UIControlStateNormal];
            });
        } else {
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

@end
