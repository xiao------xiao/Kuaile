//
//  XYSubscribeViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/23.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSubscribeViewController.h"
#import "XYDetailListCell.h"
#import "TZButtonsHeaderView.h"
#import "XYConfigViewController.h"
#import "XYSubscribeModel.h"
#import "TZFullTimeJobViewController.h"
#import "XYWelfareModel.h"
#import "TZJobExpViewController.h"
#import "TZJobExpModel.h"
#import "XYJobExperienceViewController.h"
#import "LFindLocationViewController.h"

@interface XYSubscribeViewController ()<LFindLocationViewControllerDelegete>{
    NSArray *_titles1;
    NSArray *_titles2;
}

@property (nonatomic, strong) UISwitch *swit;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) TZButtonsBottomView *conformBtn;
@property (nonatomic, assign) NSInteger segeIndex;
@property (nonatomic, strong) UITextField *keyTextField;
@property (nonatomic, strong) NSArray *welfares;
@property (nonatomic, copy) NSString *credibility;
@property (nonatomic, assign) NSInteger warnNum;
@property (nonatomic, strong) NSMutableArray *exps;
@property (nonatomic, copy) NSString *welfareIds;
@property (nonatomic, copy) NSString *jobLaid;
@property (nonatomic, assign) NSInteger areaID;
@property (nonatomic, assign) NSInteger exp;
@property (nonatomic, copy) NSString *hopeSalary;
@property (nonatomic, strong) NSArray *selectedWelfares;
@end

@implementation XYSubscribeViewController

- (UISegmentedControl *)segment {
    if (_segment == nil) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"全部",@"开心直招",@"企业直招",@"代招"]];
        _segment.size = CGSizeMake(250, 25);
        if (mScreenWidth < 375) {
            _segment.size = CGSizeMake(216, 25);
            [_segment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:0];
        }
        _segment.tintColor = TZColor(30, 176, 252);
        _segment.selectedSegmentIndex = 0;
        [_segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

- (UISwitch *)swit {
    if (!_swit) {
        _swit = [[UISwitch alloc] init];
        [_swit addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _swit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职位订阅";
    self.navigationItem.rightBarButtonItem = nil;
    _model = [[XYSubscribeModel alloc] init];
    self.segeIndex = 0;
    self.warnNum = 0;
    [self configDefaultData];
    [self configTableView];
    [self configConformBtn];
    
    [mNotificationCenter addObserver:self selector:@selector(didClickPopSelectView:) name:@"didClickPopSelectViewNoti" object:nil];
}

- (void)didClickPopSelectView:(NSNotification *)noti {
    if (self.row == 4) {
        NSInteger num = [noti.userInfo[@"selRow"] integerValue];
        self.credibility = [NSString stringWithFormat:@"%zd",num];
    }
}

- (void)createSubscribe {
//    sessionid	是	string
//    keywords	是	string	关键词
//    class	是	int	分类id
//    hope_city	是	int	区域id
//    hope_salary	是	string	期望薪资，按职位列表传
//    hope_career	是	string	福利，按职位列表传，多个举例940#941#942，#隔开
//    star	是	string	信誉度，传数字1-5代表1-5星
//    exp	是	string	经验，按职位列表
//    origin	是	int	来源，也是职位列表0全部1开心直招2企业直招3代招
//    warn
    
    if ([self.cellDetailTitles1[0] isEqualToString:@"请输入关键字"]) {[self showAlertView]; return;}
    if ([self.cellDetailTitles2[0] isEqualToString:@"请选择"]) {[self showAlertView]; return;}
    if ([self.cellDetailTitles2[1] isEqualToString:@"请选择"]) {[self showAlertView]; return;}
    if ([self.cellDetailTitles2[2] isEqualToString:@"请选择"]) {[self showAlertView]; return;}
    if ([self.cellDetailTitles2[3] isEqualToString:@"请选择"]) {[self showAlertView]; return;}
    if ([self.cellDetailTitles2[4] isEqualToString:@"请选择"]) {[self showAlertView]; return;}
    if ([self.cellDetailTitles2[5] isEqualToString:@"请选择"]) {[self showAlertView]; return;}
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    params[@"keywords"] = self.keyTextField.text;
    params[@"class"] = self.jobLaid;
//    params[@"hope_city"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"];
    params[@"hope_city"] = @(self.areaID);
    params[@"hope_salary"] = self.hopeSalary;
    params[@"hope_career"] = self.welfareIds;
    params[@"star"] = self.credibility;
    params[@"origin"] = @(self.segeIndex);
    params[@"warn"] = @(self.warnNum);
    params[@"exp"] = @(self.exp);
    [TZHttpTool postWithURL:ApiSubscribe params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"订阅成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [super done];
        });
    } failure:^(NSString *msg) {
        [self showErrorHUDWithError:@"订阅失败"];
    }];
}

