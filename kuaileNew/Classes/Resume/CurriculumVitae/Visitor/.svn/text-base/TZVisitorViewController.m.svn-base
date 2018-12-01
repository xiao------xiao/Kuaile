//
//  TZVisitorViewController.m
//  kuaile
//
//  Created by liujingyi on 15/9/18.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZVisitorViewController.h"
#import "TZVisitorModel.h"
#import "TZVisitorCell.h"

@interface TZVisitorViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *visitors;
@end

@implementation TZVisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    self.title = @"谁看过我";
    [self loadNetData];
}

- (void)configTableView {
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = __kColorWithRGBA(246, 246, 246, 1.0);
    self.tableView.rowHeight = 86;
}

- (void)loadNetData {
    NSDictionary *params = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"userUid"]};
    [TZHttpTool postWithURL:ApiLookThrough params:params success:^(id json) {
        DLog(@"谁看过我获取成功 %@",json);
        self.visitors = [TZVisitorModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        [self.tableView configNoDataTipViewWithCount:self.visitors.count tipText:@"暂无访客"];
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        [self.tableView configNoDataTipViewWithCount:self.visitors.count tipText:@"暂无访客"];
        DLog(@"谁看过我获取失败 %@",error);
    }];
}

#pragma mark tableView的数据源和代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.visitors.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZVisitorCell *cell = [[TZVisitorCell alloc] init];
    cell.model = self.visitors[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

@end
