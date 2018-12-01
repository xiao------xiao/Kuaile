//
//  TZFullTimeJobViewController.m
//  HappyWork
//
//  Created by liujingyi on 15/9/10.
//  Copyright (c) 2015年 memberwine. All rights reserved.
//

#import "TZFullTimeJobViewController.h"
#import "HWSearchBar.h"
#import "UIView+Extension.h"
#import "TZJobCell.h"
#import "TZHistoryJobsTool.h"
#import "TZSearchViewController.h"
#import "TZJobListViewController.h"
#import "UIImageView+EMWebCache.h"
#import "WebViewJavascriptBridge.h"

#define TZSelectedColor [UIColor colorWithRed:73/255.0 green:196/255.0 blue:246/255.0 alpha:1]
#define TZNonSelectedColor [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1]
#define TZLightGrayColor [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1]
#define TZScreenWidth [UIScreen mainScreen].bounds.size.width
#define TZScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TZFullTimeJobViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UIWebViewDelegate>
/** 工具条相关（热门职位/全部职位）*/
- (IBAction)hotJobButtonClick:(UIButton *)sender;
- (IBAction)allJobButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *hotJobButton;
@property (strong, nonatomic) IBOutlet UIButton *allJobButton;
@property (strong, nonatomic) IBOutlet UIView *leftIndicateLine;
@property (strong, nonatomic) IBOutlet UIView *rightIndicateLine;

/** 浏览记录相关 */
@property (strong, nonatomic) IBOutlet UIView *historyJob; // 点击全部职位时隐藏
- (IBAction)clearHistoryButton:(UIButton *)sender;
@property (nonatomic, strong) NSArray *historyJobs;
@property (strong, nonatomic) IBOutlet UILabel *tipLable;
@property (nonatomic, strong) UIView *historyBtnContent; // 历史记录容器View,为了方便删除按钮

/** 职位数据 */
@property (nonatomic, strong) NSMutableArray *hotJobs;
@property (nonatomic, strong) NSMutableArray *allJobs;
@property (nonatomic, strong) NSArray *categoryJobs;

@property (nonatomic, strong) UICollectionView *hotJobsCollectionView;
@property (nonatomic, strong) UIWebView *allJobsWebView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) BOOL isShowingAllJobs;


@property WebViewJavascriptBridge* bridge;

@end

@implementation TZFullTimeJobViewController

#pragma mark 懒加载

- (UIView *)historyBtnContent {
    if (_historyBtnContent == nil) {
        _historyBtnContent= [[UIView alloc] init];
        _historyBtnContent.x = 30;
        _historyBtnContent.y = 0;
        _historyBtnContent.width = TZScreenWidth - 35 - 40;
        _historyBtnContent.height = 50;
        [self.historyJob addSubview:_historyBtnContent];
    }
    return _historyBtnContent;
}

- (UICollectionView *)hotJobsCollectionView {
    if (_hotJobsCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake((TZScreenWidth) / 3, 44);
        
        CGFloat height = (self.hotJobs.count + 2) / 3 * 44;
        CGFloat y = 100 + 15;
        if (self.type == TZFullTimeJobViewControllerJobType) {
            y = 50 + 10;
        }
        _hotJobsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, TZScreenWidth, height) collectionViewLayout:flowLayout];
        _hotJobsCollectionView.backgroundColor = [UIColor whiteColor];
        _hotJobsCollectionView.delegate = self;
        _hotJobsCollectionView.dataSource = self;
    }
    return _hotJobsCollectionView;
}

#pragma mark configView

