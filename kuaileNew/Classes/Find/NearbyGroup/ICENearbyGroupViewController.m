//
//  ICENearbyGroupViewController.m
//  kuaile
//
//  Created by ttouch on 15/10/17.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICENearbyGroupViewController.h"
#import "ICENearbyGroupTableViewCell.h"
#import "ICEModelGroup.h"
#import "ICEGroupInfoViewController.h"

@interface ICENearbyGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *gruops;
@end

@implementation ICENearbyGroupViewController

- (NSMutableArray *)gruops {
    if (_gruops == nil) {
        _gruops = [[NSMutableArray alloc] init];
    }
    return _gruops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self loadNetData];
}

- (void)configTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNetDataHeader];
    }];
    // 马上进入刷新状态
    // [_tableView.header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadNetDataFooter];
    }];
}

- (void)loadNetDataHeader {
    [self loadNetData];
}

- (void)loadNetDataFooter {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showInfo:@"没有更多了呢"];
        [self.tableView.footer endRefreshing];
    });
}

- (void)loadNetData {
    // 配置参数
    NSString *Api;
    NSDictionary *params;
    if (self.type == ICENearbyGroupViewControllerTypeNear) {
        Api = ApiNearGroups;
        NSString *lat = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
        NSString *lng = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
        if (lat ==nil || lng == nil) {
            lat = @"";
            lng = @"";
        }
        params = @{@"lat":lat,@"lng":lng};
    } else {
        Api = ApiGetRecommendGroups;
    }
    // 发请求
    [TZHttpTool postWithURL:Api params:params success:^(id json) {
        DLog(@"附近的群/推荐的群 加载成功  %@",json);
        [self.tableView.header endRefreshing];
        self.gruops = [ICEModelGroup mj_objectArrayWithKeyValuesArray:json[@"data"]];
        [self.tableView configNoDataTipViewWithCount:self.gruops.count tipText:@"暂无群组"];
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"附近的群/推荐的群 加载失败  %@",error);
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark tableView数据源和代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gruops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"iCENearbyPeopleTableViewCell";
    ICENearbyGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ICENearbyGroupTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadDataWith:self.gruops[indexPath.row]];
    [cell addSubview:[UIView divideViewWithHeight:cell.height]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

// 去群详情页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![TZUserManager isLogin]) return;
    ICEModelGroup *model = self.gruops[indexPath.row];
    ICEGroupInfoViewController *iCEGroupInfoVc = [[ICEGroupInfoViewController alloc] initWithNibName:@"ICEGroupInfoViewController" bundle:[NSBundle mainBundle] groupID:model.group_id];
    [self.navigationController pushViewController:iCEGroupInfoVc animated:YES];
}

@end
