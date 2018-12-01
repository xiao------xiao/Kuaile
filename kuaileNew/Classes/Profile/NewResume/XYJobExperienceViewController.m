//
//  XYJobExperienceViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/2.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYJobExperienceViewController.h"
#import "XYJobExperienceCell.h"
#import "XYCheckMoreCell.h"
#import "XYAddJobExperienceViewController.h"
#import "TZJobExpModel.h"
#import "TZAddJobExpViewController.h"

@interface XYJobExperienceViewController ()
@property (nonatomic, strong) ICELoginUserModel *model;
@property (nonatomic, strong) NSMutableArray *expLists;
@property (nonatomic, strong) UIView *noJobExpShowingView;
@property (nonatomic, strong) TZButtonsBottomView *addBtn;
@end

@implementation XYJobExperienceViewController

- (UIView *)noJobExpShowingView {
    if (_noJobExpShowingView == nil) {
        _noJobExpShowingView = [[UIView alloc] initWithFrame:CGRectMake((__kScreenWidth - 200)/2, 50, 200, 220)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resume_noexp"]];
        imageView.frame = CGRectMake(20, 0, 160, 160);
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(-20, 160, 240, 60)];
        lable.lineBreakMode = NSLineBreakByCharWrapping;
        lable.numberOfLines = 0;
        
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"增加工作经验,让工作找上你";
        lable.textColor = [UIColor darkGrayColor];
        lable.font = [UIFont systemFontOfSize:17];
        [_noJobExpShowingView addSubview:lable];
        [_noJobExpShowingView addSubview:imageView];
        [self.view addSubview:_noJobExpShowingView];
    }
    return _noJobExpShowingView;
}

- (NSMutableArray *)jobExps {
    if (!_jobExps) {
        _jobExps = [NSMutableArray array];
    }
    return _jobExps;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作经验";
//    [self configTableView];
    if (self.type == XYJobExperienceViewControllerTypeEdit) {
        [self loadNetworkData];
    } 
    [self setUpJobExpList];
    
    if (self.jobExps.count) {
        self.rightNavTitle = @"保存";
    }
}

- (void)configBottomCreateButton {
    CGFloat btnH = 60;
    if (mScreenWidth < 375) btnH = 50;
    _addBtn = [[TZButtonsBottomView alloc] init];
    _addBtn.frame = CGRectMake(0, mScreenHeight - btnH - 64, mScreenWidth, btnH);
    _addBtn.titles = @[@"添加工作经验"];
    _addBtn.showBackground = YES;
    _addBtn.bgColors = @[TZColor(32, 191, 248)];
    MJWeakSelf
    [_addBtn setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        [weakSelf createNewJobExp];
    }];
    [self.view addSubview:_addBtn];
}

- (void)loadNetworkData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"resume_id"] = self.resume_id;
    params[@"uid"] = [mUserDefaults objectForKey:@"userUid"];
    NSLog(@"%@",params);
    [TZHttpTool postWithURL:ApiJobExpList params:params success:^(NSDictionary *result) {
        NSArray *array = [TZJobExpModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"exp"]];
        for (TZJobExpModel *model in array) {
            CGFloat height = [model.job_desc boundingRectWithSize:CGSizeMake(__kScreenWidth - 16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            model.describeHeight = 90 + height + 30;
            // 有新的model，才添加进来
            BOOL isExist = NO;
            
            
            for (TZJobExpModel *old_model in self.jobExps) {
                if ([old_model.company_name isEqualToString:model.company_name]) {
                    old_model.describeHeight = model.describeHeight;
                    isExist = YES;
                }
            }
            if (isExist == NO) {
                [self.jobExps addObject:model];
            }
        }
        [self setUpJobExpList];
        [self.tableView reloadData];
        [self.tableView endRefresh];
    } failure:^(NSString *msg) {
        [self.tableView endRefresh];
    }];
}

