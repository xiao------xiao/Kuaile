//
//  XYInquireWageViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYInquireWageViewController.h"
#import "XYIncomeListViewController.h"
#import "XYCashViewController.h"

@interface XYInquireWageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, copy) NSString *data;

@end

static dispatch_source_t __timer;

@implementation XYInquireWageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    [self.nextBtn setTitle:self.commitBtnText forState:UIControlStateNormal];
    [self configUI];
    
}

- (void)configUI {
    [self configTextField];
    [self configBtns];
}

- (void)configTextField {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 50, 44);
    label.text = @"+86";
    label.textColor = TZColorRGB(90);
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    self.phone.leftView = label;
    self.phone.leftViewMode = UITextFieldViewModeAlways;
    self.phone.layer.cornerRadius = 4;
    self.phone.clipsToBounds = YES;
    
    if (_phoneStr.length > 0) {
        self.phone.text = _phoneStr;
        self.phone.enabled = NO;
    }
    
    [[self.phone.rac_textSignal filter:^BOOL(NSString *value) {
        return value.length >= 11;
    }] subscribeNext:^(NSString *text) {
        self.phone.text = [text substringToIndex:11];
    }];
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 20, 44);
    view.backgroundColor = [UIColor whiteColor];
    self.code.leftView = view;
    self.code.leftViewMode = UITextFieldViewModeAlways;
    self.code.layer.cornerRadius = 4;
    self.code.clipsToBounds = YES;
    
    [[self.code.rac_textSignal filter:^BOOL(NSString *value) {
        return value.length >= 4;
    }] subscribeNext:^(NSString *text) {
        self.code.text = [text substringToIndex:4];
    }];
}

- (void)configBtns {
    self.codeBtn.layer.cornerRadius = 4;
    self.nextBtn.layer.cornerRadius = 4;
    self.codeBtn.clipsToBounds = YES;
    self.nextBtn.clipsToBounds = YES;
    
    RAC(self.codeBtn, userInteractionEnabled) = [RACSignal combineLatest:@[self.phone.rac_textSignal] reduce:^id(NSString *phone){
        if ([CommonTools isMobileNumber:phone]) {
            [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"Background"] forState:0];
            [self.codeBtn setTitleColor:[UIColor whiteColor] forState:0];
            return @YES;
        } else {
            if (phone.length > 11) {
                [CommonTools popTipShowHint:@"您输入的手机号码格式不正确" atView:self.phone inView:self.view];
            }
            [self.codeBtn setTitleColor:TZGreyText150Color forState:0];
            [self.codeBtn setBackgroundImage:nil forState:0];
            self.codeBtn.backgroundColor = TZColorRGB(238);
            return @NO;
        }
    }];
    
    RAC(self.nextBtn, userInteractionEnabled) = [RACSignal combineLatest:@[self.phone.rac_textSignal, self.code.rac_textSignal] reduce:^id(NSString *phone, NSString *code){
        if (code.length == 4 && phone.length == 11) {
            [self.nextBtn setTitleColor:[UIColor whiteColor] forState:0];
            [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"Background"] forState:0];
            return @YES;
        } else {
            [self.nextBtn setTitleColor:TZGreyText150Color forState:0];
            [self.nextBtn setBackgroundImage:nil forState:0];
            [self.nextBtn setBackgroundColor:TZColorRGB(238)];
            return @NO;
        }
    }];
    
}

- (IBAction)codeBtnClick:(id)sender {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    NSString *type;
    if ([self.titleText isEqualToString:@"佣金提现"]) {
       type = @"4";
    } else if ([self.titleText isEqualToString:@"薪资查询"]) {
       type = @"3";
    } else if ([self.titleText isEqualToString:@"绑定手机号"]) {
        type = @"5";
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"sessionid":NotNullStr(sessionId), @"phone":NotNullStr(self.phone.text),@"type":NotNullStr(type)}];
    [TZHttpTool postWithURL:ApiSms params:params success:^(NSDictionary *result) {
        NSLog(@"绑定手机号，%@", result);
        if ([result[@"status"] isEqual:@(1)]) {
            [self enableSmsCode];
            self.data = [NSString stringWithFormat:@"%@",result[@"data"]];
        }
    } failure:^(NSString *msg) {
        [self showInfo:msg];
    }];
}

