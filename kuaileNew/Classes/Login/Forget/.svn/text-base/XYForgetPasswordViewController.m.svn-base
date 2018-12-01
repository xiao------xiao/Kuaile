//
//  XYForgetPasswordViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/8.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYForgetPasswordViewController.h"
#import "MainTabViewController.h"


@interface XYForgetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *setPwd;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *checkPwd;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

@property (nonatomic, copy) NSString *sessionID;
@end

@implementation XYForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    [self configUITextField];
    [self configCodeBtn];
    [self configBtnSubmit];
}

- (void)configUITextField {
//    self.phone.layer.cornerRadius = 3;
//    self.phone.clipsToBounds = YES;
//    self.code.layer.cornerRadius = 3;
//    self.code.clipsToBounds = YES;
//    self.setPwd.layer.cornerRadius = 3;
//    self.setPwd.clipsToBounds = YES;
//    self.checkPwd.layer.cornerRadius = 3;
//    self.checkPwd.clipsToBounds = YES;
//
    [self.codeBtn setBackgroundColor:color_main forState:UIControlStateNormal];
    [self.codeBtn setBackgroundColor:color_main_disabled forState:UIControlStateDisabled];
    self.codeBtn.layer.cornerRadius = TZCornerRadios_5;
    self.codeBtn.layer.masksToBounds = YES;
    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.codeBtn.titleLabel.font = xfont(11);
    self.codeBtn.titleLabel.textColor = color_white;
    self.codeBtn.enabled = NO;
    
    [self.confirmBtn setBackgroundColor:color_main forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundColor:color_main_disabled forState:UIControlStateDisabled];
    self.confirmBtn.layer.cornerRadius = TZCornerRadios_7;
    self.confirmBtn.clipsToBounds = YES;
     self.confirmBtn.titleLabel.font = fontBig;
    self.confirmBtn.titleLabel.textColor = color_white;

    UILabel *label1 = [self getLabel];
    label1.frame = CGRectMake(0, 0, 50, 44);
    label1.text = @"+86";
    self.phone.leftView = label1;
    self.phone.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *label2 = [self getLabel];
    label2.size = CGSizeMake(8, 44);
    label2.text = @"";
    self.checkPwd.leftView = label2;
    self.checkPwd.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *label3 = [self getLabel];
    label3.size = CGSizeMake(8, 44);
    label3.text = @"";
    self.setPwd.leftView = label3;
    self.setPwd.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *label4 = [self getLabel];
    label4.size = CGSizeMake(8, 44);
    label4.text = @"";
    self.code.leftView = label4;
    self.code.leftViewMode = UITextFieldViewModeAlways;

    [[self.code.rac_textSignal filter:^BOOL(NSString*username){
        return username.length >= 4;
    }] subscribeNext:^(NSString*username){
        self.code.text = [username substringToIndex:4];
    }];
    
    [[self.setPwd.rac_textSignal filter:^BOOL(NSString*text){
        return text.length >= 18;
    }] subscribeNext:^(NSString*text){
        self.setPwd.text = [text substringToIndex:18];
    }];
    
    [[self.checkPwd.rac_textSignal filter:^BOOL(NSString*text){
        return text.length >= 18;
    }] subscribeNext:^(NSString*text){
        self.checkPwd.text = [text substringToIndex:18];
    }];
}

- (UILabel *)getLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = TZColorRGB(90);
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)configCodeBtn {
    RAC(self.codeBtn,enabled) = [RACSignal combineLatest:@[self.phone.rac_textSignal] reduce:^id(NSString *phone){
        if ([CommonTools isMobileNumber:phone]) {
            
            return @YES;
        } else {
            if (phone.length > 11) {
                [CommonTools popTipShowHint:@"您输入的手机号码格式不正确" atView:self.phone inView:self.view];
            }
            
            return @NO;
        }
    }];
}

