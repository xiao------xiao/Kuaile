//
//  ZYHomeViewController.m
//  kuaileNew
//
//  Created by admin on 2018/11/21.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ZYHomeViewController.h"
#import "TZJobListCell.h"
#import "TZNaviBarView.h"
#import "TZFullTimeJobViewController.h"
#import "LFindLocationViewController.h"
#import "ZJQRController.h"
#import "TZJobDetailViewController.h"
#import "TZJobModel.h"
#import "HomeAdCell.h"
#import "HomeSectionHeaderView.h"
#import "HomeSquareCell.h"

#import "TZScreeningViewController.h"
#import "TZJobListViewController.h"
#import "XYFinishRegisterViewController.h"
static const NSString *HomeAdCellIdentify = @"HomeAdCell";

@interface ZYHomeViewController ()<UITableViewDelegate,UITableViewDataSource,LFindLocationViewControllerDelegete,HomeSectionHeaderViewDelegate>
//@property(nonatomic,retain)  UIScrollView *scrollview;
/** 顶部轮播图 */
//@property (strong, nonatomic) IBOutlet UIScrollView *topScrollView;

@property (nonatomic, strong) TZNaviBarView *naviBar;
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int totoalPage;
@property(nonatomic,retain) NSNumber *high_salary;
//@property(nonatomic,copy) NSString *salary;

@property(nonatomic,retain) UITableView *tableview;
@property(nonatomic,retain)NSMutableArray *jobs;

//@property (nonatomic, copy) NSString *address;
/** 新参数，职位分类的id */
@property (nonatomic, copy) NSString *laid;
@property (nonatomic, copy) NSString *jobTitle;
@property (nonatomic, copy) NSString *salary; //test  是否有必要存在 ？
/** 筛选控制器返回的筛选数组 */
@property (nonatomic, strong) NSMutableDictionary *filterResultDic;
@property (nonatomic, assign) BOOL isHotJob; // 是否是在筛选热门职位 参数名为class 否则为laid

@property (nonatomic, strong) NSArray *welfares; //福利
@property (nonatomic, assign) TZJobListViewControllerType type;

@property (nonatomic, assign) NSInteger sectionIndex;
@end

@implementation ZYHomeViewController
+ (void)load {
    NSString *userCity = [mUserDefaults objectForKey:@"userCity"];
    if (userCity == nil || [userCity isEqualToString:@""] || userCity.length < 1) {
        [mUserDefaults setObject:@"无锡" forKey:@"userCity"];
        [mUserDefaults synchronize];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.type = TZJobListViewControllerTypeNormal;
    _jobs = [NSMutableArray array];
//    self.salary = @"";
    
    [self resetData];
   
    [self setupView];
    [self loadRecruitList];
    [self loadNetAllWelfares];
  
    MJWeakSelf
    self.tableview.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf loadRecruitList];
        [weakSelf.tableview endRefresh];
    }];
//    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 0;
//        [weakSelf loadRecruitList];
//        [weakSelf.tableview endRefresh];
//    }];
  
    [self.tableview registerClass:[HomeAdCell class] forCellReuseIdentifier:HomeAdCellIdentify];
    
    // 1.取定位城市
    [self upDateCurrentCityUI:[[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"]];
    // 2.成功定位后的通知，更新成定位城市
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateToLocation) name:@"didUpdateToLocation" object:nil];
}


