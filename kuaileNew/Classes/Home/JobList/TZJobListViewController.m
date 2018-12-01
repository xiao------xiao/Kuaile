//
//  TZJobListViewController.m
//  kuaile
//
//  Created by liujingyi on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobListViewController.h"
#import "TZJobListScreeningView.h"
#import "TZJobModel.h"
#import "TZJobListCell.h"
#import "TZJobDetailViewController.h"
#import "TZJobApplyView.h"
#import "TZJobHistoryView.h"
#import "TZScreeningViewController.h"
#import "HWSearchBar.h"
#import "TZSearchViewController.h"
#import "TZCraeteResumeControllerNew.h"
#import "TZNaviController.h"
#import "ICELoginViewController.h"
#import "XYCreateResumeViewController.h"
//#import "LCCollectionViewCell.h"
#import "JobListCollectionViewCell.h"
#import "AppDelegate+Location.h"
typedef NS_ENUM(NSUInteger, CollectionType) {
    CollectionTypeArea,
    CollectionTypeSalary,
    CollectionTypeWelfare
};

//static const NSString *reuseIdentifiers = @"LCCollectionViewCell";
 const NSString *collectionIdentify = @"JobListCollectionViewCell";
@interface TZJobListViewController ()<UITableViewDataSource,UITableViewDelegate,TZJobListScreeningViewDelegate,TZJobListCellDelegate,TZJobApplyViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
// @property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *jobs; // 要展示的工作岗位数组
@property (nonatomic, assign) NSInteger page;       // 分页  后台：第一页传1
@property (nonatomic, assign) NSInteger pageSearch; // 分页  后台：第一页传1  搜索时的分页
@property (nonatomic, assign) BOOL isSearch;        // 正在搜索
@property (nonatomic, assign) NSInteger totalCount; // 总页数

/** 筛选工具条相关 */
@property (nonatomic, strong) NSArray *welfares;
@property (nonatomic, strong) NSArray *salarys;
@property (nonatomic, strong) NSArray *areas;        // 区级
@property (nonatomic, strong) NSMutableArray *detail_areas; // 镇级
@property (nonatomic, strong) NSArray *isShowingArray;// 筛选tableView正在显示的数据源

/** 第一列tableView */
@property (nonatomic, strong) UITableView *screeningTableView;
@property (nonatomic, strong) UIButton *screeningcover;




/** 用户当前的城市 */
@property (nonatomic, strong) NSString *currentCity;

/** 用户选中的筛选信息 */
@property (nonatomic, strong) NSMutableArray *userSelected;
/** 筛选控制器返回的筛选数组 */
@property (nonatomic, strong) NSMutableDictionary *filterResultDic;
@property (nonatomic, assign) BOOL isHotJobType; // 是否是在筛选热门职位 参数名为class 否则为laid

/** 申请 */
@property (nonatomic, strong) TZJobApplyView *applyView;
@property (nonatomic, assign) NSInteger JobSelectedCount;
@property (nonatomic, strong) NSMutableArray *recruit_ids;
//选项卡的选项（区域 薪资 福利 筛选）
@property (nonatomic, assign) TZScreeningViewButtonType segType;

/** 导航栏搜索框 */
@property (nonatomic, strong) HWSearchBar *searchBar;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopContraint;
@property (nonatomic,retain) UIView *topview;
@property (nonatomic,retain) UICollectionView *areaPickerCollectionView;
@property (nonatomic,retain) UIView *areaFilterView;

@property (nonatomic,retain) UICollectionView *salaryPickerCollectionView;
@property (nonatomic,retain) UIView *salaryFilterView;

@property (nonatomic,retain) UICollectionView *welfarePickerCollectionView;
@property (nonatomic,retain) UIView *welfareFilterView;


@end

@implementation TZJobListViewController

#pragma mark 懒加载和配置界面

- (TZJobApplyView *)applyView {
    if (_applyView == nil) {
        _applyView = [[TZJobApplyView alloc] init];
        _applyView.frame = CGRectMake(0, __kScreenHeight - 60, __kScreenWidth, 60);
        _applyView.delegate = self;
        [self.view addSubview:_applyView];
    }
    return _applyView;
}


- (void)setupData{
    self.detail_areas = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"全%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"]]];
    self.jobs = [NSMutableArray array];
    self.welfares = @[@"不限"];
    [self loadNetAllWelfares];
    self.salarys = @[@"不限",@"面议",@"2000元/月以下",@"2001-3000元/月",@"3001-5000元/月",@"5001-8000元/月",@"8001-10000元/月",@"10001-15000元/月",@"15001-25000元/月",@"25001元/月以上"];
    
    self.isShowingArray = [[NSArray alloc] init];
    self.currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"];
    self.userSelected = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0]];
    self.recruit_ids = [[NSMutableArray alloc] init];
    [self reloadCityData];
}
-(void)reloadCityData{
    self.currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"];
    
    self.areas =  [TZCitisManager getCitis];
    
}
-(void)setupWelfarePickerView{
    //*****************当前城市层**********************
    
    
    UIView *areaView = [[UIView alloc] init];
     areaView.backgroundColor = color_white;
    areaView.frame = CGRectMake(0, CGRectGetMaxY(self.screeningView.frame), kScreenWidth, 280);
    [self.view addSubview:areaView];
//    [areaView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//        make.top.mas_equalTo(self.screeningView.mas_bottom);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.height.mas_equalTo(220);
//    }];
  
    //*****************选择福利模块**********************
   
    UILabel *lblSelectCity = [PublicView createLabelWithTitle:@"选择福利" titleColor:color_darkgray font:fontBig textAlignment:NSTextAlignmentLeft];
    [areaView addSubview:lblSelectCity];
    [lblSelectCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(areaView.mas_left).offset(20);
        make.top.mas_equalTo(areaView.mas_top).offset(14);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    //collectionview
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    if (INTERFACE_IS_PAD) {
    //        layout.itemSize = CGSizeMake(126, 45);
    //    } else {
//    layout.itemSize = CGSizeMake((self.view.frame.size.width-30-30)/3, 31);
    //    }
    layout.itemSize = CGSizeMake(80, 30);
    CGFloat paddingY                   = 5;
    CGFloat paddingX                   = 5;
    layout.sectionInset                = UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX);
    layout.minimumLineSpacing          = paddingY;
    layout.minimumInteritemSpacing      = paddingY;
    float collectHeight = 220-44;
    
    self.welfarePickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width-30, collectHeight) collectionViewLayout:layout];
    
    self.welfarePickerCollectionView.backgroundColor                = [UIColor whiteColor];
    self.welfarePickerCollectionView.dataSource                     = self;
    self.welfarePickerCollectionView.delegate                       = self;
    self.welfarePickerCollectionView.showsHorizontalScrollIndicator = NO;
    self.welfarePickerCollectionView.showsVerticalScrollIndicator   = NO;
    self.welfarePickerCollectionView.pagingEnabled                  = NO;
    
   
    self.welfarePickerCollectionView.tag                            = CollectionTypeWelfare;
    self.welfarePickerCollectionView.scrollEnabled                  = YES;
    [areaView addSubview:self.welfarePickerCollectionView];
    
    self.welfareFilterView = areaView;
}
-(void)setupSalaryPickerView{
    //*****************当前城市层**********************
    
    
    UIView *areaView = [[UIView alloc] init];
    areaView.backgroundColor = color_white;
    areaView.frame = CGRectMake(0, CGRectGetMaxY(self.screeningView.frame), kScreenWidth, 280);
    [self.view addSubview:areaView];
//    [areaView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//        make.top.mas_equalTo(self.screeningView.mas_bottom);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.height.mas_equalTo(220);
//    }];
    
    //*****************选择薪资模块**********************
    
    UILabel *lblSelectCity = [PublicView createLabelWithTitle:@"选择薪资" titleColor:color_darkgray font:fontBig textAlignment:NSTextAlignmentLeft];
    [areaView addSubview:lblSelectCity];
    [lblSelectCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(areaView.mas_left).offset(20);
        make.top.mas_equalTo(areaView.mas_top).offset(14);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    //collectionview
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    if (INTERFACE_IS_PAD) {
    //        layout.itemSize = CGSizeMake(126, 45);
    //    } else {
    float itemWidth = (kScreenWidth-40)/3;
    layout.itemSize = CGSizeMake(itemWidth, 30);
    CGFloat paddingY                   = 5;
    CGFloat paddingX                   = 5;
    layout.sectionInset                = UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX);
    layout.minimumLineSpacing          = paddingY;
    layout.minimumInteritemSpacing      = paddingY;
    
    float collectHeight = 220-44;
    
    self.salaryPickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44,kScreenWidth, collectHeight) collectionViewLayout:layout];
    
    self.salaryPickerCollectionView.backgroundColor                = [UIColor whiteColor];
    self.salaryPickerCollectionView.dataSource                     = self;
    self.salaryPickerCollectionView.delegate                       = self;
    self.salaryPickerCollectionView.showsHorizontalScrollIndicator = NO;
    self.salaryPickerCollectionView.showsVerticalScrollIndicator   = NO;
    self.salaryPickerCollectionView.pagingEnabled                  = NO;
    
   
    self.salaryPickerCollectionView.tag                            = CollectionTypeSalary;
    self.salaryPickerCollectionView.scrollEnabled                  = YES;
    [areaView addSubview:self.salaryPickerCollectionView];
    
    self.salaryFilterView = areaView;
}

