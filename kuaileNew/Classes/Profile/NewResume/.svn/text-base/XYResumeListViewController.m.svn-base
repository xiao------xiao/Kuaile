//
//  XYResumeListViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/21.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYResumeListViewController.h"
#import "XYResumeListCell.h"
#import "TZButtonsHeaderView.h"
#import "XYCollectedJobViewController.h"
#import "XYCreateResumeViewController.h"
#import "XYTipView.h"
#import "TZResumeModel.h"
#import "TZPreviewResumeController.h"


@interface XYResumeListViewController ()<CMPopTipViewDelegate,UIAlertViewDelegate>{
    NSInteger _index;
}
@property (nonatomic, strong) TZButtonsHeaderView *btnView;
@property (nonatomic, strong) TZButtonsBottomView *createBtn;
@property (nonatomic, strong) CMPopTipView *popView;
@property (nonatomic, strong) NSMutableArray *visiblePopTipViews;
@property (nonatomic, strong) XYTipView *tipView;
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIView *nodataView;

@end

@implementation XYResumeListViewController

- (XYTipView *)tipView {
    if (_tipView == nil) {
        _tipView = [[XYTipView alloc] init];
        CGFloat tipViewH = 90;
        CGFloat tipViewW = 120;
        _tipView.btnH = 45;
        _tipView.btnW = 120;
        if (mScreenWidth < 375) {
            tipViewH = 80;
            _tipView.btnH = 40;
            tipViewW = 100;
            _tipView.btnW = 100;
        }
        _tipView.frame = CGRectMake(0, 0, tipViewW, tipViewH);
        _tipView.backgroundColor = [UIColor clearColor];
        _tipView.noCover = YES;
        _tipView.titleColor = [UIColor whiteColor];
        _tipView.lineColor = [UIColor whiteColor];
        _tipView.titleLeftEdge = 5;
        _tipView.imageRightEdge = 5;
        [_tipView configTipBtnsWithTitles:@[@"刷新简历",@"设为默认"] images:@[@"reflash",@"setnormal"]];
        MJWeakSelf
        [_tipView setDidClickBtnBlock:^(NSInteger tag) {
            if (tag == 0) { // 刷新简历
                [weakSelf refreshResume];
            } else { // 设为默认
                [weakSelf setDefaultResume];
            }
        }];
    }
    return _tipView;
}


- (UIView *)nodataView {
    if (_nodataView == nil) {
        _nodataView = [[UIView alloc] initWithFrame:CGRectMake((mScreenWidth - 200)/2, 50, 200, 220)];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake((200 - 108)/2.0, 60, 108, 30);
        imageView.image = [UIImage imageNamed:@"nodate"];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(-20, 120, 240, 60)];
        lable.lineBreakMode = NSLineBreakByCharWrapping;
        lable.numberOfLines = 0;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"简历都木有，怎么找工作\n快来创建简历吧！";
        lable.textColor = TZColorRGB(180);
        lable.font = [UIFont systemFontOfSize:17];
        [_nodataView addSubview:lable];
        [_nodataView addSubview:imageView];
        [self.tableView addSubview:_nodataView];
    }
    return _nodataView;
}

//删除简历时弹出的警告框
- (UIAlertView *)alertView {
    if (_alertView == nil) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"确定删除此简历吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        _alertView.delegate = self;
    }
    return _alertView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的简历";
    _index = 0;
    self.uid = [mUserDefaults objectForKey:@"userUid"];
    self.visiblePopTipViews = [NSMutableArray array];
    [self loadNetworkData];
    [self configButtonView];
    [self configBottomCreateButton];
    
    //创建简历成功之后
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveCreateResumeSuccessful) name:@"haveCreateResumeSuccessful" object:nil];
}

- (void)haveCreateResumeSuccessful {
    [self loadNetworkData];
}

- (void)loadNetworkData {
    [TZHttpTool postWithURL:ApiResumeList params:@{@"uid":self.uid} success:^(NSDictionary *result) {
        self.models = [NSMutableArray arrayWithArray:[TZResumeModel mj_objectArrayWithKeyValuesArray:result[@"data"]]];
        
        if (self.models.count == 0) {
            self.nodataView.hidden = NO;
            [mUserDefaults setObject:@"1" forKey:@"NoResume"];
        } else {
            self.nodataView.hidden = YES;
            [mUserDefaults setObject:@"0" forKey:@"NoResume"];
        }
        [mUserDefaults synchronize];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        self.nodataView.hidden = NO;
        [self.tableView endRefresh];
    }];
}

