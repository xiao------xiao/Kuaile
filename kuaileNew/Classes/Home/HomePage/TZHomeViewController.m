//
//  TZHomeViewController.m
//  HappyWork
//
//  Created by liujingyi on 15/9/10.
//  Copyright (c) 2015年 memberwine. All rights reserved.
//

#import "TZHomeViewController.h"
#import "TZNaviBarView.h"
#import "TZFullTimeJobViewController.h"
#import "LFindLocationViewController.h"
#import "SYQRCodeViewController.h"
#import "ZJQRController.h"
#import "TZJobListCell.h"
#import "TZJobDetailViewController.h"
#import "TZJobModel.h"
#import "TZJobListViewController.h"
#import "SDCycleScrollView.h"
#import "TZSearchViewController.h"
#import "MJRefresh.h"
#import "ICEModelAds.h"
#import "TZJobListScreeningView.h"
#import "TZScreeningViewController.h"

#import "ICELiveServeViewController.h"          // 生活服务
#import "ICETimeLimitBuyViewController.h"       // 限时抢购

#import "ICELocationManager.h"
#import "EAIntroView.h" // 引导页

#import "JZLocationConverter.h"
#import "ICELocationManagerNEW.h"

#import "LocationDemoViewController.h"
#import "ICEForgetViewController.h"
#import "XYSignViewController.h"
#import "XYSignHomeViewController.h"
#import "ZYHomeViewController.h"
@interface TZHomeViewController ()<LFindLocationViewControllerDelegete,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate, EAIntroDelegate, ICELocationManagerDelegate,TZJobListScreeningViewDelegate>
@property (strong, nonatomic) SDCycleScrollView * cycleScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *bigScrollView;
/** 顶部轮播图 */
@property (strong, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (nonatomic, strong) TZNaviBarView *naviBar;
// 今日高薪相关
@property (weak, nonatomic) IBOutlet UILabel *noHighSalaryJobLable;
@property (weak, nonatomic) IBOutlet UIView *entertainmentView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *jobs;
@property (nonatomic, assign) NSInteger pageSearch; // 分页  后台：第一页传1  搜索时的分页
@property (nonatomic, assign) BOOL isSearch;        // 正在搜索
@property (nonatomic, assign) NSInteger totalCount; // 总页数
/** 2015.11.10更新 记录是否从热门职位跳转而来 */
@property (nonatomic, assign) BOOL isFromHotJob;
/** 新参数，职位分类的id */
@property (nonatomic, copy) NSString *laid;
@property (nonatomic, copy) NSString *jobTitle;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *highSalaryViewHeightContraint;
@property (nonatomic, strong) NSArray *imagesURLStrings;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSNumber *totoal;



@property (weak, nonatomic) IBOutlet UIView *stuateScreenView;// 状态筛选栏
@property (nonatomic,strong) TZJobListScreeningView * screenView;

@property (strong,nonatomic) UITableView * screeningTabelView;
@property (strong,nonatomic) UIButton * screeningcover;
/** 记录当前选择的是筛选bar的哪个按钮 */
@property (nonatomic, assign) NSInteger upTheMoreView;

/** 用户当前的城市 */
@property (nonatomic, strong) NSString *currentCity;

/** 用户选中的筛选信息 */
@property (nonatomic, strong) NSMutableArray *userSelected;
/** 筛选控制器返回的筛选数组 */
@property (nonatomic, strong) NSDictionary *filterResultDic;
@property (nonatomic, assign) BOOL isHotJobType; // 是否是在筛选热门职位 参数名为class 否则为laid

/** 筛选工具条相关 */
@property (nonatomic, strong) NSArray *welfares; //福利
@property (nonatomic, strong) NSArray *salarys; //薪资
@property (nonatomic, strong) NSArray *areas;        // 区级
@property (nonatomic, strong) NSMutableArray *detail_areas; // 镇级
@property (nonatomic, strong) NSArray *isShowingArray;// 筛选tableView正在显示的数据源

@end

@implementation TZHomeViewController


#pragma mark -- 显示筛选的第一个tableView
-(UITableView *)screeningTabelView {
    
    if (_screeningTabelView == nil) {
        _screeningTabelView = [[UITableView alloc] init];
        _screeningTabelView.delegate = self;
        _screeningTabelView.dataSource = self;
        _screeningTabelView.frame = CGRectMake(0, 44, __kScreenWidth, 0);
    }
    return _screeningTabelView;
}
-(UIButton *)screeningcover {
    if (_screeningcover== nil) {
        _screeningcover = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, __kScreenWidth, 0)];
        [_screeningcover setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.4]];
        [_screeningcover addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screeningcover;
}

- (void)coverButtonClick:(UIButton *)cover {
    [UIView animateWithDuration:0.1 animations:^{
        self.screeningTabelView.height = 0;
        self.screeningcover.height = 0;
    }];
    self.screenView.hideTipsView = YES;
    self.screenView.downMoreView = YES;
}
#pragma mark -- 获取福利列表
- (void)loadNetAllWelfares {
    [TZHttpTool postWithURL:ApiAllWelfares params:nil success:^(id json) {
        NSArray *array = json[@"data"];
        NSMutableArray *welfares = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            [welfares addObject:dict[@"title"]];
        }
        [welfares insertObject:@"不限" atIndex:0];
        self.welfares = welfares;
    } failure:^(NSString *error) {
        DLog(@"获取全部福利列表 失败");
    }];
}
- (void)configTableViewDataSource {
    self.detail_areas = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"全%@", [mUserDefaults objectForKey:@"userCity"]]];
    self.jobs = [NSMutableArray array];
    self.welfares = @[@"不限"];
    self.salarys = @[@"不限",@"面议",@"2000元/月以下",@"2001-3000元/月",@"3001-5000元/月",@"5001-8000元/月",@"8001-10000元/月",@"10001-15000元/月",@"15001-25000元/月",@"25001元/月以上"];
    self.isShowingArray = [[NSArray alloc] init];
    self.currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"];
    self.userSelected = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0]];
