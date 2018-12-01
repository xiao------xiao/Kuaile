//
//  ICEUserInfoViewController.m
//  kuaile
//
//  Created by ttouch on 15/10/21.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICEUserInfoViewController.h"
#import "ICESelfInfoModel.h"
#import "ICEWebUserViewController.h"
#import "TZJobApplyView.h"
#import "ChatViewController.h"
#import "MJPhotoBrowser.h"

#import "XYChatTipView.h"

@interface ICEUserInfoViewController ()
@property (nonatomic, strong) ICESelfInfoModel *modelSelfInfo;
@property (nonatomic, strong) TZJobApplyView *createResume;
@end

@implementation ICEUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细信息";
    [self loadNetUserInfo];
    [self configBtnDynamic];
    [self configJobApplyView];
    [self forInFriendInfo];
}

- (void)loadNetUserInfo {
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    RACSignal *sign;
    if (self.userName) {
        sign = [ICEImporter getPerson:self.userName];
    } else {
        sign = [ICEImporter getPerson:userModel.username];
    }
    [sign subscribeNext:^(id x) {
        _modelSelfInfo = [ICESelfInfoModel objectWithKeyValues:x[@"data"]];
        [self loadData];
    }];
}

- (void)loadData {
    if (![_modelSelfInfo.gender isEqualToString:@"0"]) {
        self.imageViewSex.image = [UIImage imageNamed:@"myself_xbv"];
    }
    [self.imageViewHead sd_setImageWithURL:[NSURL URLWithString:_modelSelfInfo.avatar] placeholderImage:TZPlaceholderAvaterImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageHeadView:)];
    self.imageViewHead.userInteractionEnabled = YES;
    [self.imageViewHead addGestureRecognizer:tap];
    
    self.labPhone.text = _modelSelfInfo.phone;
    self.labNickName.text = _modelSelfInfo.nickname;
    self.labHomeCity.text = _modelSelfInfo.hometown;
    self.labBirthday.text = [[ICETools standardTime:_modelSelfInfo.birthday] substringToIndex:10];;
    self.labAddress.text = _modelSelfInfo.address;
}

/// 点击头像，预览大图
- (void)tapImageHeadView:(UITapGestureRecognizer *)tap {
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.srcImageView = self.imageViewHead;
    if (_modelSelfInfo.avatar.length) {
        photo.url = [NSURL URLWithString:_modelSelfInfo.avatar];
    } else {
        photo.image = self.imageViewHead.image;
    }
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    photoBrowser.photos = @[photo];
    [photoBrowser show];
}

- (void)configBtnDynamic {
    [[self.btnDynamic rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ICEWebUserViewController *iCEWebUser = [[ICEWebUserViewController alloc] init];
        [self.navigationController pushViewController:iCEWebUser animated:YES];
    }];
}

- (void)configJobApplyView {
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    if (![self.userName isEqualToString:userModel.username]) {
        _createResume = [[TZJobApplyView alloc] init];
        [_createResume.button setTitle:@"加为好友" forState:UIControlStateNormal];
        [_createResume.button addTarget:self action:@selector(addContacts:) forControlEvents:UIControlEventTouchUpInside];
        _createResume.frame = CGRectMake(0, __kScreenHeight - 50 - 64, __kScreenWidth, 50);
        [self.view addSubview:_createResume];
    }
}

/** 遍历好友列表查看是否是我的好友 */
- (void)forInFriendInfo {
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            NSLog(@"获取成功 -- %@",buddyList);
            for (EMBuddy *emb in buddyList) {
                DLog(@"%@", emb.username);
                if ([self.userName isEqualToString:emb.username]) {
                    _createResume = [[TZJobApplyView alloc] init];
                    [_createResume.button setTitle:@"发送消息" forState:UIControlStateNormal];
                    [_createResume.button addTarget:self action:@selector(sendMessageUser) forControlEvents:UIControlEventTouchUpInside];
                    _createResume.frame = CGRectMake(0, __kScreenHeight - 50 - 64, __kScreenWidth, 50);
                    [self.view addSubview:_createResume];
                }
            }
        }
    } onQueue:nil];
}

- (void)sendMessageUser{
    if (![TZUserManager isLogin]) return;
    ChatViewController *chatView = [[ChatViewController alloc] initWithChatter:self.userName isAttented:YES isGroup:NO];
    chatView.title = [TZEaseMobManager nickNameWithUsername:self.userName];
    [self.navigationController pushViewController:chatView animated:YES];
}

- (void)addContacts:(id)sender {
    if (![TZUserManager isLogin]) return;
       __block UIAlertView *alert = [self showAlertViewWithTitle:nil message:@"说点什么吧" okBtnHandle:^{
        UITextField *messageTextField = [alert textFieldAtIndex:0];
        NSString *messageStr = @"";
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
        if (messageTextField.text.length > 0) {
            messageStr = [NSString stringWithFormat:@"%@", messageTextField.text];
        } else {
            messageStr = @"无";
        }
        [self sendFriendApplyAtIndexPath:nil message:messageStr];
    }];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
}

- (void)sendFriendApplyAtIndexPath:(NSIndexPath *)indexPath message:(NSString *)message {
    NSString *buddyName =  self.userName; // [self.dataSource objectAtIndex:indexPath.row];
    if (buddyName && buddyName.length > 0) {
        [self showHudInView:self.view hint:NSLocalizedString(@"friend.sendApply", @"sending application...")];
        EMError *error;
        [[EaseMob sharedInstance].chatManager addBuddy:buddyName message:message error:&error];
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"friend.sendApplyFail", @"send application fails, please operate again")];
        } else {
            [self showHint:NSLocalizedString(@"friend.sendApplySuccess", @"send successfully")];
            [self.navigationController popViewControllerAnimated:YES];
            // 加好友添加积分
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"uid": userModel.uid}];
            RACSignal *sign = [ICEImporter addFriendsIntegralWithParams:params];
        }
    }
}

@end