- (void)configTableView {
    if (self.jobExps.count) {
        self.needHeaderRefresh = YES;
        [super configTableView];
        [self.tableView registerCellByNibName:@"XYJobExperienceCell"];
        [self.tableView registerCellByClassName:@"XYCheckMoreCell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

- (void)setUpJobExpList {
    if (self.jobExps == nil || self.jobExps.count == 0) { // 如果没有工作经验数据
//        self.noJobExpShowingView = [[UIView alloc] initWithFrame:CGRectMake((__kScreenWidth - 200)/2, 50, 200, 220)];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resume_noexp"]];
//        imageView.frame = CGRectMake(20, 0, 160, 160);
//        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(-20, 160, 240, 60)];
//        lable.lineBreakMode = NSLineBreakByCharWrapping;
//        lable.numberOfLines = 0;
//        
//        lable.textAlignment = NSTextAlignmentCenter;
//        lable.text = @"增加工作经验,让工作找上你";
//        lable.textColor = [UIColor darkGrayColor];
//        lable.font = [UIFont systemFontOfSize:17];
//        [self.noJobExpShowingView addSubview:lable];
//        [self.noJobExpShowingView addSubview:imageView];
//        [self.view addSubview:self.noJobExpShowingView];
        self.noJobExpShowingView.hidden = NO;
        [self configBottomCreateButton];
    } else { // 如果有工作经验数据
        self.noJobExpShowingView.hidden = NO;
        _addBtn.hidden = YES;
        
//        [self.noJobExpShowingView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        [self.noJobExpShowingView removeFromSuperview];
//        [_addBtn removeFromSuperview];
        [self configTableView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.jobExps.count) {
        return 2;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.jobExps.count) {
        if (section == 1) {
            return 1;
        } else {
            return self.jobExps.count;
        }
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.jobExps.count) {
        if (indexPath.section == 0) {
            TZJobExpModel *model = self.jobExps[indexPath.row];
            return model.describeHeight;
        } else {
            return 50;
        }
    } else {
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = TZColorRGB(230);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 8;
    } else {
        return 0.0001;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XYJobExperienceCell *experienceCell = [tableView dequeueReusableCellWithIdentifier:@"XYJobExperienceCell"];
        experienceCell.model = self.jobExps[indexPath.row];
        experienceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return experienceCell;
    } else {
        XYCheckMoreCell *addCell = [tableView dequeueReusableCellWithIdentifier:@"XYCheckMoreCell"];
        [addCell configButtonWithImg:nil text:@"添加工作经验"];
        addCell.button.titleLabel.font = [UIFont systemFontOfSize:17];
        [addCell.button setTitleColor:TZColor(6, 191, 252) forState:0];
        [addCell setDidClickBtnBlock:^{
            [self createNewJobExp];
        }];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return addCell;
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //删除工作经验
        TZJobExpModel *model = self.jobExps[indexPath.row];
        NSString *expID = model.work_exp_id;
        if (expID) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"uid"] = [mUserDefaults objectForKey:@"userUid"];
            params[@"work_exp_id"] = expID;
            [TZHttpTool postWithURL:ApiDeleteResumeJob params:params success:^(NSDictionary *result) {
                [self showSuccessHUDWithStr:@"删除成功"];
                [self.jobExps removeObject:model];
                if (self.jobExps.count == 0) {
                    [self setUpJobExpList];
                }
                [self.tableView reloadData];
                
            } failure:^(NSString *msg) {
                
            }];
        } else {
            [self showSuccessHUDWithStr:@"删除成功"];
            [self.jobExps removeObject:model];
            if (self.jobExps.count == 0) {
                [self setUpJobExpList];
            }
            [self setUpJobExpList];
            [self.tableView reloadData];
        }
    }];
    return @[action];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TZAddJobExpViewController *addJobExpVc = [[TZAddJobExpViewController alloc] init];
    addJobExpVc.isEdit = YES;
    // 编辑简历模式，返回和传递整个大数组
    addJobExpVc.jobExps = self.jobExps;
    addJobExpVc.index = indexPath.row;
    addJobExpVc.returnJobExpModels = ^(NSMutableArray *jobExps) {
        self.jobExps = jobExps;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:addJobExpVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshDataWithHeader {
    [super refreshDataWithHeader];
}

- (void)refreshDataWithFooter {
    [super refreshDataWithFooter];
}


#pragma mark 点击事件

- (void)createNewJobExp {
    TZAddJobExpViewController *addJobExpVc = [[TZAddJobExpViewController alloc] init];
    addJobExpVc.isEdit = NO;
    // 创建简历模式，返回和传递单一条工作经验
    MJWeakSelf
    addJobExpVc.returnJobExpModel = ^(TZJobExpModel *model){
        CGFloat height2 = [model.job_desc boundingRectWithSize:CGSizeMake(__kScreenWidth - 16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        model.describeHeight = 90 + height2 + 30;
        [weakSelf.jobExps addObject:model];
        if (weakSelf.jobExps.count) {
            weakSelf.rightNavTitle = @"保存";
        }
        [weakSelf setUpJobExpList];
        [weakSelf.tableView reloadData];
        [weakSelf.addBtn removeFromSuperview];
    };
    [self.navigationController pushViewController:addJobExpVc animated:YES];
}

- (void)didClickRightNavAction {
    // 返回数据
    if (self.jobExps.count > 0) {
        if (self.returnJobExps) {
            self.returnJobExps(self.jobExps);
        }
//        self.returnJobExps(self.jobExps);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showAlertView]; return;
    }
}

- (void)showAlertView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"信息未填完将不会保存，确定离开界面吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
