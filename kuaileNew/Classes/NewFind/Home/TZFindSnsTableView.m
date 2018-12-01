//
//  TZFindSnsTableView.m
//  kuaile
//
//  Created by ttouch on 2016/12/21.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import "TZFindSnsTableView.h"
#import "TZFindSnsCell.h"
#import "ZJNearbyCell.h"
#import "ZYYSnsDetailController.h"
#import "TZFindSnsModel.h"
#import "XYNearViewController.h"
#import "XYNearCell.h"
#import "XYFundamentTabViewController.h"
#import "XYMessageModel.h"
#import "ICESelfInfoViewController.h"


@interface TZFindSnsTableView ()<TZFindSnsCellDelegate> {
    BOOL _retap;
    CGFloat _sizeHeight;
}
@property (nonatomic, copy) NSString * zan_num;
@property (nonatomic, copy) NSString * zansid;
@property (nonatomic, copy) NSString * sessionid;
@property (nonatomic, strong) NSMutableArray *dictModels;
@property (assign, nonatomic) BOOL haveData;
@property (assign, nonatomic) BOOL refresh;
@end


@implementation TZFindSnsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        if (self) {
            self.page = 1;
            self.tableFooterView = [UIView new];
            self.backgroundColor = TZControllerBgColor;
            [self registerCellByNibName:@"TZFindSnsCell"];
            [self registerCellByNibName:@"ZJNearbyCell"];
            [self configRefresh];
            [mNotificationCenter addObserver:self selector:@selector(refreshTableView) name:@"needRefreshFindVcNoti" object:nil];
            
            if (@available(iOS 11.0, *)) {
//                self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                self.estimatedRowHeight = 0;
                self.estimatedSectionHeaderHeight = 0;
                self.estimatedSectionFooterHeight = 0;
            }
            
//            self.needRefresh = YES;
        }
        return self;
    }
    return self;
}

- (NSMutableArray *)dictModels {
    if (_dictModels == nil) {
        _dictModels = [NSMutableArray array];
    }
    return _dictModels;
}

- (NSMutableArray *)models {
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)refreshTableView {
    self.needRefresh = YES;
//    [self reloadData];
    if (self.index == 3) {
        [self loadGetSameTown];
    }else {
        [self loadNetworkData];
    }
}

- (void)configRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithHeader)];
    self.mj_header = header;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithFooter)];
    self.mj_footer = footer;
}

- (void)refreshDataWithFooter {
    
//    [self setContentOffset:CGPointMake(0, self.contentSize.height) animated:NO];
    self.refresh = YES;
    self.needRefresh = YES;
    
    _sizeHeight = self.contentSize.height;
    
    _page ++;
    if (_page > _totalPage) {
        [self.mj_footer endRefreshingWithNoMoreData];
    } else {
        if (self.index == 3) {
            [self loadGetSameTown];
        } else {
            [self loadNetworkData];
        }
    }
}

- (void)refreshDataWithHeader {
    self.refresh = YES;
    self.needRefresh = YES;
    _page = 1;
    if (self.index == 3) {
        [self loadGetSameTown];
    }else {
        [self loadNetworkData];
    }
}

- (void)loadViewDataWithIndex:(NSInteger)index {
    self.index = index;
    if (index < 3) {
        [self loadNetworkData];
    } else {
        [self loadGetSameTown];
    }
}