// 刷新简历
- (void)refreshResume {
    TZResumeModel *model = self.models[self.selectedRow];
    [TZHttpTool postWithURL:ApiRefreshResume params:@{@"resume_id":model.resume_id,@"uid":self.uid} success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"刷新成功"];
        [_popView dismissAnimated:YES];
        [self.visiblePopTipViews removeObject:_popView];
    } failure:^(NSString *msg) {
        [_popView dismissAnimated:YES];
        [self.visiblePopTipViews removeObject:_popView];
    }];
}

//设为默认
- (void)setDefaultResume {
    TZResumeModel *model = self.models[self.selectedRow];
    [mUserDefaults setObject:@"1" forKey:@"defaultResume"];
    [mUserDefaults synchronize];
//    [TZUserManager syncUserDefaultResumeWithModel:model];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"resume_id"] = model.resume_id;
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    MJWeakSelf
    [TZHttpTool postWithURL:ApiSetDefaultResu params:params success:^(NSDictionary *result) {
        TZResumeModel *defaultModel = [TZResumeModel mj_objectWithKeyValues:result[@"data"]];
        [weakSelf showSuccessHUDWithStr:@"设置成功"];
        [weakSelf.tableView.mj_header beginRefreshing];
        [_popView dismissAnimated:YES];
        [TZUserManager syncUserModel];
        [weakSelf.visiblePopTipViews removeObject:_popView];
    } failure:^(NSString *msg) {
        [weakSelf showInfo:msg];
        [_popView dismissAnimated:YES];
        [weakSelf.visiblePopTipViews removeObject:_popView];
    }];
}

- (void)configButtonView {
    _btnView = [[TZButtonsHeaderView alloc] init];
    _btnView.frame = CGRectMake(0, 0, mScreenWidth, 46);
    _btnView.titles = @[@"我的简历",@"我的求职"];
    _btnView.fontSizes = @[@16,@16];
    _btnView.showLines = NO;
    _btnView.boldFont = 16;
    _btnView.changeFontWhenSelected = YES;
    _btnView.selectBtnIndex = 0;
    MJWeakSelf
    [_btnView setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        _index = index;
        if (index == 1) {
            weakSelf.nodataView.hidden = YES;
            _createBtn.hidden = YES;
        } else {
            if (weakSelf.models.count == 0) {
                weakSelf.nodataView.hidden = NO;
            } else {
                weakSelf.nodataView.hidden = YES;
            }
            _createBtn.hidden = NO;
        }
        [weakSelf.tableView reloadData];
    }];
    [self.view addSubview:_btnView];
}

- (void)configBottomCreateButton {
    CGFloat createBtnY = CGRectGetMaxY(self.tableView.frame);
    CGFloat btnH = 60;
    if (mScreenWidth < 375) btnH = 50;
    _createBtn = [[TZButtonsBottomView alloc] init];
    _createBtn.frame = CGRectMake(0, mScreenHeight - btnH - 64, mScreenWidth, btnH);
    
    _createBtn.titles = @[@"创建"];
    _createBtn.showBackground = YES;
    _createBtn.bgColors = @[TZColor(32, 191, 248)];
    MJWeakSelf
    [_createBtn setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        XYCreateResumeViewController *createVc = [[XYCreateResumeViewController alloc] init];
        createVc.type = XYCreateResumeViewControllerTypeNormal;
        [weakSelf.navigationController pushViewController:createVc animated:YES];
    }];
    [self.view addSubview:_createBtn];
}