-(void)setupAreaPickerView{
    
    //*****************当前城市层**********************
    
    
    UIView *areaView = [[UIView alloc] init];
    areaView.backgroundColor = color_white;
    areaView.frame = CGRectMake(0, CGRectGetMaxY(self.screeningView.frame), kScreenWidth, 280);
    [self.view addSubview:areaView];
    
//    [areaView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//        make.top.mas_equalTo(self.screeningView.mas_bottom);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.height.mas_equalTo(280);
//    }];
    UIView *currentCityView = [[UIView alloc] init];
    [areaView addSubview:currentCityView];
    [currentCityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(areaView.mas_left);
        make.top.mas_equalTo(areaView.mas_top);
        make.right.mas_equalTo(areaView.mas_right);
        make.height.mas_equalTo(58);
    }];
    
   
    UILabel *lblTitle = [PublicView createLabelWithTitle:@"当前城市" titleColor:color_darkgray font:fontBig textAlignment:NSTextAlignmentLeft];
    [currentCityView addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(currentCityView.mas_left).offset(20);
        make.top.mas_equalTo(currentCityView.mas_top).offset(14);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *currentcity =  [PublicView createPictureButtonWithNormalImage:@"square_city_sel" selectImage:nil];
//    NSString *currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_city"];
//
    [currentcity setTitle:self.currentCity forState:UIControlStateNormal];
//    currentcity.titleLabel.text = currentCity;
    currentcity.titleLabel.textColor = color_white;
//    [currentcity setTitle:currentCity forState:UIControlStateNormal];
//    [currentcity setTitleColor:color_white forState:UIControlStateNormal];
    
    [currentCityView addSubview:currentcity];
    [currentcity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lblTitle.mas_right).offset(15);
        make.top.mas_equalTo(currentCityView.mas_top).offset(14);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
  
    
    UIButton *refreshButton = [PublicView createImageButton:@"icon_next"];
    [[refreshButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //刷新当前城市
#warning zhangying 刷新当前城市
        AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate startLocation];
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            NSLog(@"1秒后添加到队列");
            [self reloadCityData];
            [currentcity setTitle:self.currentCity forState:UIControlStateNormal];
            [self.areaPickerCollectionView reloadData];
        });
        
    
    }];
    [currentCityView addSubview:refreshButton];
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(currentcity.mas_right).offset(15);
        make.top.mas_equalTo(currentCityView.mas_top).offset(14);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    //*****************选择区域模块**********************
    UIView *selectCityView = [[UIView alloc] init];
    [areaView addSubview:selectCityView];
    [selectCityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(areaView.mas_left);
        make.top.mas_equalTo(currentCityView.mas_bottom);
//        make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(areaView.mas_bottom);
        make.right.mas_equalTo(areaView.mas_right);
    }];
    UILabel *lblSelectCity = [PublicView createLabelWithTitle:@"选择区域" titleColor:color_darkgray font:fontBig textAlignment:NSTextAlignmentLeft];
    [selectCityView addSubview:lblSelectCity];
    [lblSelectCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(currentCityView.mas_left).offset(20);
        make.top.mas_equalTo(currentCityView.mas_bottom).offset(14);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    //collectionview
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    if (INTERFACE_IS_PAD) {
//        layout.itemSize = CGSizeMake(126, 45);
//    } else {
    layout.itemSize = CGSizeMake(80, 30);
    CGFloat paddingY                   = 5;
    CGFloat paddingX                   = 5;
    layout.sectionInset                = UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX);
    layout.minimumLineSpacing          = paddingY;
    layout.minimumInteritemSpacing      = paddingY;
    
   float collectHeight = 280-58-44-10;
    
    self.areaPickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, collectHeight) collectionViewLayout:layout];
    
    self.areaPickerCollectionView.backgroundColor                = [UIColor clearColor];
    self.areaPickerCollectionView.dataSource                     = self;
    self.areaPickerCollectionView.delegate                       = self;
    self.areaPickerCollectionView.showsHorizontalScrollIndicator = NO;
    self.areaPickerCollectionView.showsVerticalScrollIndicator   = NO;
    self.areaPickerCollectionView.pagingEnabled                  = NO;
  

    self.areaPickerCollectionView.tag                            = CollectionTypeArea;
    self.areaPickerCollectionView.scrollEnabled                  = YES;
    [selectCityView addSubview:self.areaPickerCollectionView];
    self.areaFilterView = areaView;
}
- (void)configScreeningView {
    TZJobListScreeningView *screenView = [[TZJobListScreeningView alloc] init];
    self.screeningView = screenView;
    self.screeningView.delegate = self;
    screenView.frame = CGRectMake(0, CGRectGetMaxY(self.topview.frame), __kScreenWidth, 44);
    screenView.autoresizesSubviews = NO;
    [self.view addSubview:screenView];
    
    [self.view addSubview:self.screeningcover];
    
    [self setupAreaPickerView];
    [self setupSalaryPickerView];
    [self setupWelfarePickerView];
    self.areaFilterView.clipsToBounds = YES;
    self.salaryFilterView.clipsToBounds = YES;
    self.welfareFilterView.clipsToBounds = YES;

    [UIView animateWithDuration:0.25 animations:^{
        self.areaFilterView.height = 0;
        self.salaryFilterView.height = 0;
        self.welfareFilterView.height = 0;
        self.screeningcover.height = 0;
    }];
    
    [self.areaPickerCollectionView registerClass:[JobListCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentify];
    [self.salaryPickerCollectionView registerClass:[JobListCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentify];
      [self.welfarePickerCollectionView registerClass:[JobListCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentify];
//    [self.areaPickerCollectionView registerNib:[UINib nibWithNibName:@"JobListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionIdentify];
//    [self.salaryPickerCollectionView registerNib:[UINib nibWithNibName:@"JobListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionIdentify];
//    [self.welfarePickerCollectionView registerNib:[UINib nibWithNibName:@"JobListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionIdentify];
    
//    self.areaFilterView.height = 0;
//    self.salaryFilterView.height = 0;
//    self.welfareFilterView.height = 0;
//    self.screeningcover.height = 0;
    
    //    [self.view addSubview:self.screeningTableView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    
    self.page = 1;
    self.pageSearch = 1;
    self.isSearch = self.type == TZJobListViewControllerTypeSearch ? YES : NO;
    self.segType = TZScreeningViewButtonTypeNone;
    
    if(self.type == TZJobListViewControllerTypeReturnMoney){
        self.title = @"入职返现";
    }
    if(self.shaixuanHotJobs){
         self.title = @"热门工作";
        [self loadHotJobs];
    }else{
        [self loadNetData];
    }
    [self setupView];
    self.applyView.hidden = YES;
    // 以下type时，不显示筛选bar
   
    
    if (self.type == TZJobListViewControllerTypeCollction || self.type == TZJobListViewControllerTypeHistory || self.type == TZJobListViewControllerTypeOthers || self.type == TZJobListViewControllerTypeRecommed || self.type == TZJobListViewControllerTypeNoti) {
        self.screeningView.hidden = YES;
        self.tableViewTopContraint.constant = 0;
    }
    // 监听有没有取消收藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveCancleCollection) name:@"haveCancleCollection" object:nil];
}

-(void)setupView{
    [self configNaviBar];
    [self configTopView];
    [self configTableView];
    [self configScreeningView];
   
    
}




/** 配置导航条bar */
- (void)configTopView {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
    // 左边40  右边60  中间搜索栏
    HWSearchBar *searchBar = [HWSearchBar searchBar];
    float searchHeight = 32;
//    searchBar.width = [UIScreen mainScreen].bounds.size.width - 100;
    searchBar.frame = CGRectMake(40, (topView.frame.size.height -searchHeight)/2, kScreenWidth-100, searchHeight);
    
    searchBar.placeholderText = [NSString stringWithFormat:@"请输入职位或公司名称"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = searchBar.frame;
    [button addTarget:self action:@selector(goSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchBar addSubview:button];
    
    [topView addSubview:searchBar];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -60, 0, 60, topView.frame.size.height)];
    [btn setTitleColor:color_dark_blue forState:UIControlStateNormal];
    [btn setTitle:@"简历" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_editor"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goCreateResume) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:btn];
    
    self.topview = topView;
    [self.view addSubview:self.topview];
 
}
/** 配置导航条bar */
- (void)configNaviBar {
//    HWSearchBar *searchBar = [HWSearchBar searchBar];
//    searchBar.width = [UIScreen mainScreen].bounds.size.width - 100;
//    searchBar.height = 32;
//    searchBar.placeholderText = [NSString stringWithFormat:@"请输入职位或公司名称"];
//
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = searchBar.frame;
//    [button addTarget:self action:@selector(goSearch) forControlEvents:UIControlEventTouchUpInside];
//    [searchBar addSubview:button];
//
//    self.navigationItem.titleView = searchBar;
//
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [btn setBackgroundImage:[UIImage imageNamed:@"gg"] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:@"gg"] forState:UIControlStateSelected];
//    [btn addTarget:self action:@selector(goCreateResume) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if (self.type == TZJobListViewControllerTypeCollction) {
        self.navigationItem.titleView = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.title = @"收藏职位";
    }
    if (self.type == TZJobListViewControllerTypeHistory) {
        self.navigationItem.titleView = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.title = @"投递记录";
    }
    
    if (self.type == TZJobListViewControllerTypeOthers) {
        self.navigationItem.titleView = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.title = self.vCtrlTitle;
    }
    
    if (self.type == TZJobListViewControllerTypeNoti) {
        self.navigationItem.titleView = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.title = @"相似职位";
    }
}
- (UITableView *)screeningTableView {
    if (_screeningTableView == nil) {
        _screeningTableView = [[UITableView alloc] init];
        _screeningTableView.delegate = self;
        _screeningTableView.dataSource = self;
        _screeningTableView.frame = CGRectMake(0, CGRectGetMaxY(self.screeningView.frame), __kScreenWidth, 0);
    }
    return _screeningTableView;
}

- (UIButton *)screeningcover {
    
    if (_screeningcover== nil) {
        _screeningcover = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.screeningView.frame), __kScreenWidth, 0)];
        [self.screeningcover setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.4]];
        [self.screeningcover addTarget:self action:@selector(coverDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screeningcover;
}

- (void)configTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    // 配置上下拉刷新
    MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithFooter)];
    self.tableView.footer = footer;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithHeader)];
    self.tableView.header = header;
}
/** 加载热门工作 */
//热门工作
/** 加载今日高薪数据 */
- (void)loadHotJobs {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:NotNullStr([mUserDefaults objectForKey:@"userCity"]) forKey:@"address"];
    [params setObject:@1 forKey:@"high_salary"];
    [params setObject:[NSString stringWithFormat:@"%zd",self.page] forKey:@"page"];
    
   
    [TZHttpTool postWithURL:ApiSnsRecruitList params:params success:^(id json) {
        NSArray *jobArray = [TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]];
        if (self.page == 1) {
            [self.jobs removeAllObjects];
        }
        [self.jobs addObjectsFromArray:jobArray];
        
        if (_type != TZJobListViewControllerTypeGetui) {
            NSNumber *totlaCount = json[@"data"][@"count_page"];
            self.totalCount = totlaCount.integerValue;
        } else {
            self.totalCount = 1;
        }
        [self.tableView configNoDataTipViewWithCount:self.jobs.count tipText:@"暂无内容"];
        [self.tableView endRefreshAndReloadData];
    } failure:^(NSString *error) {
        [self.jobs removeAllObjects];
        [self.tableView configNoDataTipViewWithCount:self.jobs.count tipText:@"暂无内容"];
        [self.tableView endRefreshAndReloadData];
    }];
}
/** 加载网络数据 */
- (void)loadNetData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    self.isSearch = NO;
    self.pageSearch = 1;
    
    // 还有校园招聘、兼职工作、包吃住职位、入职返现、放心企业、高薪职位、职位列表（全职工作）7个地方都再传一个'address'给我,就是地位的地址