- (void)configDefaultData {
    _titles1 = @[@"关键字"];
    self.cellDetailTitles1 = [NSMutableArray arrayWithArray:@[@"请输入关键字"]];
    _titles2 = @[@"职位分类",@"区域",@"薪资",@"福利",@"信誉度",@"经验"];
    self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[@"请选择",@"请选择",@"请选择",@"请选择",@"请选择",@"请选择"]];
}

- (void)configConformBtn {
    _conformBtn = [[TZButtonsBottomView alloc] init];
    _conformBtn.frame = CGRectMake(30, 44 * 9 + 8 * 2 + 20, mScreenWidth - 60, 60);
    _conformBtn.backgroundColor = [UIColor clearColor];
    _conformBtn.titles = @[@"生成订阅"];
    _conformBtn.btnY = 8;
    _conformBtn.showBackground = YES;
    _conformBtn.bgColors = @[TZColor(33, 192, 251)];
    MJWeakSelf
    [_conformBtn setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        [weakSelf createSubscribe];
    }];
    [self.view addSubview:_conformBtn];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerCellByClassName:@"XYDetailListCell"];
    [self.tableView registerCellByClassName:@"UITableViewCell"];
    [super configTableView];
}

#pragma mark -------------UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) { return _titles1.count;}
    else if (section == 1) { return _titles2.count + 1;}
    else { return 1;}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = TZControllerBgColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 2) {
        XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
        if (indexPath.section == 0) {
            cell.text = _titles1[indexPath.row];
            cell.subText = self.cellDetailTitles1[indexPath.row];
        } else {
            if (indexPath.row == _titles2.count) {
                cell.text = @"来源";
                cell.accessoryView = self.segment;
                cell.more.hidden = YES;
            } else {
                cell.text = _titles2[indexPath.row];
                cell.subText = self.cellDetailTitles2[indexPath.row];
            }
        }
        cell.labelFont = 16;
        cell.subLabelFont = 16;
        if (mScreenWidth < 375) {
            cell.labelFont = 14;
            cell.subLabelFont = 14;
        }
        cell.labelX = 14;
        cell.subLabelX = mScreenWidth * 0.28;
        cell.labelTextColor = TZColorRGB(102);
        cell.subLabelTextColor = TZGreyText150Color;
        [cell addBottomSeperatorViewWithHeight:1];
        return cell;
    } else {
        UITableViewCell *lastCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        lastCell.textLabel.text = @"三天内有相似职位自动提醒";
        lastCell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        if (mScreenWidth < 375 ) {
            lastCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        }
        lastCell.textLabel.textColor = TZColorRGB(97);
        lastCell.accessoryView = self.swit;
        return lastCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIAlertView *keyAlert = [UIAlertView alertViewWithTitle:@"请输入关键字" message:nil delegate:self];
        self.keyTextField = [keyAlert textFieldAtIndex:0];
        self.keyTextField.keyboardType = UIKeyboardTypeDefault;
        if (![self.cellDetailTitles1[0] isEqualToString:@"请输入关键字"]) {
            self.keyTextField.text = self.cellDetailTitles1[0];
        }
        [[keyAlert rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
            if (x.integerValue == 1) {
                [self refreshCellDetailNamesWith:self.keyTextField.text];
//                [self refreshCellDetailNamesWith:self.nameField.text row:indexPath.row section:indexPath.section];
            }
        }];
        [keyAlert show];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            TZFullTimeJobViewController *fullTimeVc = [[TZFullTimeJobViewController alloc] initWithNibName:@"TZFullTimeJobViewController" bundle:nil];
            fullTimeVc.type = TZFullTimeJobViewControllerJobType;
            // 初始化returnJobType的block
            fullTimeVc.returnJobType = ^(NSString *jobType,NSString *laid,TZFullTimeJobType laidOrClassJobType) {
                [self refreshCellDetailNamesWith:jobType];
                self.jobLaid = laid;
            };
            [self.navigationController pushViewController:fullTimeVc animated:YES];
        } else if (indexPath.row == 1) {
//            self.selectView.labTitle.text = @"期望工作区域";
//            [self showPopSelectViewWithArray:[TZCitisManager getCitis]];
            LFindLocationViewController *cityChooseVc = [[LFindLocationViewController alloc] init];
            cityChooseVc.delegete = self;
            cityChooseVc.loctionCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"];
            [self.navigationController pushViewController:cityChooseVc animated:YES];
            
        } else if (indexPath.row == 2) {
            self.selectView.labTitle.text = @"期望薪资";
            [self showPopSelectViewWithArray:@[@"不限",@"面议",@"2000元/月以下",@"2001-3000元/月",@"3001-5000元/月",@"5001-8000元/月",@"8001-10000元/月",@"10001-15000元/月",@"15001-25000元/月",@"25001元/月以上"]];
        } else if (indexPath.row == 3) {
            [self loadNetAllWelfaresWithIndexPath:indexPath];
        } else if (indexPath.row == 4) {
            self.selectView.labTitle.text = @"信誉度";
            [self showPopSelectViewWithArray:@[@"一星",@"二星",@"三星",@"四星",@"五星"]];
        } else if (indexPath.row == 5) {
            self.selectView.labTitle.text = @"工作年限";
            [self showPopSelectViewWithArray:@[@"无经验",@"1年以下",@"1~3年",@"3~5年",@"5~10年",@"10年以上"]];
            // 工作经验
//            XYJobExperienceViewController *jobExpVc = [[XYJobExperienceViewController alloc] init];
//            jobExpVc.jobExps = [NSMutableArray arrayWithArray:nil];
//            jobExpVc.type = XYJobExperienceViewControllerTypeNormal;
//            [jobExpVc setReturnJobExps:^(NSMutableArray *jobExps){
//                self.exps = [NSMutableArray arrayWithArray:jobExps];
//                if (self.exps.count != 0) {
//                    [self refreshCellDetailNamesWith:@"已完善"];
//                } else {
//                    [self refreshCellDetailNamesWith:@"未填写"];
//                }
//            }];
//            [self.navigationController pushViewController:jobExpVc animated:YES];
        }
    }
    self.section = indexPath.section;
    self.row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)loadNetAllWelfaresWithIndexPath:(NSIndexPath *)indexPath {
//    NSArray *welfares = [TZUserManager getSavedWelfareData];
//    if (welfares == nil) {
//        welfares = [TZUserManager getCompanyWelfare];
//    }
    NSArray *welfares = [TZUserManager getCompanyWelfare];
    XYWelfareModel *anyWelfare = [[XYWelfareModel alloc] init];
    anyWelfare.laid = @"0";
    anyWelfare.title = @"不限";
    NSMutableArray *appendWelfares = [NSMutableArray arrayWithArray:welfares];
    [appendWelfares insertObject:anyWelfare atIndex:0];
    [self pushConfigVcWithTitle:@"福利列表" vcType:XYConfigViewControllerTypeTableViewWithSaveRightItem models:appendWelfares indexPath:indexPath];
}


