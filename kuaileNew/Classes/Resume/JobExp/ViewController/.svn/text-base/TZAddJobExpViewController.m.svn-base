//
//  TZAddJobExpViewController.m
//  kuaile
//
//  Created by liujingyi on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZAddJobExpViewController.h"
#import "TZJobDescViewController.h"
#import "TZFullTimeJobViewController.h"
#import "TZJobExpModel.h"
#import "XYCheckMoreCell.h"
#import "XYDetailListCell.h"

@interface TZAddJobExpViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
/** 输入框相关 */
@property (nonatomic, strong) UITextField *companyNameField;
@property (nonatomic, strong) UITextField *jobNameField;
@property (nonatomic, strong) TZJobExpModel *model;
@end

@implementation TZAddJobExpViewController

#pragma mark 配置界面

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self configDatePickerView];
    if (self.jobExps.count) {
        self.title = @"修改工作经验";
    } else {
        self.title = @"添加工作经验";
    }
    self.navigationItem.rightBarButtonItem = nil;
}


- (void)configTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerCellByClassName:@"XYDetailListCell"];
    [self.tableView registerCellByClassName:@"XYCheckMoreCell"];
    [super configTableView];
    self.cellTitles1 = @[@"公司名称", @"开始时间",@"结束时间"];
    self.cellTitles2 = @[@"职位类别", @"职位名称", @"工作描述"];
   
    // 判断是否是编辑工作经验
    if (self.jobExps.count > 0) {
        self.model = self.jobExps[self.index];
        self.cellDetailTitles1 = [NSMutableArray arrayWithArray:@[self.model.company_name,self.model.job_start,self.model.job_end]];
        self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[self.model.department,self.model.job_name,self.model.job_desc]];
    } else {
        self.cellDetailTitles1 = [NSMutableArray arrayWithArray:@[@"请输入",@"请选择",@"请选择"]];
        self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[@"请选择",@"请输入",@"请输入"]];
    }
    [self.tableView reloadData];
}

#pragma mark tableView的数据源和代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 20;
    } else {
        return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        XYCheckMoreCell *addCell = [tableView dequeueReusableCellWithIdentifier:@"XYCheckMoreCell"];
        [addCell configButtonWithImg:nil text:@"确认并保存"];
        addCell.button.titleLabel.font = [UIFont systemFontOfSize:17];
        [addCell.button setTitleColor:TZColor(6, 191, 252) forState:0];
        [addCell setDidClickBtnBlock:^{
            [self done];
        }];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return addCell;
    } else {
        XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
        if (indexPath.section == 0) {
            cell.text = self.cellTitles1[indexPath.row];
            cell.subText = self.cellDetailTitles1[indexPath.row];
            if (indexPath.row == 1 || indexPath.row == 2) cell.imageName = @"selltime";
        } else {
            cell.text = self.cellTitles2[indexPath.row];
            cell.subText = self.cellDetailTitles2[indexPath.row];
            cell.imageName = @"genduo";
        }
        cell.labelX = 12;
        cell.label.font = [UIFont systemFontOfSize:16];
        cell.subLabelFont = 16;
        if (mScreenWidth < 375) {
            cell.labelX = 8;
            cell.label.font = [UIFont boldSystemFontOfSize:14];
            cell.subLabelFont = 14;
        }
        cell.labelTextColor = TZColorRGB(170);
        cell.subLabelTextColor = TZColorRGB(170);
        cell.subLabelX = mScreenWidth * 0.36;
        [cell addBottomSeperatorViewWithHeight:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: { // 公司名称 [输入] [用ReactiveCocoa处理]
                UIAlertView *companyAlertView = [UIAlertView alertViewWithTitle:@"请输入公司名称" message:nil delegate:self];
                self.companyNameField = [companyAlertView textFieldAtIndex:0];
                if (![self.cellDetailTitles1[0] isEqualToString:@"请输入"]) {
                    self.companyNameField.text = self.cellDetailTitles1[0];
                }
                [[companyAlertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
                    if ([indexNumber intValue] == 1) {
                        [self refreshCellDetailNamesWith:self.companyNameField.text];
                    }
                }]; 
                [companyAlertView show];
            }  break;
            case 1: { // 任职开始时间 [选择]
                [self showDatePickerView];
                self.datePickerView.untilNowButton.hidden = YES;
            }  break;
            case 2: { // 任职结束时间 [选择]
                [self showDatePickerView];
                self.datePickerView.untilNowButton.hidden = NO;
            }  break;
            default:
                break;
        }
        self.selectView.labTitle.text = self.cellTitles1[indexPath.row];
    } else {
        switch (indexPath.row) {
            case 0: { // 职位类别 [选择]
                TZFullTimeJobViewController *fullTimeVc = [[TZFullTimeJobViewController alloc] initWithNibName:@"TZFullTimeJobViewController" bundle:nil];
                fullTimeVc.type = TZFullTimeJobViewControllerJobType;
                // 初始化returnJobType的block
                fullTimeVc.returnJobType = ^(NSString *jobType,NSString *laid,TZFullTimeJobType laidOrClassJobType) {
                    [self refreshCellDetailNamesWith:jobType];
                };
                [self.navigationController pushViewController:fullTimeVc animated:YES];
            }  break;
            case 1: { // 职位名称 [输入]
                UIAlertView *jobAlertView = [UIAlertView alertViewWithTitle:@"请输入职位名称" message:nil delegate:self];
                self.jobNameField = [jobAlertView textFieldAtIndex:0];
                if (![self.cellDetailTitles2[1] isEqualToString:@"请输入"]) {
                    self.jobNameField.text = self.cellDetailTitles2[1];
                }
                [[jobAlertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
                    if ([indexNumber intValue] == 1) {
                        [self refreshCellDetailNamesWith:self.jobNameField.text];
                    }
                }];
                [jobAlertView show];
            }  break;
            case 2: { // 工作描述 [输入]
                TZJobDescViewController *jobDescVc = [[TZJobDescViewController alloc] init];
                jobDescVc.title = @"工作描述";
                if (self.model.job_desc.length > 0) {
                    jobDescVc.labTitle = self.model.job_desc;
                }
                jobDescVc.returnJobDesc = ^(NSString *jobDesc) {
                    [self refreshCellDetailNamesWith:jobDesc];
                    self.model.job_desc = jobDesc;
                };
                [self.navigationController pushViewController:jobDescVc animated:YES];
            }  break;
            default:
                break;
        }
        self.selectView.labTitle.text = self.cellTitles2[indexPath.row];
    }
    self.row = indexPath.row;
    self.section = indexPath.section;
}