-(void)setupView{
    
    [self.view addSubview:self.tableview];
 
    [self configTZNaviBarView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableview.backgroundColor = kCOLOR_WHITE;
    self.tableview.tableHeaderView = nil;

    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    if (@available(iOS 11.0, *)) {
        self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"back" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 50);
    [self.view addSubview:btn];
    MJWeakSelf
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    
}

//热门工作
/** 加载今日高薪数据 */


-(void)resetData{
    self.page =1;
    self.totoalPage = 0;
    self.high_salary = @0;
    self.laid =@"";
    self.jobTitle = @"";
    [self.filterResultDic removeAllObjects];
    self.isHotJob = NO;
//    self.address = @"";
    
    
    
}
-(void)waitForDeveloped{
    [self showInfo:@"该功能模块还在开发中"];
    
    
}


/** //负责筛选模块的刷新显示  */
- (void)reloadSearchData {
#warning TODO 理论上 这里还要有参数 职位类别 和 type等 表明是搜索校园招聘里的还是说搜索入职返现里面的等等? ...
    /*
     'keywords' String 关键词
     'address'  String 地址   传id如1代表北京
     'welfare'  String 福利   如947#948
     'salary'   String 薪资   如600108000以上都不是必须参数
     */
    
    
    //    keywords    否    String    职位关键词
    //    address    否    String    区域(中文)
    //    salary    否    String    薪资0=不限 1=面议 2000=2000元/月以下 200103000=2001-3000元/月 300105000=3001-5000元/月 500108000=5001-8000元/月 800110000=8001-10000元/月1000115000=10001-15000元/月1500025000=15001-25000元/月2500000000=25001元/月以上
    //    welfare    否    int    945代表包住宿946班车947工作餐948入职返现949季度旅游950节日福利951五险一金952加班补助953年底双薪1010五险
    //    class_id    否    int    二级或三级分类id,传一个后台会查出二级或者三级的职位
    //    origin    否    int    0全部1开心直招2企业直招3代招
    //    star    否    int    0不限12345各代表1~5星
    //    work_exp    否    int    0=不限 1=无经验 2=1年以下 3=1-3年 4=3-5年 5=5-10年 6=10年以上
    //    jobType    否    int    1全职2放心企业3附近4兼职5入职返现6包吃住7校园招聘8海外
    //    lng    否    String    经度
    //    lat    否    String    纬度
    //    page
    
//    self.isSearch = YES;

    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 新0:laid  如果是从职位类别处进来的  搜索的时候也传laid
    if (self.laid != nil && ![self.laid isEqualToString:@""]) {
        if (self.isHotJob) {
            params[@"class_id"] = self.laid;
        } else {
            params[@"laid"] = self.laid;
        }
    }
    // 新1:页数page
    if(self.page==1){
        
    }else if (self.totoalPage>0&&self.totoalPage==self.page){ //最后一页
        [self showInfo:@"没有更多了"];
        return;
    }else{
        self.page++;
    }
    params[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    
    // 0、配置关键词参数  可以是职位名和公司名
    //    params[@"keywords"] = [self getNewKeywords];
    
 
    // 2、配置福利参数
    if (self.filterResultDic.count>0) {
        params[@"welfare"] = [self getNewWorkexpFromWelfare:self.filterResultDic[@"welfare"]];
    }
    
    NSString *address = self.filterResultDic[@"area"];
    if([address isEqualToString:@"不限"]){
        params[@"address"] = NotNullStr([mUserDefaults objectForKey:@"userCity"]);

    }else{
        params[@"address"] = address;
    }
    
//    if (self.salary.length > 0) {
//        params[@"salary"] = self.salary;
//    } else {
        // 3、配置薪水参数
        if (self.filterResultDic.count>0) {
            params[@"salary"] = [self getNewSalaryFromSalray:self.filterResultDic[@"salary"]];
        }
//    }
    
    // 4、配置工作经验参数
    NSInteger paramsCount = 7;
    if (self.filterResultDic.count == paramsCount) {
        NSString *work_exp = self.filterResultDic[@"exp"];
        params[@"work_exp"] = [self getNewWorkexpFromWorkexp:work_exp];
    }
    // 5、配置信誉度参数
    if (self.filterResultDic.count == paramsCount) {  // star  1 2 3 4 5
        NSString *star = [self.filterResultDic[@"trustDegree"] substringToIndex:1];
        if (![star isEqualToString:@"不"]) {
            params[@"star"] = star;
        }
    }
    // 6、配置来源参数
    if (self.filterResultDic.count == paramsCount) {
        NSString *origin = self.filterResultDic[@"origin"];
        params[@"origin"] = [self getOirginFrom:origin];
    }
    
    // 7、配置职位分类参数
    if (self.filterResultDic.count == paramsCount) {  // laid
        if (![self.filterResultDic[@"job"] isEqualToString:@"不限"]) {
            if (self.isHotJob) {
                params[@"class_id"] = self.laid;
            } else {
                params[@"laid"] = self.laid;
            }
        }
        
    }
    
    // 其他筛选参数暂不处理
//    switch (_type) {
//        case TZJobListViewControllerTypeNormal:
//            params[@"jobType"] = @"1";
//            break;
//        case TZJobListViewControllerTypeRelievedCompany:
//            params[@"jobType"] = @"2";
//            break;
//        case TZJobListViewControllerTypeNearbyJob:
//            params[@"jobType"] = @"3";
//            params[@"lng"] = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]]; // 经度
//            params[@"lat"] = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]];  // 维度
//            break;
//        case TZJobListViewControllerTypePartTimeJob:
//            params[@"jobType"] = @"4";
//            break;
//        case TZJobListViewControllerTypeReturnMoney:
//            params[@"jobType"] = @"5";
//            break;
//        case TZJobListViewControllerTypeEatJob:
//            params[@"jobType"] = @"6";
//            break;
//        case TZJobListViewControllerTypeSchoolJob:
//            params[@"jobType"] = @"7";
//            break;
//        case TZJobListViewControllerTypeOverseasJob:
//            params[@"jobType"] = @"8";
//            break;
//        default:
//            break;
//    }
    // 8、发请求
    [TZHttpTool postWithURL:ApiSnsRecruitList params:params success:^(id json) {
        // 获取总页数
        NSNumber *totlaCount = json[@"data"][@"count_page"];
        
        self.totoalPage = totlaCount.integerValue;
        // 更新数据，刷新tableView
        
        NSArray *jobs = [TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]];
        if (self.page == 1) {
            [self.jobs removeAllObjects];
        }
        [self.jobs addObjectsFromArray:jobs];
        
        [self.tableview endRefreshAndReloadData];
    } failure:^(NSString *msg) {
        DLog(@"搜索 %@  失败 responseObject %@",params[@"keywords"],msg);
        [self.jobs removeAllObjects];
        [self.tableview endRefreshAndReloadData];
    }];
}

// 上拉刷新    //负责全部职位 和 职位类型的刷新显示
- (void)loadRecruitList{
    
 
   
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
//    address
    

 
    [params setValue:NotNullStr([mUserDefaults objectForKey:@"userCity"]) forKey:@"address"];
    

    
    
//    if(self.high_salary >0){
//        [params setValue:self.high_salary forKey:@"high_salary"];
//    }
//    // 新0:laid  如果是从职位类别处进来的  搜索的时候也传laid
//    if (self.laid != nil && ![self.laid isEqualToString:@""]) { //二级或三级分类id,传一个后台会查出二级或者三级的职位
//        params[@"class_id"] = self.laid;
//    }
    if (self.totoalPage>0 &&self.page < self.totoalPage ) {
        self.page++;
    } else if (self.page == 1){ //  请求第一页的数据
        
    }else{  //最后一页
      
        [self showInfo:@"没有更多了"];
        return ;
    }
    // 新1:页数page
    params[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    
    // 0、配置关键词参数  可以是职位名和公司名
    //    params[@"keywords"] = [self getNewKeywords];

//    class_id   二级或三级分类id,传一个后台会查出二级或者三级的职位    int
//    origin  int  0全部1开心直招2企业直招3代招
//    welfare

    // 7、配置职位分类参数
    if (self.laid != nil && ![self.laid isEqualToString:@""]) {
        if (self.isHotJob) {
            params[@"class_id"] = self.laid;
        } else {
            params[@"laid"] = self.laid;
        }
    }
  
    if(self.jobTitle.length>0){
        params[@"keywords"] = self.jobTitle;
    }
////    jobType 1全职2放心企业3附近4兼职5入职返现6包吃住7校园招聘8海外
//    // 其他筛选参数暂不处理
//    switch (_type) {
//        case TZHomeViewControllerTypeNormal:
//            params[@"jobType"] = @"1";
//            break;
//        case TZHomeViewControllerTypeRelievedCompany:
//            params[@"jobType"] = @"2";
//            break;
//        case TZHomeViewControllerTypeNearbyJob:
//            params[@"jobType"] = @"3";
//            params[@"lng"] = [NSString stringWithFormat:@"%@",[mUserDefaults objectForKey:@"longitude"]]; // 经度
//            params[@"lat"] = [NSString stringWithFormat:@"%@",[mUserDefaults objectForKey:@"latitude"]];  // 维度
//            break;
//        case TZHomeViewControllerTypePartTimeJob:
//            params[@"jobType"] = @"4";
//            break;
//        case TZHomeViewControllerTypeReturnMoney:
//            params[@"jobType"] = @"5";
//            break;
//        case TZHomeViewControllerTypeEatJob:
//            params[@"jobType"] = @"6";
//            break;
//        case TZHomeViewControllerTypeSchoolJob:
//            params[@"jobType"] = @"7";
//            break;
//        case TZHomeViewControllerTypeOverseasJob:
//            params[@"jobType"] = @"8";
//            break;
//        default:
//            break;
//    }
   
    
    [TZHttpTool postWithURL:ApiSnsRecruitList params:params success:^(id json) {
        
        self.totoalPage = (int)json[@"data"][@"count_page"];
        if(self.page==1){
            [self.jobs removeAllObjects];
        }
        [self.jobs addObjectsFromArray:[TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"jobs"]]];
        [self.tableview reloadData];
    } failure:^(NSString *error) {
        
        DLog(@"今日高薪获取失败 error,%@",error);
        
    }];
}


/** 配置这个页面特有的naviBar */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
         [self.navigationController setNavigationBarHidden:YES animated:YES];
//    NSNumber *isAnimated = [mUserDefaults objectForKey:@"isAnimated"];
//    if (isAnimated.integerValue == 1) {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    } else {
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
//    }
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
#pragma mark - Functions
#pragma mark - 扫描二维码

- (void)codeScan {
    ZJQRController *QRvc = [[ZJQRController alloc] init];
    QRvc.title = @"扫描二维码";
    [self.navigationController pushViewController:QRvc animated:YES];
    //test 
//    XYFinishRegisterViewController *vc = [[XYFinishRegisterViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];

}
-(void)skipToZhiweiSearchViewController{
    TZFullTimeJobViewController *fullTimeVc = [[TZFullTimeJobViewController alloc] initWithNibName:@"TZFullTimeJobViewController" bundle:nil];
    fullTimeVc.type = TZFullTimeJobViewControllerJobType;
    MJWeakSelf
    fullTimeVc.returnJobType = ^(NSString *jobType,NSString *laid,TZFullTimeJobType laidOrClassJobType) {
        
    
        [weakSelf resetData];
        weakSelf.laid = laid;
        weakSelf.jobTitle  = jobType;
        if (laidOrClassJobType == TZFullTimeJobTypeHot) {
            weakSelf.isHotJob = YES;
        }else{
            weakSelf.isHotJob = NO;
        }
        [weakSelf reloadSearchData];
        //热门职位 or 全部职位
        
//        [self refreshCellDetailNamesWith:jobType];
    };
    [self.navigationController pushViewController:fullTimeVc animated:YES];
}

/** 高级筛选，去筛选控制器 */
- (void)skipToShaixuanViewController  {
    TZScreeningViewController *screeningVc = [[TZScreeningViewController alloc] initWithNibName:@"TZScreeningViewController" bundle:nil];
    screeningVc.jobTitle = self.jobTitle;
    screeningVc.welfares = self.welfares;
    
    // 1、给筛选控制器初值
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *screeningItem;
   
    [dic setObject:@"不限" forKey:@"job"];//默认 不限
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"] forKey:@"area"];//默认
    [dic setObject:@"不限" forKey:@"salary"];//默认 不限
    [dic setObject:@"不限" forKey:@"welfare"];//默认 不限
    [dic setObject:@"不限" forKey:@"trustDegree"];//默认 不限
    [dic setObject:@"不限" forKey:@"exp"];//默认 不限
    [dic setObject:@"不限" forKey:@"origin"];//默认 不限

    screeningVc.resultDic = dic;
    // 2、定义block  2.1 拿到用户的筛选数据，改变UI，重新发请求   2.2 screeningInfosForUI 改变UI用的数组【三个数据】  2.3 filterResultDic 重新发请求用的数组【全部数据】
    screeningVc.returnScreeningInfoBlock = ^(NSDictionary *resultDic,NSString *laid,BOOL isHotJobType){
        [self resetData];
        self.laid = laid;
        self.isHotJob = isHotJobType;
        
        self.filterResultDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
        
        //        (不限,
        //        无锡,
        //        2001-3000元/月,
        //        工作餐,
        //        1星,
        //        1~3年,
        //        开心直招
        //        )
       
        
        [self reloadSearchData];
    };
    // 2.2、用户选择好了筛选数据，重新发请求加载新的职位列表
    



   [self.navigationController pushViewController:screeningVc animated:YES];
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

#pragma mark - LFindLocationViewControllerDelegete 城市选择
- (void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation {
    // 1.储存选择的城市 && 2.更新UI
    [self upDateCurrentCityUI:city];
    // 3.刷新今日高薪职位列表
    [self resetData];
    [self loadRecruitList];
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
//    [_screenView.areaBtn setTitle:city forState:UIControlStateNormal];
    _naviBar.btnCity.imageEdgeInsets = UIEdgeInsetsMake(0, left, 0, 0);
    _naviBar.btnCityWidthContraint.constant = width;
    // 更新约束
//    [self updateTableViewContraint];
}

// 定位成功后调用
- (void)didUpdateToLocation {
    //    DLog(@"当前经度:%@,维度:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]);
    [self upDateCurrentCityUI:[mUserDefaults objectForKey:@"userCity"]];
}
- (void)pushToJobListVcWithType:(TZJobListViewControllerType)type title:(NSString *)title hotjobs:(BOOL)hotjob{
    TZJobListViewController *jobListVc = [[TZJobListViewController alloc] initWithNibName:@"TZJobListViewController" bundle:nil];
    jobListVc.type = type;
    jobListVc.shaixuanHotJobs = hotjob;
    [self.navigationController pushViewController:jobListVc animated:YES];
}


#pragma mark - HomeSectionHeaderViewDelegate
-(void)segmentIndex:(int)segIndex{
    self.sectionIndex = segIndex;
    if (segIndex ==0) { //全部职位
        NSLog(@"全部职位j");
        [self resetData];
        [self loadRecruitList];
        
    }else if (segIndex ==1){ //职位类型
        NSLog(@"职位类型");
        
        [self skipToZhiweiSearchViewController];
    }else if (segIndex ==2){ //离我最近
        NSLog(@"离我最近");
        [self waitForDeveloped];
    }else{       //筛选
        NSLog(@"筛选");
        [self skipToShaixuanViewController];
    }
}


#pragma mark - tableView的数据源/代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 1;
    }else if (section ==1){
        return 1;
    }else{
        return self.jobs.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        HomeAdCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeAdCellIdentify forIndexPath:indexPath];
        MJWeakSelf
        cell.imageClickedBlock = ^(NSString *url, NSString *title) {
            [weakSelf pushWebVcWithUrl:url title:title];
        };
        return cell;
        
    }else if (indexPath.section == 1){
        HomeSquareCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeSquareCell"];
        if (cell == nil) {
            cell = [HomeSquareCell xibCell];
        }
        MJWeakSelf
        cell.blockSquareViewPressed = ^(int tagIndex) {
            switch (tagIndex) {
                case 1: //入职返现
                    NSLog(@"入职返现");
                     [weakSelf pushToJobListVcWithType:TZJobListViewControllerTypeReturnMoney title:@"入职返现" hotjobs:NO];
                    break;
                case 2: //热门工作
                    NSLog(@"热门工作");
                     [weakSelf pushToJobListVcWithType:TZJobListViewControllerTypeNormal title:@"入职返现" hotjobs:YES];
                    break;
                case 3: //服务门店
                    NSLog(@"服务门店");
                       [self waitForDeveloped];
                    break;
                case 4: //推荐有奖
                    NSLog(@"推荐有奖");
                       [self waitForDeveloped];
                    break;
                case 5:   //高薪急招
                    NSLog(@"高薪急招");
                    [self waitForDeveloped];
                    break;
                case 6:   //全名经纪人
                    NSLog(@"全名经纪人");
                       [self waitForDeveloped];
                    break;
                default:
                    break;
            }
        };
        
        return cell;
       
    }else{
    
        static NSString *cellIdentify = @"jobList_cell";
        TZJobListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell == nil) {
            cell = [[TZJobListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }
        cell.model = self.jobs[indexPath.row];
        cell.type = TZJobListCellTypeHighSalary;
        [cell addSubview:[UIView divideViewWithHeight:cell.height]];
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        return [HomeAdCell cellHeight];
    }else if (indexPath.section ==1){
        return [HomeSquareCell cellHeight];
    }else {
    
    
//    if (tableView == self.tableView) {
        TZJobModel *model = self.jobs[indexPath.row];
        CGFloat cellH;
        
        if ([model.fan isEqualToString:@"1"]) {
            cellH = 181;
        } else {
            cellH = 133;
        }
       return cellH;
    }
   
//        if (tableView == self.tableView) {
//            if (self.type == TZHomeViewControllerTypeHistory) {
//                return cellH + 55;
//            } else {
//                return cellH;
//            }
//        }
//    }else {
//        return 35;
//    }
//    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==2) {
       
    // 跳转到详情控制器
    TZJobDetailViewController *detailVc = [[TZJobDetailViewController alloc] initWithNibName:@"TZJobDetailViewController" bundle:nil];
    TZJobModel *model = self.jobs[indexPath.row];
    detailVc.recruit_id = model.recruit_id;
    detailVc.fanXian = model.fan;
    [self.navigationController pushViewController:detailVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
        
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0||section ==1){
        return 0.001f;
        
    }else{
        return [HomeSectionHeaderView cellHeight];
    }
}
//自定义section的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0||section ==1){
        return nil;
    }else{
    HomeSectionHeaderView *headerview = [[HomeSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [HomeSectionHeaderView cellHeight])];
    headerview.delegate = self;
    headerview.index = self.sectionIndex;
        return headerview;
    }
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];//创建一个视图
//    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
//    UIImage *image = [UIImage imageNamed:@"4-2.png"];
//    [headerImageView setImage:image];
//    [headerView addSubview:headerImageView];
//    [headerImageView release];
//
//    NSString  *createTime = [self.keysArray objectAtIndex:section];
//    createTime = [createTime stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"-"];
//    createTime = [createTime stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"-"];
//
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, 150, 20)];
//    headerLabel.backgroundColor = [UIColor clearColor];
//    headerLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    headerLabel.textColor = [UIColor blueColor];
//    headerLabel.text = createTime;
//    [headerView addSubview:headerLabel];
//    [headerLabel release];
//
//    return headerView;
}
// 让导航条也跟着scrollView滑
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableview) {
        // 1.让导航条背景色的透明度变化 130是范围 越大渐变越慢
        CGPoint offSet = scrollView.contentOffset;
        CGFloat alpha = 0;
        alpha = (offSet.y) / 130;
        self.naviBar.bgColorView.alpha = alpha;
    }
}


