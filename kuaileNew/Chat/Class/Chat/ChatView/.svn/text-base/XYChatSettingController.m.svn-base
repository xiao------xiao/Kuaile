//
//  XYChatSettingController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/10.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYChatSettingController.h"
#import "TZAddFriendCell.h"
#import "TZButton.h"
#import "XYNewFriendDetailController.h"
#import "ICESelfInfoViewController.h"

@interface XYChatSettingController ()<EMChatManagerDelegate>

@property (nonatomic, strong) UISwitch *swh;

@property (nonatomic, strong) ORUserInfoModel *model;
@end

@implementation XYChatSettingController

- (UISwitch *)swh {
    if (!_swh) {
        _swh = [[UISwitch alloc] init];
        [_swh addTarget:self action:@selector(switchValueChange) forControlEvents:UIControlEventValueChanged];
    }
    return _swh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天设置";
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [self loadData];
}


- (void)loadData {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"sessionid"] = sessionId;
    params[@"username"] = _name;
    params[@"lat"] = [mUserDefaults objectForKey:@"latitude"];
    params[@"lng"] = [mUserDefaults objectForKey:@"longitude"];
    [TZHttpTool postWithURL:ApiDeletefetOtherInfo params:params success:^(NSDictionary *result) {
        _model = [ORUserInfoModel mj_objectWithKeyValues:result[@"data"] context:nil];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
    }];
    
    [[EaseMob sharedInstance].chatManager asyncFetchBlockedListWithCompletion:^(NSArray *blockedList, EMError *error) {
        if (!error) {
            [blockedList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:_name]) {
                    self.swh.on = YES;
                    *stop = YES;
                }
            }];
        }
    } onQueue:nil];

}

- (void)configTableView {
    self.needRefresh = NO;
    [super configTableView];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerCellByNibName:@"TZAddFriendCell"];
    [self.tableView registerCellByClassName:@"UITableViewCell"];
    [self.tableView registerCellByClassName:@"TZButtonCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _model ? 3 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 10;
    } else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 65;
    } else {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TZAddFriendCell *friendCell = [tableView dequeueReusableCellWithIdentifier:@"TZAddFriendCell"];
        friendCell.attentionBtn.hidden = YES;
        friendCell.fromLabel.hidden = YES;
        friendCell.distanceLabel.hidden = YES;
        friendCell.timeLabel.hidden = YES;
        
        UIImage *imag;
        if (_model.gender.integerValue == 1) {
            imag = [UIImage imageNamed:@"girl"];
        }else {
            imag = [UIImage imageNamed:@"boy"];
        }
        
        [friendCell.ageBtn setBackgroundImage:imag forState:0];
        [friendCell.ageBtn setTitle:_model.age forState:0];
        NSString *str = _model.nickname;
        
        friendCell.nameLable.text = str ? str : _name;
        CGFloat nicknameW = [CommonTools sizeOfText:_name fontSize:14].width + 3;
        if (nicknameW > mScreenWidth * 0.6) nicknameW = mScreenWidth * 0.6;
        friendCell.nameLabelConstraintW.constant = nicknameW;
        [friendCell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:TZPlaceholderAvaterImage];
        friendCell.subTitleLable.text = _model.sign;
        friendCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return friendCell;
    } else if (indexPath.section == 1) {
        UITableViewCell *screenCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        screenCell.textLabel.text = @"屏蔽此人";
        screenCell.textLabel.font = [UIFont systemFontOfSize:15];
        screenCell.textLabel.textColor = TZColorRGB(150);
        screenCell.accessoryView = self.swh;
        screenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return screenCell;
    } else {
        TZButtonCell *attentionCell = [tableView dequeueReusableCellWithIdentifier:@"TZButtonCell"];
        attentionCell.isButtonAtRight = NO;
        
        if (_model.is_attention.integerValue == 0) {
            [attentionCell setTitle:@"关注对方" textColor:TZMainColor fontSize:18];
        }else {
            [attentionCell setTitle:@"取消关注" textColor:TZColor(255, 124, 114) fontSize:18];
        }
        
        
        [attentionCell.button addTarget:self action:@selector(attentionBtn:) forControlEvents:UIControlEventTouchUpInside];
        attentionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return attentionCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ICESelfInfoViewController *infoVc = [[ICESelfInfoViewController alloc] init];
        infoVc.otherUsername = _model.username;
        infoVc.nickName = _name;
        infoVc.type = ICESelfInfoViewControllerTypeOther;
        [self.navigationController pushViewController:infoVc animated:YES];
    }
}


- (void)attentionBtn:(UIButton *)sender {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiSnsConcernUser params:@{@"sessionid":sessionId, @"buid" : _model.uid} success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:result[@"msg"]];
        BOOL isAttented = YES;
        if ([result[@"msg"] isEqualToString:@"取关成功"]) {
            [sender setTitle:@"关注对方" forState:UIControlStateNormal];
            [sender setTitleColor:TZMainColor forState:UIControlStateNormal];
            isAttented = NO;
        }else {
            [sender setTitle:@"取消关注" forState:UIControlStateNormal];
            [sender setTitleColor:TZColor(255, 124, 114) forState:UIControlStateNormal];
        }
        if (self.didHandleAttentionBlock) {
            self.didHandleAttentionBlock(isAttented);
        }
        [mNotificationCenter postNotificationName:@"didAddFriendNoti" object:nil];
    } failure:^(NSString *msg) {
        NSLog(@"re%@", msg);
    }];
}

#pragma mark -- private
- (void)switchValueChange {
    if (self.swh.isOn) {
        EMError *error = [[EaseMob sharedInstance].chatManager blockBuddy:_name 	relationship:eRelationshipBoth];
        if (!error) {
//            [self showSuccessHUDWithStr:@"屏蔽成功"];
            if (self.didHandleScreenBlock) {
                self.didHandleScreenBlock(YES);
            }
        }
        
    }else {
        EMError *error = [[EaseMob sharedInstance].chatManager unblockBuddy:_name];
        if (!error) {
//            [self showHint:@"操作成功"];
//            [self showSuccessHUDWithStr:@"操作成功"];
            if (self.didHandleScreenBlock) {
                self.didHandleScreenBlock(NO);
            }
        }
    }
    
}

- (void)didUnblockBuddy:(NSString *)username error:(EMError *)pError {
    if (!pError) {
        [self showHint:@"操作成功"];
    }else {
        [self showHint:@"操作失败"];
    }
}

@end


@implementation ORUserInfoModel



@end
