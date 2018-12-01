//
//  XYCreateResumeViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/22.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCreateResumeViewController.h"
#import "XYDetailListCell.h"
#import "TZBaseCell.h"
#import "XYConfigViewController.h"
#import "TZDatePickerView.h"
#import "XYConfigModel.h"
#import "TZJobExpectController.h"
#import "XYFoundationCell.h"
#import "XYJobExperienceViewController.h"
#import "TZFullTimeJobViewController.h"
#import "TZJobExpViewController.h"
#import "XYJobExperienceViewController.h"
#import "TZJobDescViewController.h"
#import "TZResumeModel.h"
#import "TZJobExpModel.h"
#import "TZButtonsHeaderView.h"
#import "ICELoginUserModel.h"
#import "XYTextFieldCell.h"


#define XYLabelFont13 [UIFont boldSystemFontOfSize:13]
#define XYLabelFont15 [UIFont boldSystemFontOfSize:15]

@interface XYCreateResumeViewController ()<TZDatePickerViewDelegate,UITextFieldDelegate,UITableViewDelegate>{
    NSArray *_titles1;
    NSArray *_titles2;
    NSArray *_titles3;
    BOOL _fillPhone;
    BOOL _sendCode;
    BOOL _editPhone;
    NSAttributedString *_phone;
    NSAttributedString *_codeAtter;
    
    BOOL _isCode;
    BOOL _isCancel;
}

@property (nonatomic, strong) TZDatePickerView *datePickerView;
@property (nonatomic, strong) UIButton *coverBtn;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *majorField;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *mailField;
//@property (nonatomic, strong) UITextField *phoneField;

@property (nonatomic, assign) BOOL switchIsOn;
@property (nonatomic, strong) TZButtonsBottomView *saveBtn;
@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, copy) NSString *bindPhone;
@property (nonatomic, assign) BOOL haveBindedPhone;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, copy) NSString *code;


@end

@implementation XYCreateResumeViewController

- (TZResumeModel *)model {
    if (_model == nil) {
        _model = [[TZResumeModel alloc] init];
    }
    return _model;
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    if (self.type == XYCreateResumeViewControllerTypeNormal) {
        self.title = @"创建简历";
    } else {
        self.title = @"编辑简历";
    }
    self.bindPhone = [TZUserManager getUserModel].resume_phone;

    _fillPhone = NO;
    _sendCode = NO;
    _editPhone = NO;
    [self configDefaultData];
    [self configDatePickerView];
    [self configBottomCreateButton];
    [self configTableView];
    
}

- (void)configBottomCreateButton {
    CGFloat btnH = 60;
    if (mScreenWidth < 375) btnH = 50;
    _saveBtn = [[TZButtonsBottomView alloc] init];
    _saveBtn.frame = CGRectMake(0, mScreenHeight - btnH - 64, mScreenWidth, btnH);
    _saveBtn.titles = @[@"保存"];
    _saveBtn.showBackground = YES;
    _saveBtn.bgColors = @[TZColor(32, 191, 248)];
    MJWeakSelf
    [_saveBtn setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        [weakSelf done];
    }];
    [self.view addSubview:_saveBtn];
}

- (void)configDefaultData {
    CGFloat frontBoldFont = 15;
    CGFloat backFont = 14;
    if (mScreenWidth < 375) {
        frontBoldFont = 13;
        backFont = 12;
    }
//    [TZUserManager syncUserModel];
    NSAttributedString *name = [NSAttributedString attributedStringsWithFrontText:@"姓名" frontBoldFont:frontBoldFont frontColor:TZGreyText150Color backText:@"（必填）" backFont:backFont backColor:TZColor(250, 101, 100)];
    NSAttributedString *sex = [NSAttributedString attributedStringsWithFrontText:@"性别" frontBoldFont:frontBoldFont frontColor:TZGreyText150Color backText:@"（必填）" backFont:backFont backColor:TZColor(250, 101, 100)];
    NSAttributedString *birth = [NSAttributedString attributedStringsWithFrontText:@"出生年月" frontBoldFont:frontBoldFont frontColor:TZGreyText150Color backText:@"（必填）" backFont:backFont backColor:TZColor(250, 101, 100)];
    NSAttributedString *academic = [NSAttributedString attributedStringsWithFrontText:@"最高学历" frontBoldFont:frontBoldFont frontColor:TZGreyText150Color backText:@"（必填）" backFont:backFont backColor:TZColor(250, 101, 100)];
    _titles1 = @[name,sex,birth,academic,@"工作年限",@"专业"];
    
    _phone = [NSAttributedString attributedStringsWithFrontText:@"手机号" frontBoldFont:frontBoldFont frontColor:TZGreyText150Color backText:@"（必填）" backFont:backFont backColor:TZColor(250, 101, 100)];
    _codeAtter = [NSAttributedString attributedStringsWithFrontText:@"手机认证" frontBoldFont:frontBoldFont frontColor:TZGreyText150Color backText:@"（必填）" backFont:backFont backColor:TZColor(250, 101, 100)];
//    if (self.type == XYCreateResumeViewControllerTypeNormal) {
//        if (!self.bindPhone || self.bindPhone.length < 1) { // 没有绑定手机号码
    
    if ([TZUserManager getUserModel].resume_phone.length <= 0) {
        _isCode = YES;
        _titles2 = @[_phone,_codeAtter,@"邮箱地址"];
        self.haveBindedPhone = NO;
        self.bindPhone = @"请填写";
        self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[self.bindPhone,@"请填写",@"请填写"]];
    }else {
        _isCode = NO;
        self.haveBindedPhone = YES;
        _titles2 = @[_phone,_codeAtter,@"邮箱地址"];
        self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[self.bindPhone,@"",@"请填写"]];
    }
    
    