- (void)configTableView {
    self.needRefresh = YES;
    [super configTableView];
    self.tableView.frame = CGRectMake(0, 46, mScreenWidth, mScreenHeight - 64 - 46 - 50);
    [self.tableView registerCellByNibName:@"XYResumeListCell"];
    [self.tableView registerCellByClassName:@"UITableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_index == 0) { return self.models.count;
    } else {return 2;}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_index == 0) { return 140;
    } else { return 50;}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_index == 0) {
        XYResumeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYResumeListCell"];
        TZResumeModel *model = self.models[indexPath.section];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //编辑
        [cell setDidClickEditBlock:^{
            XYCreateResumeViewController *createVc = [[XYCreateResumeViewController alloc] init];
            createVc.type = XYCreateResumeViewControllerTypeEdit;
            createVc.model = model;
            createVc.resume_id = model.resume_id;
            [self.navigationController pushViewController:createVc animated:YES];
        }];
        //设置
        [cell setDidClickSettingBlock:^(UIButton *btn) {
//            [self showPopTipViewInRow:indexPath.row];
            [self showPopTipViewInBtn:btn];
            self.selectedRow = indexPath.section;
        }];
        //预览
        [cell setDidClickPreviewBlock:^{
//            XYCreateResumeViewController *createVc = [[XYCreateResumeViewController alloc] init];
//            createVc.type = XYCreateResumeViewControllerTypeNormal;
//            [self.navigationController pushViewController:createVc animated:YES];
            TZPreviewResumeController *previewVc = [[TZPreviewResumeController alloc] init];
            previewVc.resume_id = model.resume_id;
            [self.navigationController pushViewController:previewVc animated:YES];
        }];
        //删除
        [cell setDidClickDeleteBlock:^{
            [self.alertView show];
            self.selectedRow = indexPath.section;
//            [self deleteResumeWithModel:model];
        }];
        return cell;
    } else {
        UITableViewCell *employCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        employCell.textLabel.text = @[@"投递记录",@"收藏职位"][indexPath.section];
        employCell.imageView.image = [UIImage imageNamed:@[@"icon_wdjl",@"shoucang"][indexPath.section]];
        employCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        employCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return employCell;
    }
}

//删除简历
- (void)deleteResumeWithModel:(TZResumeModel *)model {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [mUserDefaults objectForKey:@"userUid"];
    params[@"resume_id"] = model.resume_id;
    if (model.isDefault.integerValue == 1) {
        [mUserDefaults setObject:@"0" forKey:@"defaultResume"];
        [mUserDefaults synchronize];
    }
    [TZHttpTool postWithURL:ApiDelResume params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"删除成功"];
        [self.models removeObject:model];
        if (self.models.count == 0) {
            self.nodataView.hidden = NO;
            [mUserDefaults setObject:@"1" forKey:@"NoResume"];
            [mUserDefaults setObject:@"0" forKey:@"defaultResume"];
            [TZUserManager syncUserModel];
        } else {
            [mUserDefaults setObject:@"0" forKey:@"NoResume"];
            if (self.models.count == 1) {
                [mUserDefaults setObject:@"1" forKey:@"defaultResume"];
            }
        }
        
        [mUserDefaults synchronize];
        [self.tableView reloadData];
    } failure:^(NSString *msg) {
        
    }];
}

- (void)showPopTipViewInBtn:(UIButton *)btn {
    _popView = [[CMPopTipView alloc] initWithCustomView:self.tipView];
    _popView.hasShadow = NO;
    _popView.hasGradientBackground = NO;
    _popView.has3DStyle = NO;
    _popView.topMargin = 0;
    _popView.cornerRadius = 4;
    _popView.borderColor = TZColorRGB(71);
    _popView.delegate = self;
    _popView.backgroundColor = TZColorRGB(64);
    _popView.dismissTapAnywhere = YES;
    [_popView presentPointingAtView:btn inView:self.view animated:YES];
    [self.visiblePopTipViews addObject:_popView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_index == 0) {
//        XYCreateResumeViewController *editVc = [[XYCreateResumeViewController alloc] init];
//        TZResumeModel *model = self.models[indexPath.section];
//        editVc.resume_id = model.resume_id;
//        editVc.type = XYCreateResumeViewControllerTypeEdit;
//        [self.navigationController pushViewController:editVc animated:YES];
    } else {
        if (indexPath.section == 1) {
            //职位收藏
            XYCollectedJobViewController *collectVc = [[XYCollectedJobViewController alloc] init];
            collectVc.titleText = @"职位收藏";
            collectVc.type = XYCollectedJobViewControllerTypeCollect;
            [self.navigationController pushViewController:collectVc animated:YES];
        } else {
            //投递记录
            XYCollectedJobViewController *applyVc = [[XYCollectedJobViewController alloc] init];
            applyVc.titleText = @"投递记录";
            applyVc.type = XYCollectedJobViewControllerTypeApply;
            [self.navigationController pushViewController:applyVc animated:YES];
        }
    }
}

#pragma mark - CMPopTipViewDelegate

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    [self.visiblePopTipViews removeObject:popTipView];
}


#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 确定
        TZResumeModel *model = self.models[self.selectedRow];
        [self deleteResumeWithModel:model];
    }
}

#pragma mark -- pravate 




@end