//    self.recruit_ids = [[NSMutableArray alloc] init];
    self.areas =  [TZCitisManager getCitis];
}

+ (void)load {
    NSString *userCity = [mUserDefaults objectForKey:@"userCity"];
    if (userCity == nil || [userCity isEqualToString:@""] || userCity.length < 1) {
        [mUserDefaults setObject:@"无锡" forKey:@"userCity"];
        [mUserDefaults synchronize];
    }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    return self;
}



- (void)updateTableViewContraint {
    if (self.jobs.count == 0) { // 重置
        NSInteger height = 545 + 114;
        if (__kScreenWidth <= 320) {
            height += 20;
        }
        self.bigScrollView.contentSize = CGSizeMake(0,  height);
        self.highSalaryViewHeightContraint.constant = 114 + 20;
        self.tableViewHeightContraint.constant = 84;
        self.noHighSalaryJobLable.hidden = NO;
        self.tableView.contentSize = CGSizeMake(0, 0);
    } else {
        NSInteger cellTotalHeight = 0;
        for (int i = 0; i < _jobs.count; i ++) {
            TZJobModel *model = _jobs[i];
            if ([model.fan isEqualToString:@"1"]) {
                cellTotalHeight += 181;  //有福利
            } else {
                cellTotalHeight += 133;    //没有福利一行
            }
        }
        self.tableViewHeightContraint.constant = cellTotalHeight;
        self.tableView.contentSize = CGSizeMake(0, cellTotalHeight);
        NSInteger height = 560 + cellTotalHeight;
        if (__kScreenWidth <= 320) {
            height += 20;
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.bigScrollView.contentSize = CGSizeMake(0, height);
        self.highSalaryViewHeightContraint.constant = cellTotalHeight + 10;
        self.noHighSalaryJobLable.hidden = YES;
    }
   
    [self.bigScrollView.footer endRefreshing];
    [self.bigScrollView.header endRefreshing];
    self.bigScrollView.backgroundColor  = [UIColor redColor];
    [self.tableView reloadData];
}



- (void)refreshDataWithHeader {
    [self loadHotJobs];
    [self configAdPageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.screenView = [[TZJobListScreeningView alloc]init];
//    _screenView.frame = CGRectMake(0, 0, __kScreenWidth, 44);
//    _screenView.autoresizesSubviews = NO;
//    self.screenView.delegate = self;
//    [self.stuateScreenView addSubview:self.screenView];
//    [self.stuateScreenView addSubview:self.screeningcover];
    
    
    _jobs = [NSMutableArray array];
    [self.stuateScreenView addSubview:self.screeningTabelView];
    
    
    [self configTableViewDataSource];
    
    // 获取福利列表
    [self loadNetAllWelfares];
    
    [self checkShowIntroducePage];
    self.page = 1;
    [self refreshDataWithHeader];
    
    [self updateViewConstraints];
    [self configTZNaviBarView];
    [self configRecreationalActivitiesView];
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // 1.取定位城市
    [self upDateCurrentCityUI:[[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"]];
    // 2.成功定位后的通知，更新成定位城市
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateToLocation) name:@"didUpdateToLocation" object:nil];
    // 3.配置上下拉刷新
    MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadRecruitList)];
    self.bigScrollView.footer = footer;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithHeader)];
    self.bigScrollView.header = header;
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.bigScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    
}

- (void)configTZNaviBarView {
    _naviBar = [[TZNaviBarView alloc] init];
    _naviBar.frame = CGRectMake(0, 0, __kScreenWidth, 64);
    [self.view addSubview:_naviBar];
    
    
    
    
    [[_naviBar.btnCity rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        LFindLocationViewController *cityChooseVc = [[LFindLocationViewController alloc] init];
        cityChooseVc.delegete = self;
        cityChooseVc.loctionCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"];
        [self.navigationController pushViewController:cityChooseVc animated:YES];
    }];
    
    // 扫描二维码
    [[_naviBar.btnScan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self codeScan];
    }];
    
    [[_naviBar.btnSearch rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        TZSearchViewController *searchVc = [[TZSearchViewController alloc] initWithNibName:@"TZSearchViewController" bundle:nil];
//        [self.navigationController pushViewController:searchVc animated:YES];
        TZFullTimeJobViewController *full_timeVc = [[TZFullTimeJobViewController alloc] initWithNibName:@"TZFullTimeJobViewController" bundle:nil];
        full_timeVc.type = TZFullTimeJobViewControllerNormal;
        [self.navigationController pushViewController:full_timeVc animated:YES];
        
    }];
}

/** 休闲娱乐模块 */
- (void)configRecreationalActivitiesView {
    [[self.btnLiveServe rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        ICELiveServeViewController *iCELiveServe = [[ICELiveServeViewController alloc] initWithNibName:@"ICELiveServeViewController" bundle:[NSBundle mainBundle]];
        
        self.tabBarController.selectedIndex = 2;
        //创建通知
          NSNotification * notification = [NSNotification notificationWithName:@"navigationDidClick" object:nil userInfo:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });
    }];
    [[self.btnTimeLimitBuy rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([TZUserManager isLogin]) {
            ICETimeLimitBuyViewController *iCETimeLimit = [[ICETimeLimitBuyViewController alloc] initWithNibName:@"ICETimeLimitBuyViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:iCETimeLimit animated:YES];
        }
    }];
    [[self.btnSignInGifts rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([TZUserManager isLogin]) {
//            XYSignViewController * vc = [[XYSignViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
            XYSignHomeViewController *signHomeVc = [[XYSignHomeViewController alloc] init];
            [self.navigationController pushViewController:signHomeVc animated:YES];
            
//            ICELoginUserModel *user = [ICELoginUserModel sharedInstance];
//            if ([user.rid isEqualToString:@"8"]) {
//                [self mySignInGiftsWithParams:@"" lat:@"" lng:@""];
//            } else {
//                [self baiduLocation];
//            }
        }
    }];
    [[self.btnLotteryActivity rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([TZUserManager isLogin]) {
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            NSString *strURL = [NSString stringWithFormat:@"%@%@", ApiAward, userModel.uid];
            [self pushWebVcWithUrl:strURL title:@"抽奖活动"];
        }
    }];
}

