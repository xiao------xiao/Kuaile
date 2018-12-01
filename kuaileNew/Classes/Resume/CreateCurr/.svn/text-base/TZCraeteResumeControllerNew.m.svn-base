//
//  TZCraeteResumeControllerNew.m
//  kuaile
//
//  Created by liujingyi on 15/10/14.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "TZCraeteResumeControllerNew.h"
#import "TZJobExpViewController.h"
#import "TZJobExpectController.h"
#import "TZResumeModel.h"
#import "TZCreateResumeCell.h"
#import "TZJobDescViewController.h"
#import "TZFullTimeJobViewController.h"
#import "TZJobExpModel.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface TZCraeteResumeControllerNew ()<UITableViewDataSource,UITableViewDelegate>

/** 输入框相关 */
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *phoneNumField;
@property (nonatomic, strong) UITextField *mailField;
@property (nonatomic, strong) UITextField *majorField;
@property (nonatomic, strong) UIAlertView *nameAlertView;
@property (nonatomic, strong) UIAlertView *majorAlertView;
@property (nonatomic, strong) UIAlertView *phoneAlertView;
@property (nonatomic, strong) UIAlertView *mailAlertView;
// 保存按钮
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
// 添加照片
@property (strong, nonatomic) UIButton *cameraBtn;  // 只要有一个 懒加载
@property (nonatomic, strong) UISwitch *switchView; // 只要有一个 懒加载
@property (nonatomic, strong) UISegmentedControl *segment; // 只要有一个 懒加载
@property (nonatomic, strong) UIImage *img;
// 性别相关
@property (nonatomic, assign) BOOL haveCheck; // 性别这里  segment选择的index 只重置一次
@property (nonatomic, assign) BOOL haveCheckAutoDeliver; // 自动投递这里  开关选择的状态 只重置一次

@end

@implementation TZCraeteResumeControllerNew

- (UISegmentedControl *)segment {
    if (_segment == nil) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"男",@"女"]];
        _segment.selectedSegmentIndex = 0;
        _segment.frame = CGRectMake(30 + 85, 6, __kScreenWidth - 60 - 85, 32);
    }
    return _segment;
}

- (UIButton *)cameraBtn {
    if (_cameraBtn == nil) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setImage:[UIImage imageNamed:@"resume_camera"] forState:UIControlStateNormal];
        _cameraBtn.frame = CGRectMake(0, 8, 50, 50);
        [_cameraBtn addTarget:self action:@selector(getPhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}

- (UISwitch *)switchView {
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}

- (TZResumeModel *)model {
    if (_model == nil) {
        _model = [[TZResumeModel alloc] init];
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self configDatePickerView];
    self.title = _type == TZCreateResumeControllerEdit ? @"编辑简历" : @"创建简历";
    self.saveBtn.layer.cornerRadius = 3;
    self.saveBtn.clipsToBounds = YES;
    self.img = [UIImage imageNamed:@"resume_camera"];
}

- (void)configTableView {
    [super configTableView];
    self.cellTitles1 = @[@"姓       名",@"性       别",@"出生年月",@"最高学历",@"工作年限",@"专       业"];
    self.cellTitles2 = @[@"手机号码",@"邮箱地址"];
    self.cellTitles3 = @[@"期望工作",@"期望薪资",@"期望职位"];
    self.cellTitles4 = @[@"工作经验"];
    self.cellTitles5 = @[@"个人介绍"];
    self.cellTitles6 = @[@"简历照片"];
    
    self.cellDetailTitles1 = [NSMutableArray arrayWithArray:@[@"2-6字，汉字或字母",@"请选择性别",@"请选择出生日期",@"请选择学历",@"请选择工作年限",@"请填写专业"]];
    self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[@"请输入正确的手机号",@"请填写邮箱"]];
    self.cellDetailTitles3 = [NSMutableArray arrayWithArray:@[@"请选择区域",@"请选择期望薪资",@"请选择职位名称"]];
    self.cellDetailTitles4 = [NSMutableArray arrayWithArray:@[@"点击添加工作经验"]];
    self.cellDetailTitles5 = [NSMutableArray arrayWithArray:@[@"添加教育经历、工作经历和自我评价,以获得更多企业关注"]];
    self.cellDetailTitles6 = [NSMutableArray arrayWithArray:@[@"添加形象照片,让企业记住你"]];
    
    // 如果是查看简历，则加载简历数据，更新UI
    if (self.type == TZCreateResumeControllerEdit) {
        [self loadResumeDetailData];
    }
}