//        } else {
//            self.haveBindedPhone = YES;
//            _titles2 = @[_phone,@"邮箱地址"];
//            self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[self.bindPhone,@"请填写"]];
//        }
//    } else {
//        self.haveBindedPhone = YES;
//        _titles2 = @[_phone,@"邮箱地址"];
//        self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[@"",@"请填写"]];
//    }
    
    NSAttributedString *location = [NSAttributedString attributedStringsWithFrontText:@"期望区域" frontBoldFont:frontBoldFont frontColor:TZGreyText150Color backText:@"（必填）" backFont:backFont backColor:TZColor(250, 101, 100)];
    _titles3 = @[location,@"期望薪资",@"期望职位"];
    
//    if (bindPhone == nil && bindPhone.length < 1) {
//        self.haveBindedPhone = NO;
//        bindPhone = [ICELoginUserModel sharedInstance].username;
//    }
    
    self.cellDetailTitles1 = [NSMutableArray arrayWithArray:@[@"",@"2~6个字",@"请选择",@"请选择",@"请选择",@"请选择",@"请输入"]];
    self.cellDetailTitles3 = [NSMutableArray arrayWithArray:@[@"请选择",@"请选择",@"请选择"]];
    self.cellDetailTitles4 = [NSMutableArray arrayWithArray:@[@"点击添加"]];
    self.cellDetailTitles5 = [NSMutableArray arrayWithArray:@[@"填写教育经历，工作经历和自我评价以获得更多企业关注"]];

    // 如果是查看简历，则加载简历数据，更新UI
    if (self.type == XYCreateResumeViewControllerTypeEdit) {
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
        
        NSString *str = json[@"data"][@"basic"][@"birthday"];
        if ([str containsString:@"-"]) {
            self.model.birthday = str;
        } else {
            self.model.birthday = [CommonTools getTimeStrBytimeStamp:str];
        }
        
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
        self.cellDetailTitles1[0] = self.model.avatar;
        self.cellDetailTitles1[1] = self.model.name;
        self.cellDetailTitles1[2] = self.model.gender;
        self.cellDetailTitles1[3] = self.model.birthday;
        self.cellDetailTitles1[4] = self.model.degree;
        self.cellDetailTitles1[5] = self.model.work_exp;
        self.cellDetailTitles1[6] = self.model.major ? self.model.major : @"";
        
        self.cellDetailTitles2[0] = self.model.telephone;
        self.cellDetailTitles2[1] = self.model.mail;
        
        self.cellDetailTitles3[0] = self.model.hope_town;
        self.cellDetailTitles3[1] = self.model.hope_salary;
        self.cellDetailTitles3[2] = self.model.hope_career;
        
        if (self.model.workExps.count == 0) {
            self.cellDetailTitles4[0] = @"点击添加";
        } else {
            self.cellDetailTitles4[0] = @"已完善";
        }
        
        self.cellDetailTitles5[0] = self.model.profile;
        // 简历头像
        [self.avatarView sd_setImageWithURL:TZImageUrlWithShortUrl(self.model.avatar) placeholderImage:[UIImage imageNamed:@"image"]];
        
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"拿到简历数据失败 error %@",error);
    }];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - _saveBtn.height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerCellByClassName:@"XYDetailListCell"];
    [self.tableView registerCellByClassName:@"XYFoundationCell"];
    [self.tableView registerCellByNibName:@"XYTextFieldCell"];
    [self.tableView registerClass:[XYDetailListCell class] forCellReuseIdentifier:@"cell4"];
    [super configTableView];
}