/** 配置这个页面特有的naviBar */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNumber *isAnimated = [mUserDefaults objectForKey:@"isAnimated"];
    if (isAnimated.integerValue == 1) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSNumber *isAnimated = @(1);
    if (self.navigationController.childViewControllers.count < 2) {
        isAnimated = @(0);
    }
    [mUserDefaults setObject:isAnimated forKey:@"isAnimated"];
    [mUserDefaults synchronize];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _cycleScrollView.frame = self.topScrollView.bounds;
}

#pragma mark - UIScrollViewDelegate

// 让导航条也跟着scrollView滑
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.bigScrollView) {
        // 1.让导航条背景色的透明度变化 130是范围 越大渐变越慢
        CGPoint offSet = scrollView.contentOffset;
        CGFloat alpha = 0;
        alpha = (offSet.y) / 130;
        self.naviBar.bgColorView.alpha = alpha;
    }
}

#pragma mark - tableView的数据源/代理方法

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"jobList_cell";
    static NSString * stautsCell = @"Cell";
    
    if (tableView == self.tableView) {
        TZJobListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[TZJobListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.model = self.jobs[indexPath.row];
        cell.type = TZJobListCellTypeHighSalary;
        [cell addSubview:[UIView divideViewWithHeight:cell.height]];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stautsCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stautsCell];
        }
        cell.textLabel.text = self.isShowingArray[indexPath.row];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        return self.jobs.count;
    } else if (tableView == _screeningTabelView) {
        return self.isShowingArray.count;
    } else {
        return self.detail_areas.count;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        // 跳转到详情控制器
        TZJobDetailViewController *detailVc = [[TZJobDetailViewController alloc] initWithNibName:@"TZJobDetailViewController" bundle:nil];
        TZJobModel *model = self.jobs[indexPath.row];
        detailVc.recruit_id = model.recruit_id;
        detailVc.fanXian = model.fan;
        [self.navigationController pushViewController:detailVc animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    } else if (tableView == self.screeningTabelView) {
        
        [self updateUserSelectedArray:indexPath]; // 根据indexPath更新用户选择的筛选信息
            // 选择不限或者全北京等cell时
            NSString *cellTitle = self.isShowingArray[indexPath.row];
            if ([cellTitle isEqualToString:@"不限"]) {
                if ([self.isShowingArray isEqual:self.salarys]) {
                    [self.screenView.salaryBtn setTitle:@"薪资" forState:UIControlStateNormal];
                } else if ([self.isShowingArray isEqual:self.welfares]) {
                    [self.screenView.welfareBtn setTitle:@"福利" forState:UIControlStateNormal];
                }
            } else if ([cellTitle hasPrefix:@"全"]) {
                [self.screenView.areaBtn setTitle:@"区域" forState:UIControlStateNormal];
            } else {
                // 其他情况
                if ([self.isShowingArray isEqual:[TZCitisManager getCitis]]) {
                    [self.screenView.areaBtn setTitle:cellTitle forState:UIControlStateNormal];
                } else if ([self.isShowingArray isEqual:self.salarys]) {
                    [self.screenView.salaryBtn setTitle:cellTitle forState:UIControlStateNormal];
                } else if ([self.isShowingArray isEqual:self.welfares]) {
                    [self.screenView.welfareBtn setTitle:cellTitle forState:UIControlStateNormal];
                }
            }
            
            // 如果当前点击的筛选bar的按钮不是"区域"
            if (self.upTheMoreView != 1) { // 1 区域
                [self animToHideTableView];
                // 去搜索对应筛选条件的职位
                [self filterJobList];
            } else {  // 如果是区域。根据选择的城市，刷新detail_area.选择新的数据源
//                 [self updateDetails_areas:cellTitle];
                // 11.19以前 上面一句代码
                // 11.19以后 下面两句代码
                [self animToHideTableView];
                [self filterJobList];
            }
        } else {
            [self.userSelected replaceObjectAtIndex:1 withObject:@(indexPath.row)];
            [self animToHideTableView];
            self.screenView.downMoreView = YES;
            // 去搜索对应筛选条件的职位
            [self filterJobList];
        }
}

#pragma mark 其他方法

/** 根据indexPath更新用户选择的筛选信息 */
- (void)updateUserSelectedArray:(NSIndexPath *)indexPath {
    switch (self.upTheMoreView) {
        case 1:
            [self.userSelected replaceObjectAtIndex:0 withObject:@(indexPath.row)];
            break;
        case 2:
            [self.userSelected replaceObjectAtIndex:2 withObject:@(indexPath.row)];
            break;
        case 3:
            [self.userSelected replaceObjectAtIndex:3 withObject:@(indexPath.row)];
            break;
        default:
            break;
    }
}
/** 动画隐藏tableView */
- (void)animToHideTableView {
    [UIView animateWithDuration:0.1 animations:^{
        self.screeningTabelView.height = 0;
        self.screeningcover.height = 0;
    }];
    self.screenView.hideTipsView = YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        TZJobModel *model = self.jobs[indexPath.row];
        CGFloat cellH;
        
        if ([model.fan isEqualToString:@"1"]) {
            cellH = 181;
        } else {
            cellH = 133;
        }
        if (tableView == self.tableView) {
            if (self.type == TZHomeViewControllerTypeHistory) {
                return cellH + 55;
            } else {
                return cellH;
            }
        }
    }else {
        return 35;
    }
    return 0;
}

