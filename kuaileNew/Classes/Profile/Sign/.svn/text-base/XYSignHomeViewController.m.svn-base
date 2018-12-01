//
//  XYSignHomeViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/16.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSignHomeViewController.h"
#import "XYSignHomeHeader.h"
#import "XYPromoteCell.h"
#import "XYBannerModel.h"
#import "XYScoreTaskViewController.h"
#import "XYScoreDetailViewController.h"
#import "XYSignViewController.h"
#import "XYUserInfoModel.h"
#import "ICETimeLimitBuyViewController.h"
#import "ICEPointDescViewController.h"

@interface XYSignHomeViewController () {
    NSDictionary *_bannerDic; // banner
    NSString *_str;
}

@property (nonatomic, strong) UILabel *covertLabel;
@property (nonatomic, strong) UIButton *visitBtn;

@property (nonatomic, strong) UIButton *visitBtn1;

@property (nonatomic, strong) XYSignHomeHeader *header;
@end

@implementation XYSignHomeViewController

- (UILabel *)covertLabel {
    if (_covertLabel == nil) {
        _covertLabel = [[UILabel alloc] init];
        _covertLabel.size = CGSizeMake(100, 21);
        _covertLabel.text = @"每日12:00开抢";
        _covertLabel.textAlignment = NSTextAlignmentRight;
        _covertLabel.font = [UIFont systemFontOfSize:13];
        _covertLabel.textColor = TZMainColor;
    }
    return _covertLabel;
}

- (UIButton *)visitBtn {
    if (_visitBtn == nil) {
        _visitBtn = [[UIButton alloc] init];
        _visitBtn.size = CGSizeMake(60, 22);
        [_visitBtn setTitle:@"去捧场" forState:UIControlStateNormal];
        [_visitBtn setTitleColor:TZGreyText150Color forState:UIControlStateNormal];
        _visitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _visitBtn.layer.cornerRadius = 9;
        _visitBtn.clipsToBounds = YES;
        [_visitBtn.layer setBorderColor:TZColorRGB(180).CGColor];
        [_visitBtn.layer setBorderWidth:0.6];
    }
    return _visitBtn;
}

- (UIButton *)visitBtn1 {
    if (_visitBtn1 == nil) {
        _visitBtn1 = [[UIButton alloc] init];
        _visitBtn1.size = CGSizeMake(60, 22);
        [_visitBtn1 setTitle:@"去捧场" forState:UIControlStateNormal];
        [_visitBtn1 setTitleColor:TZGreyText150Color forState:UIControlStateNormal];
        _visitBtn1.titleLabel.font = [UIFont systemFontOfSize:13];
        _visitBtn1.layer.cornerRadius = 9;
        _visitBtn1.clipsToBounds = YES;
        [_visitBtn1.layer setBorderColor:TZColorRGB(180).CGColor];
        [_visitBtn1.layer setBorderWidth:0.6];
    }
    return _visitBtn1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的积分";
    self.rightNavTitle = @"积分说明";
    
    [mNotificationCenter addObserver:self selector:@selector(updateData) name:@"didUpdateMemberInfo" object:nil];
    [mNotificationCenter addObserver:self selector:@selector(pointUpdate) name:@"pointDidUpdate" object:nil];

    [self updateData];
    
}