#pragma mark 点击事件
#warning 工作经验这里。用了两个block，一个是更新单条工作经验，一个是更新所有工作经验。有点乱。不过现在没bug了。
// 工作经验里，有一共4种情况。   一、创建简历状态下的：创建工作经验、更新工作经验  二、更新简历状态下的：创建工作经验、更新工作经验  所以这里的传值需要考虑不同情况
/** 按钮的点击 */
- (void)done {
    // 返回模型数据
    if (self.isEdit == NO) { // 添加工作经验
        // 检查数据
        if ([self.cellDetailTitles1[0] isEqualToString:@"请输入"])  { [self showAlertView]; return;}
        if ([self.cellDetailTitles1[1] isEqualToString:@"请选择"])  { [self showAlertView]; return;}
        // if ([self.cellDetailTitles1[2] isEqualToString:@"请选择"])  { [self showAlertView]; return;}
        if ([self.cellDetailTitles2[0] isEqualToString:@"请选择"])  { [self showAlertView]; return;}
        if ([self.cellDetailTitles2[1] isEqualToString:@"请输入"])  { [self showAlertView]; return;}
        if ([self.cellDetailTitles2[2] isEqualToString:@"请输入"])  { [self showAlertView]; return;}
        
        // 构建模型
        TZJobExpModel *model = [[TZJobExpModel alloc] init];
        [self setDataToModel:model];
        
        // 检查结束时间是否大于开始时间
        if (![self checkTimeIsValidWithModel:model]) {
            return;
        }
        
        if (self.returnJobExpModel) {
            self.returnJobExpModel(model);
            [self showSuccessHUDWithStr:@"添加成功"];
        } else {
            // 创建简历模式 更新该条工作经验。
            [self setDataToModel:self.model];
            self.returnJobExpModels(self.jobExps);
        }
    } else  { // 监测一下确实有work_exp_id才去更新 更新工作经验
        [self setDataToModel:self.model];
        // 编辑简历模式 更新该条工作经验。
        
//        work_exp_id	是	int	工作经验id
//        company_name	是	String	公司名称
//        job_start	是	String	开始时间
//        job_end	是	String	结束时间
//        department	是	String	职位类别
//        job_name	是	String	职位名称
//        job_desc
        
        
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"company_name"] = self.model.company_name;
//        params[@"job_desc"] = self.model.job_desc;
//        params[@"job_start"] = self.model.job_start;
//        params[@"job_end"] = self.model.job_end;
//        params[@"job_name"] = self.model.job_name;
//        params[@"department"] = self.model.department;
//
//        params[@"work_exp_id"] = self.model.work_exp_id;
        
        // 检查结束时间是否大于开始时间
        if (![self checkTimeIsValidWithModel:self.model]) {
            return;
        }
        
//        [TZHttpTool postWithURL:ApiUpdateWorkExp params:params success:^(id json) {
//            DLog(@"更新该条工作经验成功 %@",json);
//        } failure:^(NSString *error) {
//            DLog(@"更新该条工作经验失败 error %@",error);
//        }];
        self.returnJobExpModels(self.jobExps);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super done];
    });
}

- (void)setDataToModel:(TZJobExpModel *)model {
    model.company_name = self.cellDetailTitles1[0];
    model.job_start = self.cellDetailTitles1[1];
    model.job_end = self.cellDetailTitles1[2];
    model.department = self.cellDetailTitles2[0];
    model.job_name = self.cellDetailTitles2[1];
    model.job_desc = self.cellDetailTitles2[2];
}

- (BOOL)checkTimeIsValidWithModel:(TZJobExpModel *)model {
    if (!model.job_end) { return YES;  }
    // 至今处理逻辑
    if ([model.job_end isEqualToString:@"至今"]) { return YES; }
    if (model.job_end.length < 5) {  return YES; }
    
    NSString *startTime = [model.job_start stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *endTime = [model.job_end stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (startTime.integerValue > endTime.integerValue) {
        [self showInfo:@"结束时间不能小于开始时间呢"]; return NO;
    }
    return YES;
}

@end
