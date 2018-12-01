//
//  XYIncomeListViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYIncomeListViewController.h"
#import "XYProfileView.h"
#import "XYSlideNavView.h"
#import "XYSalaryTableView.h"
#import "XYSalaryListViewController.h"
#import "XYInComeModel.h"
#import "ICELoginUserModel.h"
#import "XYSalaryUserModel.h"

@interface XYIncomeListViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) XYProfileView *profileView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XYSlideNavView *slideNavView;
@property (nonatomic, strong) XYSalaryTableView *tableView1;
@property (nonatomic, strong) XYSalaryTableView *tableView2;
@property (nonatomic, strong) XYSalaryTableView *tableView3;

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) ICELoginUserModel *userModel;
@property (nonatomic, strong) NSMutableArray *tableViews;

@end

@implementation XYIncomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableViews = [NSMutableArray array];
    self.userModel = [ICELoginUserModel sharedInstance];
    self.title = @"薪资查询";
    
    [self configBgView];
    [self configProfileView];
    [self loadSalaryLists];
    
}

- (void)loadSalaryLists {
    NSString *sessStr = [mUserDefaults objectForKey:@"sessionid"];
    NSString *code = self.code;
    [TZHttpTool postWithURL:ApiSalaryList1 params:@{@"sessionid":sessStr,@"code":self.code} success:^(NSDictionary *result) {
        self.models = [XYInComeModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"items"]];
        XYSalaryUserModel *model = [XYSalaryUserModel mj_objectWithKeyValues:result[@"data"][@"user"]];
        _profileView.model = model;
        [self configSlideNavView];
        [self configListScrollView];
        [self configTipLabel];
    } failure:^(NSString *msg) {
        [self showErrorHUDWithError:msg];
    }];
}

- (void)configBgView {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64);
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(0, 1);
    UIColor *firstColor = TZColor(95, 197, 252);
    UIColor *secondColor = TZColor(56, 152, 252);
    layer.colors = @[(id)firstColor.CGColor,(id)secondColor.CGColor];
    [self.view.layer insertSublayer:layer atIndex:0];
}

- (void)configProfileView {
    _profileView = [[XYProfileView alloc] init];
    _profileView.backgroundColor = [UIColor clearColor];
    _profileView.frame = CGRectMake(0, 0, mScreenWidth, 90);
    [self.view addSubview:_profileView];
}

- (void)configSlideNavView {
    CGFloat slideY = CGRectGetMaxY(_profileView.frame) + 20;
    _slideNavView = [[XYSlideNavView alloc] init];
    _slideNavView.frame = CGRectMake(0, slideY, mScreenWidth, 60);
    XYInComeModel *model = [self.models firstObject];
    _slideNavView.titleLabel.text = [NSString stringWithFormat:@"%@年总收入",model.date];
    _slideNavView.pageControl.numberOfPages = self.models.count;
    _slideNavView.pageControl.currentPage = self.models.count - 1;
    if (self.models.count == 1) {
        _slideNavView.backBtn.enabled = NO;
        _slideNavView.forwardBtn.enabled = NO;
    }
    __weak XYSlideNavView *weak_slideNavView = _slideNavView;
    __weak UIScrollView *weak_scrollview =_scrollView;
    MJWeakSelf
    [_slideNavView setDidClickBackBtnBlock:^{ //后退
         __strong XYSlideNavView *strong_slideNavView = weak_slideNavView;
        __strong UIScrollView *strong_scrollview =weak_scrollview;
        if (strong_slideNavView.pageControl.currentPage == 0) {
            strong_slideNavView.backBtn.enabled = NO;
        } else {
            NSInteger current = strong_slideNavView.pageControl.currentPage;
            current = current - 1;
            XYInComeModel *model = weakSelf.models[weakSelf.models.count - current - 1];
            strong_slideNavView.titleLabel.text = [NSString stringWithFormat:@"%@年总收入",model.date];
            NSArray *arr = weakSelf.tableViews;
            XYSalaryTableView *showView = weakSelf.tableViews[weakSelf.models.count - current - 1];
            [showView reloadData];
            CGFloat offset = strong_scrollview.contentOffset.x;
            [strong_scrollview setContentOffset:CGPointMake(offset - mScreenWidth, 0) animated:YES];
        }
        weak_slideNavView.forwardBtn.enabled = YES;
    }];
    [_slideNavView setDidClickForwardBtnBlock:^{ //前进
        __strong XYSlideNavView *strong_slideNavView = weak_slideNavView;
        __strong UIScrollView *strong_scrollview =weak_scrollview;
        if (strong_slideNavView.pageControl.currentPage == weakSelf.models.count - 1) {
            strong_slideNavView.forwardBtn.enabled = NO;
        } else {
            NSInteger current = strong_slideNavView.pageControl.currentPage;
            current = current + 1;
            XYInComeModel *model = weakSelf.models[weakSelf.models.count - current - 1];
            strong_slideNavView.titleLabel.text = [NSString stringWithFormat:@"%@年总收入",model.date];
            XYSalaryTableView *showView = weakSelf.tableViews[weakSelf.models.count - current - 1];
            [showView reloadData];
            CGFloat offset = strong_scrollview.contentOffset.x;
            [strong_scrollview setContentOffset:CGPointMake(offset + mScreenWidth, 0) animated:YES];
        }
    }];
    [self.view addSubview:_slideNavView];
}