#pragma mark --- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return self.cellDetailTitles1.count; break;
        case 1: return self.cellDetailTitles2.count; break;
        case 2: return self.cellDetailTitles3.count; break;
        default: return 1; break;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = TZControllerBgColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (_isCode) {
            return 44;
        }
        return 0;
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    } else if (indexPath.section == 4) {
        return 60;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0 || indexPath.section == 5) {
        XYFoundationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYFoundationCell"];
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.type = XYFoundationCellTypeAvater;
            cell.avaterY = 5;
            cell.labelText = @"简历照片";
            [cell addBottomSeperatorViewWithHeight:1];
            self.avatarView = cell.avater;
            cell.avater.hidden = NO;
            cell.swit.hidden = YES;
        } else {
            cell.type = XYFoundationCellTypeSwitch;
            cell.labelText = @"三天内有相似工作自动投递";
            cell.avater.hidden = YES;
            cell.swit.hidden = NO;
            [cell setSwitValueChangeBlock:^(BOOL isOn) {
                self.switchIsOn = isOn;
            }];
        }
        cell.label.textColor = TZGreyText150Color;
        if (mScreenWidth < 375) {
            cell.label.font = XYLabelFont13;
        } else {
            cell.label.font = XYLabelFont15;
        }
        cell.labelX = 8;
        return cell;
        
    } else {
        if (indexPath.section == 4) {
            XYDetailListCell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
            cell4.text = @"个人介绍";
            cell4.subText = self.cellDetailTitles5[indexPath.row];
            cell4.labelTextColor = TZGreyText150Color;
            [self configDetailCellLabelFont:cell4];
            cell4.labelX = 8;
            cell4.subLabelTextColor = TZGreyText150Color;
            cell4.subLabelFont = 15;
            if (mScreenWidth < 375) {
                cell4.subLabelFont = 13;
            }
            cell4.subLabelX = mScreenWidth * 0.36;
            return cell4;
        } else {
            XYDetailListCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
            if (indexPath.section == 0 && indexPath.row > 0) {
                if (indexPath.row <= 4) {
                    NSInteger row = indexPath.row;
                    detailCell.attrText = _titles1[indexPath.row - 1];
                } else {
                    detailCell.text = _titles1[indexPath.row - 1];
                }
                detailCell.subText = self.cellDetailTitles1[indexPath.row];
                if (indexPath.row == 5 || indexPath.row == 6) {
                    detailCell.labelTextColor = TZGreyText150Color;
                    [self configDetailCellLabelFont:detailCell];
                }
                [detailCell addBottomSeperatorViewWithHeight:1];
            } else if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    detailCell.attrText = _titles2[indexPath.row];
                    detailCell.subText = self.cellDetailTitles2[indexPath.row];
                    detailCell.haveAccessoryBtn = YES;
                    if (self.haveBindedPhone) {
                        if (_editPhone) {
                            detailCell.accessoryBtnText = @"未绑定";
                        } else {
                            detailCell.accessoryBtnText = @"已绑定";
                        }
                        detailCell.accessoryBtnTextColor = TZColor(6, 191, 252);
                    }
                    detailCell.accessoryBtnFont = 14;
                }
                
//                if (!self.haveBindedPhone || self.type == XYCreateResumeViewControllerTypeNormal || _editPhone) {
                    if (indexPath.row == 1) {
                        XYTextFieldCell *textField = (XYTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"XYTextFieldCell"];
                        textField.textField.delegate = self;
                        
                        NSAttributedString *str = _titles2[indexPath.row];
                        
                        if (![str isKindOfClass:[NSAttributedString class]]) {
                            str = [NSAttributedString attributedTextWithText:str];
                        }
                        
                        textField.label.attributedText = str;
                        if (_fillPhone) {
                            textField.codeBtn.userInteractionEnabled = YES;
                            [textField.codeBtn setBackgroundImage:[UIImage imageNamed:@"tapbackground"] forState:UIControlStateNormal];
                            [textField.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        }
                        
                        textField.textField.hidden = !_isCode;
                        textField.codeBtn.hidden = !_isCode;
                        textField.label.hidden = !_isCode;

                        MJWeakSelf
                        [textField setDidSendCodeBlock:^{
                            if (![self isMobileNumber:self.cellDetailTitles2[0]]) {
                                [self showHint:@"请输入正确的手机号"];
                                return NO;
                            }
                            
                            [weakSelf sendCodeHttp];
                            return YES;
                        }];
                        return textField;
                    }
//                } else {
//                    if (indexPath.row == 1) {
//                        detailCell.text = _titles2[indexPath.row];
//                        detailCell.subText = self.cellDetailTitles2[indexPath.row];
//                    }
//                }
                
                
                if (indexPath.row == 2) {
                    detailCell.text = _titles2[indexPath.row];
                    detailCell.subText = self.cellDetailTitles2[indexPath.row];
                    detailCell.labelTextColor = TZGreyText150Color;
                }
                [self configDetailCellLabelFont:detailCell];
                [detailCell addBottomSeperatorViewWithHeight:1];
            } else if (indexPath.section == 2) {
                if (indexPath.row == 0) {
                    detailCell.attrText = _titles3[indexPath.row];
                } else {
                    detailCell.text = _titles3[indexPath.row];
                }
                detailCell.subText = self.cellDetailTitles3[indexPath.row];
                if (indexPath.row != 0) {
                    detailCell.labelTextColor = TZGreyText150Color;
                    [self configDetailCellLabelFont:detailCell];
                }
                [detailCell addBottomSeperatorViewWithHeight:1];
            } else if (indexPath.section == 3) {
                detailCell.text = @"工作经验";
                detailCell.subText = self.cellDetailTitles4[0];
                detailCell.labelTextColor = TZGreyText150Color;
                [self configDetailCellLabelFont:detailCell];
            }
            detailCell.labelX = 8;
            detailCell.subLabelTextColor = TZGreyText150Color;
            detailCell.subLabelFont = 15;
            if (mScreenWidth < 375) {
                detailCell.subLabelFont = 13;
            }
            detailCell.subLabelX = mScreenWidth * 0.36;
            return detailCell;
        }
    }
}

