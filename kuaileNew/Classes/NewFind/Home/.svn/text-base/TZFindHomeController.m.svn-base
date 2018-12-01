//
//  TZFindHomeController.m
//  kuaile
//
//  Created by ttouch on 2016/12/21.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import "TZFindHomeController.h"
#import "TZSnsCreateController.h"
#import "TZFindSnsTableView.h"
#import "TZFindSnsCell.h"
#import "TZFindSnsModel.h"
#import "XYNearCell.h"
#import "XYGroupCell.h"
#import "XYNearViewController.h"
#import "EaseMob.h"
#import "XYUserInfoModel.h"

// 选择图片
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TZPhotoPickerController.h"
#import "GroupDetailViewController.h"
#import "ICESelfInfoViewController.h"
#import "XYGroupInfoViewController.h"
#import "XYEditUserViewController.h"
#import "XYGroupInfoModel.h"


@interface TZFindHomeController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,TZFindSnsTableViewDelegate,UIAlertViewDelegate> {
    BOOL _loadNear;
    BOOL _isScroll;
}
@property (nonatomic, strong) TZFindSnsTableView *tableView1;
@property (nonatomic, strong) TZFindSnsTableView *tableView2;
@property (nonatomic, strong) TZFindSnsTableView *tableView3;
@property (nonatomic, strong) TZFindSnsTableView *tableView4;
@property (nonatomic, strong) UITableView *tableView5;

@property (nonatomic, strong) TZButtonsHeaderView *headerBtns;
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIButton *publishBtn;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isManuChangeType;

@property (nonatomic, strong) UIImage *picture;
@property (nonatomic,strong) NSArray * getNearArray;
@property (nonatomic, copy) NSString *snsVcTitle;
@property (nonatomic, strong) NSArray * getpeopleArr;
@property (nonatomic, strong) NSArray * getgroupArr;
@property (nonatomic, strong) NSMutableArray *peopleAvatars;
@property (nonatomic, strong) NSMutableArray *peopleNicknames;
@property (nonatomic, strong) NSMutableArray *peopleAges;
@property (nonatomic, strong) NSMutableArray *peopleGenders;
@property (nonatomic, strong) NSMutableArray *groupAvatars;
@property (nonatomic, strong) NSMutableArray *groupNames;

@property (nonatomic, copy) NSString * lng;
@property (nonatomic, copy) NSString * l;
@property (nonatomic, copy) NSString * lat;
@property (nonatomic, copy) NSString *sessionid;
@property (nonatomic, assign) NSInteger page;
@property (assign, nonatomic) NSInteger clickIndex;
@property (assign, nonatomic) BOOL needMonitor;

@end

@implementation TZFindHomeController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.peopleAvatars = [NSMutableArray array];
    self.peopleAges = [NSMutableArray array];
    self.peopleNicknames = [NSMutableArray array];
    self.peopleGenders = [NSMutableArray array];
    self.groupNames = [NSMutableArray array];
    self.groupAvatars = [NSMutableArray array];
    _loadNear = NO;
    
    self.navTitle = @"发现";
    self.clickIndex = 0;
    self.rightNavImageName = @"camera";
    [self configHeaderBtns];
    [self configBigScrollView];
    [self configPublicBtn];
    [mNotificationCenter addObserver:self selector:@selector(navigationDidClick:) name:@"navigationDidClick" object:nil];
    // 收到解散群的通知
    [mNotificationCenter addObserver:self selector:@selector(dismissGroup) name:@"didDismissGroupNoti" object:nil];
    // 创建群组成功
    [mNotificationCenter addObserver:self selector:@selector(dismissGroup) name:@"didCreateGroupNoti" object:nil];
    // 登录成功
    [mNotificationCenter addObserver:self selector:@selector(loginSuccess) name:@"kICELoginSuccessNotificationName" object:nil];
    
    [mNotificationCenter addObserver:self selector:@selector(loadLaoXiang) name:@"LaoXiangChanged" object:nil];
    
    [mNotificationCenter addObserver:self selector:@selector(aaa) name:@"didAddFriendNoti" object:nil];


    self.page = 1;
    self.lng = [mUserDefaults objectForKey:@"longitude"];
    self.lat = [mUserDefaults objectForKey:@"latitude"];
    self.sessionid = [mUserDefaults objectForKey:@"sessionid"];
    
    [self changeRightNavItemStatusWithIndex:2];
    self.isManuChangeType = YES;
    [self.bigScrollView setContentOffset:CGPointMake(2 * mScreenWidth, 0) animated:YES];
}