- (void)loadNetDataAndConfigCollectionView {
    [TZHttpTool postWithURL:ApiHot params:nil success:^(id json) {
        _hotJobs = [NSMutableArray arrayWithArray:json[@"data"]];
        [self.hotJobsCollectionView registerNib:[UINib nibWithNibName:@"TZJobCell" bundle:nil] forCellWithReuseIdentifier:@"job_cell"];
        [self.view addSubview:self.hotJobsCollectionView];
        [self.hotJobsCollectionView reloadData];
    } failure:^(NSString *error) {
        DLog(@"热门职位分类列表获取失败");
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:(BOOL)animated];
    if (self.isShowingAllJobs == YES) {
        [self.hotJobsCollectionView removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isShowingAllJobs == YES) {
        [self.view addSubview:self.hotJobsCollectionView];
    }
    [self loadNetDataAndConfigCollectionView];
    [self configHistoryView];

    [self configWebViewJavascriptBridge];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TZLightGrayColor;
    [self configNaviBar];
    [self configHistoryView];
    self.navigationController.navigationBar.hidden = NO;
}

/** 配置导航条bar */
- (void)configNaviBar {
    if (self.type != TZFullTimeJobViewControllerJobType) {
        HWSearchBar *searchBar = [HWSearchBar searchBar];
        searchBar.width = [UIScreen mainScreen].bounds.size.width - 100;
        searchBar.height = 32;
        searchBar.placeholderText = @"请输入关键词";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = searchBar.frame;
        [button addTarget:self action:@selector(goSearch) forControlEvents:UIControlEventTouchUpInside];
        [searchBar addSubview:button];
        self.navigationItem.titleView = searchBar;
        // 筛选按钮 不要了把  titie置为空
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(screening)];
    } else {
        self.title = @"选择职位类别";
    }
}

/** 配置历史记录 */
- (void)configHistoryView {
    [self.historyBtnContent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.historyJobs = [TZHistoryJobsTool historyJobs];
    CGFloat lastButtonX = 0;
    if (self.historyJobs.count > 0 && self.type != TZFullTimeJobViewControllerJobType) {
        // 有历史记录，配置按钮
        for (NSInteger i = 0; i<self.historyJobs.count; i++) {
            NSString *title = self.historyJobs[i][@"title"];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSNumber *number = self.historyJobs[i][@"laid"];
            btn.tag = number.integerValue;

            [btn setTitle:title forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            self.tipLable.hidden = YES;
            
            CGFloat margin = 10;
            btn.x = margin + lastButtonX;
            btn.y = 10;
            btn.width = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.width;
            btn.height = 30;
            
            lastButtonX += margin + btn.width;
            if (lastButtonX >= TZScreenWidth - 60) { break; } // 留出50的空隙显示删除按钮
            
            [btn addTarget:self action:@selector(pushToSearchViewWithHistoryJob:) forControlEvents:UIControlEventTouchUpInside];
            [self.historyBtnContent addSubview:btn];
        }
    } else {
        [self.historyBtnContent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.tipLable.hidden = NO;
    }
    
    if (self.type == TZFullTimeJobViewControllerJobType) {
        self.historyBtnContent.hidden = YES;
        self.historyJob.hidden = YES;
    }
}

#pragma mark 功能方法

/** 筛选 */
- (void)screening {
  
}

/** 搜索，进入搜索页 */
- (void)goSearch {
    NSLog(@"goSearch");
    TZSearchViewController *searchVc = [[TZSearchViewController alloc] initWithNibName:@"TZSearchViewController" bundle:nil];
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (IBAction)hotJobButtonClick:(UIButton *)sender {
    self.isShowingAllJobs = NO;
    sender.enabled = NO;
    self.allJobButton.enabled = YES;
    // 界面效果
    [self.hotJobButton setTitleColor:TZSelectedColor forState:UIControlStateNormal];
    [self.allJobButton setTitleColor:TZNonSelectedColor forState:UIControlStateNormal];
    self.leftIndicateLine.hidden = NO;
    self.rightIndicateLine.hidden = YES;
    // collectionView界面效果
    [UIView animateWithDuration:0.1 animations:^{ self.allJobsWebView.x = TZScreenWidth; self.hotJobsCollectionView.x = 0;  }];
    if (self.type == TZFullTimeJobViewControllerJobType) return;
    self.historyJob.hidden = NO;
}

- (IBAction)allJobButtonClick:(UIButton *)sender {
    self.isShowingAllJobs = YES;
    sender.enabled = NO;
    self.hotJobButton.enabled = YES;
    // 界面效果
    [self.allJobButton setTitleColor:TZSelectedColor forState:UIControlStateNormal];
    [self.hotJobButton setTitleColor:TZNonSelectedColor forState:UIControlStateNormal];
    self.leftIndicateLine.hidden = YES;
    self.rightIndicateLine.hidden = NO;
    
    // collectionView界面效果
    [UIView animateWithDuration:0.1 animations:^{ self.hotJobsCollectionView.x = -TZScreenWidth;  self.allJobsWebView.x = 0;  }];
    self.historyJob.hidden = YES;
}

/** 清除历史记录 */
- (IBAction)clearHistoryButton:(UIButton *)sender {
    [TZHistoryJobsTool deleteHistoryJobs];
    [self configHistoryView];
}

#pragma mark collectionView的数据源方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.hotJobsCollectionView]) {
        return self.hotJobs.count;
    } else {
        NSArray *array = self.allJobs[section][@"child"];
        return array.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"job_cell";
    TZJobCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TZJobCell alloc] init];
    }
    if (collectionView == self.hotJobsCollectionView) {
        cell.title.text = self.hotJobs[indexPath.row][@"title"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.hotJobs[indexPath.row][@"img"]]]];
        cell.titleLeftToSuperViewContraint.constant = 33;
    } else {
        NSArray *array = self.allJobs[indexPath.section][@"child"];
        cell.title.text = array[indexPath.row][@"title"];
        cell.imageView.hidden = YES;
        cell.titleLeftToSuperViewContraint.constant = indexPath.row % 3 == 0? 15 : 5;
    }
    cell.divideView.hidden = indexPath.row % 3 == 0? YES : NO;
    cell.divideWidthContraint.constant = 0.5;
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([collectionView isEqual:self.hotJobsCollectionView]) {
        return 1;
    } else {
        return self.allJobs.count;
    }
}

