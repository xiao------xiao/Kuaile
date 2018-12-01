//
//  ICESettingViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICESettingViewController.h"
#import "ICEAboutViewController.h"
#import "TZFeedBackViewController.h"

@interface ICESettingViewController ()

@end

@implementation ICESettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"软件设置";
    [self configBtn];
    [self configBtnLogout];
}

- (void)configBtn {
    [[self.btnAbout rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ICEAboutViewController *iCEAbout = [[ICEAboutViewController alloc] init];
        [self.navigationController pushViewController:iCEAbout animated:YES];
    }];
    
    [[self.btnFeedBack rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        TZFeedBackViewController *vc = [[TZFeedBackViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[self.btnCustomer rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [TZContactTool callPhoneWithPhoneNumber:@"tel:4006920099"];
    }];
}

- (void)configBtnLogout {
    [self.btnLogout setTitle:@"注销" forState:UIControlStateNormal];
    self.btnLogout.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [TZEaseMobManager logoutEaseMobWithCompletion:^(BOOL success) {
            [self performSelector:@selector(pushViewCtrl) withObject:nil afterDelay:1.0f];
            [self showSuccessHUDWithStr:@"注销成功"];
        }];
        return [ICEImporter logout];
    }];
    
    [self.btnLogout.rac_command.executionSignals subscribeNext:^(RACSignal*subscribeSignal) {
        [subscribeSignal subscribeCompleted:^{
            // 设置全局单例对象登录信息
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            userModel.hasLogin = NO;
        }];
    }];
}

/// 注销后 回到首页
- (void)pushViewCtrl {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