- (IBAction)codeBtnClick:(id)sender {
    
    static int i = 0;
    if (i > 0) {
        return;
    }
    i = 1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        i = 0;
    });
    
    [[ICEImporter smsWithPhone:self.phone.text type:@"2"] subscribeNext:^(NSDictionary *result) {
        [self enableSmsCode];

        self.codeBtn.enabled = YES;
        [self showPopTipView:@"验证码已发送!" showInView:self.codeBtn];
    }];
}

- (IBAction)connectBtn:(id)sender {
    self.callView.hidden = NO;
}


// 提交按钮
- (void)configBtnSubmit {
    // 下一步
    @weakify(self);
    self.confirmBtn.rac_command = [[RACCommand alloc] initWithEnabled:[self validateBtnNextStep] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.view endEditing:YES];
        [self showHudInView:self.view hint:@"密码修改中..."];
        // 回调网络请求信号
        NSString *sessionID = [mUserDefaults objectForKey:@"sessionid"];
        return [ICEImporter frogetWithUsername:self.phone.text password:self.checkPwd.text smsCode:self.code.text sessionID:sessionID];
    }];
    [self.confirmBtn.rac_command.executionSignals subscribeNext:^(RACSignal*subscribeSignal) {
        [subscribeSignal subscribeNext:^(id x) {
            @strongify(self);
            [self showInfo:@"密码修改成功"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popToRootViewControllerAnimated:YES];
//                MainViewController *mainVc = (MainViewController *)self.tabBarController;
//                mainVc.selectedIndex = 0;
//            });
            
//            [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.phone.text password:self.checkPwd.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
//                if (!error) {
//                    NSLog(@"注册成功");
//                }
//            } onQueue:nil];
            
            [TZEaseMobManager logoutEaseMobWithCompletion:^(BOOL success) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    MainTabViewController *mainVc = (MainTabViewController *)self.tabBarController;
                    mainVc.selectedIndex = 0;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }];
            [ICEImporter logout];
            
        }];
    }];
    [self.confirmBtn.rac_command.errors subscribeNext:^(NSError *error) {
        [self showInfo:[NSString stringWithFormat:@"%@!",error.domain]];
    }];
}


- (void)enableSmsCode {
    [self.view endEditing:YES];
    self.codeBtn.enabled = NO;
    
    __block NSInteger timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                self.codeBtn.enabled = YES;
                [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                
            });
        } else {
            //            NSInteger minutes = timeout / 60;
//            NSInteger seconds = timeout % 60;
            //            NSString *strTime = [NSString stringWithFormat:@"%d分%.2d秒后重新获取验证码",minutes, seconds];
            NSString *strTime = [NSString stringWithFormat:@"%.2ld秒", (long)timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.codeBtn.enabled = NO;
                
                [self.codeBtn setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (RACSignal *)validateSmsCode {
    return [RACSignal combineLatest:@[self.phone.rac_textSignal,] reduce:^id(NSString *username) {
        if ([ICETools isMobileNumber:username]) {
            
            self.codeBtn.enabled = YES;
            return @YES;
        } else {
            if (username.length >= 11) {
                [self.view endEditing:YES];
                [self showPopTipView:@"您输入的手机号码不正确!" showInView:self.phone];
            }
            
            self.confirmBtn.enabled = NO;
            return @NO;
        }
    }];
}

- (RACSignal *)validateBtnNextStep {
    return [RACSignal
            combineLatest:@[
                            self.phone.rac_textSignal,
                            self.setPwd.rac_textSignal,
                            self.checkPwd.rac_textSignal,
                            self.code.rac_textSignal,
                            
                            ]
            reduce:^id(NSString *number,NSString *password, NSString *checkPwd ,NSString *smsCode)
            {
                if (password.length == checkPwd.length) {
                    if ( ![password isEqualToString:checkPwd]) {
                        [self showPopTipView:@"确认密码输入不一致！" showInView:self.checkPwd];
                       
                        return @NO;
                    } else {
                        if (number.length == 11 && password.length > 5 && smsCode.length == 4) {
                          
                            return @YES;
                        } else {
                            
                            return @NO;
                        }
                    }
                } else {
                
                    return @NO;
                }
            }];
}



@end
