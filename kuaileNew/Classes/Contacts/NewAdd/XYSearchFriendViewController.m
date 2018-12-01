//
//  XYSearchFriendViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/4/18.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSearchFriendViewController.h"
#import "TZAddFrindTableView.h"
#import "TZAddFriendHeaderView.h"
#import "XYRecommendFriendModel.h"
#import "TZAddFriendCell.h"

//#import "AFHTTPRequestOperation.h"
#import "XYMapResultModel.h"
#import "XYShowMapResultCell.h"
#import "XYUserInfoModel.h"
#import "ICESelfInfoViewController.h"

@interface XYSearchFriendViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    BOOL _isSearch;
}
@property (nonatomic, strong) UITableView *tableView1;
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, strong) UITableView *tableView3;
@property (nonatomic, strong) UITableView *showTableView;

@property (nonatomic, strong) TZButtonsHeaderView *headerBtns;
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, assign) BOOL isManuChangeType;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSString *searchCompanyName;

@property (nonatomic, strong) NSMutableArray *dataSource1;
@property (nonatomic, strong) NSMutableArray *dataSource2;
@property (nonatomic, strong) NSMutableArray *dataSource3;

@property (nonatomic, strong) NSMutableArray *colleagues;

@property (nonatomic, assign) NSInteger page1;
@property (nonatomic, assign) NSInteger totalPage1;

@property (nonatomic, assign) NSInteger page2;
@property (nonatomic, assign) NSInteger totalPage2;

@property (nonatomic, assign) NSInteger page3;
@property (nonatomic, assign) NSInteger totalPage3;

@property (nonatomic, assign) CGFloat scrollViewY;
//@property (nonatomic, assign) NSInteger index;



@end

@implementation XYSearchFriendViewController

- (NSMutableArray *)colleagues {
    if (_colleagues == nil) {
        _colleagues = [NSMutableArray array];
    }
    return _colleagues;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isSearch = NO;
    self.title = @"查找添加结果";
    self.page1 = 1;
    self.page2 = 1;
    self.page3 = 1;
    self.dataSource1 = [NSMutableArray array];
    self.dataSource2 = [NSMutableArray array];
    self.dataSource3 = [NSMutableArray array];
    [self configHeaderBtns];
    [self configSearchBar];
    [self configBigScrollView];
    
    [mNotificationCenter addObserver:self selector:@selector(showAlert) name:@"showAlertNoti" object:self];
}

- (void)configHeaderBtns {
    _headerBtns = [[TZButtonsHeaderView alloc] init];
    _headerBtns.frame = CGRectMake(0, 0, mScreenWidth, 40);
    _headerBtns.notCalcuLateTitleWidth = YES;
    _headerBtns.showLines = NO;
    _headerBtns.titles = @[@"加好友",@"找老乡",@"找同事"];
    _headerBtns.selectBtnIndex = self.selectedIndex;
    MJWeakSelf
    [_headerBtns setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        weakSelf.isManuChangeType = YES;
        weakSelf.headerBtns.selectBtnIndex = index;
        weakSelf.searchBar.text = @"";
        [weakSelf.bigScrollView setContentOffset:CGPointMake(index * mScreenWidth, 0) animated:YES];
    }];
    [self.view addSubview:_headerBtns];
}

- (void)configSearchBar {
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.frame = CGRectMake(0, 40, mScreenWidth, 44);
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    [self.view addSubview:_searchBar];
}

- (void)configBigScrollView {
    self.scrollViewY = CGRectGetMaxY(self.searchBar.frame);
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.scrollViewY, mScreenWidth, mScreenHeight - 64 - self.scrollViewY)];
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.delegate = self;
    self.bigScrollView.contentSize = CGSizeMake(mScreenWidth * 3, 0);
    [self.bigScrollView setContentOffset:CGPointMake(self.selectedIndex * mScreenWidth, 0) animated:YES];
    [self.view addSubview:self.bigScrollView];
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithFooter)];
//    self.bigScrollView.mj_footer = footer;
    
    [self tableView1];
    [self tableView2];
}

