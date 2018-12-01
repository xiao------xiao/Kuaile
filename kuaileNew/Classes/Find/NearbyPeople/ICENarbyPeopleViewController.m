//
//  ICENarbyPeopleViewController.m
//  kuaile
//
//  Created by ttouch on 15/10/17.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICENarbyPeopleViewController.h"
#import "ICENearbyPeopleTableViewCell.h"
#import "TZNearbyPersonModel.h"
#import "ICEUserInfoViewController.h"

@interface ICENarbyPeopleViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _pageIndex;
}
@property (nonatomic, strong) NSMutableArray *cellDataArray;

@end

@implementation ICENarbyPeopleViewController

- (NSMutableArray *)cellDataArray{
    if (_cellDataArray == nil) {
        _cellDataArray = [[NSMutableArray alloc] init];
    }
    return _cellDataArray;
}

- (NSString *)gender {
    if (_gender == nil) {
        _gender = @"2";
    }
    return _gender;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近的人";
    [self configTableView];
    [self configNaviItem];
}

// 设置实体属性
- (void)settingModelWithEneity {
    //    [ICEMyOrderModel setupObjectClassInArray:^NSDictionary *{
    //        return @{
    //                 @"result" : @"ICEHomePageData"
    //                 };
    //    }];
}

// 网络数据，请求网络
- (void)loadNetWorkData:(BOOL)isUp {
    [self settingModelWithEneity];
    if (isUp) {
        _pageIndex = 1;
        self.cellDataArray = nil;
    } else {
        _pageIndex++;
        // 上拉加载更多 暂时没有
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView endRefresh];
            [self showInfo:@"没有更多了呢"];
        });
        return;
    }
    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                   initWithDictionary:@{
                                                        @"lat" : @"",
                                                        @"lng" : @"",
                                                        @"gender" : self.gender,
                                                        }];
    if (latitude != nil && longitude != nil ) {
        params = [[NSMutableDictionary alloc]
                  initWithDictionary:@{
                                       @"lat" : latitude,
                                       @"lng" : longitude,
                                       @"gender" : self.gender,
                                       }];
    }
    [TZHttpTool postWithURL:ApiNearPeople params:params success:^(id json) {
        NSArray *persons = [TZNearbyPersonModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        [self.cellDataArray addObjectsFromArray:persons];
        [_tableView endRefreshAndReloadData];
    } failure:^(NSString *error) {
        [_tableView endRefreshAndReloadData];
    }];
}

- (void)configNaviItem {
    // 发布按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 22, 22);
    [addButton setImage:[UIImage imageNamed:@"nearmore"] forState:UIControlStateNormal];
    UIBarButtonItem *addFriendItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addFriendItem;
    
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        DLog(@"筛选男女");
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                delegate:nil
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"查看全部",@"只看女生",@"只看男生",  nil];
        @weakify(actionSheet);
        [actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *buttonIndex) {
            @strongify(actionSheet);
            NSInteger index = [buttonIndex integerValue];
            NSString *title = [actionSheet buttonTitleAtIndex:index];
            NSLog(@"title %@,  %ld",title, index);
            switch (index) {
                case 0: {
                    self.gender = @"2";
                } break;
                case 1: {
                    self.gender = @"1";
                } break;
                case 2: {
                    self.gender = @"0";
                } break;
                default: break;
            }
            [self loadNetWorkData:YES];
        }];
        [actionSheet showInView:self.view];
    }];
}

- (void)configTableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNetWorkData:YES];
    }];
    // 马上进入刷新状态
    [_tableView.header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadNetWorkData:NO];
    }];
}

#pragma mark tableView数据源和代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"iCENearbyPeopleTableViewCell";
    ICENearbyPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ICENearbyPeopleTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TZNearbyPersonModel *model = _cellDataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
// 去个人详情页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TZNearbyPersonModel *model = _cellDataArray[indexPath.row];
    ICEUserInfoViewController *iCEUserInfo = [[ICEUserInfoViewController alloc] init];
    iCEUserInfo.userName = model.username;
    [self.navigationController pushViewController:iCEUserInfo animated:YES];
}

@end
