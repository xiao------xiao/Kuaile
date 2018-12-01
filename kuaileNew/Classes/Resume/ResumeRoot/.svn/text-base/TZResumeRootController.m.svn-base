//
//  TZResumeRootController.m
//  kuaile
//
//  Created by liujingyi on 15/9/24.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZResumeRootController.h"

@interface TZResumeRootController ()<UITableViewDataSource,UITableViewDelegate,TZDatePickerViewDelegate,TZPopSelectViewDelegate>
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIButton *maskView;

@end

@implementation TZResumeRootController

#pragma mark 配置界面

//- (UIButton *)cover {
//    if (_cover == nil) {
//        UIButton *cover = [[UIButton alloc] init];
//        cover.backgroundColor = [UIColor lightGrayColor];
//        cover.alpha = 0.4;
//        cover.frame = CGRectMake(0, __kScreenHeight, __kScreenWidth, __kScreenHeight);
//        [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
//        _cover = cover;
//    }
//    return _cover;
//}

- (void)dealloc {
    [self.maskView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPopSelectView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
}

- (void)configTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = __kColorWithRGBA(246, 246, 246, 1.0);
}

- (void)configDatePickerView {
    TZDatePickerView *datePickerView = [[TZDatePickerView alloc] init];
    datePickerView.frame = CGRectMake(30, __kScreenHeight + 64 + 100, __kScreenWidth - 60, 200);
    datePickerView.hidden = YES;
    datePickerView.delegate = self;
    self.datePickerView = datePickerView;
    [self.maskView addSubview:datePickerView];
//    [self.navigationController.view addSubview:datePickerView];
}

- (void)setUpPopSelectView {
    TZPopSelectView *selectView = [[TZPopSelectView alloc] init];
    CGFloat height = 44 * (self.selectView.options.count + 1);
    selectView.frame = CGRectMake(30, __kScreenHeight + 64 + 100, __kScreenWidth - 60, height);
    selectView.hidden = YES;
    selectView.delegate = self;
    self.selectView = selectView;
    [self.maskView addSubview:self.cover];
    [self.maskView addSubview:self.selectView];

//    [self.navigationController.view addSubview:self.cover];
//    [self.navigationController.view addSubview:self.selectView];
}

#pragma mark tableView的数据源和代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.cellTitles1.count > 0) self.number = 1;
    if (self.cellTitles2.count > 0) self.number = 2;
    if (self.cellTitles3.count > 0) self.number = 3;
    if (self.cellTitles4.count > 0) self.number = 4;
    if (self.cellTitles5.count > 0) self.number = 5;
    if (self.cellTitles6.count > 0) self.number = 7; // 此时只有创建简历页面能到这里。
    return self.number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.number) {
        case 1:
            return self.cellTitles1.count;
            break;
        case 2:
            return section == 0 ? self.cellTitles1.count : self.cellTitles2.count;
            break;
        case 3:
            if (section == 0) return self.cellTitles1.count;
            else return section == 1 ? self.cellTitles2.count : self.cellTitles3.count;
            break;
        default:
            return 0;
            break;
    }
}

- (void)configCell:(TZResumeRootCell *)cell indexPath:(NSIndexPath *)indexPath {
    // 设置标题
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = self.cellTitles1[indexPath.row];
            cell.detailTextLabel.text = self.cellDetailTitles1[indexPath.row];
        }   break;
        case 1: {
            cell.textLabel.text = self.cellTitles2[indexPath.row];
            cell.detailTextLabel.text = self.cellDetailTitles2[indexPath.row];
        }   break;
        case 2: {
            cell.textLabel.text = self.cellTitles3[indexPath.row];
            cell.detailTextLabel.text = self.cellDetailTitles3[indexPath.row];
        }   break;
        default:
            break;
    }
    // 设置外观
    if ([cell.detailTextLabel.text isEqualToString:@"请输入"] || [cell.detailTextLabel.text isEqualToString:@"请选择"] || [cell.detailTextLabel.text isEqualToString:@"未完善"]) {
        cell.detailTextLabel.textColor = [UIColor redColor];
    } else {
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZResumeRootCell *cell = [TZResumeRootCell resumeRootCell:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.tableView.style == UITableViewStyleGrouped) {
        return 20;
    } else {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 6) {
        return 40;
    }
    if (self.tableView.style == UITableViewStyleGrouped) {
        return 0.5;
    } else {
        return 0.5;
    }
}

#pragma mark 弹出选择框相关