- (void)searchAction {
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if ([self.searchText isEqualToString:loginUsername]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notAddSelf", @"can't add yourself as a friend") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [self loadSearchFriendData];
}

- (void)addUserCompany {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    params[@"name"] = self.searchBar.text;
    [TZHttpTool postWithURL:ApiAddCompany params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"添加成功"];
    } failure:^(NSString *msg) {
        
    }];
}

- (void)loadSearchFriendData {
    __block NSInteger count = 0;
    [self.dataSource3 removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSInteger seleBtnIndex = _headerBtns.selectBtnIndex;
    if (seleBtnIndex == 2) {
        params[@"keywords"] = self.searchBar.text;
//        params[@"types"] = @"170000";
//        params[@"key"] = @"ef1874d4093c90f7219b6296efb344bd";
        params[@"city"] = [mUserDefaults objectForKey:@"userCity"];
//        params[@"citylimit"] = @YES;
        [TZHttpTool postWithURL:ApiSearchCompany params:params success:^(NSDictionary *result) {
            [self.tableView3 hideNoData];
            self.dataSource3 = [NSMutableArray arrayWithArray:[XYMapResultModel mj_objectArrayWithKeyValuesArray:result[@"data"]]];
            [self.tableView3 configNoDataTipViewWithCount:self.dataSource3.count tipText:@"暂无搜索结果"];
            [self.tableView3 reloadData];
            [self.tableView3 endRefresh];
        } failure:^(NSString *msg) {
            if ([msg isEqualToString:@"未查到相关企业"]) {
                [self showAlert];
            }
            [self.tableView3 configNoDataTipViewWithCount:self.dataSource3.count tipText:@"暂无搜索结果"];
            [self.tableView3 endRefresh];
        }];
    } else {
        params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
        params[@"search_word"] = self.searchText;
        if (seleBtnIndex == 0) {
            params[@"page"] = @(self.page1);
            params[@"tag"] = @"1";
        } else {
            params[@"page"] = @(self.page2);
            params[@"tag"] = @"2";
        }
        [TZHttpTool postWithURL:ApiSearchFriend params:params success:^(NSDictionary *result) {
            NSArray *array = [XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"friend"]];
            if (seleBtnIndex == 0) {
                if (self.page1 == 1) {
                    [self.dataSource1 removeAllObjects];
                }
                self.totalPage1 = [result[@"data"][@"count_page"] integerValue];
                [self.dataSource1 addObjectsFromArray:array];
                [self.tableView1 configNoDataTipViewWithCount:self.dataSource1.count tipText:@"暂无搜索结果"];
                [self.tableView1 reloadData];
                [self.tableView1 endRefresh];
            } else {
                if (self.page2 == 1) {
                    [self.dataSource2 removeAllObjects];
                }
                self.totalPage2 = [result[@"data"][@"count_page"] integerValue];
                [self.dataSource2 addObjectsFromArray:array];
                [self.tableView2 configNoDataTipViewWithCount:self.dataSource2.count tipText:@"暂无搜索结果"];
                [self.tableView2 reloadData];
                [self.tableView2 endRefresh];
            }
        } failure:^(NSString *msg) {
            if (seleBtnIndex == 0) {
                [self.tableView1 endRefresh];
            } else {
                [self.tableView2 endRefresh];
            }
            
        }];
    }
}

- (void)searchCompanyColleague {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];;
    params[@"search_word"] = self.searchCompanyName;
    params[@"page"] = @(self.page3);
    params[@"tag"] = @"3";
    [TZHttpTool postWithURL:ApiSearchFriend params:params success:^(NSDictionary *result) {
        [self.tableView3 hideNoData];
        if (self.page3 == 1) {
            [self.colleagues removeAllObjects];
        }
        self.totalPage3 = [result[@"data"][@"count_page"] integerValue];
        [self.colleagues addObjectsFromArray:[XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"friend"]]];
        [_tableView3 configNoDataTipViewWithCount:self.colleagues.count tipText:@"暂无搜索结果"];
        [_tableView3 reloadData];
        [_tableView3 endRefresh];
    } failure:^(NSString *msg) {
        [_tableView3 endRefresh];
    }];
}