- (void)didClickRightNavAction {
    ICEPointDescViewController *iCEPointDesc = [[ICEPointDescViewController alloc] initWithNibName:@"ICEPointDescViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:iCEPointDesc animated:YES];

}

- (void)pointUpdate {
    [TZUserManager syncUserModelWithCompletion:^(XYUserInfoModel *model) {
        self.userModel = model;
        _header.point = self.userModel.point;

    }];
}

- (void)updateData {
    //    self.userModel
    [TZUserManager getNETUserModelWithCompletion:^(XYUserInfoModel *model) {
        self.userModel = model;
        _header.point = model.point;
    }];
    
//    self.userModel = [TZUserManager getUserModel];
//    _header.point = self.userModel.point;
    
    //tip , banner
    [TZHttpTool postWithURL:ApiDeleteSignInfo params:nil success:^(NSDictionary *result) {
        NSLog(@"or......%@", result);
        _header.tips = result[@"data"][@"words"];
        _str = result[@"data"][@"words"];
        NSArray *array = result[@"data"][@"ads"];
        if (array.count > 0) {
            _bannerDic = array.firstObject;
            [self.tableView reloadData];
        }
    } failure:^(NSString *msg) {
        
    }];

}

- (void)configTableView {
    self.needRefresh = YES;
    [super configTableView];
    [self.tableView registerCellByClassName:@"XYPromoteCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell1"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell2"];

     _header = [[XYSignHomeHeader alloc] init];
    
#pragma mark ---
    MJWeakSelf
    //签到
    __weak typeof(_str) weak_str = _str;
    
    [_header setDidClickSignBtnBlock:^{
        XYSignViewController *signVc = [[XYSignViewController alloc] init];
        signVc.aModel = weakSelf.userModel;
        NSLog(@"12312313%@", weak_str);
        signVc.tips = weak_str;
        [weakSelf.navigationController pushViewController:signVc animated:YES];
    }];
    //积分任务
    [_header setDidClickTaskBtnBlock:^{
        XYScoreTaskViewController *taskVc = [[XYScoreTaskViewController alloc] init];
        [weakSelf.navigationController pushViewController:taskVc animated:YES];
    }];
    //积分细节
    [_header setDidClickDetailBtnBlock:^{
        XYScoreDetailViewController *detailVc = [[XYScoreDetailViewController alloc] init];
        [weakSelf.navigationController pushViewController:detailVc animated:YES];
    }];
    self.tableView.tableHeaderView = _header;
    UIView *view = self.tableView.tableHeaderView;
    view.height = 200;
    self.tableView.tableHeaderView = view;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 120;
    } else if (indexPath.row == 1){
        return 44;
    } else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        XYPromoteCell *adsCell = [tableView dequeueReusableCellWithIdentifier:@"XYPromoteCell"];
        adsCell.backgroundColor = TZControllerBgColor;
        [adsCell.imgView sd_setImageWithURL:_bannerDic[@"path"] placeholderImage:TZPlaceholderImage];
        adsCell.margin = 3;
        adsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return adsCell;
    } else if (indexPath.row == 1) {
        UITableViewCell *covertCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell1"];
        covertCell.imageView.image = [UIImage imageNamed:@"icon_jfdh"];
        covertCell.textLabel.text = @"积分兑换";
        covertCell.accessoryView = self.covertLabel;
        [covertCell addBottomSeperatorViewWithHeight:1];
        covertCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return covertCell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell2"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell2"];
        }
        cell.imageView.image = [UIImage imageNamed:@[@"cjhd",@"xsdh"][indexPath.row - 2]];
        cell.textLabel.text = @[@"抽奖活动",@"限时抢兑"][indexPath.row - 2];
        cell.detailTextLabel.text = @[@"好运气抽大奖",@"积分换好礼"][indexPath.row - 2];
        cell.textLabel.y = 10;
        cell.accessoryView = self.visitBtn;
        if (indexPath.row == 3) {
            cell.accessoryView = self.visitBtn1;
        }
        [cell addBottomSeperatorViewWithHeight:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        if ([_bannerDic[@"href"] length] <= 0) {
            return;
        }
        
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
//        NSString *strURL = [NSString stringWithFormat:@"%@%@", _bannerDic[@"href"], userModel.uid];
        
        [self pushWebVcWithUrl:_bannerDic[@"href"] title:@"抽奖活动"];
    }
    if (indexPath.row == 1) {
        if ([TZUserManager isLogin]) {
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            NSString *strURL = [NSString stringWithFormat:@"http://www.hap-job.com/app/goods/moneyGoods/uid/%@", userModel.uid];
            [self pushWebVcWithUrl:strURL title:@"抽奖活动"];
        }

    }
    if (indexPath.row == 2) {
        if ([TZUserManager isLogin]) {
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            NSString *strURL = [NSString stringWithFormat:@"%@%@", ApiAward, userModel.uid];
            [self pushWebVcWithUrl:strURL title:@"抽奖活动"];
        }
    }
    if (indexPath.row == 3) {
        if ([TZUserManager isLogin]) {
            ICETimeLimitBuyViewController *iCETimeLimit = [[ICETimeLimitBuyViewController alloc] initWithNibName:@"ICETimeLimitBuyViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:iCETimeLimit animated:YES];
        }

    }
}


@end