#pragma mark - LFindLocationViewControllerDelegete 城市选择
- (void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation {
    // 1.储存选择的城市 && 2.更新UI
    [self upDateCurrentCityUI:city];
    // 3.刷新今日高薪职位列表
    [self loadHotJobs];
}

- (void)upDateCurrentCityUI:(NSString *)city {
    // 若city为空 做一些操作
    if (city == nil || [city isEqualToString:@""] || city.length < 1) {
        city = @"无锡";
    }
    [mUserDefaults setObject:city forKey:@"userCity"];
    [mUserDefaults synchronize];
    
    [_naviBar.btnCity setTitle:city forState:UIControlStateNormal];
    NSInteger width = 67;
    NSInteger left = 50;
    if (city.length == 3) {
        width = 84;
        left = 67;
    } else if (city.length >= 4) {
        left = 89;
        width = 106;
    }
   [_screenView.areaBtn setTitle:city forState:UIControlStateNormal];
    _naviBar.btnCity.imageEdgeInsets = UIEdgeInsetsMake(0, left, 0, 0);
    _naviBar.btnCityWidthContraint.constant = width;
    // 更新约束
    [self updateTableViewContraint];
}

// 定位成功后调用
- (void)didUpdateToLocation {
//    DLog(@"当前经度:%@,维度:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]);
    [self upDateCurrentCityUI:[mUserDefaults objectForKey:@"userCity"]];
}

#pragma mark - 按钮点击

/** 按钮点击 */
- (IBAction)buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1: { // 全职工作
            TZFullTimeJobViewController *full_timeVc = [[TZFullTimeJobViewController alloc] initWithNibName:@"TZFullTimeJobViewController" bundle:nil];
            full_timeVc.type = TZFullTimeJobViewControllerNormal;
            [self.navigationController pushViewController:full_timeVc animated:YES];
        }  break;
        case 2:  { // 放心企业
            [self pushToJobListVcWithType:TZJobListViewControllerTypeRelievedCompany title:@"放心企业"];
        }  break;
        case 3:  { // 附近工作
            TZJobListViewController *jobListVc = [[TZJobListViewController alloc] initWithNibName:@"TZJobListViewController" bundle:nil];
            jobListVc.type = TZJobListViewControllerTypeNearbyJob;
            jobListVc.jobTitle = @"附近工作";
            [self.navigationController pushViewController:jobListVc animated:YES];
        }  break;
        case 4:  { // 兼职工作
            [self pushToJobListVcWithType:TZJobListViewControllerTypePartTimeJob title:@"兼职工作"];
        }  break;
        case 5:  { // 入职返现
            [self pushToJobListVcWithType:TZJobListViewControllerTypeReturnMoney title:@"入职返现"];
        }  break;
        case 6:  { // 包吃包住
            [self pushToJobListVcWithType:TZJobListViewControllerTypeEatJob title:@"包吃包住"];
        }  break;
        case 7:  { // 校园招聘
            [self pushToJobListVcWithType:TZJobListViewControllerTypeSchoolJob title:@"校园招聘"];
        }  break;
        case 8:  { // 海外招聘
            [self pushToJobListVcWithType:TZJobListViewControllerTypeOverseasJob title:@"海外招聘"];
        }  break;
        default:  break;
    }
}
#pragma mark -- 状态筛选视图框
- (void)screeningView:(TZJobListScreeningView *)screeningView didClickButtonType:(TZScreeningViewButtonType)type {
    // 配置UI，设置数据源
    BOOL isBtnClick;
    switch (type) {
        case TZScreeningViewButtonTypeArea: // 区域
            isBtnClick = [self.isShowingArray isEqual:[TZCitisManager getCitis]];
            self.upTheMoreView = 1;
            self.isShowingArray = [TZCitisManager getCitis];
            break;
        case TZScreeningViewButtonTypeSalary: // 薪水
            isBtnClick = [self.isShowingArray isEqual:self.salarys];
            self.upTheMoreView = 2;
            self.isShowingArray = self.salarys;
            break;
        case TZScreeningViewButtonTypeWelfare: // 福利
            isBtnClick = [self.isShowingArray isEqual:self.welfares];
            self.upTheMoreView = 3;
            self.isShowingArray = self.welfares;
            break;
        case TZScreeningViewButtonTypeScreening: // 筛选
            [self screeningViewControll];return;
            break;
        default:
            break;
    }
    [self.screeningTabelView reloadData];
    self.screenView.downMoreView = YES;
    
    // 动画形式展现出来/缩放回去，并记录用户的选中筛选属性
    [UIView animateWithDuration:0.25 animations:^{
        if (self.screeningcover.height == __kScreenHeight - 108 && isBtnClick == YES) {
            self.screeningTabelView.height = 0;
            self.screeningcover.height = 0;
            self.screenView.downMoreView = YES;
        } else {
            self.screeningTabelView.height = self.isShowingArray.count * 35 > __kScreenHeight - 200 ? __kScreenHeight - 200 : self.isShowingArray.count * 35;
            self.screeningcover.height = __kScreenHeight - 108;
            NSNumber *number = [[NSNumber alloc] init];
            switch (self.upTheMoreView) {
                case 1:
                    self.screenView.upAreaMoreView = YES;
                    number = self.userSelected[0];
                    break;
                case 2:
                    self.screenView.upSalaryMoreView = YES;
                    number = self.userSelected[2];
                    break;
                case 3:
                    self.screenView.upWelfareMoreView = YES;
                    number = self.userSelected[3];
                    break;
                default:
                    break;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:number.integerValue inSection:0];
            [self.screeningTabelView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }];
}
#pragma mark -- 筛选按钮点击事件
-(void)screeningViewControll {
    
    TZScreeningViewController *screeningVc = [[TZScreeningViewController alloc] initWithNibName:@"TZScreeningViewController" bundle:nil];
    screeningVc.jobTitle = self.jobTitle;
    screeningVc.isSearch = self.type == TZJobListViewControllerTypeSearch ? YES : NO;
    screeningVc.welfares = self.welfares;
    // 1、给筛选控制器初值
    NSMutableArray *screeningInfosForSearch = [NSMutableArray array];
    NSString *screeningItem;
    
    screeningItem = [self.screenView.areaBtn.titleLabel.text isEqualToString:@"区域"] ? @"不限":@"不限";
    [screeningInfosForSearch addObject:screeningItem];
    
    
    screeningItem = [self.screenView.areaBtn.titleLabel.text isEqualToString:@"区域"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"]:self.screenView.areaBtn.titleLabel.text;
    [screeningInfosForSearch addObject:screeningItem];
    
    screeningItem = [self.screenView.salaryBtn.titleLabel.text isEqualToString:@"薪资"] ? @"不限":self.screenView.salaryBtn.titleLabel.text;
    [screeningInfosForSearch addObject:screeningItem];
    
    screeningItem = [self.screenView.welfareBtn.titleLabel.text isEqualToString:@"福利"] ? @"不限":self.screenView.welfareBtn.titleLabel.text;
    [screeningInfosForSearch addObject:screeningItem];
    
//    if (self.screeningInfosForSearch != nil) {
//        [screeningInfosForSearch addObject:self.screeningInfosForSearch[4]];
//        [screeningInfosForSearch addObject:self.screeningInfosForSearch[5]];
//        [screeningInfosForSearch addObject:self.screeningInfosForSearch[6]]; // 来   源  下标是6 新增的
//        [screeningInfosForSearch addObject:self.screeningInfosForSearch[0]]; // 职位分类 下标是0 新增的
//        screeningVc.laid = self.laid;
//        screeningVc.cellDetails1 = [NSMutableArray arrayWithArray:screeningInfosForSearch];
//    } else if (screeningInfosForSearch != nil && screeningInfosForSearch.count > 0) {
//        [screeningInfosForSearch addObject:@"不限"];
//        [screeningInfosForSearch addObject:@"不限"];
//        [screeningInfosForSearch addObject:@"不限"];
////        [screeningInfosForSearch addObject:@"不限"];
//        screeningVc.cellDetails1 = [NSMutableArray arrayWithArray:screeningInfosForSearch];
//    }
    
    // 2、定义block  2.1 拿到用户的筛选数据，改变UI，重新发请求   2.2 screeningInfosForUI 改变UI用的数组【三个数据】  2.3 screeningInfosForSearch 重新发请求用的数组【全部数据】
//    screeningVc.returnScreeningInfoBlock = ^(NSArray *screeningInfosForUI,NSDictionary *resultDic,NSString *laid,BOOL isHotJobType){
//        self.laid = laid;
//        self.isHotJobType = isHotJobType;
////        self.screeningInfosForSearch = [NSMutableArray arrayWithArray:screeningInfosForSearch];
//        // 2.1、改变UI
//
//        //区域
//        //薪资
//        //福利
//        //筛选
//        for (NSInteger i = 1; i<screeningInfosForUI.count; i++) {
//            NSString *screeningInfo = screeningInfosForUI[i];
//            switch (i) {
//                case 1: { // 区域
//                    if ([screeningInfo hasPrefix:@"全"]) {
//                        [self.screenView.areaBtn setTitle:@"区域" forState:UIControlStateNormal];
//                    } else {
//                        [self.screenView.areaBtn setTitle:screeningInfo forState:UIControlStateNormal];
//                    }
//                }  break;
//                case 2: { // 薪资
//                    if ([screeningInfo isEqualToString:@"不限"]) {
//                        [self.screenView.salaryBtn setTitle:@"薪资" forState:UIControlStateNormal];
//                    } else {
//                        [self.screenView.salaryBtn setTitle:screeningInfo forState:UIControlStateNormal];
//                    }
//                }  break;
//                case 3: { // 福利
//                    if ([screeningInfo isEqualToString:@"不限"]) {
//                        [self.screenView.welfareBtn setTitle:@"福利" forState:UIControlStateNormal];
//                    } else {
//                        [self.screenView.welfareBtn setTitle:screeningInfo forState:UIControlStateNormal];
//                    }
//                }  break;
//                default:
//                    break;
//            }
//        }
//        // 2.2、用户选择好了筛选数据，重新发请求加载新的职位列表
//        [self filterJobList];
//    };
    [self.navigationController pushViewController:screeningVc animated:YES];
}


- (void)pushToJobListVcWithType:(TZJobListViewControllerType)type title:(NSString *)title{
    TZJobListViewController *jobListVc = [[TZJobListViewController alloc] initWithNibName:@"TZJobListViewController" bundle:nil];
    jobListVc.type = type;
    [self.navigationController pushViewController:jobListVc animated:YES];
}

#pragma mark - 轮播广告

- (void)configAdPageView {
    //网络加载 --- 创建带标题的图片轮播器
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.topScrollView.bounds imageURLStringsGroup:nil]; // 模拟网络延时情景
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.delegate = self;
        _cycleScrollView.backgroundColor = [UIColor clearColor];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        [self.topScrollView addSubview:_cycleScrollView];
    }
    
    RACSignal *sign = [ICEImporter ads];
    [sign subscribeNext:^(id x) {
        _imagesURLStrings = [ICEModelAds mj_objectArrayWithKeyValuesArray:x[@"data"]];
        NSMutableArray *imgAry = [NSMutableArray array];
        for (NSInteger i = 0; i < _imagesURLStrings.count; i++) {
            ICEModelAds *model = _imagesURLStrings[i];
            NSString *imgURL = [NSString stringWithFormat:@"%@%@", ApiSystemImage, model.path];
            if (i == 4) {
                [mUserDefaults setObject:model.href forKey:@"huodongguize"];
                [mUserDefaults synchronize];
            }
            [imgAry addObject:imgURL];
        }
        _cycleScrollView.imageURLStringsGroup = imgAry;
    }];
}

#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    ICEModelAds *model = _imagesURLStrings[index];
    if ([model.href containsString:ApiSns] || [model.href containsString:ApiSnsNew]) { // 广场
        self.tabBarController.selectedIndex = 2;
    } else if ([model.href isEqualToString:ApiAward]) {
        if ([TZUserManager isLogin]) {
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            [self pushWebVcWithUrl:[model.href stringByAppendingString:userModel.uid] title:model.ads_title];
        }
    } else {
        [self pushWebVcWithUrl:model.href title:model.ads_title];
    }
}

