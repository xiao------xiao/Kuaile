//
//  XYAddJobExperienceViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/2.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYAddJobExperienceViewController.h"
#import "XYDetailListCell.h"
#import "XYCheckMoreCell.h"
#import "XYConfigViewController.h"
#import "TZDatePickerView.h"

@interface XYAddJobExperienceViewController ()<TZDatePickerViewDelegate>{
    NSArray *_titles1;
    NSArray *_titles2;
    NSArray *_subTitles1;
    NSArray *_subTitles2;
}
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) TZDatePickerView *datePickerView;
@property (nonatomic, strong) UIButton *coverBtn;
@end

@implementation XYAddJobExperienceViewController

- (UIButton *)coverBtn {
    if (_coverBtn == nil) {
        _coverBtn = [[UIButton alloc] init];
        _coverBtn.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64);
        _coverBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_coverBtn];
    }
    return _coverBtn;
}

- (TZDatePickerView *)datePickerView {
    if (_datePickerView == nil) {
        _datePickerView = [[TZDatePickerView alloc] init];
        _datePickerView.frame = CGRectMake(30, (mScreenHeight - 200 - 64)/2.0, mScreenWidth - 60, 200);
        _datePickerView.delegate = self;
        [self.view addSubview:_datePickerView];
    }
    return _datePickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加工作经验";
    [self loadDefaultSettingData];
}

- (void)loadDefaultSettingData {
    _titles1 = @[@"公司名称",@"开始时间",@"结束时间"];
    _titles2 = @[@"职位类别",@"职位名称",@"工作描述"];
    _subTitles1 = @[@"请输入",@"请选择",@"请选择"];
    _subTitles2 = @[@"请选择",@"请输入",@"请输入"];
}

//- (void)configConfirmBtn {
//    CGFloat confirmBtnY = CGRectGetMaxY(self.tableView.frame) + 50;
//    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _confirmBtn.frame = CGRectMake(0, confirmBtnY, mScreenWidth, 50);
//    [_confirmBtn setTitle:@"确认并保存" forState:0];
//    [_confirmBtn setTitleColor:TZColor(6, 191, 252) forState:0];
//    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_confirmBtn];
//}

- (void)configTableView {
    self.needRefresh = NO;
    [super configTableView];
    [self.tableView registerCellByClassName:@"XYDetailListCell"];
    [self.tableView registerCellByClassName:@"XYCheckMoreCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark -- UITableViewCellDataSource & UITableViewCellDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 1;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 30;
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
            [self.navigationController popViewControllerAnimated:YES];
        }];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return addCell;
    } else {
        XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
        if (indexPath.section == 0) {
            cell.text = _titles1[indexPath.row];
            cell.subText = _subTitles1[indexPath.row];
            if (indexPath.row == 1 || indexPath.row == 2) cell.imageName = @"selltime";
        } else {
            cell.text = _titles2[indexPath.row];
            cell.subText = _subTitles2[indexPath.row];
        }
        cell.labelX = 12;
        cell.label.font = [UIFont systemFontOfSize:16];
        if (mScreenWidth < 375) {
            cell.labelX = 8;
            cell.label.font = [UIFont boldSystemFontOfSize:14];
        }
        cell.labelTextColor = TZColorRGB(170);
        cell.subLabelTextColor = TZColorRGB(170);
        cell.subLabelX = mScreenWidth * 0.36;
        [cell addBottomSeperatorViewWithHeight:1];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self pushConfigVcWithTitle:@"公司名称" vcType:XYConfigViewControllerTypeTextField models:nil indexPath:indexPath];
        } else {
            self.coverBtn.hidden = NO;
            self.datePickerView.hidden = NO;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self pushConfigVcWithTitle:@"职位类别" vcType:XYConfigViewControllerTypeTableView models:nil indexPath:indexPath];
        } else if (indexPath.row == 1) {
            [self pushConfigVcWithTitle:@"职位名称" vcType:XYConfigViewControllerTypeTextField models:nil indexPath:indexPath];
        } else {
            [self pushConfigVcWithTitle:@"工作描述" vcType:XYConfigViewControllerTypeTextView models:nil indexPath:indexPath];
        }
    }
}

#pragma mark -- private

- (void)pushConfigVcWithTitle:(NSString *)title vcType:(XYConfigViewControllerType)vcType models:(NSArray *)models indexPath:(NSIndexPath *)indexPath{
    XYDetailListCell *selCell = [self.tableView cellForRowAtIndexPath:indexPath];
    XYConfigViewController *configVc = [[XYConfigViewController alloc] init];
    configVc.selRow = selCell.selRow;
    configVc.didClickTableView = selCell.didClickRow;
    configVc.type = vcType;
    configVc.titleText = title;
    if (models) {
        configVc.models = models;
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
    [self.navigationController pushViewController:configVc animated:YES];
}


#pragma mark TZDatePickerDelegate

- (void)datePickerViewDidClickOKButton:(UIDatePicker *)datePicker {
    
}

- (void)datePickerViewDidClickCancleButton {
    self.coverBtn.hidden = YES;
    self.datePickerView.hidden = YES;
}


#pragma mark -- private

- (void)coverBtnClick {
    self.coverBtn.hidden = YES;
    self.datePickerView.hidden = YES;
}

//- (void)confirmBtnClick {
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