- (void)configListScrollView {
    CGFloat scrollViewY = CGRectGetMaxY(_slideNavView.frame);
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, scrollViewY, mScreenWidth, mScreenHeight - 64 - scrollViewY - 50);
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(mScreenWidth * self.models.count, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView setContentOffset:CGPointMake((self.models.count - 1) * mScreenWidth, 0)];
    [self.view addSubview:_scrollView];

    for (NSInteger i = 0; i < self.models.count; i++) {
        XYSalaryTableView *salaryView = [self getTableViewWithIndex:self.models.count - i - 1];
        [_scrollView addSubview:salaryView];
        [self.tableViews addObject:salaryView];
    }
}

- (void)configTipLabel {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, mScreenHeight - 33 - 64, mScreenWidth - 20, 21);
    label.text = @"工资查询以企业实际明细为准，本功能查询仅供参考";
    label.textColor = [UIColor whiteColor];
    CGFloat fontSize = 14;
    if (mScreenWidth < 375) fontSize = 12;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (XYSalaryTableView *)getTableViewWithIndex:(NSInteger)index {
    XYSalaryTableView *salaryTableView = [[XYSalaryTableView alloc] initWithFrame:CGRectMake(index * mScreenWidth, 0, mScreenWidth, mScreenHeight - 64 - 50 - CGRectGetMaxY(_slideNavView.frame)) style:UITableViewStylePlain];
    salaryTableView.backgroundColor = [UIColor clearColor];
    salaryTableView.delegate = salaryTableView;
    salaryTableView.dataSource = salaryTableView;
    XYInComeModel *model = self.models[self.models.count - index - 1];
    salaryTableView.models = model.items;
    salaryTableView.rowHeight = 110;
    salaryTableView.tableFooterView = [[UIView alloc] init];
    [salaryTableView registerCellByNibName:@"XYSalaryListCell"];
    salaryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return salaryTableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / mScreenWidth + 0.5;
    if (page == self.models.count - 1) {
        _slideNavView.forwardBtn.enabled = NO;
        _slideNavView.backBtn.enabled = YES;
    } else if (page == 0) {
        _slideNavView.backBtn.enabled = NO;
        _slideNavView.forwardBtn.enabled = YES;
    } else {
        _slideNavView.backBtn.enabled = YES;
        _slideNavView.forwardBtn.enabled = YES;
    }
    XYInComeModel *model = self.models[self.models.count - 1 - page];
    _slideNavView.titleLabel.text = [NSString stringWithFormat:@"%@年总收入",model.date];
    _slideNavView.pageControl.currentPage = page;
}





@end