//    if (self.dic) {
//        NSString *dicstr = ;
//    }
    NSString *userCity = [mUserDefaults objectForKey:@"userCity"] ;
    // 分页参数
    params[@"page"] = [NSString stringWithFormat:@"%zd",self.page];
    
    

    NSString *API = [NSString string];
    if (self.type == TZJobListViewControllerTypeNormal) {  // 正常请求职位列表数据
        params[@"address"] = userCity;
        if (self.isFromHotJob) {
            params[@"class_id"] = self.laid;
            API = ApiSnsRecruitList; // 热门职位
        } else {
            params[@"class_id"] = self.laid;
            API = ApiSnsRecruitList;
            params[@"jobType"] = @1;// 全部职位
        }
    } else if (self.type == TZJobListViewControllerTypeHistory) {   // 投递记录数据
        API = ApiPostLog;
    } else if (self.type == TZJobListViewControllerTypeCollction) { // 收藏职位数据
        API = ApiViewFav;
    } else if (self.type == TZJobListViewControllerTypeRecommed) {  // 推荐职位数据 API暂无
        
    } else if (self.type == TZJobListViewControllerTypeOthers) {    // 该公司其他职位
        params[@"uid"] = self.uid; // 公司的uid
        API = ApiSnsRecruitList;
    } else if (self.type == TZJobListViewControllerTypeSchoolJob) { // 校园招聘
        params[@"address"] = userCity;
         params[@"jobType"] = @7;
        API = ApiSnsRecruitList;
    } else if (self.type == TZJobListViewControllerTypePartTimeJob) { // 兼职工作
        params[@"address"] = userCity;
         params[@"jobType"] = @4;
        API = ApiSnsRecruitList;
    } else if (self.type == TZJobListViewControllerTypeEatJob) {      // 包吃包住
        params[@"address"] = userCity;
         params[@"jobType"] = @6;
        API = ApiSnsRecruitList;
    } else if (self.type == TZJobListViewControllerTypeReturnMoney) { // 入职返现
        params[@"address"] = userCity;
        params[@"jobType"] = @5;
        API = ApiSnsRecruitList;
    }else if (self.type  == TZJobListViewControllerTypeOverseasJob) {// 海外招聘
        params[@"address"] = userCity;
        params[@"jobType"] = @8;
        API = ApiSnsRecruitList;
    }else if (self.type == TZJobListViewControllerTypeNearbyJob) {   // 附近工作
        API = ApiSnsRecruitList;
        params[@"jobType"] = @3;
        params[@"lng"] = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]]; // 经度
        params[@"lat"] = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]];  // 维度
    } else if (self.type == TZJobListViewControllerTypeSearch) {      // 搜索职位
        params[@"address"] = userCity;
        API = ApiSnsRecruitList;
        params[@"keywords"] = self.jobTitle;
    } else if (self.type == TZJobListViewControllerTypeRelievedCompany) { // 放心企业
        params[@"jobType"] = @2;
        params[@"address"] = userCity;
        API = ApiSnsRecruitList;
        // params[@"laid"] = self.laid;
    } else if (self.type == TZJobListViewControllerTypeNoti) { // 系统消息
        if (self.address.length > 0) {
            
            if (self.isFromHotJob) {
                params[@"class_id"] = self.laid;
            } else {
                params[@"class_id"] = self.laid;
            }            
            params[@"address"] = self.address;
            params[@"salary"] = self.salary;
        }
        API = ApiSnsRecruitList;
    } else if (self.type == TZJobListViewControllerTypeGetui) {
        API = ApiSnsRecruitList;
        params[@"recruit_ids"] = self.is_mess;
    }
    
    
    if (_dic) {
        params[@"keywords"] = _dic[@"keywords"];
        params[@"class_id"] = _dic[@"class"];
        params[@"address"] = _dic[@"hope_city"];
        params[@"salary"] = _dic[@"hope_salary"];
        params[@"welfare"] = _dic[@"hope_career"];
        params[@"star"] = _dic[@"star"];
        params[@"work_exp"] = _dic[@"exp"];
        params[@"origin"] = _dic[@"origin"];
    }
 
    __block NSArray *jobs = [NSArray array];
    [TZHttpTool postWithURL:API params:params success:^(id json) {
        [self.tableView endRefresh];
        // DLog(@"%@  职位列表获取成功 responseObject %@",self.jobTitle,json);
        // 因为不同的api，后台返回的数据格式不一样。若这里报错，很可能是字段格式又改了。
        if (self.type == TZJobListViewControllerTypeNormal || self.type == TZJobListViewControllerTypeSchoolJob || self.type == TZJobListViewControllerTypePartTimeJob|| self.type == TZJobListViewControllerTypeReturnMoney || self.type == TZJobListViewControllerTypeEatJob || self.type == TZJobListViewControllerTypeNearbyJob || self.type == TZJobListViewControllerTypeOverseasJob) {
            jobs = [TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]];
        } else if (self.type == TZJobListViewControllerTypeHistory || self.type == TZJobListViewControllerTypeRelievedCompany) {
            jobs = [TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]];
        } else if (self.type == TZJobListViewControllerTypeCollction) {
            jobs = [TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]];
        } else if (self.type == TZJobListViewControllerTypeOthers) {
            jobs = [TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]];
        } else if (self.type == TZJobListViewControllerTypeSearch) {
            jobs = [TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]];
        } else if (self.type == TZJobListViewControllerTypeNoti) {
            jobs = [TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]];
        } else if (self.type == TZJobListViewControllerTypeGetui) {
            jobs = [TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]];
        }

        if (self.page == 1) {
            [self.jobs removeAllObjects];
        }
        [self.jobs addObjectsFromArray:jobs];
        
        if (_type != TZJobListViewControllerTypeGetui) {
            NSNumber *totlaCount = json[@"data"][@"count_page"];
            self.totalCount = totlaCount.integerValue;
        } else {
            self.totalCount = 1;
        }
        [self.tableView configNoDataTipViewWithCount:self.jobs.count tipText:@"暂无内容"];
        [self.tableView endRefreshAndReloadData];
    } failure:^(NSString *error) {
        DLog(@"%@  职位列表获取失败 error %@",self.jobTitle,error);
        [self.jobs removeAllObjects];
        [self.tableView configNoDataTipViewWithCount:self.jobs.count tipText:@"暂无内容"];
        [self.tableView endRefreshAndReloadData];
    }];
}

