//
//  XYNearViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/14.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYNearViewController.h"
#import "XYGroupCell.h"
#import "TZAddFriendCell.h"
#import "XYCommontView.h"
#import "ICECreateGroupViewController.h"
#import "XYFliteGroupViewController.h"
#import "HJSreeningViewController.h"
#import "GroupDetailViewController.h"
#import "TZFindSnsModel.h"
#import "ICESelfInfoViewController.h"
#import "XYGroupInfoViewController.h"
#import "XYGroupInfoModel.h"


@interface XYNearViewController () {
    NSMutableArray *_selectedIndexesFromNearPeople;
}
@property (nonatomic, strong) XYCommontView *headerView;
@property(nonatomic,strong) NSMutableArray * nearPeople;
@property(nonatomic,strong) NSArray * nearGroup;
@property(nonatomic,strong) NSString * sessionid;
@property(nonatomic,strong) NSString * lng;
@property(nonatomic,strong) NSString * lat;
@property(nonatomic,strong) NSMutableArray * address;
@property(nonatomic,strong) NSMutableArray * distance;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (assign, nonatomic) BOOL haveData;
@property (strong, nonatomic) NSArray *selectedIndexes;
@end

@implementation XYNearViewController

-(NSMutableArray *)address {
    if (!_address) {
        _address = [NSMutableArray array];
    }
    return _address;
}
-(NSMutableArray *)distance {
    if (!_distance) {
        _distance = [NSMutableArray array];
    }
    return _distance;
}

-(NSMutableArray *)nearPeople {
    if (!_nearPeople) {
        _nearPeople = [NSMutableArray array];
    }
    return _nearPeople;
}


- (XYCommontView *)headerView {
    if (_headerView == nil) {
        _headerView = [[XYCommontView alloc] init];
    }
    return _headerView;
}

- (NSMutableDictionary *)params {
    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    [self configNavBarButtonItem];
    _selectedIndexesFromNearPeople = [NSMutableArray arrayWithArray:@[@11,@200,@0]];
    self.page = 1;
    self.sessionid = [mUserDefaults objectForKey:@"sessionid"];
    self.lng = [mUserDefaults objectForKey:@"longitude"];
    self.lat = [mUserDefaults objectForKey:@"latitude"];
   
    self.params[@"lng"] = self.lng;
    self.params[@"lat"] = self.lat;
    self.params[@"sessionid"] = self.sessionid;
    if (self.type == XYNearViewControllerTypeNearPeople) {
        self.params[@"page"] = @(self.page);
    }
    [self loadNetworkData];
    // 收到解散群的通知
    [mNotificationCenter addObserver:self selector:@selector(dismissGroup) name:@"didDismissGroupNoti" object:nil];
}

- (void)loadNetworkData {
    NSString *api;
    if (self.type == XYNearViewControllerTypeNearPeople) {
        api = ApiSnsGetNearPeople;
    } else if (self.type == XYNearViewControllerTypeNearGroup) {
        api = ApiSnsGetNearGroup;
    } else {
        api = ApiSnsGetRecommendGroups;
    }
    
    self.params[@"lng"] = self.lng;
    self.params[@"lat"] = self.lat;
    self.params[@"sessionid"] = self.sessionid;
    if (self.type == XYNearViewControllerTypeNearPeople) {
        self.params[@"page"] = @(self.page);
    }
    
    NSMutableDictionary *di = self.params;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [TZHttpTool postWithURL:api params:self.params success:^(NSDictionary *result) {
            self.haveData = YES;
            if (self.type == XYNearViewControllerTypeNearPeople) {
                self.totalPage = [result[@"data"][@"count_page"] integerValue];
                NSArray * arraypeople = [NearPeople mj_objectArrayWithKeyValuesArray:result[@"data"][@"people"]];
                if (self.page == 1) {
                    [self.nearPeople removeAllObjects];
                }
                [self.nearPeople addObjectsFromArray:arraypeople];
                [self.tableView configNoDataTipViewWithCount:self.nearPeople.count tipText:@"暂无内容"];
            } else if (self.type == XYNearViewControllerTypeNearGroup){
                self.nearGroup = [getGroupModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            } else {
                self.nearGroup = [XYGroupInfoModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
            });
            [self.tableView endRefresh];
        } failure:^(NSString *msg) {
            [self showInfo:msg];
            [self.tableView endRefresh];
        }];
    });
}