#pragma mark - 签到功能

/** 签到区分业务员还是求职者 */
- (void)mySignInGiftsWithParams:(NSString *)address lat:(NSString *)latitude lng:(NSString *)longitude {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"address" : address, @"lat" : latitude, @"lng" : longitude }];
    RACSignal *sign = [ICEImporter signWithParams:params];
    [sign subscribeNext:^(id x) {
        [self hideHud];
        UIAlertView *nameAlertView =  [[UIAlertView alloc] initWithTitle:x[@"msg"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [nameAlertView show];
    }];
}

#pragma mark - 私有方法

- (void)checkShowIntroducePage {
    
    if ([CommonTools needShowNewFeature]) {
        EAIntroPage *page1 = [EAIntroPage page];
        page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yd01"]];
        EAIntroPage *page2 = [EAIntroPage page];
        page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yd02"]];
        EAIntroPage *page3 = [EAIntroPage page];
        page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yd03"]];
        
        CGRect rect = CGRectMake(0, 0, __kScreenWidth, __kScreenHeight);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.tag = 100;
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rect andPages:@[page1,page2,page3]];
        intro.scrollView.frame = CGRectMake(0, -44, __kScreenWidth, __kScreenHeight);
        intro.backgroundColor = [UIColor whiteColor];
        intro.skipButton.hidden = YES;
        intro.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        intro.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        [intro setDelegate:self];
        [intro showInView:self.tabBarController.view animateDuration:0.3];
    }else {
        
        
        [self action_two];
    }

    
}