#pragma mark collectionView的代理方法
/** 从职位列表处 -> 搜索结果页 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 保存历史记录
    NSString *historyJobTitle = @"";
    NSString *historyJobLaid = @"";

    TZJobListViewController *jobListVc = [[TZJobListViewController alloc] initWithNibName:@"TZJobListViewController" bundle:nil];
    
    if ([collectionView isEqual:self.hotJobsCollectionView]) {
        historyJobTitle = self.hotJobs[indexPath.row][@"title"];
        historyJobLaid = self.hotJobs[indexPath.row][@"laid"];
        jobListVc.jobTitle = self.hotJobs[indexPath.row][@"title"];
        jobListVc.laid = self.hotJobs[indexPath.row][@"laid"];  // 热门职位 列表控制器class参数
        jobListVc.isFromHotJob = YES;
    } else {
        NSArray *array = self.allJobs[indexPath.section][@"child"];
        historyJobTitle = array[indexPath.row][@"title"];
        historyJobLaid = array[indexPath.row][@"laid"];
        jobListVc.jobTitle = array[indexPath.row][@"title"];
        jobListVc.laid = array[indexPath.row][@"laid"];
    }
    
    [self setTypeWithVc:jobListVc];
    
    NSDictionary *historyJob = @{@"title":historyJobTitle,@"laid":historyJobLaid};
    if (self.type == TZFullTimeJobViewControllerJobType) {
        [self.navigationController popViewControllerAnimated:YES];
        // 调用block 返回用户选择的职位
        if (self.returnJobType) {
            self.returnJobType(historyJobTitle,historyJobLaid,TZFullTimeJobTypeHot);
        }
    } else {
        [TZHistoryJobsTool addHistoryJob:historyJob];
        // 执行跳转
        [self.navigationController pushViewController:jobListVc animated:YES];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

/** 从历史记录 -> 搜索结果页 */
- (void)pushToSearchViewWithHistoryJob:(UIButton *)button {
    TZJobListViewController *jobListVc = [[TZJobListViewController alloc] initWithNibName:@"TZJobListViewController" bundle:nil];
    jobListVc.jobTitle = button.titleLabel.text;
    jobListVc.laid = [NSString stringWithFormat:@"%zd",button.tag];
    
    // 从历史记录处进去，也要判断这个字段是热门职位还是全部职位
    for (NSDictionary *dic in self.hotJobs) {
        if ([jobListVc.laid isEqualToString:dic[@"laid"]]) {
            jobListVc.isFromHotJob = YES;
        }
    }
    
    [self setTypeWithVc:jobListVc];
    [self.navigationController pushViewController:jobListVc animated:YES];
}

- (void)setTypeWithVc:(TZJobListViewController *)jobListVc {
    // 给jobListVc设定类型。带值过去
    if (self.type == TZFullTimeJobViewControllerTypeEatJob) {
        jobListVc.type = TZJobListViewControllerTypeEatJob;
    } else if (self.type == TZFullTimeJobViewControllerTypeSchoolJob) {
        jobListVc.type = TZJobListViewControllerTypeSchoolJob;
    } else if (self.type == TZFullTimeJobViewControllerTypePartTimeJob) {
        jobListVc.type = TZJobListViewControllerTypePartTimeJob;
    } else if (self.type == TZFullTimeJobViewControllerTypeReturnMoney) {
        jobListVc.type = TZJobListViewControllerTypeReturnMoney;
    } else if (self.type == TZFullTimeJobViewControllerTypeRelievedCompany) {
        jobListVc.type = TZJobListViewControllerTypeRelievedCompany;
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('h2')[0].style.webkitTextFillColor= 'red'"];
}

/** 配置webView与本地code 的桥接 */
- (void)configWebViewJavascriptBridge {
    if (_bridge) { return; }
    
    // 1. 所有工作岗位  用webView，之前的代码放最后
    self.allJobsWebView = [[UIWebView alloc] init];
    self.allJobsWebView.frame = CGRectMake(TZScreenWidth, 50 , TZScreenWidth, TZScreenHeight - 114);
    [self.allJobsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ApiClass]]];
    [self.view addSubview:self.allJobsWebView];
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.allJobsWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        /// 点击Web页面JS
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"getJobCategoryId" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        TZJobListViewController *jobListVc = [[TZJobListViewController alloc] initWithNibName:@"TZJobListViewController" bundle:nil];
        jobListVc.jobTitle = data[@"ctitle"];
        jobListVc.laid = data[@"cid"];
        
        [self setTypeWithVc:jobListVc];
        
        NSDictionary *historyJob = @{@"title":data[@"ctitle"],@"laid":data[@"cid"]};
        if (self.type == TZFullTimeJobViewControllerJobType) {
            [self.navigationController popViewControllerAnimated:YES];
            // 调用block 返回用户选择的职位
            if (self.returnJobType) {
                self.returnJobType(data[@"ctitle"],data[@"cid"],TZFullTimeJobTypeAll);
            }
        } else {
            [TZHistoryJobsTool addHistoryJob:historyJob];
            // 执行跳转
            [self.navigationController pushViewController:jobListVc animated:YES];
        }
    }];
}

@end
