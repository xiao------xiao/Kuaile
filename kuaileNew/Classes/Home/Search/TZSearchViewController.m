//
//  TZSearchViewController.m
//  kuaile
//
//  Created by liujingyi on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZSearchViewController.h"
#import "TZJobSearchTool.h"
#import "HWSearchBar.h"
#import "TZSearchCell.h"
#import "TZJobListViewController.h"

@interface TZSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HWSearchBar *naviBar;
@property (nonatomic, strong) NSMutableArray *jobs;
@end

@implementation TZSearchViewController


#pragma mark 懒加载和配置界面

- (NSMutableArray *)jobs {
    if (_jobs == nil) {
        _jobs = (NSMutableArray *)[TZJobSearchTool SearchJobs];//从工具类中取得搜索记录
        if (_jobs == nil) {
            _jobs = [[NSMutableArray alloc] init];
        } else if (_jobs.count > 0) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:_jobs];
            [array addObject:@"清空搜索历史记录"];
            _jobs = array;
        }
    }
    return _jobs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNaviBar];
    CGFloat rgb = 246/255.0;
    self.tableView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    if (self.jobs.count == 0) {
        self.tableView.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSearchTitle:) name:@"addSearchTitle" object:nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.naviBar becomeFirstResponder];
}

/** 栈顶控制器被pop（工作列表控制器被移除）,刷新数据 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _jobs = [NSMutableArray arrayWithArray:[TZJobSearchTool SearchJobs]];
    if (_jobs.count) {
        [_jobs addObject:@"清空搜索历史记录"];
    }
    [self.tableView reloadData];
}

/** 配置导航条bar */
- (void)configNaviBar {
    HWSearchBar *searchBar = [HWSearchBar searchBar];
    searchBar.width = [UIScreen mainScreen].bounds.size.width - 100;
    searchBar.height = 32;
    searchBar.placeholderText = @"请输入关键词搜索";
    
    self.naviBar = searchBar;
    self.naviBar.delegate = self;
    self.naviBar.returnKeyType = UIReturnKeySearch;
    self.navigationItem.titleView = searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searching)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.naviBar endEditing:YES];
}

#pragma mark tableView的数据源/代理方法

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"search_cell";
    TZSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TZSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.title.textColor = [UIColor darkGrayColor];
        cell.addButton.hidden = NO;
    }
    cell.title.text = self.jobs[indexPath.row];
    if ([cell.title.text isEqualToString:@"清空搜索历史记录"]) {
        cell.title.textColor = [UIColor redColor];
        cell.addButton.hidden = YES;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jobs.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.jobs.count - 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清空历史" message:@"确认清空搜索历史？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        self.naviBar.text = self.jobs[indexPath.row];
        [self searching];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.naviBar endEditing:YES];
}


#pragma mark 功能方法

/** 通知方法。将该历史搜索记录添加到搜索框中 */
- (void)addSearchTitle:(NSNotification *)noti {
    self.naviBar.text = noti.userInfo[@"title"];
}

/** 开始搜索 */
- (void)searching {
    [TZJobSearchTool addSearchJob:self.naviBar.text];
    // 执行搜索
    TZJobListViewController *jobListVc = [[TZJobListViewController alloc] initWithNibName:@"TZJobListViewController" bundle:nil];
    jobListVc.jobTitle = self.naviBar.text;
    jobListVc.type = TZJobListViewControllerTypeSearch;
    [self.navigationController pushViewController:jobListVc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searching];
    return YES;
}

/** 清空搜索历史 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [TZJobSearchTool deleteSearchJobs];
        self.tableView.hidden = YES;
        [self.tableView reloadData];
    }
}


@end