#pragma mark - Private Functions
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

/// 跳转到网页
- (void)pushWebVcWithUrl:(NSString *)url title:(NSString *)title {
    [self pushWebVcWithUrl:url shareImage:nil title:title content:nil];
}

- (void)pushWebVcWithFilename:(NSString *)filename title:(NSString *)title {
    TZWebViewController *vc = [TZWebViewController new];
    vc.navTitle = title;
    vc.filename = filename;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushWebVcWithUrl:(NSString *)url shareImage:(id)shareImage title:(NSString *)title content:(NSString *)content {
    TZWebViewController *vc = [TZWebViewController new];
    vc.shareTitle = title;
    vc.shareContent = content;
    if ([url isKindOfClass:[NSURL class]]) {
        NSURL *shareUrl = (NSURL *)url;
        vc.url = shareUrl.absoluteString;
    } else {
        vc.url = url;
    }
    if ([shareImage isKindOfClass:[UIImage class]]) {
        vc.shareImage = shareImage;
    } else if ([shareImage isKindOfClass:[NSURL class]]) {
        NSURL *shareImageUrl = (NSURL *)shareImage;
        vc.shareImageUrlStr = shareImageUrl.absoluteString;
    } else if ([shareImage isKindOfClass:[NSString class]]) {
        vc.shareImageUrlStr = shareImage;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Getter and Setter
-(UITableView *)tableview{
    if(!_tableview){
        _tableview = [[UITableView alloc] init];
        _tableview.dataSource = self;
        _tableview.delegate = self;
       
    }
    return _tableview;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
