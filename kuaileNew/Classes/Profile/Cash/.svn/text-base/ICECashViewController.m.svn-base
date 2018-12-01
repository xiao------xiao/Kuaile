//
//  ICECashViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICECashViewController.h"

@interface ICECashViewController ()

@end

@implementation ICECashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佣金提现";
    [self loadNetDataBankInfo];
    [self configTextField];
    [self configBtnSmsCode];
    [self configBtnSubmit];
}

- (void)configTextField {
    self.textFieldCashMoney.placeholder = [NSString stringWithFormat:@"可提现金额 %@", self.strCashMoney];
    
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
        [parmas setValue:self.textFieldCashMoney.text forKey:@"amount"];
        [parmas setValue:self.textFieldBankNum.text forKey:@"bank_account"];
        [parmas setValue:self.textFieldName.text forKey:@"account_name"];
        [parmas setValue:self.textFieldBankInfo.text forKey:@"bank"];
        [parmas setValue:userModel.username forKey:@"phone"];
        [parmas setValue:self.textFieldSmsCheck.text forKey:@"code"];
        // 回调网络请求信号
        return [ICEImporter withdrawWithParam:parmas];
    }];
    [self.btnSubmit.rac_command.executionSignals subscribeNext:^(RACSignal*subscribeSignal) {
        [subscribeSignal subscribeNext:^(id x) {
            @strongify(self);
            [self showInfo:@"提现申请提交成功"];
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
                            self.textFieldName.rac_textSignal,
                            self.textFieldBankNum.rac_textSignal,
                            self.textFieldBankInfo.rac_textSignal,
                            self.textFieldCashMoney.rac_textSignal,
                            self.textFieldSmsCheck.rac_textSignal,
                            ]
            reduce:^id(NSString *username, NSString *banknum, NSString *bankinfo ,NSString *cashmoney, NSString *smscheck)
            {
                if (username.length > 0 && banknum.length > 0 && bankinfo.length > 0 && cashmoney.length > 0 && smscheck.length == 4) {
                    self.btnSubmit.backgroundColor = kCOLOR_MAIN;
                    return @YES;
                } else {
                    self.btnSubmit.backgroundColor = kCOLOR_BIANKUANG;
                    return @NO;
                }
            }];
}

- (void)pustViewController {
    if (self.cashViewBlack) {
        self.cashViewBlack();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// 验证码
- (void)configBtnSmsCode {
    // 验证码
    [[self.btnSmsCode rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 获取验证码前，先检测是否有银行信息
        [self.view endEditing:YES];
        if (self.textFieldBankNum.text.length < 10) { [self showPopTipView:@"请填写正确的银行卡号" showInView:self.textFieldBankNum]; return; }
        if (self.textFieldBankInfo.text.length < 1) { [self showPopTipView:@"请填写开户行信息" showInView:self.textFieldBankInfo]; return; }
        NSString *money = [self.strCashMoney substringFromIndex:2];
        if (self.textFieldCashMoney.text.length < 1) {
            [self showPopTipView:@"请填写提现金额" showInView:self.textFieldCashMoney]; return;
        } else if (self.textFieldCashMoney.text.floatValue > money.floatValue) {
            [self showPopTipView:@"提现金额需不大于余额" showInView:self.textFieldCashMoney]; return;
        }
        
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        RACSignal *sign = [ICEImporter smsWithPhone:userModel.username type:@"4"];
        [self enableSmsCode];
        [sign subscribeNext:^(id x) {
            
        } completed:^{
            
        }];
    }];
}

- (void)enableSmsCode {
    self.btnSmsCode.userInteractionEnabled = NO;
    [self.btnSmsCode setTitle:@"59秒" forState:UIControlStateNormal];
    
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

- (void)loadNetDataBankInfo {
    RACSignal *sign = [ICEImporter bankInfo];
    [sign subscribeNext:^(id x) {
        if (x[@"data"][@"account_name"]) {
            self.textFieldName.text = x[@"data"][@"account_name"];
            self.textFieldName.enabled = NO;
        }
        if (x[@"data"][@"bank_account"]) {
            self.textFieldBankNum.text = x[@"data"][@"bank_account"];
            self.textFieldBankNum.enabled = NO;
        }
        if (x[@"data"][@"bank"]) {
            self.textFieldBankInfo.text = x[@"data"][@"bank"];
            self.textFieldBankInfo.enabled = NO;
        }
        [self configBtnSubmit];
    }];
}
@end