- (void)loadLaoXiang {
    [_tableView4 loadGetSameTown];
}

- (void)loginSuccess {
    
    [self aaa];
    
    if (self.needMonitor) {
        [self jugeHaveSetupHometown];
    }
}

- (void) aaa {
    switch (_selectedIndex) {
            
        case 1:
            [self.tableView2 loadNetworkData];
            
            break;
        case 2:
            [self.tableView3 loadNetworkData];
            
            break;
        case 3:
            [self.tableView4 loadGetSameTown];
            break;
        case 0:
            [self.tableView1 loadNetworkData];
            break;
        case 4:
            [self loadGetNearPeople];
            break;
        default:
            break;
    }
}

- (void)dismissGroup {
    [self loadGetNearPeople];
}

- (void)getKeyedArchiveData {
    self.getNearArray = [TZUserManager getRecommendGroupWithTag:2];
    self.getpeopleArr = [TZUserManager getUserNearPeoples];
    self.getgroupArr = [TZUserManager getRecommendGroupWithTag:1];
    NSInteger count = self.getpeopleArr.count > 4 ? 4 : self.getpeopleArr.count;
    for (int i = 0; i < count; i++) {
        NearPeople *model = self.getpeopleArr[i];
        [self.peopleAvatars addObject:model.avatar];
        [self.peopleNicknames addObject:model.nickname];
        [self.peopleAges addObject:model.age];
        [self.peopleGenders addObject:model.gender];
    }
    NSInteger groupCount = self.getgroupArr.count > 4 ? 4 : self.getgroupArr.count;
    for (int i = 0; i < groupCount; i++) {
        XYGroupInfoModel *model = self.getgroupArr[i];
        [self.groupAvatars addObject:model.avatar];
        [self.groupNames addObject:model.owner];
    }
    [self.tableView5 reloadData];
    if (!_loadNear) {
        [self loadGetNearPeople];
        [self loadGetRecommendGroupsNetWork];
    }
}


// 注册通知
- (void)navigationDidClick:(NSNotification *)not {
    _headerBtns.selectBtnIndex = 3;
    self.bigScrollView.contentOffset = CGPointMake(3 * mScreenWidth, 0);
    [self.tableView4 loadGetSameTown];
}
//销毁通知
- (void)removeNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)configHeaderBtns {
    _headerBtns = [[TZButtonsHeaderView alloc] init];
    _headerBtns.frame = CGRectMake(0, 0, mScreenWidth, 40);
    _headerBtns.notCalcuLateTitleWidth = YES;
    _headerBtns.titles = @[@"动态",@"美拍",@"广场",@"老乡",@"附近"];
    _headerBtns.showSpots = @[@1,@1,@1,@1,@1];
    _headerBtns.selectBtnIndex = 0;
    _headerBtns.spotColor = [UIColor redColor];
    MJWeakSelf
    [_headerBtns setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        
        weakSelf.isManuChangeType = YES;
        [weakSelf.bigScrollView setContentOffset:CGPointMake(index * mScreenWidth, 0) animated:YES];
        [weakSelf changeRightNavItemStatusWithIndex:index];
    }];
    [self.view addSubview:_headerBtns];
}

