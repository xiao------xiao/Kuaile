//
//  HJSreeningViewController.m
//  kuaile
//
//  Created by 胡光健 on 2017/3/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "HJSreeningViewController.h"



@interface HJSreeningViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource> {
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UIButton *girlButton;
@property (weak, nonatomic) IBOutlet UIButton *boyButton;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLayout;

@property (weak, nonatomic) IBOutlet UIButton *fifetyButton;
@property (weak, nonatomic) IBOutlet UIButton *sixtyButton;
@property (weak, nonatomic) IBOutlet UIButton *threeDayButton;
@property (weak, nonatomic) IBOutlet UIButton *oneDayButton;

@property (nonatomic, strong) UIPickerView *picker;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *screeningButton;

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,assign) BOOL selectHideBton;
@property(nonatomic,strong) NSArray * genderArray;
@property(nonatomic,strong) NSArray * allBtnTimeArr;


@property (nonatomic,strong) NSString * selectGenderIndex;
@property (nonatomic,strong) NSString * selectTimeIndex;
@property (nonatomic,strong) NSString * selectAge_lowIndex;
@property (nonatomic,strong) NSString * selectAge_highIndex;

@end

@implementation HJSreeningViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, mScreenHeight / 3, mScreenWidth, mScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.rowHeight = 40;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选附近";
    self.rightNavTitle = @"确定";
    _genderArray = @[self.girlButton,self.boyButton,self.allButton];
    _allBtnTimeArr = @[self.fifetyButton,self.sixtyButton,self.oneDayButton,self.threeDayButton];
    _dataArray = @[@"1岁~10岁",@"11岁~20岁",@"21岁~30岁",@"31岁~40岁",@"41岁~50岁",@"51岁~60岁",@"61岁~70岁"];
//    [self setInitSetting];
}

- (void)setInitSetting {
    // 性别
    NSInteger sexTag = [self.selectedIndexes[0] integerValue];
    for (UIButton *sexBtn in _genderArray) {
        if (sexBtn.tag == sexTag) {
            [self allBtnClicked:sexBtn]; break;
        }
    }
    // 活跃时间
    NSInteger timeTag = [self.selectedIndexes[1] integerValue];
    for (UIButton *timeBtn in _allBtnTimeArr) {
        if (timeBtn.tag == timeTag) {
            [self allBtnTimeClicked:timeBtn]; break;
        }
    }
    // 年龄
    NSInteger ageTag = [self.selectedIndexes[2] integerValue];
}



- (IBAction)allBtnClicked:(UIButton *)sender {
    [self.selectedIndexes replaceObjectAtIndex:0 withObject:@(sender.tag)];
    for (UIButton * btn in self.genderArray) {
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
    if (sender.tag - 10 == 1) {
        _selectGenderIndex = @"1";
    } else if (sender.tag - 10 == 0) {
        _selectGenderIndex = @"0";
    } else if (sender.tag - 10 == 2) {
        _selectGenderIndex = @"2";
    }
}

- (IBAction)allBtnTimeClicked:(UIButton *)sender {
    [self.selectedIndexes replaceObjectAtIndex:1 withObject:@(sender.tag)];
    for (UIButton * btn in self.allBtnTimeArr) {
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
    if (sender.tag - 200 == 0) {
        _selectTimeIndex = @"900";
    }else if (sender.tag - 200 == 1) {
        _selectTimeIndex = @"3600";
    }else if (sender.tag - 200 == 2) {
        _selectTimeIndex = @"86400";
    }else if (sender.tag - 200 == 3) {
        _selectTimeIndex = @"259200";
    }
}

- (IBAction)screeningButton:(UIButton *)sender {
    self.picker.hidden = NO;
    if (!_selectHideBton) {
        [self.view addSubview:self.tableView];
        _selectHideBton = YES;
    }else {
        [self.tableView removeFromSuperview];
        _selectHideBton = NO;
    }
}

#pragma mark --UITableViewDataSource  弹框
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (_dataArray[indexPath.row] > 0) {
        cell.textLabel.text = _dataArray[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.ageLabel.text = _dataArray[indexPath.row];
    [self getNewWorkexpFromWorkexp: self.ageLabel.text];
    [self.tableView removeFromSuperview];
    _selectHideBton = NO;
}
// 配置年龄参数
- (NSString *)getNewWorkexpFromWorkexp:(NSString *)agetext {
    agetext = [agetext stringByReplacingOccurrencesOfString:@"~" withString:@"~"];
    if ([agetext isEqualToString:@"1岁~10岁"]) {
        _selectAge_lowIndex = @"1";
        _selectAge_highIndex = @"10";
    } else if ([agetext isEqualToString:@"11岁~20岁"]) {
        _selectAge_lowIndex = @"11";
        _selectAge_highIndex = @"20";
    } else if ([agetext isEqualToString:@"21岁~30岁"]) {
        _selectAge_lowIndex = @"21";
        _selectAge_highIndex = @"30";
    } else if ([agetext isEqualToString:@"31岁~40岁"]) {
        _selectAge_lowIndex = @"31";
        _selectAge_highIndex = @"40";
    } else if ([agetext isEqualToString:@"41岁~50岁"]) {
        _selectAge_lowIndex = @"41";
        _selectAge_highIndex = @"50";
    } else if ([agetext isEqualToString:@"51岁~60岁"]) {
        _selectAge_lowIndex = @"51";
        _selectAge_highIndex = @"60";
    } else if ([agetext isEqualToString:@"61岁~70岁"]) {
        _selectAge_lowIndex = @"61";
        _selectAge_highIndex = @"70";
    }
    return _selectAge_lowIndex,_selectAge_highIndex;
}

- (void)didClickRightNavAction {
    
    if (!self.selectGenderIndex && !self.selectTimeIndex && !self.selectAge_lowIndex && !self.selectAge_highIndex) {
        [self.navigationController popViewControllerAnimated:YES];

        return;
    }
    
    if (self.didSreeningItemBlock) {
        self.didSreeningItemBlock(self.selectGenderIndex,self.selectTimeIndex,self.selectAge_lowIndex,self.selectAge_highIndex,self.selectedIndexes);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