- (IBAction)nextBtnClick:(id)sender {
    if ([self.data isEqualToString:self.code.text]) {
        if ([self.titleText isEqualToString:@"佣金提现"]) {
            XYCashViewController *cashVc = [[XYCashViewController alloc] init];
            [self.navigationController pushViewController:cashVc animated:YES];
        } else if ([self.titleText isEqualToString:@"薪资查询"]) {
            XYIncomeListViewController *incomeListVc = [[XYIncomeListViewController alloc] init];
            incomeListVc.code = self.data;
            [self.navigationController pushViewController:incomeListVc animated:YES];
        } else if ([self.titleText isEqualToString:@"绑定手机号"]) {
            [self bindPhone];
        }
    } else {
        [self showErrorHUDWithError:@"请输入正确的验证码"];
    }
}

- (void)bindPhone {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [mUserDefaults objectForKey:@"userUid"];
    params[@"code"] = self.code.text;
    params[@"username"] = self.phone.text;
    [TZHttpTool postWithURL:ApiBindPhone params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"绑定成功"];
        [mUserDefaults setObject:self.phone.text forKey:@"bindPhone"];
        [mUserDefaults synchronize];
        [mNotificationCenter postNotificationName:@"didBindPhoneNoti" object:nil];
        if (self.didCommitSuccessBlock) {
            self.didCommitSuccessBlock(self.phone.text);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSString *msg) {
        [self showErrorHUDWithError:@"绑定失败"];
    }];
}

- (void)enableSmsCode {
//    self.codeBtn.userInteractionEnabled = NO;
////    [self.codeBtn setTitle:@"60秒" forState:UIControlStateNormal];
//    
//    __block NSInteger timeout = 59; // 倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    __timer = _timer;
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(timeout <= 0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
////                [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"Background"] forState:0];
//                self.codeBtn.userInteractionEnabled = YES;
//                [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"Background"] forState:0];
//                [self.codeBtn setTitleColor:[UIColor whiteColor] forState:0];
//                [self.codeBtn setTitle:@"验证码" forState:UIControlStateNormal];
//            });
//        } else {
//            NSInteger seconds = timeout % 60;
//            NSString *strTime = [NSString stringWithFormat:@"%.2ld秒", (long)seconds];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                self.codeBtn.userInteractionEnabled = NO;
//                [self.codeBtn setTitleColor:TZGreyText150Color forState:0];
//                [self.codeBtn setBackgroundImage:nil forState:0];
//                self.codeBtn.backgroundColor = TZColorRGB(238);
////                [self.nextBtn setBackgroundImage:nil forState:0];
//                [self.codeBtn setTitle:strTime forState:UIControlStateNormal];
//            });
//            timeout--;
//        }
//    });
//    dispatch_resume(_timer);
    
    
    
    __block NSInteger timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_TARGET_QUEUE_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    __timer = timer;
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"Background"] forState:0];
                self.codeBtn.userInteractionEnabled = YES;
                [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"Background"] forState:0];
                [self.codeBtn setTitleColor:[UIColor whiteColor] forState:0];
                [self.codeBtn setTitle:@"验证码" forState:UIControlStateNormal];
            });
        } else {
            NSInteger seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2ld秒", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.codeBtn.userInteractionEnabled = NO;
                [self.codeBtn setTitleColor:TZGreyText150Color forState:0];
                [self.codeBtn setBackgroundImage:nil forState:0];
                self.codeBtn.backgroundColor = TZColorRGB(238);
                //                [self.nextBtn setBackgroundImage:nil forState:0];
                [self.codeBtn setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(timer);

}




@end