#pragma mark -- 获取附近的人网络请求
- (void)loadGetNearPeople {
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"lng"] = @(_lng.doubleValue);
    params[@"lat"] = @(_lat.doubleValue);
    params[@"sessionid"] = self.sessionid;
    [TZHttpTool postWithURL:ApiSnsGetNearInfo params:params success:^(NSDictionary *result) {
        self.getpeopleArr = [NearPeople mj_objectArrayWithKeyValuesArray:result[@"data"][@"nearPeople"]];
        [TZUserManager syncUserNearPeoplesWithPeoples:result[@"data"][@"nearPeople"]];
        NSInteger count = self.getpeopleArr.count > 4 ? 4 : self.getpeopleArr.count;
        if (self.peopleAvatars.count || self.peopleNicknames.count) {
            [self.peopleNicknames removeAllObjects];
            [self.peopleAvatars removeAllObjects];
            [self.peopleAges removeAllObjects];
            [self.peopleGenders removeAllObjects];
        }
        for (int i = 0; i < count; i++) {
            NearPeople *model = self.getpeopleArr[i];
            [self.peopleAvatars addObject:model.avatar];
            [self.peopleNicknames addObject:model.nickname];
            [self.peopleAges addObject:model.age];
            [self.peopleGenders addObject:model.gender];
        }
        self.getgroupArr = [XYGroupInfoModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"nearGroup"]];
        [TZUserManager syncRecommendGroupWithGroup:result[@"data"][@"nearGroup"] tag:1];
        NSInteger groupCount = self.getgroupArr.count > 4 ? 4 : self.getgroupArr.count;
        if (self.groupNames.count || self.groupAvatars.count) {
            [self.groupNames removeAllObjects];
            [self.groupAvatars removeAllObjects];
        }
        for (int i = 0; i < groupCount; i++) {
            XYGroupInfoModel *model = self.getgroupArr[i];
            [self.groupAvatars addObject:model.avatar];
            [self.groupNames addObject:model.owner];
        }
        _loadNear = YES;
        [self.tableView5 reloadData];
        [self.tableView5 endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView5 endRefresh];
    }];
}

-(void)loadGetRecommendGroupsNetWork {
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"lng"] = @(_lng.doubleValue);
    params[@"lat"] = @(_lat.doubleValue);
    params[@"sessionid"] = self.sessionid;
    [TZHttpTool postWithURL:ApiSnsGetRecommendGroups params:params success:^(NSDictionary *result) {
        self.getNearArray = [XYGroupInfoModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        [TZUserManager syncRecommendGroupWithGroup:result[@"data"] tag:2];
        [self.tableView5 reloadData];
        [self.tableView5 endRefresh];
        _loadNear = YES;
    } failure:^(NSString *msg) {
        [self.tableView5 endUpdates];
    }];
}


- (void)configBigScrollView {
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, mScreenWidth, mScreenHeight - 64 - 40 - 49)];
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.delegate = self;
    self.bigScrollView.contentSize = CGSizeMake(mScreenWidth * 5, 0);
    [self.view addSubview:_bigScrollView];
    
    [self.tableView1 class];
    [self.tableView1 loadViewDataWithIndex:0];
    [self.tableView2 class];
    [self.tableView3 class];
    [self.tableView4 class];
    [self.tableView5 class];
}

