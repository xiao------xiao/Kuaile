//
//  XYNewFriendDetailController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/8.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYNewFriendDetailController.h"
#import "TZStoreNaviBar.h"
#import "XYNewFriendHeaderView.h"
#import "TZAddFrindTableView.h"
#import "XYDetailListCell.h"
#import "ZJMoreBtnTipView.h"
#import "XYRecommendFriendModel.h"

@interface XYNewFriendDetailController ()

@property (nonatomic, strong) TZStoreNaviBar *naviBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *smallScrollView;
@property (nonatomic, strong) XYNewFriendHeaderView *headerView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) TZButtonsBottomView *bottomView;
@property (nonatomic, strong) UITableView *tableView1;
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, strong) ZJMoreBtnTipView *tipView;

@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, assign) NSInteger page;

@end

@implementation XYNewFriendDetailController

- (ZJMoreBtnTipView *)tipView {
    if (_tipView == nil) {
        _tipView = [[ZJMoreBtnTipView alloc] init];
        _tipView.frame = CGRectMake(0, 64, mScreenWidth, mScreenHeight - 64);
        [_tipView creatViewBtn];
        [self.view addSubview:_tipView];
        _tipView.hidden = YES;
        MJWeakSelf
        [_tipView setBtnClickBlock:^(NSInteger tag) {
            if (tag == 0) {
//                if ([XYUserManager isLogin]) {
//                    XYMessageViewController *vc = [[XYMessageViewController alloc] init];
//                    [weakSelf.navigationController pushViewController:vc animated:YES];
//                }
            } else {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomePage" object:nil];
//                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    return _tipView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.view.backgroundColor = TZControllerBgColor;
    [self configScrollView];
    [self configNaviButton];
    [self configTZNaviBarView];
    [self configHeaderView];
    [self configSmallScrollView];
    [self configTableView1];
    [self configTableView2];
    [self configBottmView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)loadMoreFriendNotiData {
    NSString *sessionId = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiRecommendMoreFriendLists params:@{@"sessionid":sessionId} success:^(NSDictionary *result) {
        self.models = [XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
    } failure:^(NSString *msg) {
    
    }];
}


- (void)configScrollView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = TZControllerBgColor;
    _scrollView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - 50);
    _scrollView.bounces = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(mScreenWidth, 10000)];
}

- (void)configSmallScrollView {
    CGFloat smallY = CGRectGetMaxY(_headerView.frame) + 5;
    _smallScrollView = [[UIScrollView alloc] init];
    _smallScrollView.frame = CGRectMake(0, smallY, mScreenWidth, mScreenHeight - smallY);
    [_scrollView addSubview:_smallScrollView];
}

- (void)configHeaderView {
    _headerView = [[XYNewFriendHeaderView alloc] init];
    _headerView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight/2);
    MJWeakSelf
    [_headerView setDidClickButtonsViewBlock:^(NSInteger index) {
        [weakSelf.smallScrollView setContentOffset:CGPointMake(index * mScreenWidth, 0) animated:YES];
    }];
    [_scrollView addSubview:_headerView];
}

- (void)configTZNaviBarView {
    _naviBar = [[TZStoreNaviBar alloc] init];
    _naviBar.frame = CGRectMake(0, 0, __kScreenWidth, 66);
    [self.view addSubview:_naviBar];
    [self.view bringSubviewToFront:self.scrollView];
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.moreButton];
    
    __weak typeof(self) weakSelf = self;
    [[_naviBar.messageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf didClickBackButton:weakSelf.backButton];
    }];
}

- (void)configNaviButton {
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 27, 30, 30)];
    _backButton.alpha = 1;
    [_backButton.layer addStandardShadow];
    [_backButton setImage:[UIImage imageNamed:@"navi_back"]  forState:0];
    [_backButton addTarget:self action:@selector(didClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(mScreenWidth - 40, 27, 30, 30)];
    _moreButton.alpha = 1;
    [_moreButton.layer addStandardShadow];
    [_moreButton setImage:[UIImage imageNamed:@"diandian"]  forState:0];
    [_moreButton addTarget:self action:@selector(didClickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_moreButton];
    
}

- (void)configTableView1 {
    _tableView1 = [self getTableViewWithIndex:0];
    
}

- (void)configTableView2 {
    _tableView2 = [self getTableViewWithIndex:1];
}

- (void)configBottmView {
    _bottomView = [[TZButtonsBottomView alloc] init];
    
    _bottomView.frame = CGRectMake(0, mScreenHeight - 50, mScreenWidth, 50);
    _bottomView.titles = @[@"发消息",@"+关注"];
    _bottomView.bgColors = @[TZColor(1, 196, 255),TZColor(70, 175, 255)];
    MJWeakSelf
    [_bottomView setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        //
    }];
    [self.view addSubview:_bottomView];
}

- (void)didClickBackButton:(UIButton*)backButton {
    if (self.navigationController.childViewControllers.count >= 2) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didClickMoreButton:(UIButton *)moreButton {
    self.tipView.hidden = !self.tipView.hidden;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _smallScrollView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger index = (offsetX + mScreenWidth / 2) / mScreenWidth;
        _headerView.selHeaderView.selectBtnIndex = index;
//        if (!self.isManuChangeType) {
//            _headerBtns.selectBtnIndex = index;
//        }
//        if (index > 0) {  [self tableView3]; }
    } else if (scrollView == _scrollView) {
        [self refreshNavigationBarAlpha];
    }
}



- (void)refreshNavigationBarAlpha {
    CGFloat offsetY = self.scrollView.mj_offsetY;

    if (offsetY < 64) {
        _backButton.alpha = 1 - offsetY/64;
        self.naviBar.alphaFloat = 0;
        [self.view bringSubviewToFront:self.scrollView];
        [self.view bringSubviewToFront:self.backButton];
//        [self.view bringSubviewToFront:self.markButton];
        return;
    }
    [self.view bringSubviewToFront:self.naviBar];
    if (offsetY < 128) {
        self.naviBar.alphaFloat = (offsetY - 64)/64;
        _backButton.alpha = 0;
    } else {
        self.naviBar.alphaFloat = 1;
        _backButton.alpha = 0;
    }
}

- (TZAddFrindTableView *)getTableViewWithIndex:(NSInteger)index {
    TZAddFrindTableView *tableView = [[TZAddFrindTableView alloc] initWithFrame:CGRectMake(index * mScreenWidth , 0, mScreenWidth, _smallScrollView.height) style:UITableViewStylePlain];
    [tableView registerCellByClassName:@"XYDetailListCell"];
    tableView.scrollEnabled = NO;
    tableView.tableFooterView = [UIView new];
    tableView.index = index;
    tableView.delegate = tableView;
    tableView.dataSource = tableView;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.backgroundColor = TZControllerBgColor;
    tableView.type = TZAddFriendTableViewTypeNewFriendNews;
    tableView.texts = @[@"昵称",@"家乡",@"现居地",@"感情状况",@"个性签名"];
    tableView.subTexts = @[@"刘能",@"辽宁铁岭",@"辽宁铁岭",@"已婚",@"呵呵呵"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.smallScrollView addSubview:tableView];
    
    return tableView;
}




@end
