//
//  XYSearchViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/5/9.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSearchViewController.h"
#import "XYSearchNaviView.h"
#import "LFindLocationViewController.h"
#import "XYShowMapResultCell.h"
#import "XYMapResultModel.h"
#import "XYDetailListCell.h"

@interface XYSearchViewController ()<UISearchBarDelegate,LFindLocationViewControllerDelegete, UIAlertViewDelegate>
@property (nonatomic, strong) XYSearchNaviView *naviBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITextField *companyTextField;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, assign) BOOL isSearching;
@end

@implementation XYSearchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    self.isSearching = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configNaviBarView];
    [self configTableView];
    // 1.取定位城市
    [self upDateCurrentCityUI:[[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)searchWithText:(NSString *)text {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keywords"] = text;
    params[@"types"] = @"170000";
    params[@"key"] = @"ef1874d4093c90f7219b6296efb344bd";
    params[@"city"] = [mUserDefaults objectForKey:@"userCity"];
    params[@"citylimit"] = @YES;
    [TZHttpTool postWithURL:ApiSearchColleague params:params success:^(NSDictionary *result) {
        self.dataSource = [XYMapResultModel mj_objectArrayWithKeyValuesArray:result[@"pois"]];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
    }];
}

- (void)configNaviBarView {
    _naviBar = [[XYSearchNaviView alloc] init];
    _naviBar.frame = CGRectMake(0, 0, __kScreenWidth, 64);
    _naviBar.searchBar.delegate = self;
    [self.view addSubview:_naviBar];
    // 切换城市
    [[_naviBar.cityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        LFindLocationViewController *cityChooseVc = [[LFindLocationViewController alloc] init];
        cityChooseVc.delegete = self;
        cityChooseVc.loctionCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"];
        [self.navigationController pushViewController:cityChooseVc animated:YES];
    }];
    // 取消
    [[_naviBar.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)addUserCompanyWithTitle:(NSString *)title {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    params[@"name"] = self.companyTextField.text;
    [TZHttpTool postWithURL:ApiAddCompany params:params success:^(NSDictionary *result) {
//        [self showSuccessHUDWithStr:@"添加成功"];
        [self showSuccessHUDWithStr:@"创建成功"];
//        if (self.didSelecteCompany) {
//            self.didSelecteCompany(self.companyTextField.text);
//        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

    } failure:^(NSString *msg) {
        
    }];
}



- (void)configTableView {
    CGFloat tableViewY = CGRectGetMaxY(_naviBar.frame);
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, tableViewY, mScreenWidth, mScreenHeight - tableViewY);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.rowHeight = 60;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_tableView registerCellByClassName:@"XYShowMapResultCell"];
    [_tableView registerCellByClassName:@"XYDetailListCell"];
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithHeader)];
//    _tableView.mj_header = header;
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithFooter)];
//    _tableView.mj_footer = footer;
    [self.view addSubview:_tableView];
}


#pragma mark -- UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching) {
        return self.dataSource.count + 1;
    } else {
        return self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearching) {
        if (indexPath.row == self.dataSource.count) {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//            cell.textLabel.text = [NSString stringWithFormat:@"创建”%@“为新公司/工厂",self.searchText];
//            cell.textLabel.textColor = TZColor(64, 159, 252);
//            cell.textLabel.font = [UIFont systemFontOfSize:16];
//            [cell addBottomSeperatorViewWithHeight:1];
//            return cell;

            XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
            cell.subLabelX = mScreenWidth;
            cell.subLabel.hidden = YES;
            cell.more.hidden = YES;
            cell.text = [NSString stringWithFormat:@"创建”%@“为新公司/工厂",self.searchText];
            cell.labelTextColor = TZColor(64, 159, 252);
            cell.labelFont = 16;
            return cell;
        } else {
            XYShowMapResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYShowMapResultCell"];
            cell.selImageView.hidden = YES;
            XYMapResultModel *model = self.dataSource[indexPath.row];
            cell.titleLabel.text = model.name;
            cell.subTileLabel.text = model.address;
            [cell addBottomSeperatorViewWithHeight:1];
            return cell;
        }
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearching) {
        if (indexPath.row == self.dataSource.count) {
            UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"公司名称" message:nil delegate:self];
            self.companyTextField = [alertView textFieldAtIndex:0];
            self.companyTextField.keyboardType = UIKeyboardTypeDefault;
            [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
                if (x.integerValue == 1) {
                    
                    [self addUserCompanyWithTitle:nil];
                }
            }];
            [alertView show];
        } else {
            XYMapResultModel *model = self.dataSource[indexPath.row];
            if (self.didSelecteCompany) {
                self.didSelecteCompany(model.name);
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
}

- (void)upDateCurrentCityUI:(NSString *)city {
    // 若city为空 做一些操作
    if (city == nil || [city isEqualToString:@""] || city.length < 1) {
        city = @"无锡";
    }
    [mUserDefaults setObject:city forKey:@"userCity"];
    [mUserDefaults synchronize];
    
    [_naviBar.cityBtn setTitle:city forState:UIControlStateNormal];
    NSInteger width = 67;
    NSInteger left = 50;
    if (city.length == 3) {
        width = 84;
        left = 67;
    } else if (city.length >= 4) {
        left = 89;
        width = 106;
    }
    _naviBar.cityBtn.imageEdgeInsets = UIEdgeInsetsMake(0, left, 0, 0);
    _naviBar.cityBtnConstraintW.constant = width;
}


#pragma mark --  UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@",searchText);
    self.isSearching = YES;
    [self searchWithText:searchText];
    self.searchText = searchText;
}

- (void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation {
    [self.naviBar.cityBtn setTitle:city forState:UIControlStateNormal];
    [self upDateCurrentCityUI:city];
}

//- ale


@end