- (void)pushConfigVcWithTitle:(NSString *)title vcType:(XYConfigViewControllerType)vcType models:(NSArray *)models indexPath:(NSIndexPath *)indexPath{
    XYDetailListCell *selCell = [self.tableView cellForRowAtIndexPath:indexPath];
    XYConfigViewController *configVc = [[XYConfigViewController alloc] init];
    configVc.selRow = selCell.selRow;
    configVc.didClickTableView = selCell.didClickRow;
    configVc.type = vcType;
    configVc.titleText = title;
    if (models) {
        configVc.models = models;
        configVc.selectedModels = self.selectedWelfares;
    }
    configVc.placeText = nil;
    [configVc setDidClickConformBtnBlock:^(NSString *text) {
        selCell.subText = text;
    }];
    [configVc setDidSelecteTableViewRowBlock:^(NSString *text,NSInteger selRow,BOOL didClickRow) {
        selCell.subText = text;
        selCell.selRow = selRow;
        selCell.didClickRow = didClickRow;
    }];
    [configVc setDidClickSaveBtnBlick:^(NSString *title,NSString *laidStr, NSArray *selModels){
//        selCell.subText = title;
        [self refreshCellDetailNamesWith:title];
        self.welfareIds = laidStr;
        self.selectedWelfares = selModels;
    }];
    [self.navigationController pushViewController:configVc animated:YES];
}

#pragma mamrk -- private

- (void)segmentClick:(UISegmentedControl *)segment {
    self.segeIndex = segment.selectedSegmentIndex;
}

- (void)switchValueChange:(UISwitch *)swit {
    if (swit.isOn) {
        self.warnNum = 1;
    } else {
        self.warnNum = 0;
    }
}

- (void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation {
    [self refreshCellDetailNamesWith:city];
    NSString *cityID = [ZYLocationTools getCityIDWithCityName:city];
    self.areaID = cityID.integerValue;
}

- (void)popSelectViewDidSelectedCell:(NSString *)cellName index:(NSInteger)index{
    [super popSelectViewDidSelectedCell:cellName index:index];
    if (self.row == 2) {
        NSString *salaryStr = cellName;
        if ([salaryStr containsString:@"元"]) {
            NSArray *allSalary = [salaryStr componentsSeparatedByString:@"元"];
            NSString *preSalary = [allSalary firstObject];
            if ([preSalary containsString:@"-"]) {
                self.hopeSalary = [preSalary stringByReplacingOccurrencesOfString:@"-" withString:@"0"];
            }
        } else {
            if ([salaryStr isEqualToString:@"不限"]) {
                self.hopeSalary = @"0";
            } else if ([salaryStr isEqualToString:@"面议"]) {
                self.hopeSalary = @"1";
            }
        }
    } else if (self.row == 5) {
        self.exp = index;
    }
    
}


@end