- (void)action_two {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
    
    [imageView sd_setImageWithURL:TZImageUrlWithShortUrl([mUserDefaults objectForKey:@"lanchImg"]) placeholderImage:[UIImage imageNamed:@"LaunchImage"]];
    
    
    [TZHttpTool postWithURL:ApiLanchScreen params:@{@"sessionid":@""} success:^(NSDictionary *result) {
        
        NSLog(@"i %@", result);
        
//        if ([result[@"status"]]) {
//            <#statements#>
//        }
        
        [mUserDefaults setObject:result[@"data"][@"path"] forKey:@"lanchImg"];
        
        NSLog(@"%@", TZImageUrlWithShortUrl(result[@"data"][@"path"]));
        [imageView sd_setImageWithURL:TZImageUrlWithShortUrl(result[@"data"][@"path"]) placeholderImage:[UIImage imageNamed:@"LaunchImage"]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                imageView.alpha = 0;
            }completion:^(BOOL finished) {
                [imageView removeFromSuperview];
            }];
            
        });
        
    } failure:^(NSString *msg) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                imageView.alpha = 0;
            }completion:^(BOOL finished) {
                [imageView removeFromSuperview];
            }];
            
        });
    }];
    
}

#pragma mark - 扫描二维码

- (void)codeScan {
//    ZJQRController *QRvc = [[ZJQRController alloc] init];
//    QRvc.title = @"扫描二维码";
//    [self.navigationController pushViewController:QRvc animated:YES];
    ZYHomeViewController *vc = [[ZYHomeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 网络请求
//热门工作
/** 加载今日高薪数据 */
- (void)loadHotJobs {
    
    self.salary = @"1";
    [self loadRecruitList];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
//
//    NSDictionary *params = @{@"address":[mUserDefaults objectForKey:@"userCity"],@"high_salary":@1};
//
//    [TZHttpTool postWithURL:ApiSnsRecruitList params:params success:^(id json) {
//        [self.bigScrollView.header endRefreshing];
//        self.totoal = json[@"data"][@"count_page"];
//        _jobs = [TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]];
//        // 1. 得到数据才配置tableView
//        self.tableView.dataSource = self;
//        self.tableView.delegate = self;
//        self.tableView.scrollEnabled = NO;
//        // 2. 更新约束
//        [self updateTableViewContraint];
//    } failure:^(NSString *error) {
//        [self.bigScrollView.header endRefreshing];
//        self.jobs = [NSMutableArray array];
//        [self updateTableViewContraint];
//    }];
}
//下一页
// 上拉刷新
- (void)loadRecruitList{
    
    if (self.page < [self.totoal integerValue]) {
        self.page++;
    } else {
        [self.bigScrollView endRefresh];
        [self showInfo:@"没有更多了"];
        return ;
    }
    NSDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:NotNullStr([mUserDefaults objectForKey:@"userCity"]) forKey:@"address"];
    if (self.page >0) {
        [params setValue:@(self.page) forKey:@"page"];

    }
    if(self.salary.length>0){
        [params setValue:self.salary forKey:@"high_salary"];
    }

    
    [TZHttpTool postWithURL:ApiSnsRecruitList params:params success:^(id json) {
        [self.bigScrollView endRefresh];
        self.totoal = json[@"data"][@"count_page"];
        [self.jobs addObjectsFromArray:[TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]]];
        [self updateTableViewContraint];
    } failure:^(NSString *error) {
        [self.bigScrollView endRefresh];
        DLog(@"今日高薪获取失败 error,%@",error);
        [self updateTableViewContraint];
    }];
}


//筛选职位
-(void)filterJobList{
    self.isSearch = YES;
    self.page = 0;
    [self reloadSearchData];
}

/** 发送搜索请求的方法 */
- (void)reloadSearchData {
    /*
     'keywords' String 关键词
     'address'  String 地址   传id如1代表北京
     'welfare'  String 福利   如947#948
     'salary'   String 薪资   如600108000以上都不是必须参数
     */
   
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 新0:laid  如果是从职位类别处进来的  搜索的时候也传laid
    if (self.laid != nil && ![self.laid isEqualToString:@""]) { //二级或三级分类id,传一个后台会查出二级或者三级的职位
        params[@"class_id"] = self.laid;
    }
    if (self.totoal>0 &&self.page < [self.totoal integerValue]) {
        self.page++;
    } else if (self.totoal==0){ //  请求第一页的数据
        
    }else{  //最后一页
        [self.bigScrollView endRefresh];
        [self showInfo:@"没有更多了"];
        return ;
    }
    // 新1:页数page
    params[@"page"] = [NSString stringWithFormat:@"%zd",self.page];
    
    // 0、配置关键词参数  可以是职位名和公司名
    //    params[@"keywords"] = [self getNewKeywords];
    
    if (self.address.length > 0) {
        params[@"address"] = self.address;
    } else {
        // 1、配置区域参数
        NSString *address = self.screenView.areaBtn.titleLabel.text;
        params[@"address"] = [self getNewAddressFromAddress:address];
    }
    
    // 2、配置福利参数
    NSString *welfare = self.screenView.welfareBtn.titleLabel.text;
    if (![welfare isEqualToString:@"福利"]) {
        params[@"welfare"] = [self getNewWorkexpFromWelfare:welfare];
    }
    
    if (self.salary.length > 0) {
        params[@"salary"] = self.salary;
    } else {
//        // 3、配置薪水参数
//        NSString *salary = self.screenView.salaryBtn.titleLabel.text;
//        if (![salary isEqualToString:@"薪资"]) {
//            params[@"salary"] = [self getNewSalaryFromSalray:salary];
//        }
    }
    
//    // 4、配置工作经验参数
//    NSInteger paramsCount = 8;
//    if (self.screeningInfosForSearch.count == paramsCount) {
//        NSString *work_exp = self.screeningInfosForSearch[5];
//        params[@"work_exp"] = [self getNewWorkexpFromWorkexp:work_exp];
//    }
//    // 5、配置信誉度参数
//    if (self.screeningInfosForSearch.count == paramsCount) {  // star  1 2 3 4 5
//        NSString *star = [self.screeningInfosForSearch[4] substringToIndex:1];
//        if (![star isEqualToString:@"不"]) {
//            params[@"star"] = star;
//        }
//    }
//    // 6、配置来源参数
//    if (self.screeningInfosForSearch.count == paramsCount) {
//        NSString *origin = self.screeningInfosForSearch[6];
//        params[@"origin"] = [self getOirginFrom:origin];
//    }
//
//    // 7、配置职位分类参数
//    if (self.screeningInfosForSearch.count == paramsCount) {  // laid
//        if (![self.screeningInfosForSearch[0] isEqualToString:@"不限"]) {
//            params[@"class_id"] = self.laid;
//        }
//
//    }
    
    // 其他筛选参数暂不处理
    switch (_type) {
        case TZHomeViewControllerTypeNormal:
            params[@"jobType"] = @"1";
            break;
        case TZHomeViewControllerTypeRelievedCompany:
            params[@"jobType"] = @"2";
            break;
        case TZHomeViewControllerTypeNearbyJob:
            params[@"jobType"] = @"3";
            params[@"lng"] = [NSString stringWithFormat:@"%@",[mUserDefaults objectForKey:@"longitude"]]; // 经度
            params[@"lat"] = [NSString stringWithFormat:@"%@",[mUserDefaults objectForKey:@"latitude"]];  // 维度
            break;
        case TZHomeViewControllerTypePartTimeJob:
            params[@"jobType"] = @"4";
            break;
        case TZHomeViewControllerTypeReturnMoney:
            params[@"jobType"] = @"5";
            break;
        case TZHomeViewControllerTypeEatJob:
            params[@"jobType"] = @"6";
            break;
        case TZHomeViewControllerTypeSchoolJob:
            params[@"jobType"] = @"7";
            break;
        case TZHomeViewControllerTypeOverseasJob:
            params[@"jobType"] = @"8";
            break;
        default:
            break;
    }
    params[@"high_salary"] = @1;
    // 8、发请求
    [TZHttpTool postWithURL:ApiSnsRecruitList params:params success:^(id json) {
        // 获取总页数
        NSNumber *totlaCount = json[@"data"][@"count_page"];
        self.totalCount = totlaCount.integerValue;
        // 更新数据，刷新tableView
        NSArray *jobs = [TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]];
        [self.jobs removeAllObjects];
        
        [self.jobs addObjectsFromArray:jobs];
        [self.tableView endRefreshAndReloadData];
    } failure:^(NSString *msg) {
        DLog(@"搜索 %@  失败 responseObject %@",params[@"keywords"],msg);
        [self.jobs removeAllObjects];
        [self.tableView endRefreshAndReloadData];
    }];
}



