//
//  XYFundamentTabViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/15.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYFundamentTabViewController.h"
#import "HJZanListModel.h"
#import "BaseTableViewCell.h"
#import "HJZanListCell.h"
#import "ICESelfInfoViewController.h"

@interface XYFundamentTabViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
/// 需要上下拉刷新
@property (nonatomic, assign) BOOL needRefresh;
/// 只需要下拉刷新
@property (nonatomic, assign) BOOL needHeaderRefresh;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;

@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation XYFundamentTabViewController

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight) style:UITableViewStylePlain];
        self.tableView.rowHeight = self.rowH;
        [self.tableView registerCellByNibName:@"HJZanListCell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"有%@人点赞",_model.zan_num];
    self.page = 1;
    self.totalPage = 1;
    [self createRefresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)createRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithHeader)];
    self.tableView.mj_header = header;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithFooter)];
    self.tableView.mj_footer = footer;
}

- (void)refreshDataWithFooter {
    self.page ++;
    [self loadNetworkD];
}

- (void)refreshDataWithHeader {
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self loadNetworkD];
}

-(void)loadNetworkD {
    NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionid"];
    NSMutableDictionary * params = @{@"sessionid":str,@"sid":@(_model.sid.integerValue),@"page":@(self.page)};
    [TZHttpTool postWithURL:ApiSnsHitsList params:params success:^(NSDictionary *result) {

        NSArray * array = [HJZanListModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        
        [self.dataArray addObjectsFromArray:array];
        
        [self.tableView reloadData];
        [self.tableView endRefresh];
        
    } failure:^(NSString *msg) {
        [self showInfo:msg];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HJZanListCell *friendCell = [tableView dequeueReusableCellWithIdentifier:@"HJZanListCell"];
    HJZanListModel * model = self.dataArray[indexPath.row];
    friendCell.model = model;
    if (model.isconcern) {
        friendCell.type = HJZanListCellTypeAttention;
    } else {
        friendCell.type = HJZanListCellTypeNoAttention;
    }
    friendCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [friendCell addBottomSeperatorViewWithHeight:1];
    [friendCell setDidClickAttentionBtnBlock:^{
        model.isconcern = !model.isconcern;
        [self checkAttentionStatusWithBuddyName:model.uid];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    return friendCell;
}

- (void)checkAttentionStatusWithBuddyName:(NSString *)buddyName {
    if (buddyName && buddyName.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
        params[@"buid"] = buddyName;
        [TZHttpTool postWithURL:ApiSnsConcernUser params:params success:^(NSDictionary *result) {
            [self showSuccessHUDWithStr:result[@"msg"]];
            [mNotificationCenter postNotificationName:@"didAddFriendNoti" object:nil];
            // 加好友添加积分
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"uid": userModel.uid }];
            RACSignal *sign = [ICEImporter addFriendsIntegralWithParams:params];
        } failure:^(NSString *msg) {
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HJZanListModel * model = self.dataArray[indexPath.row];
    
    ICESelfInfoViewController *infoVc = [[ICESelfInfoViewController alloc] init];
    if ([[TZUserManager getUserModel].uid isEqualToString:model.uid]) {
        infoVc.type = ICESelfInfoViewControllerTypeSelf;
    } else {
        infoVc.type = ICESelfInfoViewControllerTypeOther;
        infoVc.uid = model.uid;
        infoVc.nickName = model.unickname;
    }
    [self.navigationController pushViewController:infoVc animated:YES];

}


@end