#pragma mark -- 获取老乡帖子网络请求
-(void)loadGetSameTown {
    
    XYUserInfoModel *model = [TZUserManager getUserModel];

    if (model.hometown == nil || model.hometown.length < 1) {
        [self.models removeAllObjects];
        self.haveData = NO;
        [self reloadData];
        return;
    }
    
    
    if (!self.haveData || self.needRefresh) {
        if (!self.refresh) {
            [self.models addObjectsFromArray:[TZUserManager getSameTownSnsWithTag:4]];
            self.haveData = YES;
            [self reloadData];
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
            params[@"page"]= @(self.page);
            [TZHttpTool postWithURL:ApiSnsGetSameTown params:params success:^(NSDictionary *result) {
                self.haveData = YES;
                self.totalPage = [result[@"data"][@"count_page"] integerValue];
                NSArray * dictArray = result[@"data"][@"sns"];

                NSMutableArray *aar = [NSMutableArray array];
                [dictArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TZFindSnsModel *model = [TZFindSnsModel modelWithDictionary:obj];
                    [aar addObject:model];
                }];
                
                NSArray *array = [TZFindSnsModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"sns"]];
                if (self.page == 1) {
                    [self.models removeAllObjects];
                    [self.dictModels removeAllObjects];
                }
                [self.models addObjectsFromArray:aar];
                [self.dictModels addObjectsFromArray:result[@"data"][@"sns"]];
                [self configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
                // 缓存帖子
                [TZUserManager syncSameTownSnsWithSns:self.dictModels tag:4];
                [self reloadData];
                [self endRefresh];
            } failure:^(NSString *msg) {
                [self endRefresh];
                [self configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
            }];
        });
    }
}

