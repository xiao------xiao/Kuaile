//
//  XYCashViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/20.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCashViewController.h"
#import "XYMoneyView.h"
#import "XYCashBankView.h"
#import "XYCashAliPayView.h"
#import "XYCashCodeView.h"
#import "YYControl.h"
#import "ICEComMoneyViewController.h"

@interface XYCashViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XYCashBankView *cashBankView;
@property (nonatomic, strong) XYMoneyView *moneyDetailView;
@property (nonatomic, strong) XYCashAliPayView *cashAlipayView;
@property (nonatomic, strong) XYCashCodeView *codeView;
@property (nonatomic, strong) UIButton *cashBtn;
@property (nonatomic, copy) NSString *commission;
@end

@implementation XYCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佣金提现";
    [self configScrollView];
    [self configCashView];
    [self configMoneyDetailView];
    [self configCodeView];
    [self configCashBtn];
    self.commission = [TZUserManager getUserCommission];
    
    [mNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [mNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.leftNavImageName = @"back";
}


- (void)didClickLeftNavAction {
    MJWeakSelf
    
    __block BOOL flag = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ICEComMoneyViewController class]]) {
            [weakSelf.navigationController popToViewController:obj animated:YES];
            flag = YES;
            *stop = YES;
        }
    }];
    if (!flag) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)keyboardWillShow:(NSNotification *)notif {
    NSLog(@"n %@", notif);
    
//    NSTimeInterval duration =
    
    NSInteger index = 0;
    if (_moneyDetailView.moneyTextField.isFirstResponder) {
        index = 1;
    }
    
    if (_codeView.code.isFirstResponder) {
        index = 2;
    }
    
    if (index == 0) {
        return;
    }
    
    CGRect boardR = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    CGFloat indication;
    
    if (index == 1) {
         indication = (CGRectGetMaxY(_moneyDetailView.frame) - _scrollView.contentOffset.y) + 64 - boardR.origin.y;

    }else {
         indication = (CGRectGetMaxY(_codeView.frame) - _scrollView.contentOffset.y) + 64 - boardR.origin.y;

    }
    
        if (indication > 0) {
            [UIView animateWithDuration:0.25 animations:^{
                CGRect bounds = self.view.bounds;
                bounds.origin.y = indication;
                self.view.bounds = bounds;
            }];
        }
    
    
    
}

- (void)keyboardWillHide:(NSNotification *)notif {
    NSLog(@"n %@", notif);
    [UIView animateWithDuration:0.25 animations:^{
        CGRect bounds = self.view.bounds;
        bounds.origin.y = 0;
        self.view.bounds = bounds;
    }];

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double v = [scrollView.panGestureRecognizer velocityInView:scrollView].y;
    
    if (abs(v) > 300) {
        [self.view endEditing:YES];
        
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *commission = [TZUserManager getUserCommission];
    if (commission == nil) {
        [TZUserManager syncUserCommissionWithCompletion:^(NSString *commission) {
            _moneyDetailView.leftMoneyLabel.text = [NSString stringWithFormat:@"佣金余额¥%@",commission];
        }];
    }
   _moneyDetailView.leftMoneyLabel.text = [NSString stringWithFormat:@"佣金余额¥%@",commission];
    NSString *realName = [mUserDefaults objectForKey:@"realName"];
    if (self.type == XYCashViewControllerTypeCard) {
//        _cashBankView.name.text = realName;
    } else {
//        _cashAlipayView.name.text = realName;
    }
}


- (void)configScrollView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64);
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
}

- (void)configCashView {
    if (self.type == XYCashViewControllerTypeCard) {
        _cashBankView = [[XYCashBankView alloc] init];
        _cashBankView.frame = CGRectMake(10, 10, mScreenWidth - 20, 190);
        [_scrollView addSubview:_cashBankView];
    } else {
        _cashAlipayView = [[XYCashAliPayView alloc] init];
        _cashAlipayView.frame = CGRectMake(10, 10, mScreenWidth - 20, 253);
        [_scrollView addSubview:_cashAlipayView];
    }
}

- (void)configMoneyDetailView {
    CGFloat y;
    if (self.type == XYCashViewControllerTypeCard) {
        y = CGRectGetMaxY(_cashBankView.frame) + 15;
    } else {
        y = CGRectGetMaxY(_cashAlipayView.frame) + 15;
    }
    _moneyDetailView = [[XYMoneyView alloc] init];
    _moneyDetailView.frame = CGRectMake(10, y, mScreenWidth - 20, 120);
    [_scrollView addSubview:_moneyDetailView];
}