#pragma mark -- UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchText = searchBar.text;
    if (searchBar.text.length < 1) return;
    if (_headerBtns.selectBtnIndex == 0) {
        self.page1 = 1;
        [self searchAction];
    } else if (_headerBtns.selectBtnIndex == 1) {
        self.page2 = 1;
        [self searchAction];
    } else {
        _isSearch = NO;
        [self loadSearchFriendData];
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (_headerBtns.selectBtnIndex == 2) {
//        _isSearch = NO;
//        [self loadSearchFriendData];
//    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSLog(@"%f",offsetX);
    NSInteger index = (offsetX + mScreenWidth / 2) / mScreenWidth;
    if (!self.isManuChangeType && offsetX) {
        _headerBtns.selectBtnIndex = index;
        _searchBar.text = @"";
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isManuChangeType = NO;
}


#pragma mark - Get

- (UITableView *)tableView1 {
    if (_tableView1 == nil) {
        _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - self.scrollViewY) style:UITableViewStylePlain];
        _tableView1.backgroundColor = TZControllerBgColor;
        _tableView1.dataSource = self;
        _tableView1.delegate = self;
        _tableView1.tableFooterView = [[UIView alloc] init];
        _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView1 registerCellByNibName:@"TZAddFriendCell"];
        _tableView1.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithHeader)];
//        _tableView1.mj_header = header;
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithFooter)];
        _tableView1.mj_footer = footer;
        [self.bigScrollView addSubview:_tableView1];
    }
    return _tableView1;
}

- (UITableView *)tableView2 {
    if (_tableView2 == nil) {
        _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(mScreenWidth, 0, mScreenWidth, mScreenHeight - 64 - self.scrollViewY) style:UITableViewStylePlain];
        _tableView2.backgroundColor = TZControllerBgColor;
        _tableView2.dataSource = self;
        _tableView2.delegate = self;
        _tableView2.tableFooterView = [[UIView alloc] init];
        _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView2.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView2 registerCellByNibName:@"TZAddFriendCell"];
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithFooter)];
        _tableView2.mj_footer = footer;
        [self.bigScrollView addSubview:_tableView2];
    }
    return _tableView2;
}

- (UITableView *)tableView3 {
    if (_tableView3 == nil) {
        _tableView3 = [[UITableView alloc] initWithFrame:CGRectMake(2 * mScreenWidth, 0, mScreenWidth, mScreenHeight - 64 - self.scrollViewY) style:UITableViewStylePlain];
        _tableView3.backgroundColor = TZControllerBgColor;
        _tableView3.dataSource = self;
        _tableView3.delegate = self;
        _tableView3.tableFooterView = [[UIView alloc] init];
        _tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView3.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView3 registerCellByClassName:@"XYShowMapResultCell"];
        [_tableView3 registerCellByNibName:@"TZAddFriendCell"];
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithFooter)];
        _tableView3.mj_footer = footer;
        [self.bigScrollView addSubview:_tableView3];
    }
    return _tableView3;
}