- (void)configPublicBtn {
    _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _publishBtn.hidden = YES;
    CGFloat publishBtnX = mScreenWidth - 10 - 60;
    CGFloat publishBtnY = mScreenHeight - 64 - 49 - 30 - 50;
    _publishBtn.frame = CGRectMake(publishBtnX, publishBtnY , 60, 60);
    [_publishBtn setBackgroundImage:[UIImage imageNamed:@"public"] forState:0];
    [[_publishBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (![TZUserManager isLogin]) return;
        TZSnsCreateController *vc = [[TZSnsCreateController alloc] init];
        vc.titleText = @"发布新帖";
        vc.index = 3;
        vc.iShow = YES;
        
        vc.refreshModel = ^() {
            switch (_selectedIndex) {
                    
                case 1:
                    [self.tableView2 loadNetworkData];
                    
                    break;
                case 2:
                    [self.tableView3 loadNetworkData];
                    
                    break;
                case 3:
                    [self.tableView4 loadGetSameTown];
                    
                    break;
                    
                default:
                    break;
            }
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:_publishBtn];
}

#pragma mark - UITableViewDatasource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.getNearArray.count +1;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 40;
        } else {
            return 110;
        }
    } else {
        if (indexPath.row == 0) {
            return 40;
        } else {
            return 110;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        cell.imageView.image = [UIImage imageNamed:@[@"fujin_ren",@"fujin_qun",@"tuijian_qun"][indexPath.section]];
        cell.textLabel.text = @[@"附近的人",@"附近的群",@"推荐群组"][indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addBottomSeperatorViewWithHeight:1];
        return cell;
    } else {
        if (indexPath.section == 2) {
            XYGroupCell *groupCell = [tableView dequeueReusableCellWithIdentifier:@"XYGroupCell"];
            [groupCell addBottomSeperatorViewWithHeight:1];
            XYGroupInfoModel * model = self.getNearArray[indexPath.row - 1];
            groupCell.groupInfoModel = model;
            groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return groupCell;
        } else {
            XYNearCell *nearCell = [tableView dequeueReusableCellWithIdentifier:@"XYNearCell"];
            nearCell.fontSize = 14;
            if (indexPath.section == 0) {
                MJWeakSelf;
                [nearCell setXYNearCellViewBlock:^(NSInteger tag) {
                    if (![TZUserManager isLogin]) return;
                    NearPeople * peopleModel = weakSelf.getpeopleArr[tag];
                    NSString * username = peopleModel.username;
                    [weakSelf pushICESelfInfoViewControllerWithType:ICESelfInfoViewControllerTypeOther tag:tag username:username nickName:peopleModel.nickname];
                }];
                [nearCell configButtonWithImages:self.peopleAvatars titles:self.peopleNicknames ages:self.peopleAges gender:self.peopleGenders];
            } else {
                nearCell.hideSexBtn = YES;
                nearCell.imgViewY = 3;
                nearCell.imgCornerRadius = 7;
                MJWeakSelf;
                [nearCell setXYNearCellViewBlock:^(NSInteger tag) {
                    if (![TZUserManager isLogin]) return;
                    XYGroupInfoModel * groupModel = weakSelf.getgroupArr[tag];
                    XYGroupInfoViewController *groupInfoVC = [[XYGroupInfoViewController alloc] initWithGroupId:groupModel.group_id];
                    groupInfoVC.titleText = groupModel.owner;
                    groupInfoVC.gid = groupModel.gid;
//                    groupInfoVC.model = groupModel;
                    [self.navigationController pushViewController:groupInfoVC animated:YES];
                }];
                [nearCell configButtonWithImages:self.groupAvatars titles:self.groupNames ages:@[@"1",@"1",@"1",@"1"] gender:@[@"",@"",@"",@""]];
            }
            nearCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return nearCell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self pushNearViewControllerWithType:XYNearViewControllerTypeNearPeople title:@"附近的人"];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [self pushNearViewControllerWithType:XYNearViewControllerTypeNearGroup title:@"附近的群"];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [self pushNearViewControllerWithType:XYNearViewControllerTypeRecommendGroup title:@"推荐群组"];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        } else {
            if (![TZUserManager isLogin]) return;
            getRecommendGroup * model = self.getNearArray[indexPath.row-1];
            XYGroupInfoViewController *groupInfoVC = [[XYGroupInfoViewController alloc] initWithGroupId:model.group_id];
            groupInfoVC.titleText = model.owner;
            groupInfoVC.gid = model.gid;
            groupInfoVC.model = model;
//            NSDictionary *dict = [[[EaseMob sharedInstance] chatManager] loginInfo];
//            if ([dict[kSDKUsername] isEqualToString:model.grouper]) {
//                groupInfoVC.occupantType = XYGroupOccupantTypeOwner;
//            } else {
//                groupInfoVC.occupantType = XYGroupOccupantTypeJoin;
//            }
            [self.navigationController pushViewController:groupInfoVC animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}
#pragma mark -- 点击附近的人 视图跳转到个人信息主页
- (void)pushICESelfInfoViewControllerWithType:(ICESelfInfoViewControllerType)type tag:(NSInteger)tag username:(NSString *)username nickName:(NSString *)nickName{
    if (![TZUserManager isLogin]) return;
    ICESelfInfoViewController * vc = [[ICESelfInfoViewController alloc]init];
    vc.type = ICESelfInfoViewControllerTypeOther;
    vc.otherUsername = username;
    vc.nickName = nickName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushNearViewControllerWithType:(XYNearViewControllerType)type title:(NSString *)title{
    if (![TZUserManager isLogin]) return;
    XYNearViewController *nearVc = [[XYNearViewController alloc] init];
    nearVc.type = type;
    nearVc.titleText = title;
    [self.navigationController pushViewController:nearVc animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.bigScrollView) {
        return;
    }
    
    _isScroll = YES;
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / mScreenWidth + 0.5;
    _headerBtns.selectBtnIndex = index;
    if (index < 4) { //动态,美拍,广场,老乡
        if (index != 3) {
            TZFindSnsTableView *tableView = [self.view viewWithTag:index + 2000];
            [tableView loadViewDataWithIndex:index];
        } else {
            [self jugeHaveSetupHometown];
        }
        if (index == 2) {
            _publishBtn.hidden = NO;
        } else {
            _publishBtn.hidden = YES;
        }
    } else { //附近
        [self getKeyedArchiveData];
    }
    if (![TZUserManager isLoginNoPresent] && index != 3) {
        self.clickIndex = index;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _isScroll = YES;
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / mScreenWidth + 0.5;
    if (offsetX) {
        _headerBtns.selectBtnIndex = index;
    }
    if (index < 4) { //动态,美拍,广场,老乡
        if (index != 3) {
            TZFindSnsTableView *tableView = [self.view viewWithTag:index + 2000];
            [tableView loadViewDataWithIndex:index];
        } else {
            [self jugeHaveSetupHometown];
        }
        if (index == 2) {
            _publishBtn.hidden = NO;
        } else {
            _publishBtn.hidden = YES;
        }
    } else { //附近
        [self getKeyedArchiveData];
    }
    if (![TZUserManager isLoginNoPresent] && index != 3) {
        self.clickIndex = index;
    }
    _selectedIndex = index;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isManuChangeType = NO;
}

- (BOOL)jugeHaveSetupHometown {
    if (![TZUserManager isLogin]) {
        self.needMonitor = YES;
        self.tableView4.needRefresh = NO;
        self.isManuChangeType = NO;
        [self.bigScrollView setContentOffset:CGPointMake(mScreenWidth * self.clickIndex, 0)];
        _headerBtns.selectBtnIndex = self.clickIndex;
        return NO;
    }
    
    [self.bigScrollView setContentOffset:CGPointMake(3 * mScreenWidth, 0)];
    _headerBtns.selectBtnIndex = 3;
    self.tableView4.needRefresh = YES;
    TZFindSnsTableView *tableView = [self.view viewWithTag:3 + 2000];
    [tableView loadViewDataWithIndex:3];

    XYUserInfoModel *model = [TZUserManager getUserModel];
    if (model.hometown == nil || model.hometown.length < 1) {
        MJWeakSelf
        [self showAlertViewWithTitle:@"提示" message:@"未设置故乡，是否设置故乡？" okBtnHandle:^{
            XYEditUserViewController *editVc = [[XYEditUserViewController alloc] init];
            editVc.model = model;
            [weakSelf.navigationController pushViewController:editVc animated:YES];
        }];
        
    } else {
        if (!_isScroll) {
             TZSnsCreateController *vc = [TZSnsCreateController new];
            vc.titleText = self.snsVcTitle;
            MJWeakSelf
            __weak TZSnsCreateController *weak_vc = vc;
            [vc setRefreshModel:^{
                TZFindSnsTableView *tableView = [weakSelf.view viewWithTag:2000 + weak_vc.index];
                tableView.needRefresh = YES;
                [tableView loadViewDataWithIndex:weak_vc.index];
                if (weak_vc.index == 3) {
                    TZFindSnsTableView *tableView4 = [weakSelf.view viewWithTag:2000 + weak_vc.index + 1];
                    tableView4.needRefresh = YES;
                    [tableView4 loadViewDataWithIndex:weak_vc.index];
                }
            }];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    return YES;
}

#pragma mark - private

- (void)changeRightNavItemStatusWithIndex:(NSInteger)index {
    
    if (index == 0) {
        NSString  * rid = [mUserDefaults objectForKey:@"rid"];
        if ([rid isEqualToString:@"7"] || [rid isEqualToString:@"18"]) {
            self.rightNavImageName = @"camera";
            self.snsVcTitle = @"动态";
        }else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    } else if (index == 1) {
        self.rightNavImageName = @"camera";
        self.snsVcTitle = @"自拍美拍";
    }else if (index == 2) {
        self.rightNavImageName = @"camera";
        self.snsVcTitle = @"广场";
    } else if (index == 3) {
        self.rightNavImageName = @"camera";
        self.snsVcTitle = @"老乡";
    } else  if (index == 4) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)didClickRightNavAction {
    if ([TZUserManager isLogin]) {
        
        if (_selectedIndex == 3) {
            XYUserInfoModel *model = [TZUserManager getUserModel];
            if (model.hometown == nil || model.hometown.length < 1) {
                MJWeakSelf
                [self showAlertViewWithTitle:@"提示" message:@"未设置故乡，是否设置故乡？" okBtnHandle:^{
                    XYEditUserViewController *editVc = [[XYEditUserViewController alloc] init];
                    editVc.model = model;
                    [weakSelf.navigationController pushViewController:editVc animated:YES];
                }];
                return;
            }
        }
        
        TZSnsCreateController *vc = [TZSnsCreateController new];
        vc.titleText = self.snsVcTitle;
        [vc setRefreshModel:^{
//            TZFindSnsTableView *tableView = [self.view viewWithTag:2000 + vc.index];
//            tableView.needRefresh = YES;
//            [tableView loadViewDataWithIndex:vc.index];
//            if (vc.index == 3) {
//                TZFindSnsTableView *tableView4 = [self.view viewWithTag:2000 + vc.index + 1];
//                tableView4.needRefresh = YES;
//                [tableView4 loadViewDataWithIndex:vc.index];
//            }
            
            switch (_selectedIndex) {
                    
                case 1:
                    [self.tableView2 loadNetworkData];
                    
                    break;
                case 2:
                    [self.tableView3 loadNetworkData];
                    
                    break;
                case 3:
                    [self.tableView4 loadGetSameTown];
                    
                    break;
                    
                default:
                    break;
            }
            
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Get
- (TZFindSnsTableView *)tableView1 {
    if (!_tableView1) {
        _tableView1 = [self getTableViewWithIndex:0];
    }
    return _tableView1;
}

- (TZFindSnsTableView *)tableView2 {
    if (!_tableView2) {
        _tableView2 = [self getTableViewWithIndex:1];
    }
    return _tableView2;
}

- (TZFindSnsTableView *)tableView3 {
    if (!_tableView3) {
        _tableView3 = [self getTableViewWithIndex:2];
    }
    return _tableView3;
}

- (TZFindSnsTableView *)tableView4 {
    if (!_tableView4) {
        _tableView4 = [self getTableViewWithIndex:3];
    }
    return _tableView4;
}

- (UITableView *)tableView5 {
    if (!_tableView5) {
        _tableView5 = [[UITableView alloc] initWithFrame:CGRectMake(4 * mScreenWidth, 0, mScreenWidth, _bigScrollView.height) style:UITableViewStylePlain];
        _tableView5.dataSource = self;
        _tableView5.delegate = self;
        _tableView5.backgroundColor = TZControllerBgColor;
        _tableView5.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView5WithHeader)];
        _tableView5.mj_header = header;
        [_tableView5 registerCellByClassName:@"XYNearCell"];
        [_tableView5 registerCellByClassName:@"UITableViewCell"];
        [_tableView5 registerCellByNibName:@"XYGroupCell"];
        [_bigScrollView addSubview:_tableView5];
    }
    return _tableView5;
}

- (TZFindSnsTableView *)getTableViewWithIndex:(NSInteger)index {
    TZFindSnsTableView *tableView = [[TZFindSnsTableView alloc] initWithFrame:CGRectMake(index * mScreenWidth , 0, mScreenWidth, _bigScrollView.height) style:UITableViewStylePlain];
    tableView.index = index;
    tableView.tag = index + 2000;
    tableView.delegate = tableView;
    tableView.dataSource = tableView;
    tableView.tz_delegate = self;
    tableView.needRefresh = YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bigScrollView addSubview:tableView];
    return tableView;
}

- (void)refreshTableView5WithHeader {
    [self loadGetNearPeople];
    [self loadGetRecommendGroupsNetWork];
}

@end