// 上拉刷新 两种Api，从职位类别进来，或者从搜索页面进来。
- (void)refreshDataWithFooter {
    // 前端来判断总页数
    if (self.page >= self.totalCount || self.pageSearch >= self.totalCount) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showInfo:@"没有更多了呢"];
            [self.tableView.footer endRefreshing];
        });
    } else {
        if (self.isSearch) { // 搜索/筛选 状态
            self.pageSearch ++;
            [self reloadSearchData];
        } else {            // 职位类别浏览职位状态
            self.page ++;
            [self loadNetData];
        }
    }
}

// 下拉刷新 两种Api，从职位类别进来，或者从搜索页面进来。
- (void)refreshDataWithHeader {
    if (self.isSearch) {
        self.pageSearch = 1;
        [self reloadSearchData];
    } else {
        self.page = 1;
        [self loadNetData];
    }
}

- (void)loadNetAllWelfares {
    [TZHttpTool postWithURL:ApiAllWelfares params:nil success:^(id json) {
        NSArray *array = json[@"data"];
        NSMutableArray *welfares = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            [welfares addObject:dict[@"title"]];
        }
        [welfares insertObject:@"不限" atIndex:0];
        self.welfares = welfares;
        [self.welfarePickerCollectionView reloadData];
    } failure:^(NSString *error) {
        DLog(@"获取全部福利列表 失败");
    }];
}