- (void)showSelectViewWithYears {
    NSMutableArray *years = [NSMutableArray array];
    for (NSInteger i = 1999; i>= 1955; i--) {
        [years addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    self.selectView.row = 9;
    [self showPopSelectViewWithArray:years];
}

- (void)showPopSelectViewWithArray:(NSArray *)options {
    [self coverClick];
    self.maskView.hidden = NO;

    self.selectView.options = [NSMutableArray arrayWithArray:options];;
    self.selectView.hidden = NO;
    self.cover.y = 0;
    self.selectView.y = 64 + 100;
    CGFloat maxHeight = __kScreenHeight - 180;
    self.selectView.height = 44 * (self.selectView.options.count + 1) > maxHeight ? maxHeight : 44 * (self.selectView.options.count + 1);
    self.selectView.y = (__kScreenHeight - self.selectView.height)/2;
    
}

- (void)coverClick {
    self.selectView.hidden = YES;
    self.datePickerView.hidden = YES;
    self.cover.y = __kScreenHeight;
    self.selectView.y = __kScreenHeight + (__kScreenHeight - 64 - self.selectView.height)/2;
    self.datePickerView.y = __kScreenHeight + (__kScreenHeight - 64 - self.datePickerView.height)/2;
}

#pragma mark 选择框代理方法 TZPopselectViewDelegate

- (void)popSelectViewDidClickCancleButton {
    [self coverClick];
}

- (void)popSelectViewDidSelectedCell:(NSString *)cellName index:(NSInteger)index{
    self.maskView.hidden = YES;
    [self refreshCellDetailNamesWith:cellName];
    [self coverClick];
}

#pragma mark datePickerView相关

- (void)showDatePickerView {
    
    self.selectView.hidden = YES;
    
    self.maskView.hidden = NO;
    self.datePickerView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.cover.y = 0;
        self.datePickerView.y = (__kScreenHeight - self.datePickerView.height)/2;
    }];
    
    
    
    
}



#pragma mark TZDatePickerViewDelegate

- (void)datePickerViewDidClickCancleButton {
    [self coverClick];
}

- (void)datePickerViewDidClickUntilNowButton {
    // 局部刷新
    [self refreshCellDetailNamesWith:@"至今"];
    [self coverClick];
}

- (void)datePickerViewDidClickOKButton:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *date = [formatter stringFromDate:datePicker.date];
    // 局部刷新
    [self refreshCellDetailNamesWith:date];
    [self coverClick];
    self.maskView.hidden = YES;
}

#pragma mark 按钮点击事件

- (void)done {
    DLog(@"确定按钮被点击");
    [self.navigationController popViewControllerAnimated:YES];
    // 具体做什么事情，由子类自己写
}

#pragma mark 私有方法

- (void)refreshCellDetailNamesWith:(NSString *)name {
    
    if (![name isEqualToString:@""] && name != nil) { // 输入不为空才刷新
        if (self.section == 0) {
            [self.cellDetailTitles1 replaceObjectAtIndex:self.row withObject:name];
        } else if (self.section == 1){
            [self.cellDetailTitles2 replaceObjectAtIndex:self.row withObject:name];
        } else if (self.section == 2) {
            [self.cellDetailTitles3 replaceObjectAtIndex:self.row withObject:name];
        } else if (self.section == 3) {
            [self.cellDetailTitles4 replaceObjectAtIndex:self.row withObject:name];
        } else if (self.section == 4) {
            [self.cellDetailTitles5 replaceObjectAtIndex:self.row withObject:name];
        } else if (self.section == 5) {
            [self.cellDetailTitles6 replaceObjectAtIndex:self.row withObject:name];
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.row inSection:self.section];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"haveRefreshCellDetailNames" object:self];
}

- (void)showAlertView {
    self.alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"信息未填完将不会保存，确定离开界面吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [self.alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && alertView == self.alertView) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)maskClick {
    _maskView.hidden = YES;;
}

- (UIButton *)maskView {
    
    
    if (!_maskView) {
        _maskView = [UIButton buttonWithType:UIButtonTypeCustom];
        _maskView.frame = [UIScreen mainScreen].bounds;
        _maskView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.6];
        [_maskView addTarget:self action:@selector(maskClick) forControlEvents:UIControlEventTouchUpInside];
        _maskView.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
        
        
        
    }
    
    if (![_maskView.superview isKindOfClass:[UIView class]]) {
        [[UIApplication sharedApplication].keyWindow addSubview:_maskView];

    }
    
    return _maskView;
}

@end