- (void)configDetailCellLabelFont:(XYDetailListCell *)cell {
    CGFloat labelFont = 15;
    if (mScreenWidth < 375) labelFont = 13;
    cell.label.font = [UIFont boldSystemFontOfSize:labelFont];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: { // 基本信息
            switch (indexPath.row) {
                case 0: { // 修改头像
                    XYFoundationCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
                    [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
                        selCell.avater.image = editedImage;
                        self.icon = editedImage;
                    }];
                }  break;
                case 1: { // 昵称
                    UIAlertView *nameAlert = [UIAlertView alertViewWithTitle:@"请输入真实姓名" message:nil delegate:self];
                    self.nameField = [nameAlert textFieldAtIndex:0];
                    self.nameField.keyboardType = UIKeyboardTypeDefault;
                    if (![self.cellDetailTitles1[1] isEqualToString:@"2~6个字"]) {
                        self.nameField.text = self.cellDetailTitles1[1];
                    }
                    [[nameAlert rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
                        if (x.integerValue == 1) {
                            [self refreshCellDetailNamesWith:self.nameField.text row:indexPath.row section:indexPath.section];
                        }
                    }];
                    [nameAlert show];
                   
                }  break;
                case 2: { // 性别
                    self.selectView.labTitle.text = @"选择性别";
                    [self showPopSelectViewWithArray:@[@"男",@"女"]];
                    
                }  break;
                case 3: { //
                    [self showDatePickerView];
                    self.datePickerView.untilNowButton.hidden = YES;
                    
                }  break;
                case 4: { // 学历
                    [self showPopSelectViewWithArray:@[@"初中",@"高中",@"中专",@"中技",@"大专",@"本科",@"硕士",@"MBA",@"EMBA",@"博士",@"其他"]];
                    self.selectView.labTitle.text = @"选择学历";
                    
                }  break;
                case 5: { // 工作年限
                    self.selectView.labTitle.text = @"工作年限";
                    [self showPopSelectViewWithArray:@[@"无经验",@"1年以下",@"1~3年",@"3~5年",@"5~10年",@"10年以上"]];
                }  break;
                case 6: { // 专业
                    UIAlertView *majorAlertView = [UIAlertView alertViewWithTitle:@"请填写专业" message:nil delegate:self];
                    self.majorField = [majorAlertView textFieldAtIndex:0];
                    self.majorField.keyboardType = UIKeyboardTypeDefault;
                    if (![self.cellDetailTitles1[6] isEqualToString:@"请输入"]) {
                        self.majorField.text = self.cellDetailTitles1[6];
                    }
                    [[majorAlertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
                        if (x.integerValue == 1) {
                            [self refreshCellDetailNamesWith:self.majorField.text row:indexPath.row section:indexPath.section];
                        }
                    }];
                    [majorAlertView show];
                } break;
                default:
                    break;
            }
        }  break;
        case 1: { // 认证信息
            switch (indexPath.row) {
                case 0: { // 手机号码
                    UIAlertView *phoneAlertView = [UIAlertView alertViewWithTitle:@"请填写正确的手机号码" message:nil delegate:self];
                    self.phoneField = [phoneAlertView textFieldAtIndex:0];
                    self.phoneField.keyboardType = UIKeyboardTypeDecimalPad;
                    self.phoneField.delegate = self;
                    if (![self.cellDetailTitles2[0] isEqualToString:@"请填写"]) {
                        self.phoneField.text = self.cellDetailTitles2[0];
                    }
                    [[phoneAlertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
                        if (x.integerValue == 0) {
                            _isCancel = YES;
                            return ;
                        }
                        _isCancel = NO;
                        _fillPhone = YES;
                        if ([self.phoneField.text isEqualToString:self.cellDetailTitles2[0]]) {
                            return ;
                        } else {
                            if (self.type == XYCreateResumeViewControllerTypeEdit) {
                                _editPhone = YES;
                                _titles2 = @[_phone,_codeAtter,@"邮箱地址"];
                                self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[self.phoneField.text,@"请输入验证码",@"请填写"]];
                                NSIndexSet *set = [NSIndexSet indexSetWithIndex:1];
                                [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
                            } else {
                                NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:1];
                                [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
                            }
                            [self refreshCellDetailNamesWith:self.phoneField.text row:indexPath.row section:indexPath.section];
                        }
                       
                    }];
                    [phoneAlertView show];
                }  break;
                case 1: { // 邮箱地址
                    if (self.bindPhone.length) {
                        UIAlertView *mailAlertView = [UIAlertView alertViewWithTitle:@"请填写验证码" message:nil delegate:self];
                        self.mailField = [mailAlertView textFieldAtIndex:0];
                        self.mailField.keyboardType = UIKeyboardTypeEmailAddress;
                        if (![self.cellDetailTitles2[1] isEqualToString:@"请填写"]) {
                            self.mailField.text = self.cellDetailTitles2[1];
                        }
                        [[mailAlertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
                            [self refreshCellDetailNamesWith:self.mailField.text row:indexPath.row section:indexPath.section];
                        }];
                        [mailAlertView show];
                    }
                    
                }  break;
                default:{
                    UIAlertView *mailAlertView1 = [UIAlertView alertViewWithTitle:@"请填写邮箱" message:nil delegate:self];
                    self.mailField = [mailAlertView1 textFieldAtIndex:0];
                    self.mailField.keyboardType = UIKeyboardTypeEmailAddress;
                    if (![self.cellDetailTitles2[2] isEqualToString:@"请填写"]) {
                        self.mailField.text = self.cellDetailTitles2[2];
                    }
                    [[mailAlertView1 rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
                        [self refreshCellDetailNamesWith:self.mailField.text row:indexPath.row section:indexPath.section];
                    }];
                    [mailAlertView1 show];
                }
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
        case 3: {
            // 工作经验
            XYJobExperienceViewController *jobExpVc = [[XYJobExperienceViewController alloc] init];
            jobExpVc.jobExps = [NSMutableArray arrayWithArray:self.model.workExps];
            
            // 告诉下一个页面 是创建简历状态 还是编辑简历状态
            if (self.type == XYCreateResumeViewControllerTypeEdit) { // 编辑简历
                jobExpVc.type = XYJobExperienceViewControllerTypeEdit;
                jobExpVc.resume_id = self.model.resume_id;
//                jobExpVc.isEditingJobExp = YES;
            } else { // 创建简历
                jobExpVc.type = XYJobExperienceViewControllerTypeNormal;
            }
            [jobExpVc setReturnJobExps:^(NSMutableArray *jobExps){
                self.model.workExps = [NSMutableArray arrayWithArray:jobExps];
                if (self.model.workExps.count != 0) {
                    [self refreshCellDetailNamesWith:@"已完善"];
                } else {
                    [self refreshCellDetailNamesWith:@"未填写"];
                }
            }];
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    if (textField.text.length <= 0 || _isCancel) {
        return;
    }
    
    if (textField == self.phoneField) {
//        self.bindPhone = textField.text;
        if (![textField.text isEqualToString:[TZUserManager getUserModel].resume_phone]) {
            _isCode = YES;
//            _titles2 = @[_phone,_codeAtter,@"邮箱地址"];
//            self.haveBindedPhone = NO;
//            self.bindPhone = @"请填写";
//            self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[textField.text,@"请填写",@"请填写"]];

        }else {
            _isCode = NO;
//            self .haveBindedPhone = YES;
//            _titles2 = @[_phone,@"",@"邮箱地址"];
//            self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[textField.text,@"",@"请填写"]];
        }
        [self.tableView reloadData];
    }
}

- (void)refreshCellDetailNamesWith:(NSString *)name row:(NSInteger)row section:(NSInteger)section {
    if (name && ![name isEqualToString:@""]) {
        if (section == 0) {
            [self.cellDetailTitles1 replaceObjectAtIndex:row withObject:name];
        } else if (section == 1) {
            [self.cellDetailTitles2 replaceObjectAtIndex:row withObject:name];
        } else if (section == 2) {
            [self.cellDetailTitles3 replaceObjectAtIndex:row withObject:name];
        }
    }
    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationLeft];
}

//- (void)refreshCellDetailNamesWith:(NSString *)name {
//    
//}

//- (void)push {
//    if (indexPath.section == 0) {
//        if (indexPath.row == 1) {
//            [self pushConfigVcWithTitle:@"姓名" vcType:XYConfigViewControllerTypeTextField models:nil indexPath:indexPath];
//        } else if (indexPath.row == 2) {
//            [self pushConfigVcWithTitle:@"性别" vcType:XYConfigViewControllerTypeTableView models:@[@"男",@"女"] indexPath:indexPath];
//        } else if (indexPath.row == 3) {
//            self.coverBtn.hidden = NO;
//            self.datePickerView.hidden = NO;
//        } else if (indexPath.row == 4) {
//            [self pushConfigVcWithTitle:@"最高学历" vcType:XYConfigViewControllerTypeTableView models:@[@"初中",@"高中",@"中专",@"中技",@"大专",@"本科",@"硕士",@"MBA",@"EMBA",@"博士",@"其他"] indexPath:indexPath];
//        } else if (indexPath.row == 5) {
//            [self pushConfigVcWithTitle:@"工作年限" vcType:XYConfigViewControllerTypeTableView models:@[@"无经验",@"1年以下",@"1~3年",@"3~5年",@"5~10年",@"10年以上"] indexPath:indexPath];
//        } else {
//            [self pushConfigVcWithTitle:@"专业" vcType:XYConfigViewControllerTypeTextField models:nil indexPath:indexPath];
//        }
//    } else if (indexPath.section == 1) {
//        if (indexPath.row == 0) {
//            [self pushConfigVcWithTitle:@"手机号码" vcType:XYConfigViewControllerTypeTextField models:nil indexPath:indexPath];
//        } else {
//            [self pushConfigVcWithTitle:@"邮箱号码" vcType:XYConfigViewControllerTypeTextField models:nil indexPath:indexPath];
//        }
//    } else if (indexPath.section == 2) {
//        if (indexPath.row == 0) {
//            //
//        } else if (indexPath.row == 1) {
//            [self pushConfigVcWithTitle:@"期望薪资" vcType:XYConfigViewControllerTypeTableView models:@[@"2000元/月以下",@"2001-3000元/月",@"3001-5000元/月",@"5001-8000元/月",@"8001-10000元/月",@"10001-15000元/月",@"15001-25000元/月",@"25001元/月以上"] indexPath:indexPath];
//        } else {
//            TZJobExpectController *jobExpect = [[TZJobExpectController alloc] init];
//            jobExpect.type = TZJobExpectControllerTypeProfile;
//            [self.navigationController pushViewController:jobExpect animated:YES];
//        }
//    } else if (indexPath.section == 3) {
//        XYJobExperienceViewController *experienceVc = [[XYJobExperienceViewController alloc] init];
//        [self.navigationController pushViewController:experienceVc animated:YES];
//    } else if (indexPath.section == 4) {
//        [self pushConfigVcWithTitle:@"个人介绍" vcType:XYConfigViewControllerTypeTextView models:nil indexPath:indexPath];
//    }
//}

//- (void)pushConfigVcWithTitle:(NSString *)title vcType:(XYConfigViewControllerType)vcType models:(NSArray *)models indexPath:(NSIndexPath *)indexPath{
//    XYDetailListCell *selCell = [self.tableView cellForRowAtIndexPath:indexPath];
//    XYConfigViewController *configVc = [[XYConfigViewController alloc] init];
//    configVc.selRow = selCell.selRow;
//    configVc.didClickTableView = selCell.didClickRow;
//    configVc.type = vcType;
//    configVc.titleText = title;
//    if (models) {
//        configVc.models = models;
//    }
//    configVc.placeText = nil;
//    [configVc setDidClickConformBtnBlock:^(NSString *text) {
//        selCell.subText = text;
//    }];
//    [configVc setDidSelecteTableViewRowBlock:^(NSString *text,NSInteger selRow,BOOL didClickRow) {
//        selCell.subText = text;
//        selCell.selRow = selRow;
//        selCell.didClickRow = didClickRow;
//    }];
//    [self.navigationController pushViewController:configVc animated:YES];
//}


- (void)done {
    // 1、构造模型 2、检查数据
    if ([self.cellDetailTitles1[1] isEqualToString:@"2~6个字"])   { [self showAlertView]; return;}
    else {  self.model.name = self.cellDetailTitles1[1];};
    
    if ([self.cellDetailTitles1[2] isEqualToString:@"请选择"])         { [self showAlertView]; return;}
    else {
        self.model.gender = [self.cellDetailTitles1[2] isEqualToString:@"男"] ? @"0" : @"1"; // 0男 1女

    }
    
    if ([self.cellDetailTitles1[3] isEqualToString:@"请选择"])      {
        [self showAlertView]; return;
    }
    else {
//        self.model.birthday = @"12313";
        self.model.birthday = self.cellDetailTitles1[3];
    };
    
    if ([self.cellDetailTitles1[4] isEqualToString:@"请选择"])         { [self showAlertView]; return;}
    else {  self.model.degree = self.cellDetailTitles1[4];};
    
    if ([self.cellDetailTitles1[5] isEqualToString:@"请选择"])      { }
    else {  self.model.work_exp = self.cellDetailTitles1[5];};
    
    if ([self.cellDetailTitles1[6] isEqualToString:@"请输入"])      { }
    else {  self.model.major = self.cellDetailTitles1[6];};
    
    if ([self.cellDetailTitles2[0] isEqualToString:@"请填写"])   {             [self showHint:@"请填写手机号码"];
; return;}
    else {  self.model.telephone = self.cellDetailTitles2[0];};
    
    if ([self.cellDetailTitles2[1] isEqualToString:@"请填写"])         { }
    else {  self.model.mail = self.cellDetailTitles2[1];};
    
    
    if (_isCode) {
        
        XYTextFieldCell *textField = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        
        self.code = textField.textField.text;
        if (self.code.length < 1) {
            [self showHint:@"请填写验证码"];
            return;
        }
    }

    
    if ([self.cellDetailTitles3[0] isEqualToString:@"请选择"])      {
        [self showHint:@"请填写工作区域"]; return;
    }
    else {
        self.model.hope_city = self.cellDetailTitles3[0];

    };
    
//    if ([self.model.text isEqualToString:@"请填写"]) {
//        
//    }
    //    }
    if ([self.cellDetailTitles3[0] isEqualToString:@"请选择"])         { [self showAlertView]; return;}
    else {  self.model.hope_town = self.cellDetailTitles3[0];};
    
    if ([self.cellDetailTitles3[1] isEqualToString:@"请选择"])      { }
    else {  self.model.hope_salary = self.cellDetailTitles3[1];};
    
    if ([self.cellDetailTitles3[2] isEqualToString:@"请选择"])      { }
    else {  self.model.hope_career = self.cellDetailTitles3[2];};
    
//    if ([self.cellDetailTitles4[0] isEqualToString:@"点击添加工作经验"])    { }
    
    if ([self.cellDetailTitles5[0] isEqualToString:@"填写教育经历，工作经历和自我评价以获得更多企业关注"])  { }  else {  self.model.profile = self.cellDetailTitles5[0];};
    
    // if (self.img.size.width < 20)  { [self showAlertView]; return;}
    
    self.model.hope_city = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"];
    self.model.deliver = self.switchIsOn ? @"1" : @"0";
    
    // 3、记录更新时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.model.updated = [formatter stringFromDate:date];
    // 4、如果是从简历列表过来的。要返回数据
    if (self.returnResumeModelBlock) {
        self.returnResumeModelBlock(self.model);
    }
    // 5.发送请求给服务器
    [self sendResume];
    
//    [super done];
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
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    NSDate *birthdayDate = [formatter dateFromString:self.model.birthday];
//    NSString *timeSp = [NSString stringWithFormat:@"%f", (NSTimeInterval)[birthdayDate timeIntervalSince1970]];
//    params[@"birthday"] = timeSp;
    params[@"birthday"] = [CommonTools getTimeStampBytimeStr:self.model.birthday];
//    params[@"birthday"] = self.model.birthday;
    
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
    if (_isCode) {
    params[@"code"] = self.code.length > 0 ? self.code : @"";
    }

    // 1.4 简历照片
    UIImage *newImage = [CommonTools imageScale:self.icon size:CGSizeMake(300 * 2, 300 * 2 * self.icon.size.height / self.icon.size.width)];
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
    
    // 2 发送数据 需要工作经验数据
    params[@"avatar"] = imageData;
    if (self.type == XYCreateResumeViewControllerTypeNormal) {  // 创建简历
        params[@"work"] = workExpsJsonStr;
        
        NSMutableArray *fileArray = [NSMutableArray array];
        NSDictionary *dict = @{ @"file" : imageData,
                                @"name" : @"imageName.png",
                                @"key"  : @"file" };
        [fileArray addObject:dict];
        
   
        
        [TZHttpTool postWithUploadImages:ApiCreateNewRes params:params formDataArray:fileArray process:nil success:^(NSDictionary *responseObject) {
            if (![responseObject[@"status"] isEqual:@(1)]) {
              
                [self showInfo:responseObject[@"msg"]];
                return ;
            }
            
            NSString *str = [mUserDefaults objectForKey:@"NoResume"];
            
            if ( str.integerValue == 1) {
                [TZUserManager getUserModel].resume_phone = self.model.telephone;
                [mUserDefaults setObject:@"0" forKey:@"NoResume"];
            }
            
            [TZUserManager syncUserModel];
            
            DLog(@"创建简历成功 responseObject %@",responseObject);
            [self showSuccessHUDWithStr:@"创建简历成功"];
            [mUserDefaults setObject:self.model.telephone forKey:@""];
            [mUserDefaults setObject:@"1" forKey:@"NoResume"];
            [mUserDefaults setObject:@"1" forKey:@"defaultResume"];
            [mUserDefaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"haveCreateResumeSuccessful" object:nil];
            [self.navigationController popViewControllerAnimated:YES];

        } failure:^(NSString *msg) {
            DLog(@"创建简历失败 error %@",msg);
            [self showInfo:@"创建简历失败"];
        }];
    } else {
        params[@"resume_id"] = self.model.resume_id;
        params[@"work"] = workExpsJsonStr;
        
        
        NSMutableArray *fileArray = [NSMutableArray array];
        NSDictionary *dict = @{ @"file" : imageData,
                                @"name" : @"imageName.png",
                                @"key"  : @"file" };
        [fileArray addObject:dict];
       
//        [mgr POST:ApiUpdateResume parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            if (imageData != nil) {   // 图片数据不为空才传递
//                [formData appendPartWithFileData:imageData name:@"file" fileName:@"imageName.png" mimeType:@"image/jpeg"];
//                params[@"avatar"] = formData;
//            }
//        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [TZHttpTool postWithUploadImages:ApiUpdateResume params:params formDataArray:fileArray process:nil success:^(NSDictionary *responseObject) {
                
            DLog(@"更新简历成功 responseObject %@",responseObject);
            [mUserDefaults setObject:self.model.telephone forKey:@""];
            [self showSuccessHUDWithStr:@"更新简历成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"haveCreateResumeSuccessful" object:nil];
            [self.navigationController popViewControllerAnimated:YES];

        } failure:^(NSString *msg) {
            DLog(@"更新简历失败 error %@",msg);
            [self showInfo:@"更新简历失败"];
        }];
    }
}