#pragma mark tableView的数据源/代理方法 （一共3个tableView）

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID1 = @"jobList_cell";
    static NSString *ID2 = @"search_cell";
    
    if (tableView == self.tableView) {
        TZJobListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (cell == nil) {
            cell = [[TZJobListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
        }
        cell.model = self.jobs[indexPath.row];
        cell.delegate = self;
        if (self.type != TZJobListViewControllerTypeHistory) {
            [cell addSubview:[UIView divideViewWithHeight:cell.height]];
        }
        [self setUpCellTypeWith:cell model:cell.model];
        return cell;
    } else { // if (tableView == self.screeningTableView)
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID2];
        }
        cell.textLabel.text = self.isShowingArray[indexPath.row];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
}

/** 根据不同的cell类型。配置cell */
- (void)setUpCellTypeWith:(TZJobListCell *)cell model:(TZJobModel *)model{
    switch (self.type) {
        case TZJobListViewControllerTypeNormal:
            cell.type = TZJobListCellTypeNormal;
            break;
        case TZJobListViewControllerTypeCollction:
            cell.type = TZJobListCellTypeCollection; // 如果type是TZJobListCellTypeCollection 里面的收藏按钮要是已收藏状态的
            break;
        case TZJobListViewControllerTypeHistory: {
            cell.type = TZJobListCellTypeHistory;
            TZJobHistoryView *history = [[TZJobHistoryView alloc] init];
            history.frame = CGRectMake(0, 120, __kScreenWidth, 54);
            history.applyDate.text = model.sendtime;
            [cell addSubview:history];
        }   break;
        case TZJobListViewControllerTypeRecommed:
            cell.type = TZJobListCellTypeRecommed;
            break;
        case TZJobListViewControllerTypeOthers:
            cell.type = TZJobListCellTypeOthers;
            break;
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.jobs.count;
    } else if (tableView == _screeningTableView) {
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
//        detailVc.uid = model.uid;
        // 处理是否被收藏
        if (self.type == TZJobListViewControllerTypeCollction) {
            detailVc.haveCollection = YES;
        }
        [self.navigationController pushViewController:detailVc animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (tableView == self.screeningTableView) {
        
        [self updateUserSelectedArray:indexPath]; // 根据indexPath更新用户选择的筛选信息
        // 选择不限或者全北京等cell时
        NSString *cellTitle = self.isShowingArray[indexPath.row];
        
        switch (self.segType) {
            case TZScreeningViewButtonTypeArea:
                self.address = cellTitle;
                 [self.screeningView.areaBtn setTitle:cellTitle forState:UIControlStateNormal];
                break;
            case TZScreeningViewButtonTypeSalary:
                if(indexPath.row==0){
                    [self.screeningView.salaryBtn setTitle:@"薪资" forState:UIControlStateNormal];

                }else{
                [self.screeningView.salaryBtn setTitle:cellTitle forState:UIControlStateNormal];
                }
                break;
            case TZScreeningViewButtonTypeWelfare:
                if(indexPath.row==0){
                    [self.screeningView.welfareBtn setTitle:@"福利" forState:UIControlStateNormal];

                }else{
                 [self.screeningView.welfareBtn setTitle:cellTitle forState:UIControlStateNormal];
                }
                break;
            default:
                break;
        }
        [self animToHideTableView];
        // 去搜索对应筛选条件的职位
        [self reloadSearchData];
       
    } else {
        [self.userSelected replaceObjectAtIndex:1 withObject:@(indexPath.row)];
        [self animToHideTableView];
        self.screeningView.downMoreView = YES;
        // 去搜索对应筛选条件的职位
        [self reloadSearchData];
    }
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
            if (self.type == TZJobListViewControllerTypeHistory) {
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    // 收藏、投递记录 允许删除
    if (self.type == TZJobListViewControllerTypeCollction || self.type == TZJobListViewControllerTypeHistory) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == TZJobListViewControllerTypeCollction) { // 删除收藏
        
        UITableViewRowAction *delAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            TZJobModel *model = self.jobs[indexPath.row];
            [self postDeleteInfo:model.recruit_id];
            [self.jobs removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        delAction.backgroundColor = [UIColor grayColor];
        
        
        return @[delAction];
    } else { // 删除投递记录
        
        UITableViewRowAction *delAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除该条记录" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            TZJobModel *model = self.jobs[indexPath.row];
            [self postDeleteDeliverLog:model.deliver_id];
            [self.jobs removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        delAction.backgroundColor = [UIColor grayColor];
        return @[delAction];
    }
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (collectionView.tag) {
        case CollectionTypeArea:
            return self.areas.count;
            break;
        case CollectionTypeSalary:
            return self.salarys.count;
            break;
        case CollectionTypeWelfare:
            return self.welfares.count;
            break;
        default:
            break;
    }
    return 0;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    LCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifiers forIndexPath:indexPath];
    JobListCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentify forIndexPath:indexPath];
    
//    JobListCollectionViewCell *cell = (JobListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentify];
    
    NSNumber *selectRow;
    NSString *titleStr = @"";
    switch (collectionView.tag) {
        case CollectionTypeArea:
            selectRow = self.userSelected[0];
            titleStr = self.areas[indexPath.row];

            break;
        case CollectionTypeSalary:
            selectRow = self.userSelected[1];
            titleStr = self.salarys[indexPath.row];

            break;
        case CollectionTypeWelfare:
            selectRow = self.userSelected[2];
            titleStr = self.welfares[indexPath.row];

            break;
        default:
            break;
    }
    
    cell.nameStr = titleStr;
    
//    cell.nameStr= titleStr;
//    cell.nameStr = @"23445";
    if (selectRow.integerValue == indexPath.row) {
        cell.select =   YES;
    }else{
        cell.select =   NO;
    }
    
//    [self updateUserSelectedArray:indexPath];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *selectRow;
    NSString *titleStr = @"";
    switch (collectionView.tag) {
        case CollectionTypeArea:
            selectRow = self.userSelected[0];
            titleStr = self.areas[indexPath.row];
            self.address = titleStr;
            [self.screeningView.areaBtn setTitle:titleStr forState:UIControlStateNormal];
            
             [self.userSelected replaceObjectAtIndex:0 withObject:@(indexPath.row)];
            break;
        case CollectionTypeSalary:
            selectRow = self.userSelected[1];
            titleStr = self.salarys[indexPath.row];
            if(indexPath.row==0){
                [self.screeningView.salaryBtn setTitle:@"薪资" forState:UIControlStateNormal];
                
            }else{
                [self.screeningView.salaryBtn setTitle:titleStr forState:UIControlStateNormal];
            }
             [self.userSelected replaceObjectAtIndex:1 withObject:@(indexPath.row)];
            break;
        case CollectionTypeWelfare:
            selectRow = self.userSelected[2];
            titleStr = self.welfares[indexPath.row];
            if(indexPath.row==0){
                [self.screeningView.welfareBtn setTitle:@"福利" forState:UIControlStateNormal];
                
            }else{
                [self.screeningView.welfareBtn setTitle:titleStr forState:UIControlStateNormal];
            }
             [self.userSelected replaceObjectAtIndex:2 withObject:@(indexPath.row)];
            break;
        default:
            break;
    }
    [self hideAllFilterView];
//    [self animToHideTableView];

}


#pragma mark - HTTP

- (void)postDeleteInfo:(NSString *)messageID {
    // 2. 如果已经登录
    NSString * sessionid = [mUserDefaults objectForKey:@"sessionid"];
    NSDictionary *params = @{@"recruit_id":messageID,@"sessionid":sessionid};
    [TZHttpTool postWithURL:ApiSnsDelFav params:params success:^(id json) {
//        DLog(@"取消收藏成功 %@",json);
    } failure:^(NSString *error) {
        DLog(@"取消收藏失败 %@",error);
    }];
}

- (void)postDeleteDeliverLog:(NSString *)deliver_id {
    NSDictionary *params = @{@"deliver_id":deliver_id};
    [TZHttpTool postWithURL:ApiDeleteDeliverLog params:params success:^(id json) {
//        DLog(@"投递记录删除成功 %@",json);
    } failure:^(NSString *error) {
        DLog(@"投递记录删除失败 %@",error);
    }];
}

#pragma mark 筛选工具条的代理方法
- (void)screeningView:(TZJobListScreeningView *)screeningView didClickButtonType:(TZScreeningViewButtonType)type {
  
    

    if (type == self.segType) {
        //close
        [self openArea:NO withType:type];
    }else{
        //open
        [self openArea:YES withType:type];
        self.segType = type;
    }
    
   
//    switch (type) {
//        case TZScreeningViewButtonTypeArea: // 区域
//
//            self.isShowingArray = self.areas;
//            break;
//        case TZScreeningViewButtonTypeSalary: // 薪水
//
//            self.isShowingArray = self.salarys;
//            break;
//        case TZScreeningViewButtonTypeWelfare: // 福利
//
//            self.isShowingArray = self.welfares;
//            break;
//        case TZScreeningViewButtonTypeScreening: // 筛选
//            [self screening];return;
//            break;
//        default:
//            break;
//    }
//    [self.screeningTableView reloadData];
//    self.screeningView.downMoreView = YES;
//
//    // 动画形式展现出来/缩放回去，并记录用户的选中筛选属性
//     [UIView animateWithDuration:0.25 animations:^{  //close
//        if (self.screeningcover.height == (__kScreenHeight - 108) ) {
//            self.screeningTableView.height = 0;
//            self.screeningcover.height = 0;
//            self.screeningView.downMoreView = YES;
//        } else {  //open
//
//            self.screeningTableView.height = MIN(self.isShowingArray.count * 35, __kScreenHeight - 200);
//            self.screeningcover.height = __kScreenHeight - 108;
//            NSNumber *number = [[NSNumber alloc] init];
//            switch (self.segType) {
//                case 1:
//                    self.screeningView.upAreaMoreView = YES;
//                    number = self.userSelected[0];
//                    break;
//                case 2:
//                    self.screeningView.upSalaryMoreView = YES;
//                    number = self.userSelected[2];
//                    break;
//                case 3:
//                    self.screeningView.upWelfareMoreView = YES;
//                    number = self.userSelected[3];
//                    break;
//                default:
//                    break;
//            }
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:number.integerValue inSection:0];
//            [self.screeningTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//        }
//     }];
}


-(void)openArea:(BOOL)open withType:(TZScreeningViewButtonType)type{
    if (open) {
           [UIView animateWithDuration:0.25 animations:^{
            if(type == TZScreeningViewButtonTypeArea){
                self.areaFilterView.height = 280;
                self.salaryFilterView.height = 0;
                self.welfareFilterView.height = 0;
                self.screeningcover.height = __kScreenHeight - 108;
            }else if (type == TZScreeningViewButtonTypeSalary){
                self.areaFilterView.height = 0;
                self.salaryFilterView.height = 220;
                self.welfareFilterView.height = 0;
                self.screeningcover.height = __kScreenHeight - 108;
            }else if(type == TZScreeningViewButtonTypeWelfare){
                self.areaFilterView.height = 0;
                self.salaryFilterView.height = 0;
                self.welfareFilterView.height = 220;
                self.screeningcover.height = __kScreenHeight - 108;
            }else if(type == TZScreeningViewButtonTypeScreening){//筛选
                self.areaFilterView.height = 0;
                self.salaryFilterView.height = 0;
                self.welfareFilterView.height = 0;
                self.screeningcover.height = 0;
    //            self.areaFilterView.height = MIN(self.isShowingArray.count * 35, __kScreenHeight - 200);
    //            self.screeningcover.height = __kScreenHeight - 108;
            }else{
                
            }
           }];
//        [self.areaPickerCollectionView reloadData];
//        [self.salaryPickerCollectionView reloadData];
//        [self.welfarePickerCollectionView reloadData];
        if(type == TZScreeningViewButtonTypeScreening){
            [self screening];
        }
    }else{//close
        [self hideAllFilterView];
    }
}
-(void)hideAllFilterView{
    self.segType = TZScreeningViewButtonTypeNone;

    [UIView animateWithDuration:0.25 animations:^{
        self.areaFilterView.height = 0;
        self.salaryFilterView.height = 0;
        self.welfareFilterView.height = 0;
        self.screeningcover.height = 0;
    }];
}
//
// 点击一次收起 点击一次打开
//收起的时候所有的都是 y = 0；
//打开的时候当前的y 设置成原来的大小

- (void)coverDidClick:(UIButton *)cover {
    [self hideAllFilterView];
//    [UIView animateWithDuration:0.1 animations:^{
//        self.screeningTableView.height = 0;
//        self.screeningcover.height = 0;
//    }];
//    self.screeningView.hideTipsView = YES;
//    self.screeningView.downMoreView = YES;
}

#pragma mark TZJobApplyViewDelegate

/** 申请职位 */
- (void)jobApplyDidClickButton {
    
    if (![TZUserManager isLogin]) return;
    NSString *recruit_id = [self.recruit_ids componentsJoinedByString:@","];
    // 拼参数
    NSDictionary *params = @{@"recruit_id":recruit_id,@"sessionid":[mUserDefaults objectForKey:@"sessionid"]};
    // 发请求
    [TZHttpTool postWithURL:ApiSnsDeliver params:params success:^(id json) {
        [self showInfo:@"投递成功"];
    } failure:^(NSString *error) {
        DLog(@"简历投递失败 %@",error);
        [self showInfo:error];
    }];
}

#pragma mark 其他方法
/** 根据indexPath更新用户选择的筛选信息 */
- (void)updateUserSelectedArray:(NSIndexPath *)indexPath {
    
    if(self.areaFilterView.height>0){
        [self.userSelected replaceObjectAtIndex:0 withObject:@(indexPath.row)];

    }
    if(self.salaryFilterView.height>0){
        [self.userSelected replaceObjectAtIndex:1 withObject:@(indexPath.row)];

    }
    if(self.welfareFilterView.height >0){
        [self.userSelected replaceObjectAtIndex:2 withObject:@(indexPath.row)];
    }

}

/** 动画隐藏tableView */
- (void)animToHideTableView {
    [UIView animateWithDuration:0.1 animations:^{
        self.screeningTableView.height = 0;
        self.screeningcover.height = 0;
    }];
    self.screeningView.hideTipsView = YES;
}

#pragma mark TZJobListCellDelegate
- (void)jobListCellDidClickCheckBtn:(UIButton *)checkBtn recruit_id:(NSString *)recruit_id{
    self.applyView.hidden = NO;
    if (checkBtn.selected == YES) {
        // 显示申请框
        self.JobSelectedCount++;
        [UIView animateWithDuration:0.15 animations:^{
            self.applyView.y = __kScreenHeight - 124;
        }];
        [self.recruit_ids addObject:recruit_id];
    } else {
        // 隐藏申请框
        self.JobSelectedCount--;
        if (self.JobSelectedCount == 0) {
            [UIView animateWithDuration:0.15 animations:^{
                self.applyView.y = __kScreenHeight - 64;
            }];
        }
        [self.recruit_ids removeObject:recruit_id];
    }
}

#pragma mark 按钮点击

/** 高级筛选，去筛选控制器 */
- (void)screening {
    TZScreeningViewController *screeningVc = [[TZScreeningViewController alloc] initWithNibName:@"TZScreeningViewController" bundle:nil];
    screeningVc.jobTitle = self.jobTitle;
    screeningVc.isSearch = self.type == TZJobListViewControllerTypeSearch ? YES : NO;
    screeningVc.welfares = self.welfares;
    
    // 1、给筛选控制器初值
    NSMutableDictionary *filterResultDic = [NSMutableDictionary dictionary];
    NSString *screeningItem;

    
    screeningItem = [self.screeningView.areaBtn.titleLabel.text isEqualToString:@"区域"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"]:self.screeningView.areaBtn.titleLabel.text;
     [filterResultDic setObject:screeningItem forKey:@"area"];
    

    
    screeningItem = [self.screeningView.salaryBtn.titleLabel.text isEqualToString:@"薪资"] ? @"不限":self.screeningView.salaryBtn.titleLabel.text;
     [filterResultDic setObject:screeningItem forKey:@"salary"];
    
    screeningItem = [self.screeningView.welfareBtn.titleLabel.text isEqualToString:@"福利"] ? @"不限":self.screeningView.welfareBtn.titleLabel.text;
     [filterResultDic setObject:screeningItem forKey:@"welfare"];
    

    
    if (self.filterResultDic != nil) {
        [filterResultDic setObject:self.filterResultDic[@"job"] forKey:@"job"];
        [filterResultDic setObject:self.filterResultDic[@"trustDegree"] forKey:@"trustDegree"];
        [filterResultDic setObject:self.filterResultDic[@"exp"] forKey:@"exp"];
        [filterResultDic setObject:self.filterResultDic[@"origin"] forKey:@"origin"];
        
        screeningVc.laid = self.laid;
    } else {
        [filterResultDic setObject:@"不限" forKey:@"job"];
        [filterResultDic setObject:@"不限"forKey:@"trustDegree"];
        [filterResultDic setObject:@"不限" forKey:@"exp"];
        [filterResultDic setObject:@"不限" forKey:@"origin"];
    }
     screeningVc.resultDic = filterResultDic;
    // 2、定义block  2.1 拿到用户的筛选数据，改变UI，重新发请求   2.2 screeningInfosForUI 改变UI用的数组【三个数据】  2.3 filterResultDic 重新发请求用的数组【全部数据】
     screeningVc.returnScreeningInfoBlock = ^(NSDictionary *resultDic,NSString *laid,BOOL isHotJobType){
        self.laid = laid;
        self.isHotJobType = isHotJobType;
        self.filterResultDic = [NSMutableDictionary dictionaryWithDictionary:filterResultDic];
        
//        (不限,
//        无锡,
//        2001-3000元/月,
//        工作餐,
//        1星,
//        1~3年,
//        开心直招
//        )
        
        // 2.1、改变UI
         // 区域
         NSString *areaStr = self.filterResultDic[@"area"];
         self.address = areaStr;
         if ([areaStr hasPrefix:@"全"]) {
             
             [self.screeningView.areaBtn setTitle:@"区域" forState:UIControlStateNormal];
         } else {
             [self.screeningView.areaBtn setTitle:areaStr forState:UIControlStateNormal];
         }
         // 薪资
         NSString *salaryStr = self.filterResultDic[@"salary"];
         if ([salaryStr isEqualToString:@"不限"]) {
             [self.screeningView.salaryBtn setTitle:@"薪资" forState:UIControlStateNormal];
         } else {
             [self.screeningView.salaryBtn setTitle:salaryStr forState:UIControlStateNormal];
         }
         // 福利
         NSString *welStr = self.filterResultDic[@"welfare"];
         if ([welStr isEqualToString:@"不限"]) {
             [self.screeningView.welfareBtn setTitle:@"福利" forState:UIControlStateNormal];
         } else {
             [self.screeningView.welfareBtn setTitle:welStr forState:UIControlStateNormal];
         }

        
        // 2.2、用户选择好了筛选数据，重新发请求加载新的职位列表
        [self reloadSearchData];
    };
    [self.navigationController pushViewController:screeningVc animated:YES];
}

/** 搜索，进入搜索页 */
- (void)goSearch {
    TZSearchViewController *searchVc = [[TZSearchViewController alloc] initWithNibName:@"TZSearchViewController" bundle:nil];
    [self.navigationController pushViewController:searchVc animated:YES];
}

/** 去创建简历 */
- (void)goCreateResume {
    // 设置全局单例对象登录信息
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    // 这里控制标签栏的登录 通过 ! 取反
    if (!userModel.isLogin || !userModel.isHXLogin) {
        ICELoginViewController *iCELogin = [[ICELoginViewController alloc] initWithNibName:@"ICELoginViewController" bundle:[NSBundle mainBundle]];
        iCELogin.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        TZNaviController *navi = [[TZNaviController alloc] initWithRootViewController:iCELogin];
        [self presentViewController:navi animated:YES completion:nil];
    } else {
        XYCreateResumeViewController *createResumeVc = [[XYCreateResumeViewController alloc] init];
        [self.navigationController pushViewController:createResumeVc animated:YES];
    }
}

#pragma mark 搜索相关

/** 发送搜索请求的方法 */
- (void)reloadSearchData {
#warning TODO 理论上 这里还要有参数 职位类别 和 type等 表明是搜索校园招聘里的还是说搜索入职返现里面的等等? ...
    /*
     'keywords' String 关键词
     'address'  String 地址   传id如1代表北京
     'welfare'  String 福利   如947#948
     'salary'   String 薪资   如600108000以上都不是必须参数
     */
    
    
//    keywords	否	String	职位关键词
//    address	否	String	区域(中文)
//    salary	否	String	薪资0=不限 1=面议 2000=2000元/月以下 200103000=2001-3000元/月 300105000=3001-5000元/月 500108000=5001-8000元/月 800110000=8001-10000元/月1000115000=10001-15000元/月1500025000=15001-25000元/月2500000000=25001元/月以上
//    welfare	否	int	945代表包住宿946班车947工作餐948入职返现949季度旅游950节日福利951五险一金952加班补助953年底双薪1010五险
//    class_id	否	int	二级或三级分类id,传一个后台会查出二级或者三级的职位
//    origin	否	int	0全部1开心直招2企业直招3代招
//    star	否	int	0不限12345各代表1~5星
//    work_exp	否	int	0=不限 1=无经验 2=1年以下 3=1-3年 4=3-5年 5=5-10年 6=10年以上
//    jobType	否	int	1全职2放心企业3附近4兼职5入职返现6包吃住7校园招聘8海外
//    lng	否	String	经度
//    lat	否	String	纬度
//    page
    
    self.isSearch = YES;
    self.page = 1;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 新0:laid  如果是从职位类别处进来的  搜索的时候也传laid
    if (self.laid != nil && ![self.laid isEqualToString:@""]) {
        if (self.isFromHotJob) {
            params[@"class_id"] = self.laid;
        } else {
            params[@"laid"] = self.laid;
        }
    }
    // 新1:页数page
    params[@"page"] = [NSString stringWithFormat:@"%zd",self.pageSearch];
    
    // 0、配置关键词参数  可以是职位名和公司名
//    params[@"keywords"] = [self getNewKeywords];
    
    if (self.address.length > 0) {
          params[@"address"] = [self getNewAddressFromAddress:self.address];
    } else {
        // 1、配置区域参数
       
        params[@"address"] = [self getNewAddressFromAddress:@"区域"];
    }    

    // 2、配置福利参数
    NSString *welfare = self.screeningView.welfareBtn.titleLabel.text;
    if (![welfare isEqualToString:@"福利"]) {
        params[@"welfare"] = [self getNewWorkexpFromWelfare:welfare];
    }
    
    if (self.salary.length > 0) {
        params[@"salary"] = self.salary;
    } else {
        // 3、配置薪水参数
        NSString *salary = self.screeningView.salaryBtn.titleLabel.text;
        if (![salary isEqualToString:@"薪资"]) {
            params[@"salary"] = [self getNewSalaryFromSalray:salary];
        }
    }
    

    // 4、配置工作经验参数
    NSInteger paramsCount = 8;
    if (self.filterResultDic.count >0) {
        params[@"work_exp"] = [self getNewWorkexpFromWorkexp:self.filterResultDic[@"exp"]];
    
    // 5、配置信誉度参数
   
        NSString *star = [self.filterResultDic[@"trustDegree"] substringToIndex:1];
        if (![star isEqualToString:@"不"]) {
            params[@"star"] = star;
        }
    
    // 6、配置来源参数
    
        NSString *origin = self.filterResultDic[@"origin"];
        params[@"origin"] = [self getOirginFrom:origin];
    
    
    // 7、配置职位分类参数

        if (![self.filterResultDic[@"job"] isEqualToString:@"不限"]) {
            if (self.isHotJobType) {
                params[@"class_id"] = self.laid;
            } else {
                params[@"laid"] = self.laid;
            }
        }
        
    }

    // 其他筛选参数暂不处理
    switch (_type) {
        case TZJobListViewControllerTypeNormal:
            params[@"jobType"] = @"1";
            break;
        case TZJobListViewControllerTypeRelievedCompany:
            params[@"jobType"] = @"2";
            break;
        case TZJobListViewControllerTypeNearbyJob:
            params[@"jobType"] = @"3";
            params[@"lng"] = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]]; // 经度
            params[@"lat"] = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]];  // 维度
            break;
        case TZJobListViewControllerTypePartTimeJob:
            params[@"jobType"] = @"4";
            break;
        case TZJobListViewControllerTypeReturnMoney:
            params[@"jobType"] = @"5";
            break;
        case TZJobListViewControllerTypeEatJob:
            params[@"jobType"] = @"6";
            break;
        case TZJobListViewControllerTypeSchoolJob:
            params[@"jobType"] = @"7";
            break;
         case TZJobListViewControllerTypeOverseasJob:
            params[@"jobType"] = @"8";
            break;
        default:
            break;
    }
    // 8、发请求
    [TZHttpTool postWithURL:ApiSnsRecruitList params:params success:^(id json) {
        // 获取总页数
        NSNumber *totlaCount = json[@"data"][@"count_page"];
        self.totalCount = totlaCount.integerValue;
        // 更新数据，刷新tableView

        NSArray *jobs = [TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]];
        if (self.pageSearch == 1) {
            [self.jobs removeAllObjects];
        }
        [self.jobs addObjectsFromArray:jobs];
        [self.tableView endRefreshAndReloadData];
    } failure:^(NSString *msg) {
        DLog(@"搜索 %@  失败 responseObject %@",params[@"keywords"],msg);
        [self.jobs removeAllObjects];
        [self.tableView endRefreshAndReloadData];
    }];
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
        newSalary = @"2000";
    } else if ([salary isEqualToString:@"2001-3000元/月"]) {
        newSalary = @"200103000";
    } else if ([salary isEqualToString:@"3001-5000元/月"]) {
        newSalary = @"300105000";
    } else if ([salary isEqualToString:@"5001-8000元/月"]) {
        newSalary = @"500108000";
    } else if ([salary isEqualToString:@"8001-10000元/月"]) {
        newSalary = @"800110000";
    } else if ([salary isEqualToString:@"10001-15000元/月"]) {
        newSalary = @"1000115000";
    } else if ([salary isEqualToString:@"15001-25000元/月"]) {
        newSalary = @"1500025000";
    } else if ([salary isEqualToString:@"25001元/月以上"]) {
        newSalary = @"2500000000";
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
//- (NSString *)getNewKeywords {
//    NSString *keywords = @"";
//    // 确定关键字参数
//    if (![self.filterResultDic[5] isEqualToString:@"输入关键词"]) { // 高级筛选控制器带回来的关键字,覆盖之前选择的第三级职位
//        keywords = self.filterResultDic[5];
//        if (keywords != nil && ![keywords isEqualToString:@""]) {
//            self.jobTitle = keywords;
//        }
//    }
//    if (self.type == TZJobListViewControllerTypeSearch && ([keywords isEqualToString:@""] || keywords == nil)) {
//        keywords = self.jobTitle;
//    }
//    return keywords;
//}

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
    
    return nil;
}


- (NSString *)getOirginFrom:(NSString *)origin {
    if ([origin isEqualToString:@"全部"]) { return @"0"; }
    if ([origin isEqualToString:@"开心直招"]) { return @"1"; }
    if ([origin isEqualToString:@"企业直招"]) { return @"2"; }
    if ([origin isEqualToString:@"代招"]) { return @"3"; }
    return nil;
}



#pragma mark 通知方法 收藏职位 刷新数据

- (void)haveCancleCollection {
    if (self.type == TZJobListViewControllerTypeCollction) { // 刷新收藏列表
        [self loadNetData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     NSLog(@"zhangying  ---TZJoblistviewcontroller  dealloc");
}

- (void)showBack {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(actionBackLeft) image:@"navi_back" highImage:@"navi_back"];
}

- (void)actionBackLeft {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