#pragma mark -- 获取帖子的网络请求(帖子类型 1动态 2美拍 3广场)
- (void)loadNetworkData {
    if (!_haveData || self.needRefresh) {
        if (!self.refresh) {
            [self.models addObjectsFromArray:[TZUserManager getSameTownSnsWithTag:self.index + 1]];
            NSArray *ar = self.models;
            self.haveData = YES;
            [self reloadData];
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
        params[@"tag"] = @(self.index+1);
        params[@"page"] = @(self.page);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [TZHttpTool postWithURL:ApiSnsGetSns params:params success:^(NSDictionary *result) {
                self.haveData = YES;
                
                
                self.totalPage = [result[@"data"][@"count_page"] integerValue];
                NSArray * dictArray = result[@"data"][@"sns"];
                
//                NSLog(@"%@", dictArray);

                
                for (NSDictionary * dic in dictArray) {
                    self.zansid = dic[@"sid"];
                    self.zan_num = dic[@"zan_num"];
                }
                
                NSMutableArray *aar = [NSMutableArray array];
                [dictArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TZFindSnsModel *model = [TZFindSnsModel modelWithDictionary:obj];
                    [aar addObject:model];
                }];
                
                NSArray *dataArray = [TZFindSnsModel mj_objectArrayWithKeyValuesArray:dictArray];
                if (self.page == 1) {
                    [self.models removeAllObjects];
                    [self.dictModels removeAllObjects];
                }
                [self.models addObjectsFromArray:aar];
                [self.dictModels addObjectsFromArray:dictArray];
                // 缓存帖子
                [TZUserManager syncSameTownSnsWithSns:self.dictModels tag:self.index+1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                    [self endRefresh];
                    [self configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
                });
            } failure:^(NSString *msg) {
                [self configNoDataTipViewWithCount:self.models.count tipText:@"暂无内容"];
                [self endRefresh];
            }];
        });
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_haveData) {
        return 0;
    } else {
        if (self.index == 4) {
            return 3;
        } else {
            return self.models.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 4) {
        if (indexPath.row == 2) {
            return 3 * 71 +38;
        } else {
            CGFloat cellH = (mScreenWidth - 3) / 4 + 30 +38;
            return cellH;
        }
    } else {
        TZFindSnsModel *model = self.models[indexPath.row];
        return model.totalHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   __block TZFindSnsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZFindSnsCell"];
    
    if (self.models.count <= indexPath.row) {
        return cell;
    }
    
    TZFindSnsModel *model = self.models[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    MJWeakSelf
    cell.blockClickZanReload = ^(NSString *msg) {
        [weakSelf showInfo:msg];
        [weakSelf reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];

//        [weakSelf reloadData];
    };
    // 关注
    __weak typeof(cell) weak_cell = cell;
    __weak typeof(tableView) weak_tableView = tableView;
    __weak typeof(model) weak_model = model;
    [cell setCareBtnClicked:^ {
        if ([TZUserManager isLogin]) {
            [TZHttpTool postWithURL:ApiSnsConcernUser params:@{@"sessionid":[mUserDefaults objectForKey:@"sessionid"],@"buid":model.uid} success:^(NSDictionary *result) {
                weak_model.isconcern = !weak_model.isconcern;
                weak_cell.careBtn.selected = weak_model.isconcern;
                weak_cell.careBtn.layer.borderWidth = weak_model.isconcern ? 0 : 1;
                NSMutableArray *indexArr = [NSMutableArray array];
                for (NSInteger i = 0; i < weakSelf.models.count; i++) {
                    TZFindSnsModel *handleModel = weakSelf.models[i];
                    if ([handleModel.uid isEqualToString:weak_model.uid]) {
                        handleModel.isconcern = weak_model.isconcern;
                        NSIndexPath *index = [NSIndexPath indexPathWithIndex:i];
                        [indexArr addObject:index];
                    }
                }
                [[UIViewController currentViewController] showSuccessHUDWithStr:result[@"msg"]];
                [mNotificationCenter postNotificationName:@"didAddFriendNoti" object:nil];
//                [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];
                [weak_tableView reloadData];
            } failure:^(NSString *msg) {
            }];
        }
    }];
//    // 点赞
//    [cell setCheckMoreZanBlock:^{
//        XYFundamentTabViewController *zanVc = [[XYFundamentTabViewController alloc] init];
//        TZFindSnsModel *model = weakSelf.models[indexPath.row];
//        zanVc.model = model;
//        zanVc.rowH = 60;
//        [[UIViewController currentViewController].navigationController pushViewController:zanVc animated:YES];
//    }];
    // 更多
    [cell setMoreBtnClick:^{
        [weakSelf.models removeObject:model];
        [weak_tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [weak_tableView reloadData];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYYSnsDetailController *vc = [[ZYYSnsDetailController alloc] init];
    TZFindSnsModel *model = self.models[indexPath.row];
    vc.shareIndex = self.index;
    vc.model = model;
    MJWeakSelf;
    [vc setRefreshUIBlock:^{
        [weakSelf reloadData];
    }];
    [vc setRefreshDeleteUIBlock:^(TZFindSnsModel *model, NSString *sid) {
        [self FindSnsCelldelegate:self sidID:sid removeArray:model];
    }];
    
    [[UIViewController currentViewController].navigationController pushViewController:vc animated:YES];
}


#pragma mark -- 跳转到详情页面
-(void)FindSnsCelldelegate:(TZFindSnsCell *)cell removeArray:(TZFindSnsModel *)model {
     if (![TZUserManager isLogin]) return;
    
    
    if (_retap) {
        return;
    }
    _retap = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _retap = NO;
    });
    
    ZYYSnsDetailController *vc = [[ZYYSnsDetailController alloc] init];
    vc.model = model;
    
    MJWeakSelf;
    [vc setRefreshUIBlock:^{
        [weakSelf reloadData];
    }];
    [vc setRefreshDeleteUIBlock:^(TZFindSnsModel *model, NSString *sid) {
       [self FindSnsCelldelegate:self sidID:sid removeArray:model];
    }];
    [[UIViewController currentViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 删除帖子接口请求
-(void)FindSnsCelldelegate:(TZFindSnsCell *)cell sidID:(NSString *)sid removeArray:(TZFindSnsModel *)model{
    NSInteger inde=0;
    for (int i = 0; i < self.models.count; i ++ ) {
        TZFindSnsModel *mm = self.models[i];
        if ([mm.sid isEqualToString:model.sid]) {
            [self.models removeObject:mm];
            inde = i;
            break;
        }
    }
    [self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:inde inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    NSString * str = [mUserDefaults objectForKey:@"sessionid"];
    NSMutableDictionary * params = @{@"sid":@(sid.integerValue),@"sessionid":str};
    [TZHttpTool postWithURL:ApiSnsDel params:params success:^(NSDictionary *result) {
        [self showInfo:@"删除成功"];        
        [ORParentModel removeMsgWithID:sid];
        [mNotificationCenter postNotificationName:kNotiSysMessageListchange object:nil userInfo:@{@"or":@"1"}];
    } failure:^(NSString *msg) {
        [self showInfo:msg];
    }];
}

@end
