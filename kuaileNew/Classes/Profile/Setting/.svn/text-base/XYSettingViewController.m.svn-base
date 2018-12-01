//
//  XYSettingViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/9.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSettingViewController.h"
#import "XYForgetPasswordViewController.h"
#import "ICEAboutViewController.h"
#import "TZFeedBackViewController.h"
#import "TZButtonsHeaderView.h"
#import "MainTabViewController.h"



@interface XYSettingViewController ()<UIAlertViewDelegate>{
    NSArray *_titles;
}
@property (nonatomic, strong) UIButton *logoutBtn;
@property (nonatomic, copy) NSString *currentVersion;
@end

@implementation XYSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self judeHaveNewVersion];
    _titles = @[@"关于我们",@"修改密码",@"联系客服",@"清理缓存",@"意见反馈",@"检查更新"];
    NSString *phone =[ICELoginUserModel sharedInstance].phone;
    NSInteger thirdLogin = [[mUserDefaults objectForKey:@"thirdLogin"] integerValue];
    //,@"检查更新"
    if (phone.length > 1) {
        _titles = @[@"关于我们",@"联系客服",@"清理缓存",@"意见反馈"];
    } else {
        _titles = @[@"关于我们",@"修改密码",@"联系客服",@"清理缓存",@"意见反馈"];
    }
    [self configLogoutBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)judeHaveNewVersion {
    self.currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *lastVersion = [mUserDefaults objectForKey:@"lastVersion"];
    if (![lastVersion isEqualToString:self.currentVersion]) {
        self.currentVersion = @"有新版本可用";
    }
}

- (void)pushToItunesConnection {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
    alert.tag = 1001;
    [alert show];
}

- (void)configLogoutBtn {
    CGFloat btnH = 55;
    if (mScreenWidth < 375) btnH = 45;
    _logoutBtn = [[UIButton alloc] init];
    _logoutBtn.frame = CGRectMake(30, mScreenHeight - 64 - btnH - 100, mScreenWidth - 60, btnH);
    [_logoutBtn setTitle:@"注销" forState:0];
    [_logoutBtn setTitleColor:[UIColor whiteColor] forState:0];
    _logoutBtn.layer.cornerRadius = btnH/2.0;
    _logoutBtn.clipsToBounds = YES;
    [_logoutBtn setBackgroundColor:TZColor(6, 191, 252)];
    _logoutBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [TZEaseMobManager logoutEaseMobWithCompletion:^(BOOL success) {
            [mUserDefaults setObject:nil forKey:@"sessionid"];
            [self showSuccessHUDWithStr:@"注销成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MainTabViewController *mainVc = (MainTabViewController *)self.tabBarController;
                mainVc.selectedIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            });
            
        }];
        return [ICEImporter logout];
    }];
    [self.view addSubview:_logoutBtn];
}

- (void)configTableView {
    self.needRefresh = NO;
    [super configTableView];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerCellByClassName:@"UITableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section != _titles.count - 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        cell.textLabel.text = _titles[indexPath.section];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
//    } else {
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//        cell.textLabel.text = _titles[indexPath.section];
//        cell.textLabel.textColor = [UIColor darkGrayColor];
//        cell.detailTextLabel.text = self.currentVersion;
//        if ([self.currentVersion isEqualToString:@"有新版本可用"]) {
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
}

//@[@"关于我们",@"修改密码",@"联系客服",@"清理缓存",@"意见反馈",@"检查更新"];
//@[@"关于我们",@"联系客服",@"清理缓存",@"意见反馈",@"检查更新"];
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd",indexPath.section);
    NSString *title = _titles[indexPath.section];
    if ([title isEqualToString:@"关于我们"]) {
        ICEAboutViewController *iCEAbout = [[ICEAboutViewController alloc] init];
        [self.navigationController pushViewController:iCEAbout animated:YES];
    } else if ([title isEqualToString:@"修改密码"]) {
        XYForgetPasswordViewController *forgetVc = [[XYForgetPasswordViewController alloc] init];
        forgetVc.titleText = @"修改密码";
        [self.navigationController pushViewController:forgetVc animated:YES];
    } else if ([title isEqualToString:@"联系客服"]) {
        [TZContactTool callPhoneWithPhoneNumber:@"4006920099"];
    } else if ([title isEqualToString:@"清理缓存"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否清理缓存" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
    } else if ([title isEqualToString:@"意见反馈"]) {
        TZFeedBackViewController *vc = [[TZFeedBackViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"检查更新"]) {
        if ([self.currentVersion isEqualToString:@"有新版本可用"]) {
            [self pushToItunesConnection];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self clearCaches];
        }
    } else {
        if (buttonIndex == 1) {
            NSString *appStoreLink = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@",AppID];
            NSURL *url = [NSURL URLWithString:appStoreLink];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)clearCaches {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showSuccessHUDWithStr:@"清理成功"];
        });
    });
}



@end