- (void)loadResumeDetailData {
    // 请求数据
    [TZHttpTool postWithURL:ApiPreviewResume params:@{@"resume_id":self.resume_id} success:^(id json) {
        DLog(@"拿到简历数据成功 responseObject %@",json);
        self.model.avatar = json[@"data"][@"resume"][@"avatar"];
        self.model.degree = json[@"data"][@"basic"][@"degree"];
        self.model.work_exp = json[@"data"][@"basic"][@"work_exp"];
        self.model.major = json[@"data"][@"basic"][@"major"];
        self.model.telephone = json[@"data"][@"basic"][@"telephone"];
        self.model.hope_city = json[@"data"][@"basic"][@"hope_city"];
        self.model.mail = json[@"data"][@"basic"][@"link_email"];
        self.model.profile = json[@"data"][@"basic"][@"profile"];
        self.model.hope_town = json[@"data"][@"basic"][@"hope_town"];
        self.model.name = json[@"data"][@"basic"][@"name"];
        self.model.birthday = json[@"data"][@"basic"][@"birthday"];
        self.model.gender = [json[@"data"][@"basic"][@"gender"] isEqualToString:@"0"] ? @"男" : @"女";  // 0男 1女
        self.model.workExps = [TZJobExpModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"work"]];
        for (TZJobExpModel *model in self.model.workExps) {
            model.job_start = [[ICETools standardTime:model.job_start] substringToIndex:10];
            if (model.job_end.length < 5) {
                model.job_end = @"至今";
            } else {
                model.job_end = [[ICETools standardTime:model.job_end] substringToIndex:10];
            }
        }
        // 1.更新UI
        self.cellDetailTitles1[0] = self.model.name;
        self.cellDetailTitles1[1] = self.model.gender;
        self.cellDetailTitles1[2] = self.model.birthday;
        self.cellDetailTitles1[3] = self.model.degree;
        self.cellDetailTitles1[4] = self.model.work_exp;
        self.cellDetailTitles1[5] = self.model.major ? self.model.major : @"";
        
        self.cellDetailTitles2[0] = self.model.telephone;
        self.cellDetailTitles2[1] = self.model.mail;
        
        self.cellDetailTitles3[0] = self.model.hope_town;
        self.cellDetailTitles3[1] = self.model.hope_salary;
        self.cellDetailTitles3[2] = self.model.hope_career;
        
        if (self.model.workExps.count == 0) {
            self.cellDetailTitles4[0] = @"未填写";
        } else {
            self.cellDetailTitles4[0] = @"已完善";
        }
        
        self.cellDetailTitles5[0] = self.model.profile;
        
        // 2.下载简历照片
        [self.cameraBtn setImage:[UIImage imageNamed:@"resume_camera"] forState:UIControlStateNormal];
        if (self.model.avatar) {
#warning 20151102 陈冰
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.model.avatar] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                self.img = image;
            }];
            [self.cameraBtn setImage:nil forState:UIControlStateNormal];
            [self.cameraBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"resume_camera"]];
        }
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"拿到简历数据失败 error %@",error);
    }];
}

#pragma mark tableView的数据源和代理方法