#pragma mark -- private

- (void)coverBtnClick {
    self.coverBtn.hidden = YES;
    self.datePickerView.hidden = YES;
}

- (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //2.1.6版本修改只判断是否是11位数字
    NSString *MOBILE = @"^1\d{10}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
//
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
//
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//
//    return [regextestmobile evaluateWithObject:mobileNum];
}


- (void)sendCodeHttp {
    
    
    NSString *sessionID = [mUserDefaults objectForKey:@"sessionid"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = sessionID;
    params[@"phone"] = self.cellDetailTitles2[0];
    params[@"type"] = @"0";
    [TZHttpTool postWithURL:ApiSms params:params success:^(NSDictionary *result) {
        if ([result[@"status"] isEqual:@(1)]) {
            [self showSuccessHUDWithStr:@"已发送"];
            _sendCode = YES;
//            self.code = [NSString stringWithFormat:@"%@",result[@"data"]];
        }else {
            [self showErrorHUDWithError:result[@"msg"]];

        }
    } failure:^(NSString *msg) {
        [self showErrorHUDWithError:msg];
    }];
}

#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.code = textField.text;
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    return YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double v = [scrollView.panGestureRecognizer velocityInView:scrollView].y;
    
    if (abs(v) > 300) {
        [self.view endEditing:YES];

    }
    
}



@end