#pragma mark --UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = _headerBtns.selectBtnIndex;
    if (index == 0) {
        return self.dataSource1.count;
    } else if (index == 1) {
        return self.dataSource2.count;
    } else {
        if (_isSearch) {
            return self.colleagues.count;
        } else {
            return self.dataSource3.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView1) {
        if (self.dataSource1.count) {
            return 34;
        } else {
            return 0.00001;
        }
    } else if (tableView == self.tableView2){
        if (self.dataSource2.count) {
            return 34;
        } else {
            return 0.000001;
        }
    } else {
        if (_isSearch) {
            if (self.colleagues.count) {
                return 34;
            } else {
                return 0.00001;
            }
        } else {
            if (self.dataSource3.count) {
                return 34;
            } else {
                return 0.00001;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = TZColorRGB(246);
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = TZColorRGB(150);
    if (tableView == self.tableView1) {
        if (self.dataSource1.count) {
            label.text = @"  搜索结果";
        } else {
            label.text = @"";
        }
    } else if (tableView == self.tableView2) {
        if (self.dataSource2.count) {
            XYUserInfoModel *infoModel = [TZUserManager getUserModel];
            NSString *loca;
            if (self.searchText && self.searchText.length) {
                loca = self.searchText;
            } else {
                loca = infoModel.hometown;
            }
            NSString *appStr = [NSString stringWithFormat:@"  都来自“%@”",loca];
            label.text = appStr;
        } else {
            label.text = @"";
        }
    } else {
        if (_isSearch) {
            if (self.colleagues.count) {
                XYMapResultModel *model = self.dataSource3[section];
                NSString *appStr = [NSString stringWithFormat:@"  都来自“%@”",model.name];
                label.text = appStr;
            } else {
                label.text = @"";
            }
        } else {
            if (self.dataSource3.count) {
                label.text = @"  搜索结果";
            } else {
                label.text = @"";
            }
        }
    }
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = _headerBtns.selectBtnIndex;
    if (index == 2) {
        if (_isSearch) {
            TZAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZAddFriendCell"];
            cell.moreView.hidden = YES;
            cell.timeLabel.hidden = YES;
            cell.distanceLabel.hidden = YES;
            XYRecommendFriendModel *model = self.colleagues[indexPath.row];
            cell.recommendFriendMode = model;
            if (model.isconcern) {
                cell.type = TZAddFriendCellTypeBothAttention;
            } else {
                cell.type = TZAddFriendCellTypeNoAttention;
            }
            [cell addBottomSeperatorViewWithHeight:1];
            [cell setDidAttentionBlock:^{// 关注
                model.isconcern = !model.isconcern;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self checkAttentionStatusWithBuddyName:model.username];
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            XYShowMapResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYShowMapResultCell"];
            cell.selImageView.hidden = YES;
            XYMapResultModel *model = self.dataSource3[indexPath.row];
            cell.titleLabel.text = model.name;
            cell.subTileLabel.text = model.address;
            [cell addBottomSeperatorViewWithHeight:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else {
        TZAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZAddFriendCell"];
        cell.moreView.hidden = YES;
        cell.timeLabel.hidden = YES;
        cell.distanceLabel.hidden = YES;
        XYRecommendFriendModel *model;
        if (index == 0) {
            model = self.dataSource1[indexPath.row];
        } else {
            model = self.dataSource2[indexPath.row];
        }
        cell.recommendFriendMode = model;
        if (model.isconcern) {
            cell.type = TZAddFriendCellTypeBothAttention;
        } else {
            cell.type = TZAddFriendCellTypeNoAttention;
        }
        [cell addBottomSeperatorViewWithHeight:1];
        [cell setDidAttentionBlock:^{// 关注
            model.isconcern = !model.isconcern ;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self checkAttentionStatusWithBuddyName:model.username];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView3 && !_isSearch) {
        _isSearch = YES;
        XYMapResultModel *model = self.dataSource3[indexPath.row];
        self.searchCompanyName = model.name;
        _searchBar.text = model.name;
        [self searchCompanyColleague];
    } else {
        ICESelfInfoViewController *friendVc = [[ICESelfInfoViewController alloc] init];
        friendVc.type = ICESelfInfoViewControllerTypeOther;
        XYRecommendFriendModel *remodel;
        if (tableView == self.tableView1) {
            remodel = self.dataSource1[indexPath.row];
        } else if (tableView == self.tableView2) {
            remodel = self.dataSource2[indexPath.row];
        } else if (tableView == self.tableView3) {
            if (_isSearch) {
                remodel = self.colleagues[indexPath.row];
            }
        }
        friendVc.nickName = remodel.nickname;
        friendVc.otherUsername = remodel.username;
        [self.navigationController pushViewController:friendVc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshDataWithFooter {
    NSInteger index = _headerBtns.selectBtnIndex;
    if (index == 0) {
        self.page1 ++;
        if (self.page1 > self.totalPage1) {
            [_tableView1.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self loadSearchFriendData];
        }
    } else if (index == 1) {
        self.page2 ++;
        if (self.page2 > self.totalPage2) {
            [_tableView2.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self loadSearchFriendData];
        }
    } else {
        if (_isSearch) {
            self.page3 ++;
            if (self.page3 > self.totalPage3) {
                [_tableView3.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self searchCompanyColleague];
            }
        } else {
            [_tableView3.mj_footer endRefreshingWithNoMoreData];
        }
    }
}


#pragma mark -- 
- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未查到相关企业,是否添加" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self addUserCompany];
}

- (void)checkAttentionStatusWithBuddyName:(NSString *)buddyName {
    if (buddyName && buddyName.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
        params[@"username"] = buddyName;
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



@end