// 这里没有设置单元格重用。1、为了加快进度。2、本身也没多少cell,cell的样式却不少，重用的话代码量加大不少。 by 谭真
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZCreateResumeCell *cell = [[TZCreateResumeCell alloc] init];
    CGFloat height = 44;
    switch (indexPath.section) {
        case 0: { // 第一组，基本信息
            cell.title1.text = self.cellTitles1[indexPath.row];
            /*
            if (indexPath.row == 1) { // 性别
                cell.title2.text = self.model.gender;
                [cell addSubview:self.segment];
                if ([self.model.gender isEqualToString:@"女"] && self.haveCheck == NO) {
                    self.segment.selectedSegmentIndex = 1;
                    self.haveCheck = YES;
                }
            } else { */
                cell.title2.text = self.cellDetailTitles1[indexPath.row];
                cell.accessoryType = indexPath.row > 0 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            // }
        }  break;
        case 1: { // 第二组，认证信息
            cell.title1.text = self.cellTitles2[indexPath.row];
            cell.title2.text = self.cellDetailTitles2[indexPath.row];
        }  break;
        case 2: { // 第三组，期望工作
            cell.title1.text = self.cellTitles3[indexPath.row];
            cell.title2.text = self.cellDetailTitles3[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }  break;
        case 3: { // 第四组，工作经验
            cell.title1.text = self.cellTitles4[indexPath.row];
            cell.title2.text = self.cellDetailTitles4[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }  break;
        case 4: { // 第五组，个人介绍
            cell.title1.text = self.cellTitles5[indexPath.row];
            cell.title2.text = self.cellDetailTitles5[indexPath.row];
            height = 66;
        }  break;
        case 5: { // 第六组，简历照片
            cell.title1.text = self.cellTitles6[indexPath.row];
            cell.title2.text = self.cellDetailTitles6[indexPath.row];
            cell.accessoryView = self.cameraBtn;
            height = 66;
        }  break;
        case 6: { // 第七组，三天内自动投递
            UITableViewCell *cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell1.textLabel.text = @"三天内有相似工作自动投递";
            cell1.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = __kColorWithRGBA1(144, 144, 144);
            cell1.accessoryView = self.switchView;
            if (self.haveCheckAutoDeliver == NO) {
                self.switchView.on = [self.model.deliver isEqualToString:@"1"] ? YES:NO;
                self.haveCheckAutoDeliver = YES;
            }
            return cell1;
        }  break;
        default:
            break;
    }
    [self configDetailTextLableColorWithCell:cell];
    [cell addSubview:[UIView divideViewWithHeight:height]];
    return cell;
}

// 把必填项的颜色变成红色
- (void)configDetailTextLableColorWithCell:(TZCreateResumeCell *)cell {
    /*
     self.cellDetailTitles2 = [@"2-6字，汉字或字母",@"",@"请选择出生日期",@"请选择学历",@"请选择工作年限"]];
     self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[@"请输入正确的手机号",@"请填写邮箱"]];
     self.cellDetailTitles3 = [NSMutableArray arrayWithArray:@[@"请选择区域",@"请选择期望薪资",@"请选择职位名称"]];
     self.cellDetailTitles4 = [NSMutableArray arrayWithArray:@[@"点击添加工作经验"]];
     self.cellDetailTitles5 = [NSMutableArray arrayWithArray:@[@"添加教育经历、工作经历和自我评价,以获得更多企业关注"]];
     self.cellDetailTitles6 = [NSMutableArray arrayWithArray:@[@"添加形象照片,让企业记住你"]];
     */
    if ([cell.title2.text isEqualToString:@"2-6字，汉字或字母"] || [cell.title2.text isEqualToString:@"请选择性别"] || [cell.title2.text isEqualToString:@"请选择出生日期"] || [cell.title2.text isEqualToString:@"请选择学历"] || [cell.title2.text isEqualToString:@"请输入正确的手机号"] || [cell.title2.text isEqualToString:@"请选择区域"]) {
        cell.title2.textColor = [UIColor redColor];
    } else {
        cell.title2.textColor = [UIColor lightGrayColor];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.cellTitles1.count;
            break;
        case 1:
            return self.cellTitles2.count;
            break;
        case 2:
            return self.cellTitles3.count;
            break;
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4 || indexPath.section == 5) { // 个人介绍 简历照片
        return 66;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: { // 基本信息
            switch (indexPath.row) {
                case 0: { // 姓名
                    self.nameAlertView = [UIAlertView alertViewWithTitle:@"请输入真实姓名" message:nil delegate:self];
                    self.nameField = [self.nameAlertView textFieldAtIndex:0];
                    self.nameField.keyboardType = UIKeyboardTypeDefault;
                    if (![self.cellDetailTitles1[0] isEqualToString:@"2-6字，汉字或字母"]) {
                        self.nameField.text = self.cellDetailTitles1[0];
                    }
                    [[self.nameAlertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
                        if (x.integerValue == 1) {
                            [self refreshCellDetailNamesWith:self.nameField.text];
                        }
                    }];
                    [self.nameAlertView show];
                }  break;
                case 1: { // 性别
                    self.selectView.labTitle.text = @"选择性别";
                    [self showPopSelectViewWithArray:@[@"男",@"女"]];
                }  break;
                case 2: { // 出生年月
                    [self showDatePickerView];
                    self.datePickerView.untilNowButton.hidden = YES;
                }  break;
                case 3: { // 最高学历
                    [self showPopSelectViewWithArray:@[@"初中",@"高中",@"中专",@"中技",@"大专",@"本科",@"硕士",@"MBA",@"EMBA",@"博士",@"其他"]];
                    self.selectView.labTitle.text = @"选择学历";
                }  break;
                case 4: { // 工作年限
                    self.selectView.labTitle.text = @"工作年限";
                    [self showPopSelectViewWithArray:@[@"无经验",@"1年以下",@"1~3年",@"3~5年",@"5~10年",@"10年以上"]];
                }  break;
                case 5: { // 专业
                    self.majorAlertView = [UIAlertView alertViewWithTitle:@"请填写专业" message:nil delegate:self];
                    self.majorField = [self.majorAlertView textFieldAtIndex:0];
                    self.majorField.keyboardType = UIKeyboardTypeDefault;
                    if (![self.cellDetailTitles1[5] isEqualToString:@"请填写专业"]) {
                        self.majorField.text = self.cellDetailTitles1[5];
                    }
                    [[self.majorAlertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
                        if (x.integerValue == 1) {
                            [self refreshCellDetailNamesWith:self.majorField.text];
                        }
                    }];
                    [self.majorAlertView show];
                }  break;
                default:
                    break;
            }
        }  break;
        case 1: { // 认证信息
            switch (indexPath.row) {
                case 0: { // 手机号码
                    self.phoneAlertView = [UIAlertView alertViewWithTitle:@"请输入手机号码" message:nil delegate:self];
                    self.phoneNumField = [self.phoneAlertView textFieldAtIndex:0];
                    if (![self.cellDetailTitles2[0] isEqualToString:@"请输入正确的手机号"]) {
                        self.phoneNumField.text = self.cellDetailTitles2[0];
                    }
                    self.phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
                    [[self.phoneAlertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
                        NSString *string = self.phoneNumField.text;
                        if (x.integerValue == 1) {
                            // 判断号码是否合法
                            if (string.length != 11) {
                                [self showInfo:@"号码不合法呢，核实一下吧"];return;
                            }
                            [self refreshCellDetailNamesWith:self.phoneNumField.text];
                        }
                    }];
                    [self.phoneAlertView show];
                }  break;
                case 1: { // 邮箱地址
                    self.mailAlertView = [UIAlertView alertViewWithTitle:@"请填写邮箱" message:nil delegate:self];
                    self.mailField = [self.mailAlertView textFieldAtIndex:0];
                    self.mailField.keyboardType = UIKeyboardTypeEmailAddress;
                    if (![self.cellDetailTitles2[1] isEqualToString:@"请填写邮箱"]) {
                        self.mailField.text = self.cellDetailTitles2[1];
                    }
                    [[self.mailAlertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
                        [self refreshCellDetailNamesWith:self.mailField.text];
                    }];
                    [self.mailAlertView show];
                }  break;
                default:
                    break;
            }
        }  break;
        case 2: { // 期望
            switch (indexPath.row) {
                case 0: { // 期望工作区域
                    self.selectView.labTitle.text = @"期望工作区域";
                    [self showPopSelectViewWithArray:[TZCitisManager getCitis]];
                }  break;
                case 1: { // 期望薪资
                    self.selectView.labTitle.text = @"期望薪资";
                    [self showPopSelectViewWithArray:@[@"2000元/月以下",@"2001-3000元/月",@"3001-5000元/月",@"5001-8000元/月",@"8001-10000元/月",@"10001-15000元/月",@"15001-25000元/月",@"25001元/月以上"]];
                }  break;
                case 2: { // 期望职位
                    TZFullTimeJobViewController *fullTimeVc = [[TZFullTimeJobViewController alloc] initWithNibName:@"TZFullTimeJobViewController" bundle:nil];
                    fullTimeVc.type = TZFullTimeJobViewControllerJobType;
                    // 初始化returnJobType的block
                    fullTimeVc.returnJobType = ^(NSString *jobType,NSString *laid,TZFullTimeJobType laidOrClassJobType) {
                        [self refreshCellDetailNamesWith:jobType];
                    };
                    [self.navigationController pushViewController:fullTimeVc animated:YES];
                }  break;
                default:
                    break;
            }
        }  break;
        case 3: { // 工作经验
            TZJobExpViewController *jobExpVc = [[TZJobExpViewController alloc] initWithNibName:@"TZJobExpViewController" bundle:nil];
            jobExpVc.jobExps = [NSMutableArray arrayWithArray:self.model.workExps];
            
            // 告诉下一个页面 是创建简历状态 还是编辑简历状态
            if (self.type == TZCreateResumeControllerEdit) { // 编辑简历
                jobExpVc.type = TZJobExpViewControllerTypeEdit;
            } else { // 创建简历
                jobExpVc.type = TZJobExpViewControllerTypeNormal;
            }
            
            if (self.model.resume_id.length > 0) {
                jobExpVc.resume_id = self.model.resume_id;
                jobExpVc.isEditingJobExp = YES;
            }
            jobExpVc.returnJobExps = ^(NSMutableArray *jobExps) {
                self.model.workExps = [NSMutableArray arrayWithArray:jobExps];
                if (self.model.workExps.count != 0) {
                    [self refreshCellDetailNamesWith:@"已完善"];
                } else {
                    [self refreshCellDetailNamesWith:@"未填写"];
                }
            };
            [self.navigationController pushViewController:jobExpVc animated:YES];
        }  break;
        case 4: { // 个人介绍
            TZJobDescViewController *jobDescVc = [[TZJobDescViewController alloc] init];
            jobDescVc.title = @"个人介绍";
            if (self.model.profile.length > 0) {
                jobDescVc.labTitle = self.model.profile;
            }
            jobDescVc.returnJobDesc = ^(NSString *jobDesc) {
                [self refreshCellDetailNamesWith:jobDesc];
                self.model.profile = jobDesc;
            };
            [self.navigationController pushViewController:jobDescVc animated:YES];
        }  break;
        default:
            break;
    }
    self.row = indexPath.row;
    self.section = indexPath.section;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 按钮点击
- (IBAction)saveBtnClick:(UIButton *)sender {
    [self done];
}

- (void)getPhoto {
    [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
        [self.cameraBtn setImage:nil forState:UIControlStateNormal];
        [self.cameraBtn setBackgroundImage:editedImage forState:UIControlStateNormal];
        self.img = editedImage;
    }];
}

- (void)done {
    // 1、构造模型 2、检查数据
    if ([self.cellDetailTitles1[0] isEqualToString:@"2-6字，汉字或字母"])   { [self showAlertView]; return;}
    else {  self.model.name = self.cellDetailTitles1[0];};

    if ([self.cellDetailTitles1[1] isEqualToString:@"请选择性别"])         { [self showAlertView]; return;}
    else {  self.model.gender = self.cellDetailTitles1[1];};
    
    if ([self.cellDetailTitles1[2] isEqualToString:@"请选择出生日期"])      { [self showAlertView]; return;}
    else {  self.model.birthday = self.cellDetailTitles1[2];};
    
    if ([self.cellDetailTitles1[3] isEqualToString:@"请选择学历"])         { [self showAlertView]; return;}
    else {  self.model.degree = self.cellDetailTitles1[3];};
    
    if ([self.cellDetailTitles1[4] isEqualToString:@"请选择工作年限"])      { }
    else {  self.model.work_exp = self.cellDetailTitles1[4];};
    
    if ([self.cellDetailTitles1[5] isEqualToString:@"请输入专业"])      { }
    else {  self.model.major = self.cellDetailTitles1[5];};
    
    if ([self.cellDetailTitles2[0] isEqualToString:@"请输入正确的手机号"])   { [self showAlertView]; return;}
    else {  self.model.telephone = self.cellDetailTitles2[0];};
    
    if ([self.cellDetailTitles2[1] isEqualToString:@"请填写邮箱"])         { }
    else {  self.model.mail = self.cellDetailTitles2[1];};
    
    if ([self.cellDetailTitles3[0] isEqualToString:@"请选择区域"])         { [self showAlertView]; return;}
    else {  self.model.hope_town = self.cellDetailTitles3[0];};
    
    if ([self.cellDetailTitles3[1] isEqualToString:@"请选择期望薪资"])      { }
    else {  self.model.hope_salary = self.cellDetailTitles3[1];};
    
    if ([self.cellDetailTitles3[2] isEqualToString:@"请选择职位名称"])      { }
    else {  self.model.hope_career = self.cellDetailTitles3[2];};
    
    if ([self.cellDetailTitles4[0] isEqualToString:@"点击添加工作经验"])    { }
    
    if ([self.cellDetailTitles5[0] isEqualToString:@"添加教育经历、工作经历和自我评价,以获得更多企业关注"])  { }  else {  self.model.profile = self.cellDetailTitles5[0];};
    
    // if (self.img.size.width < 20)  { [self showAlertView]; return;}
    
    self.model.gender = [self.cellDetailTitles1[1] isEqualToString:@"男"] ? @"0" : @"1"; // 0男 1女
    self.model.hope_city = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"];
    self.model.deliver = self.switchView.isOn ? @"1" : @"0";
    // self.model.hope_career_t = @"销售";  // 先写死 这个字段没了
    
    // 3、记录更新时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.model.updated = [formatter stringFromDate:date];
    // 4、如果是从简历列表过来的。要返回数据
    if (self.returnResumeModel) {
        self.returnResumeModel(self.model);
    }
    // 5.发送请求给服务器
    [self sendResume];
    
    [super done];
}


#warning 创建/更新简历这里。 根据后台的设计，创建简历时，要把工作经验一并传上去。   而更新简历时，工作经验的更新是单独的接口，更新简历接口时，不要带工作经验数据上去。
- (void)sendResume {
    /*
     uid String 用户id
     avatar String 简历头像
     name String 真实姓名
     gender String 性别
     birthday String 出生年月
     profile String 个人介绍
     telephone String 手机号码
     degree String 最高学历
     work_exp String 工作年限
     hope_city String 期望工作城市（市）
     hope_town String 期望工作城市（县）
     hope_salary String 期望薪资
     hope_career String 期望职位
     hope_career_t String 期望职位（二级）
     
     work Array 工作经验
     
     deliver String 自动投递（三天内有相似工作）
     */
    
    // 1 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 1.1 个人信息
    params[@"name"] = self.model.name;
    params[@"link_email"] = self.model.mail;
    params[@"gender"] = self.model.gender;
    params[@"uid"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"userUid"];
    DLog(@"params uid %@",params[@"uid"]);
    
    // 把birthday转成时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *birthdayDate = [formatter dateFromString:self.model.birthday];
    NSString *timeSp = [NSString stringWithFormat:@"%f", (NSTimeInterval)[birthdayDate timeIntervalSince1970]];
    params[@"birthday"] = timeSp;
    
    params[@"telephone"] = self.model.telephone;
    params[@"profile"] = self.model.profile;
    params[@"work_exp"] = self.model.work_exp;
    params[@"degree"] = self.model.degree;
    params[@"major"] = self.model.major;
    // 1.2 期望职位
    params[@"hope_city"] = self.model.hope_city;
    params[@"hope_town"] = self.model.hope_town;
    params[@"hope_salary"] = self.model.hope_salary;
    params[@"hope_career"] = self.model.hope_career;
    params[@"hope_career_t"] = self.model.hope_career_t;
    // 1.3 自动投递
    params[@"deliver"] = self.model.deliver;
    // 1.4 简历照片
    UIImage *newImage = [CommonTools imageScale:self.img size:CGSizeMake(300 * 2, 300 * 2 * self.img.size.height / self.img.size.width)];
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
    NSData *imageDataPng = UIImagePNGRepresentation(newImage);
    // params[@"avatar"] = imageData;
    
    DLog(@"imageData %zd,imageDataPng %zd",imageData.length,imageDataPng.length);
    // 1.5 工作经验
    NSMutableArray *workExps = [NSMutableArray array];
    for (TZJobExpModel *model in self.model.workExps) {
        NSMutableDictionary *workExp = [NSMutableDictionary dictionary];
        workExp[@"company_name"] = model.company_name;
        NSString *start = [ICETools timeStamp:model.job_start];
        NSString *end = @"";
        if (![model.job_end isEqualToString:@"至今"]) {
            end = [ICETools timeStamp:model.job_end];
        }
        workExp[@"job_start"] = start ;
        workExp[@"job_end"] = end;
        workExp[@"department"] = model.department;
        workExp[@"job_desc"] = model.job_desc;
        workExp[@"job_name"] = model.job_name;
        [workExps addObject:workExp];
    }
    NSData *workExpsData = [NSJSONSerialization dataWithJSONObject:workExps options:NSJSONWritingPrettyPrinted error:nil];
    NSString *workExpsJsonStr = [[NSString alloc] initWithData:workExpsData encoding:NSUTF8StringEncoding];
    
  
  
    
      params[@"avatar"] = imageData;
    if (self.type == TZCreateResumeControllerNormal) {  // 创建简历
        params[@"work"] = workExpsJsonStr;
        NSMutableArray *fileArray = [NSMutableArray array];
        
        // 2 发送数据 需要工作经验数据
        NSDictionary *dict = @{ @"file" : imageData,
                                @"name" : @"imageName.png",
                                @"key"  : @"file" };
        [fileArray addObject:dict];
        
        
        [TZHttpTool postWithLoginURL:ApiCreateNewRes params:params success:^(NSDictionary *result) {
            
            DLog(@"创建简历成功 responseObject %@",result);
            [self showInfo:@"创建简历成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"haveCreateResumeSuccessful" object:self];
        } failure:^(NSString *msg){
            DLog(@"创建简历失败 error %@",msg);
            [self showInfo:@"创建简历失败"];
        }];
    } else {
        params[@"resume_id"] = self.model.resume_id;
        params[@"work"] = workExpsJsonStr;
        
        NSMutableArray *fileArray = [NSMutableArray array];
        
        // 2 发送数据 需要工作经验数据
        NSDictionary *dict = @{ @"file" : imageData,
                                @"name" : @"imageName.png",
                                @"key"  : @"file" };
        [fileArray addObject:dict];
        
        
        [TZHttpTool postWithLoginURL:ApiUpdateResume params:params success:^(NSDictionary *result) {
            DLog(@"更新简历成功 responseObject %@",result);
            [self showInfo:@"更新简历成功"];
        } failure:^(NSString *msg) {
            DLog(@"更新简历失败 error %@",msg);
            [self showInfo:@"更新简历失败"];
        }];
    }
}

@end