#pragma mark - 用户签到

- (void)baiduLocation {
    LocationDemoViewController *locationController = [[LocationDemoViewController alloc] init];
    [locationController setDidGetLocationInfoBlock:^(double lat, double lng, NSString *address) {
        [self mySignInGiftsWithParams:address lat:[@(lat) stringValue] lng:[@(lng) stringValue]];
    }];
    [self.navigationController pushViewController:locationController animated:YES];
}


// 配置薪水参数
- (NSString *)getNewSalaryFromSalray:(NSString *)salary {
    /*
     0=不限
     1=面议
     2000=2000元/月以下
     200103000=2001-3000元/月
     300105000=3001-5000元/月
     500108000=5001-8000元/月
     800110000=8001-10000元/月
     1000115000=10001-15000元/月
     1500025000=15001-25000元/月
     2500000000=25001元/月以上
     */
    NSString *newSalary;
    
    if ([salary isEqualToString:@"不限"]) {
        newSalary = @"0";
    } else if ([salary isEqualToString:@"面议"]) {
        newSalary = @"1";
    } else if ([salary isEqualToString:@"2000元/月以下"]) {
        newSalary = @"2";
    } else if ([salary isEqualToString:@"2001-3000元/月"]) {
        newSalary = @"3";
    } else if ([salary isEqualToString:@"3001-5000元/月"]) {
        newSalary = @"4";
    } else if ([salary isEqualToString:@"5001-8000元/月"]) {
        newSalary = @"5";
    } else if ([salary isEqualToString:@"8001-10000元/月"]) {
        newSalary = @"6";
    } else if ([salary isEqualToString:@"10001-15000元/月"]) {
        newSalary = @"7";
    } else if ([salary isEqualToString:@"15001-25000元/月"]) {
        newSalary = @"8";
    } else if ([salary isEqualToString:@"25001元/月以上"]) {
        newSalary = @"9";
    }
    return newSalary;
}

