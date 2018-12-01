//
//  ICEReportViewController.m
//  kuaile
//
//  Created by ttouch on 15/11/17.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICEReportViewController.h"

@interface ICEReportViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *ary;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation ICEReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报   ";
    _ary = @[@"色情低俗", @"广告骚扰", @"谣言", @"政治敏感", @"威胁恐吓", @"其他"];
    [self configUITableView];
    [self configRightItem];
}

- (void)configRightItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(loadNet)];
}

- (void)loadNet {
    self.reason = @"";
    self.reason = _ary[_currentIndex];
    if ([self.reason isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择举报内容!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"sid" : self.reportCid,@"reason" : self.reason}];
    RACSignal *sign = [ICEImporter netReportSnsWithParams:params];
    [sign subscribeNext:^(id x) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"举报成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
            if (x.integerValue == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        [alert show];
    }];
}

- (void)configUITableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, __kScreenWidth, __kScreenHeight - 64 - 49)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _ary[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray *cellAry = [tableView visibleCells];
    for (UITableViewCell *cell in cellAry) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    _currentIndex = indexPath.row;
}

@end