- (void)configCodeView {
    CGFloat codeViewY = CGRectGetMaxY(_moneyDetailView.frame) + 15;
    _codeView = [[XYCashCodeView alloc] init];
    _codeView.frame = CGRectMake(10, codeViewY, mScreenWidth - 20, 90);
    [_codeView.codeBtn setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self enableSmsCode];
        [self sendCodeHttp];
    }];
    _codeView.phone.text = [NSString stringWithFormat:@"手机号：%@",[TZUserManager getUserModel].username];
    [_scrollView addSubview:_codeView];
}

- (void)configCashBtn {
    CGFloat btnY = CGRectGetMaxY(_codeView.frame) + 20;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, btnY, mScreenWidth - 20, 45);
    [btn setBackgroundColor:TZColor(0, 194, 255)];
    [btn setTitle:@"提现" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.layer.cornerRadius = 45/2.0;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    CGFloat contentH = CGRectGetMaxY(btn.frame) + 20;
    [_scrollView setContentSize:CGSizeMake(mScreenWidth, contentH)];
}

- (void)nextBtnClick {
//    sessionid	是	String
//    amount	是	String	提现金额
//    type	是	int	1银行卡2支付宝
//    bank_account	是	String	银行账号
//    account_name	是	String	开户人姓名
//    bank	是	String	银行名称
//    phone	是	String	手机号码
//    code

    
    NSString *amount = _moneyDetailView.moneyTextField.text;
    NSString *code = self.codeView.code.text;
    if (self.type == XYCashViewControllerTypeCard) {
        NSString *bankName = _cashBankView.name.text;
        NSString *bank = _cashBankView.bank.text;
        NSString *account = _cashBankView.account.text;
        if (bankName.length < 1 || bank.length < 1 || account < 1 || amount < 1 || code < 1) {
            [self showErrorHUDWithError:@"请将信息填写完整"]; return;
        }
    } else if (self.type == XYCashViewControllerTypeAlipay) {
        NSString *bank_account = _cashAlipayView.aliPayAgain.text;
        NSString *aliName = _cashAlipayView.name.text;
        
        if (![_cashAlipayView.aliPayAgain.text isEqualToString:_cashAlipayView.aliPay.text]) {
            [self showErrorHUDWithError:@"支付宝账号不一致"]; return;

        }
        
        
        if (amount.length < 1 || code.length < 1 || bank_account < 1 || aliName.length < 1) {
            [self showErrorHUDWithError:@"请将信息填写完整"]; return;
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    if (self.type = XYCashViewControllerTypeAlipay) {
        params[@"type"] = @2;
        params[@"bank_account"] = _cashAlipayView.aliPayAgain.text;
    } else if (self.type == XYCashViewControllerTypeCard) {
        params[@"type"] = @1;
        params[@"bank_account"] = _cashBankView.account.text;
        params[@"account_name"] = _cashBankView.name.text;
        params[@"bank"] = _cashBankView.bank.text;
    }
    params[@"amount"] = amount;
    params[@"phone"] = [TZUserManager getUserModel].username;
    params[@"code"] = code;
    [TZHttpTool postWithURL:ApiWithdraw params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"提现成功"];
        
        [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MJWeakSelf
            __block BOOL flag = NO;
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[ICEComMoneyViewController class]]) {
                    [weakSelf.navigationController popToViewController:obj animated:YES];
                    flag = YES;
                    *stop = YES;
                }
            }];
            if (!flag) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        });
    } failure:^(NSString *msg) {
        [self showErrorHUDWithError:msg];
    }];
}

- (void)sendCodeHttp {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = [TZUserManager getUserModel].username;
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    params[@"type"] = @4;
    [TZHttpTool postWithURL:ApiSms params:params success:^(NSDictionary *result) {
        NSLog(@"%@",result);
        NSString *code = result[@"data"];
    } failure:^(NSString *msg) {
    
    }];
}

- (void)enableSmsCode {
    self.codeView.codeBtn.userInteractionEnabled = NO;
    [self.codeView.codeBtn setTitle:@"59秒" forState:UIControlStateNormal];
    
    __block NSInteger timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeView.codeBtn setBackgroundImage:[UIImage imageNamed:@"tapbackground"] forState:UIControlStateNormal];
                self.codeView.codeBtn.userInteractionEnabled = YES;
                [self.codeView.codeBtn setTitle:@"验证码" forState:UIControlStateNormal];
                [self.codeView.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            });
        } else {
            NSInteger seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2ld秒", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.codeView.codeBtn.userInteractionEnabled = NO;
                [self.codeView.codeBtn setTitle:strTime forState:UIControlStateNormal];
                [self.codeView.codeBtn setBackgroundImage:nil forState:UIControlStateNormal];
                [self.codeView.codeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}



@end