// 配置地址参数
- (NSString *)getNewAddressFromAddress:(NSString *)address {
    NSString *oldStr = address;
    if ([address isEqualToString:@"区域"] || [address isEqualToString:@"不限"]) {
        address = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"];
    }
    
    // 10.17更新 发给后台的数据 末尾是县、区、市、州的，把这些字去掉 [简单点实现...就先不判断最后一个了]
    address = [address stringByReplacingOccurrencesOfString:@"县" withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"市" withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"区" withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"州" withString:@""];
    
    if ([oldStr isEqualToString:@"新区"]) {
        address = oldStr;
    }
    
    return address;
}

// 配置关键词参数
- (NSString *)getNewKeywords {
    NSString *keywords = @"";
    // 确定关键字参数
    
//    if (![self.screeningInfosForSearch[5] isEqualToString:@"输入关键词"]) { // 高级筛选控制器带回来的关键字,覆盖之前选择的第三级职位
//        keywords = self.screeningInfosForSearch[5];
//        if (keywords != nil && ![keywords isEqualToString:@""]) {
//            self.jobTitle = keywords;
//        }
//    }
//    if (self.type == TZJobListViewControllerTypeSearch && ([keywords isEqualToString:@""] || keywords == nil)) {
//        keywords = self.jobTitle;
//    }
    return keywords;
}

// 配置工作经验参数
- (NSString *)getNewWorkexpFromWorkexp:(NSString *)workexp {
    /*
     0=不限
     1=无经验
     2=1年以下
     3=1-3年
     4=3-5年
     5=5-10年
     6=10年以上工作经验对应传值
     */
    NSString *newWorkExp;
    workexp = [workexp stringByReplacingOccurrencesOfString:@"~" withString:@"-"];
    if ([workexp isEqualToString:@"不限"]) {
        newWorkExp = @"0";
    } else if ([workexp isEqualToString:@"无经验"]) {
        newWorkExp = @"1";
    } else if ([workexp isEqualToString:@"1年以下"]) {
        newWorkExp = @"2";
    } else if ([workexp isEqualToString:@"1-3年"]) {
        newWorkExp = @"3";
    } else if ([workexp isEqualToString:@"3-5年"]) {
        newWorkExp = @"4";
    } else if ([workexp isEqualToString:@"5-10年"]) {
        newWorkExp = @"5";
    } else if ([workexp isEqualToString:@"10年以上"]) {
        newWorkExp = @"6";
    }
    return newWorkExp;
}
- (NSString *)getNewWorkexpFromWelfare:(NSString *)welfare {
    
    if ([welfare isEqualToString:@"不限"]) { return @""; }
    if ([welfare isEqualToString:@"包住宿"]) { return @"945"; }
    if ([welfare isEqualToString:@"班车"]) { return @"946"; }
    if ([welfare isEqualToString:@"工作餐"]) { return @"947"; }
    if ([welfare isEqualToString:@"入职返现"]) { return @"948"; }
    if ([welfare isEqualToString:@"季度旅游"]) { return @"949"; }
    if ([welfare isEqualToString:@"节日福利"]) { return @"950"; }
    if ([welfare isEqualToString:@"五险一金"]) { return @"951"; }
    if ([welfare isEqualToString:@"加班补助"]) { return @"952"; }
    if ([welfare isEqualToString:@"年底双薪"]) { return @"953"; }
    if ([welfare isEqualToString:@"公司福利"]) { return @"954"; }
    if ([welfare isEqualToString:@"五险"]) { return @"1010"; }
    
    return welfare;
}

- (NSString *)getOirginFrom:(NSString *)origin {
    if ([origin isEqualToString:@"全部"]) { return @"0"; }
    if ([origin isEqualToString:@"开心直招"]) { return @"1"; }
    if ([origin isEqualToString:@"企业直招"]) { return @"2"; }
    if ([origin isEqualToString:@"代招"]) { return @"3"; }
    return nil;
}
@end
