//
//  XYRegisterTwoViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYRegisterTwoViewController.h"
#import "XYShowCallView.h"
#import "XYRegisterOneViewController.h"
#import "ICELoginViewController.h"

@interface XYRegisterTwoViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avater;

@property (nonatomic, copy) NSString *status;

@end

@implementation XYRegisterTwoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self configBtns];
}

- (void)configBtns {
    self.headerView.layer.cornerRadius = 5;
    self.loginBtn.layer.cornerRadius = 25;
    self.loginBtn.clipsToBounds = YES;
//    self.registerBtn.layer.cornerRadius = 25;
//    self.registerBtn.clipsToBounds = YES;
}

- (IBAction)loginBtnClick:(id)sender {
    ICELoginViewController *login = [[ICELoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

- (IBAction)registerBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)connectBtnClick:(id)sender {
    self.callView.hidden = NO;
}

@end
