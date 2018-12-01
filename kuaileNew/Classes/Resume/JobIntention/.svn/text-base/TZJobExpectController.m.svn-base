//
//  TZJobExpectController.m
//  kuaile
//
//  Created by tanzhen on 15/9/22.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobExpectController.h"
#import "TZFullTimeJobViewController.h"
#import "TZResumeModel.h"
#import "ICEJobExpect.h"

@interface TZJobExpectController ()<TZPopSelectViewDelegate>
{
    UISwitch *_cellSwitch;
    ICEJobExpect *_modelJobExpect;
    TZFullTimeJobType _fullTimeJobType;
}
@end

@implementation TZJobExpectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"求职意向";
    [self configTableView];
    [self setUpPopInputView];
    [self loadNetWorkData:YES];
    
    _modelJobExpect = [[ICEJobExpect alloc] init];
}

- (void)configTableView {
    self.cellTitles1 = @[@"期望工作区域", @"期望薪资", @"期望职位"];
    self.cellDetailTitles1 = [NSMutableArray array];
    self.cellDetailTitles1[0] = self.model.hope_town ? self.model.hope_town : @"请选择";
    self.cellDetailTitles1[1] = self.model.hope_salary ? self.model.hope_salary : @"请选择";;
    self.cellDetailTitles1[2] = self.model.hope_career ? self.model.hope_career : @"请选择";;
    
    self.cellTitles2 = @[@""];
    
    [super configTableView];
}

- (void)setUpPopInputView {
    TZPopSelectView *selectedView = [[TZPopSelectView alloc] init];
    CGFloat height = 44 * (self.selectView.options.count + 1);
    selectedView.frame = CGRectMake(30, __kScreenHeight + 64 + 100, __kScreenWidth - 60, height);
    selectedView.hidden = YES;
    selectedView.delegate = self;
    self.selectView = selectedView;
    
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = [UIColor lightGrayColor];
    cover.alpha = 0.4;
    cover.frame = CGRectMake(0, __kScreenHeight, __kScreenWidth, __kScreenHeight);
    self.cover = cover;
    [self.cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:cover];
    [self.navigationController.view addSubview:selectedView];
}

#pragma mark tableView的数据源和代理方法

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TZResumeRootCell *cell = [TZResumeRootCell resumeRootCell:tableView];
        [self configCell:cell indexPath:indexPath];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = self.type == TZJobExpectControllerTypeResume ? @"三天内有相似职位自动投递" : @"三天内有相似职位自动提醒";
        _cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        cell.accessoryView = _cellSwitch;
        if ([_modelJobExpect.warn isEqualToString:@"1"]) {
            _cellSwitch.on = YES;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: { // 期望工作区域
                [self showPopSelectViewWithArray:[TZCitisManager getCitis]];
            }  break;
            case 1: { // 期望薪资
                [self showPopSelectViewWithArray:@[@"不限",@"面议",@"2000元/月以下",@"2001-3000元/月",@"3001-5000元/月",@"5001-8000元/月",@"8001-10000元/月",@"10001-15000元/月",@"15001-25000元/月",@"25001元/月以上"]];
            }  break;
            case 2: { // 期望职位
                TZFullTimeJobViewController *fullTimeVc = [[TZFullTimeJobViewController alloc] initWithNibName:@"TZFullTimeJobViewController" bundle:nil];
                fullTimeVc.type = TZFullTimeJobViewControllerJobType;
                // 初始化returnJobType的block
                fullTimeVc.returnJobType = ^(NSString *jobType,NSString *laid,TZFullTimeJobType laidOrClassJobType) {
                    _fullTimeJobType = laidOrClassJobType;
                    [self refreshCellDetailNamesWith:jobType];
                };
                [self.navigationController pushViewController:fullTimeVc animated:YES];
            }  break;
            default:
                break;
        }
    } else {
        
    }
    
    self.row = indexPath.row;
    self.section = indexPath.section;
    self.selectView.labTitle.text = self.cellTitles1[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)done {
    // 检查数据
    if ([self.cellDetailTitles1[0] isEqualToString:@"请选择"])  { [self showAlertView]; return;}
    if ([self.cellDetailTitles1[1] isEqualToString:@"请选择"])  { [self showAlertView]; return;}
    if ([self.cellDetailTitles1[2] isEqualToString:@"请选择"])  { [self showAlertView]; return;}
    // 修改模型
    _modelJobExpect.hope_town = self.cellDetailTitles1[0];
    _modelJobExpect.hope_salary = self.cellDetailTitles1[1];
    _modelJobExpect.hope_career = self.cellDetailTitles1[2];
    _modelJobExpect.warn = _cellSwitch.isOn ? @"1" : @"0";
    // 返回模型
    if (self.returnJobExpect) {
        self.returnJobExpect();
    }
    
    [self updataNetWorkData];
}

//-------------------------------------------------------------------------------------------
- (void)loadNetWorkData:(BOOL)isUp {
    [[ICEImporter userIntension] subscribeNext:^(id x) {
        _modelJobExpect = [ICEJobExpect objectWithKeyValues:x[@"data"]];
        self.cellDetailTitles1[0] = _modelJobExpect.hope_city ? _modelJobExpect.hope_city : @"请选择";
        self.cellDetailTitles1[1] = _modelJobExpect.hope_salary ? _modelJobExpect.hope_salary : @"请选择";;
        self.cellDetailTitles1[2] = _modelJobExpect.hope_career ? _modelJobExpect.hope_career : @"请选择";;
        if ([_modelJobExpect.is_hot isEqualToString:@"1"]) {
            _fullTimeJobType = TZFullTimeJobTypeHot;
        } else {
            _fullTimeJobType = TZFullTimeJobTypeAll;
        }
        [self.tableView reloadData];
    }];
}

- (void)updataNetWorkData {
    NSString *is_hot = _fullTimeJobType == TZFullTimeJobTypeHot ? @"1" : @"0";
    NSDictionary *parmas = @{
                             @"hope_city" : _modelJobExpect.hope_town,
                             @"hope_salary" : _modelJobExpect.hope_salary,
                             @"hope_career" : _modelJobExpect.hope_career,
                             @"warn" : _modelJobExpect.warn,
                             @"is_hot" : is_hot
                             };
    RACSignal *sign = [ICEImporter JobInvensionWithPamams:parmas];
    @weakify(self);
    [sign subscribeNext:^(id x) {
        @strongify(self);
        [self showInfo:@"修改成功！"];
        [self performSelector:@selector(pustViewController) withObject:nil afterDelay:1.5f];
    }];
}

- (void)pustViewController {
    [super done];
}

#pragma mark 按钮点击
#if 0
- (void)done {
    // 检查数据
    if ([self.cellDetailTitles1[0] isEqualToString:@"请选择"])  { [self showAlertView]; return;}
    if ([self.cellDetailTitles1[1] isEqualToString:@"请选择"])  { [self showAlertView]; return;}
    if ([self.cellDetailTitles1[2] isEqualToString:@"请选择"])  { [self showAlertView]; return;}
    // 修改模型
    self.model.hope_town = self.cellDetailTitles1[0];
    self.model.hope_salary = self.cellDetailTitles1[1];
    self.model.hope_career = self.cellDetailTitles1[2];
    self.model.deliver = _cellSwitch.isOn ? @"1" : @"0";
    // 返回模型
    if (self.returnJobExpect) {
        self.returnJobExpect();
    }
    [super done];
}
#endif

@end