- (void)dismissGroup {
    [self refreshDataWithHeader];
}

- (void)configNavBarButtonItem {
    UIBarButtonItem *fliterItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shaixuan"] style:UIBarButtonItemStyleDone target:self action:@selector(fliterItemClick)];
    if (self.type == XYNearViewControllerTypeNearGroup) {
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jiahao"] style:UIBarButtonItemStyleDone target:self action:@selector(addItemClick)];
        self.navigationItem.rightBarButtonItems = @[fliterItem,addItem];
    } else {
        self.navigationItem.rightBarButtonItems = @[fliterItem];
    }
}

- (void)configTableView {
    if (self.type == XYNearViewControllerTypeNearPeople) {
        self.needRefresh = YES;
    } else {
        self.needRefresh = NO;
    }
    [super configTableView];
    [self.tableView registerCellByNibName:@"TZAddFriendCell"];
    [self.tableView registerCellByNibName:@"XYGroupCell"];
    if (self.type == XYNearViewControllerTypeNearGroup) {
        self.tableViewStyle = UITableViewStyleGrouped;
    } else {
        self.tableViewStyle = UITableViewStylePlain;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.haveData) {
        if (self.type == XYNearViewControllerTypeNearGroup) {
            return self.nearGroup.count;
        } else {
            return 1;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == XYNearViewControllerTypeNearGroup) {
        getGroupModel *model = self.nearGroup[section];
        return model.groups.count;
    } else if (self.type == XYNearViewControllerTypeRecommendGroup) {
        return self.nearGroup.count;
    } else {
        return self.nearPeople.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == XYNearViewControllerTypeNearPeople) {
        return 60;
    } else {
        return 90;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.type == XYNearViewControllerTypeNearGroup) {
        XYCommontView *view = [[XYCommontView alloc] init];
        getGroupModel *model = self.nearGroup[section];
        view.frontText = model.address;
        NSString *distance = [NSString stringWithFormat:@"%.2fkm",model.distance.floatValue];
        view.backText = distance;
        return view;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.type == XYNearViewControllerTypeNearGroup) {
        return 40;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == XYNearViewControllerTypeNearGroup) {
        XYGroupCell *groupCell = [tableView dequeueReusableCellWithIdentifier:@"XYGroupCell"];
        getGroupModel * model = self.nearGroup[indexPath.section];
        XYGroupInfoModel * groupModel = model.groups[indexPath.row];
        groupCell.groupInfoModel = groupModel;
        [groupCell addBottomSeperatorViewWithHeight:1];
        groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return groupCell;
    } else if (self.type == XYNearViewControllerTypeRecommendGroup){
        XYGroupCell *groupCell = [tableView dequeueReusableCellWithIdentifier:@"XYGroupCell"];
        XYGroupInfoModel * model = self.nearGroup[indexPath.row];
        groupCell.groupInfoModel = model;
        [groupCell addBottomSeperatorViewWithHeight:1];
        groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return groupCell;
    } else {
        TZAddFriendCell *peopleCell = [tableView dequeueReusableCellWithIdentifier:@"TZAddFriendCell"];
        NearPeople * peopleModel = self.nearPeople[indexPath.row];
        [peopleCell.avatarImageView sd_setImageWithURL:TZImageUrlWithShortUrl(peopleModel.avatar) placeholderImage:TZPlaceholderAvaterImage options:SDWebImageRefreshCached];
        
        NSString *name = peopleModel.nickname;
        CGFloat nicknameW = [CommonTools sizeOfText:name fontSize:14].width + 2;
        if (nicknameW > mScreenWidth * 0.26) nicknameW = mScreenWidth * 0.26;
        peopleCell.nameLabelConstraintW.constant = nicknameW;
        peopleCell.nameLable.text = name;
        peopleCell.subTitleLable.text = peopleModel.sign;
        if ([peopleModel.gender isEqualToString:@"0"]) {
            [peopleCell.ageBtn setBackgroundImage:[UIImage imageNamed:@"boy"] forState:UIControlStateNormal];
            [peopleCell.ageBtn setTitle:peopleModel.age forState:UIControlStateNormal];
        }else {
            [peopleCell.ageBtn setBackgroundImage:[UIImage imageNamed:@"girl"] forState:UIControlStateNormal];
            [peopleCell.ageBtn setTitle:peopleModel.age forState:UIControlStateNormal];
        }
        peopleCell.fromLabel.hidden = YES;
        peopleCell.attentionBtn.hidden = YES;
        peopleCell.moreView.hidden = YES;
//        NSLog(@"dis %lf",peopleModel.distance);

//        if (peopleModel.distance < 0.1) {
//            peopleCell.distanceLabel.text = @"100m内";
//        }else {
//            peopleCell.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",peopleModel.distance ];
//
//        }
        peopleCell.distanceLabel.text = peopleModel.distance;
        peopleCell.timeLabel.text = [CommonTools getFriendTimeFromTimeStamp:peopleModel.last_login];
        [peopleCell addBottomSeperatorViewWithHeight:1];
        peopleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return peopleCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([TZUserManager isLogin]) {
        if (self.type == XYNearViewControllerTypeNearGroup) {
            getGroupModel * groupModel = self.nearGroup[indexPath.section];
            XYGroupInfoModel *model = groupModel.groups[indexPath.row];
            XYGroupInfoViewController *groupInfoVc = [[XYGroupInfoViewController alloc] initWithGroupId:model.group_id];
            groupInfoVc.gid = model.gid;
            groupInfoVc.titleText = model.owner;
            //        groupInfoVc.model = model;
            [self.navigationController pushViewController:groupInfoVc animated:YES];
        } else if (self.type == XYNearViewControllerTypeRecommendGroup) {
            XYGroupInfoModel *model = self.nearGroup[indexPath.row];
            XYGroupInfoViewController *groupInfoVc = [[XYGroupInfoViewController alloc] initWithGroupId:model.group_id];
            groupInfoVc.gid = model.gid;
            groupInfoVc.titleText = model.owner;
            //        groupInfoVc.model = model;
            [self.navigationController pushViewController:groupInfoVc animated:YES];
        } else {
            ICESelfInfoViewController * vc = [[ICESelfInfoViewController alloc]init];
            vc.type = ICESelfInfoViewControllerTypeOther;
            NearPeople * model = self.nearPeople[indexPath.row];
            vc.otherUsername = model.username;
            vc.nickName = model.nickname;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)fliterItemClick {
    if (self.type == XYNearViewControllerTypeNearGroup) {
        XYFliteGroupViewController * fliteVC = [[XYFliteGroupViewController alloc] init];
        fliteVC.selectedIndexes = self.selectedIndexes;
        MJWeakSelf
        fliteVC.didClickConformItemBlock = ^(NSString * tagText, NSArray *indexes) {
            if (tagText.length && tagText) {
                weakSelf.params[@"tag"] = tagText;
                weakSelf.selectedIndexes = indexes;
                [weakSelf loadNetworkData];
            }
          };
        [self.navigationController pushViewController:fliteVC animated:YES];
    }else {
        HJSreeningViewController *tagVc = [[HJSreeningViewController alloc] init];
        tagVc.selectedIndexes = _selectedIndexesFromNearPeople;
        MJWeakSelf
        tagVc.didSreeningItemBlock = ^(NSString* gender, NSString *active_time, NSString* age_low, NSString * age_high, NSArray *selectedIndexes) {
            _selectedIndexesFromNearPeople = [NSMutableArray arrayWithArray:selectedIndexes];
            self.page = 1;
            weakSelf.params[@"page"] = @(self.page);
            weakSelf.params[@"gender"] = gender;
            weakSelf.params[@"active_time"] = active_time;
            if (age_low.length && age_high.length) {
                weakSelf.params[@"age_low"] = age_low;
                weakSelf.params[@"age_high"] = age_high;
            }
            [weakSelf loadNetworkData];
        };
        [self.navigationController pushViewController:tagVc animated:YES];
    }
}

- (void)addItemClick {
    ICECreateGroupViewController *createVc = [[ICECreateGroupViewController alloc] init];
    [self.navigationController pushViewController:createVc animated:YES];
}



@end
