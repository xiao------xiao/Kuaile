//
//  XYEditUserViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/9.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYEditUserViewController.h"
#import "TZResumeModel.h"
#import "ICESelfInfoModel.h"
#import "XYDetailListCell.h"
#import "XYFoundationCell.h"
#import "ICEForgetViewController.h"
#import "XYUserInfoModel.h"
#import "XYInquireWageViewController.h"
#import "XYEditBindViewController.h"
#import "TZJobDescViewController.h"
#import "LFindLocationViewController.h"
#import "XYConfigViewController.h"
#import "XYSearchViewController.h"

@interface XYEditUserViewController ()<UITableViewDelegate,UITableViewDataSource,LFindLocationViewControllerDelegete>{

}
@property (nonatomic, strong) TZPopInputView *inputView;
//@property (nonatomic, strong) TZResumeModel *model1;
@property (nonatomic, strong) ICESelfInfoModel *modelSelfInfo;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *iconPath;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, copy) NSString *bind;
@property (nonatomic, strong) UIColor *bindTextColor;
@property (nonatomic, assign) NSInteger homeID;
@property (nonatomic, assign) NSInteger addressID;
@property (nonatomic, assign) BOOL editHome;
@property (nonatomic, assign) BOOL editAddress;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, assign) CGFloat signConstraintH;
@end

@implementation XYEditUserViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑";
    self.editHome = NO;
    self.editAddress = NO;
//    [self loadNetWorkData];
    [self configTableView];
    [self configDefaultData];
    [self configDatePickerView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_inputView) {
        _inputView = [[TZPopInputView alloc] initWithContentView:self.view];
    }
}

- (void)configDefaultData {
    self.cellTitles1 = @[@"昵称",@"手机号",@"家乡",@"出生日期",@"性别",@"现居地",@"情感状态",@"个性签名",@"在职公司"];
    if (self.model) {
        NSString *nickName = self.model.nickname && self.model.nickname.length ? self.model.nickname : @"请填写";
        NSString *phone = self.model.username;
        if (![self isMobileNumber:phone]) {
            phone = @"暂未绑定手机号";
        }
        self.bind = [self.model.is_bind isEqualToString:@"1"] ? @"已绑定" : @"未绑定";
        self.bindTextColor = [self.model.is_bind isEqualToString:@"1"] ? TZColor(6, 191, 252) : TZColor(255, 124, 114);
        NSString *home = self.model.hometown && self.model.hometown.length ? self.model.hometown : @"请填写";
        NSString *bir = self.model.birthday && self.model.birthday.length ? self.model.birthday : @"请选择";
        if ([self.model.birthday isEqualToString:@"0"]) bir = @"请选择";
        NSString *sex = [self.model.gender isEqualToString:@"0"] ? @"男" : @"女";
        NSString *live = self.model.address && self.model.address.length ? self.model.address : @"请选择";
        NSString *company_name = self.model.company_name && self.model.company_name.length ? self.model.company_name : @"请填写";
        NSString *emotionStatus;
        NSInteger emotionInt = self.model.emotional_state.integerValue;//情感状态1保密2单身3热恋中4已婚
        if (emotionInt == 1) { emotionStatus = @"保密"; }
        else if (emotionInt == 2) { emotionStatus = @"单身";}
        else if (emotionInt == 3) { emotionStatus = @"热恋中"; }
        else if (emotionInt == 4) { emotionStatus = @"已婚"; }
        else { emotionStatus = @"请选择"; }
        NSString *sign = self.model.sign && self.model.sign.length ? self.model.sign : @"请填写";
        CGFloat signFont;
        if (mScreenWidth < 375) {
            signFont = 14;
        } else {
            signFont = 16;
        }
        self.signConstraintH = [CommonTools sizeOfText:sign fontSize:signFont].height + 45;
        self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[nickName,phone,home,bir,sex,live,emotionStatus,sign,company_name]];
    } else {
        self.cellDetailTitles2 = [NSMutableArray arrayWithArray:@[@"请填写",@"请填写",@"请填写",@"请选择",@"请选择",@"请选择",@"请填写",@"请选择",@"请填写"]];
    }
    [self.tableView reloadData];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerCellByClassName:@"XYDetailListCell"];
    [self.tableView registerCellByClassName:@"XYFoundationCell"];
    [super configTableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.cellTitles1.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.00001;
    } else {
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { return 70; }
    else {
        if (indexPath.row == 7) {
            return self.signConstraintH > 34 ? self.signConstraintH : 44;
        } else {
            return 44;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XYFoundationCell *avaterCell = [tableView dequeueReusableCellWithIdentifier:@"XYFoundationCell"];
        avaterCell.type = XYFoundationCellTypeAvater;
        avaterCell.haveMoreView = YES;
        avaterCell.isRoundCornor = YES;
        avaterCell.labelText = @"修改头像";
        [avaterCell.avater sd_setImageWithURL:TZImageUrlWithShortUrl(self.model.avatar) placeholderImage:TZPlaceholderAvaterImage];
        if (mScreenWidth < 375) {
            avaterCell.label.font = [UIFont boldSystemFontOfSize:14];
        } else {
            avaterCell.label.font = [UIFont boldSystemFontOfSize:16];
        }
        avaterCell.label.textColor = TZColorRGB(171);
        return avaterCell;
    } else {
        XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
        cell.text = self.cellTitles1[indexPath.row];
        cell.subText = self.cellDetailTitles2[indexPath.row];
        if (indexPath.row == 1) {
            cell.haveAccessoryBtn = YES;
            cell.accessoryBtnText = self.bind;
            cell.accessoryBtnTextColor = self.bindTextColor;
            cell.accessoryBtnFont = 15;
            if (mScreenWidth < 375) {
                cell.accessoryBtnFont = 13;
            }
        }
        if (mScreenWidth < 375) {
            cell.label.font = [UIFont boldSystemFontOfSize:14];
            cell.subLabelFont = 14;
        } else {
            cell.label.font = [UIFont boldSystemFontOfSize:16];
            cell.subLabelFont = 16;
        }
        cell.labelTextColor = TZColorRGB(171);
        cell.subLabelTextColor = TZColorRGB(193);
        [cell addBottomSeperatorViewWithHeight:1];
        return cell;
    }
}

- (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XYFoundationCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
        [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
            selCell.avater.image = editedImage;
            self.icon = editedImage;
            [self updataHeadImg:editedImage isIcon:YES];
        }];
        
    } else {
        switch (indexPath.row) {
            case 0: {  // 昵称
                [self editNickName];
            }  break;
            case 1: {
                if ([self.model.is_bind isEqualToString:@"1"]) {// 绑定手机号
                    XYEditBindViewController *editVc = [[XYEditBindViewController alloc] init];
                    editVc.phoneNum = self.model.username;
                    [self.navigationController pushViewController:editVc animated:YES];
                } else {// 未绑定
                    XYInquireWageViewController *bindVc = [[XYInquireWageViewController alloc] init];
                    bindVc.titleText = @"绑定手机号";
                    bindVc.commitBtnText = @"绑定手机号";
                    MJWeakSelf
                    [bindVc setDidCommitSuccessBlock:^(NSString *phone){
                        
                        
                        if (phone) {
                            self.model.is_bind = @"1";
                            self.bind = [self.model.is_bind isEqualToString:@"1"] ? @"已绑定" : @"未绑定";
                            self.bindTextColor = [self.model.is_bind isEqualToString:@"1"] ? TZColor(6, 191, 252) : TZColor(255, 124, 114);
                        }
                        
                        [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];
                        
                        weakSelf.section = indexPath.section;
                        weakSelf.row = indexPath.row;
                        
                        [self refreshCellDetailNamesWith:phone];
                    }];
                    [self.navigationController pushViewController:bindVc animated:YES];
                }
            } break;
            case 2: {  // 家乡
                LFindLocationViewController *cityChooseVc = [[LFindLocationViewController alloc] init];
                cityChooseVc.delegete = self;
                cityChooseVc.loctionCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"];
                [self.navigationController pushViewController:cityChooseVc animated:YES];
            } break;
            case 3: {  //出生日期
                [self showDatePickerView];
            } break;
            case 4: { //性别
                self.selectView.labTitle.text = @"选择性别";
                [self showPopSelectViewWithArray:@[@"男",@"女"]];
            } break;
            case 5: { // 现居地
                self.editAddress = YES;
                LFindLocationViewController *cityChooseVc = [[LFindLocationViewController alloc] init];
                cityChooseVc.delegete = self;
                cityChooseVc.loctionCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"];
                [self.navigationController pushViewController:cityChooseVc animated:YES];
            }  break;
            case 6: { // 情感状态
                self.selectView.labTitle.text = @"选择情感状态";
                [self showPopSelectViewWithArray:@[@"保密",@"单身",@"热恋中",@"已婚"]];
            } break;
            case 7: {  // 个性签名
                XYConfigViewController *introductionVc = [[XYConfigViewController alloc] init];
                introductionVc.titleText = @"个性签名";
                introductionVc.type = XYConfigViewControllerTypeTextView;
                NSString *sign = self.cellDetailTitles2[7];
                if ([sign isEqualToString:@"未填写"]) {
                    introductionVc.placeText = nil;
                } else {
                    introductionVc.placeText = sign;
                }
                MJWeakSelf
                [introductionVc setDidClickConformBtnBlock:^(NSString *text) {
                    XYDetailListCell *introductionCell = [tableView cellForRowAtIndexPath:indexPath];
                    CGFloat signFont;
                    if (mScreenWidth < 375) {
                        signFont = 14;
                    } else {
                        signFont = 16;
                    }
                    weakSelf.signConstraintH = [CommonTools sizeOfText:text fontSize:signFont].height + 45;
                    [self.cellDetailTitles2 replaceObjectAtIndex:self.row withObject:text];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                }];
                [self.navigationController pushViewController:introductionVc animated:YES];
    
            } break;
            case 8: {
                MJWeakSelf
                XYSearchViewController *searchVc = [[XYSearchViewController alloc] init];
                [searchVc setDidSelecteCompany:^(NSString *company){
                    [weakSelf.cellDetailTitles2 replaceObjectAtIndex:self.row withObject:company];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
                [self.navigationController pushViewController:searchVc animated:YES];
            }
            default: break;
        }
        
        self.row = indexPath.row;
        self.section = indexPath.section;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/** 编辑昵称 */
- (void)editNickName {
    UIAlertView *nameAlertView = [UIAlertView alertViewWithTitle:@"请输入昵称" message:nil delegate:self];
    self.nameField = [nameAlertView textFieldAtIndex:0];
    if (![self.cellDetailTitles2[0] isEqualToString:@"请输入"]) {
        self.nameField.text = self.cellDetailTitles2[0];
    }
    [[nameAlertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
        if (x.integerValue == 1) {
            [self refreshCellDetailNamesWith:self.nameField.text];
//            if(self.nameField.text.length) {
//                // 设置推送设置
//                MJWeakSelf
//                [[EaseMob sharedInstance].chatManager setApnsNickname:self.nameField.text];
//                [weakSelf.tableView reloadData];
//                [self editSelfInfo:@"nickname" value:self.nameField.text];
//            }
        }
    }];
    [nameAlertView show];
}

//- (void)editUserInfoWithIndexRow:(NSInteger)row {
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    NSString *editText = self.cellDetailTitles2[row];
//    if (row == 0) {
//        params[@"nickname"] = editText;
//    } else if (row == 1) {
//        if ([editText isEqualToString:@"男"]) {
//            params[@"gender"] = @"0";
//        } else {
//            params[@"gender"] = @"1";
//        }
//    } else if (row == 2) {
//        params[@"hometown"] = editText;
//    } else if (row == 3) {
//        
//    } else if (row == 4) {
//        params[@"birthday"] = editText;
//    } else if (row == 5) {
//        params[@"address"] = editText;
//    } else if (row == 6) {
//        params[@"emotional_state"] = editText;
//    } else {
//        params[@"sign"] = editText;
//    }
//    
//    [TZHttpTool postWithURL:ApiEditUser params:params success:^(NSDictionary *result) {
//        [self showInfo:@"修改成功"];
//    } failure:^(NSString *msg) {
//        [self showErrorHUDWithError:msg];
//    }];
//}

- (void)refreshCellDetailNamesWith:(NSString *)name {
    if (![name isEqualToString:@""] && name != nil) { // 输入不为空才刷新
        
        if (self.section == 1) {
            [self.cellDetailTitles2 replaceObjectAtIndex:self.row withObject:name];
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.row inSection:self.section];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


//self.cellTitles1 = @[@"昵称",@"手机号",@"家乡",@"出生日期",@"性别",@"现居地",@"情感状态",@"个性签名"];
//self.cellDetailTitles1 = [NSMutableArray arrayWithArray:@[nickName,phone,home,bir,sex,live,emotionStatus,sign]];
- (void)done {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    if (self.icon) {
        params[@"avatar"] = self.iconPath;
    } else if (self.model.avatar) {
        params[@"avatar"] = self.model.avatar;
    } else {
        [self showErrorHUDWithError:@"请选择头像"]; return;
    }
    if ([self.cellDetailTitles2[0] isEqualToString:@"请填写"])   { [self showAlertView]; return;}
    else { params[@"nickname"] = self.cellDetailTitles2[0];}
//    if ([self.cellDetailTitles1[1] isEqualToString:@"请选择"])   { [self showAlertView]; return;}
//    else { params[@"phone"] = self.cellDetailTitles1[1];}

    if (self.editHome) {// 如果有编辑家乡
        if ([self.cellDetailTitles2[2] isEqualToString:@"请选择"])   { [self showAlertView]; return;}
        else {
            params[@"hometown_id"] = @(self.homeID);
            params[@"hometown"] = self.cellDetailTitles2[2];
        }
    } else {
        if ([self.cellDetailTitles2[2] isEqualToString:@"请选择"])   { [self showAlertView]; return;}
        else {
            params[@"hometown_id"] = [mUserDefaults objectForKey:@"homeID"];
            params[@"hometown"] = self.cellDetailTitles2[2];
        }
    }
    
    if ([self.cellDetailTitles2[3] isEqualToString:@"请选择"])   { [self showAlertView]; return;}
    else { params[@"birthday"] = [CommonTools getTimeStampBytimeStr:self.cellDetailTitles2[3]];}
    if ([self.cellDetailTitles2[4] isEqualToString:@"请选择"])  {[self showAlertView]; return; }
    else { params[@"gender"] = [self.cellDetailTitles2[4] isEqualToString:@"男"] ? @"0" : @"1";}
    if (self.editAddress) {// 如果有编辑现居地
        if ([self.cellDetailTitles2[5] isEqualToString:@"请填写"]) {[self showAlertView]; return; }
        else {
            params[@"now_address_id"] = @(self.addressID);
            params[@"address"] = self.cellDetailTitles2[5];
        }
    } else {
        if ([self.cellDetailTitles2[5] isEqualToString:@"请填写"]) {[self showAlertView]; return; }
        else {
            params[@"now_address_id"] = [mUserDefaults objectForKey:@"addressID"];
            params[@"address"] = self.cellDetailTitles2[5];
        }
    }
    if ([self.cellDetailTitles2[6] isEqualToString:@"请填写"]) { [self showAlertView]; return; }
    else {
        NSInteger emoState;
        if ([self.cellDetailTitles2[6] isEqualToString:@"保密"]) {
            emoState = 1;
        } else if ([self.cellDetailTitles2[6] isEqualToString:@"单身"]) {
            emoState = 2;
        } else if ([self.cellDetailTitles2[6] isEqualToString:@"热恋中"]) {
            emoState = 3;
        } else {
            emoState = 4;
        }
        params[@"emotional_state"] = @(emoState);
    }
    if ([self.cellDetailTitles2[7] isEqualToString:@"请填写"]) {
//        [self showAlertView];
        params[@"sign"] = @"";}
    else {params[@"sign"] = self.cellDetailTitles2[7];}
    if ([self.cellDetailTitles2[8] isEqualToString:@"请填写"]) {
//        [self showAlertView];
        params[@"company_name"] = @"";
        }
    else {params[@"company_name"] = self.cellDetailTitles2[8];}
    NSDictionary *dict = params;
    [TZHttpTool postWithURL:ApiEditUser params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"保存成功"];
        [TZUserManager syncUserModel];
        [mUserDefaults setObject:@(self.addressID) forKey:@"addressID"];
        [mUserDefaults setObject:@(self.homeID) forKey:@"homeID"];
        [mUserDefaults synchronize];
        [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];
        if ([params[@"hometown"] length] > 0) {
            [mNotificationCenter postNotificationName:@"LaoXiangChanged" object:nil];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSString *msg) {
        [self showErrorHUDWithError:msg];
    }];
}

///// 绑定/解绑手机号
//- (void)bindPhoneBtnClick:(UIButton *)sender {
//    if (sender.hidden) return;
//    ICEForgetViewController *iCEForget = [[ICEForgetViewController alloc] init];
//    iCEForget.uid = _modelSelfInfo.uid;
//    if ([self.cellDetailTitles2[3] isEqualToString:@"请绑定手机号"]) {
//        iCEForget.navigationItem.title = @"绑定手机号";
//        iCEForget.typeOfVc = ICEForgetViewControllerTypeBindPhone;
//    } else if (_canUnbindPhone) {
//        iCEForget.navigationItem.title = @"解绑手机号";
//        iCEForget.typeOfVc = ICEForgetViewControllerTypeUnbindPhone;
//        iCEForget.phone = DEF_PERSISTENT_GET_OBJECT(DEF_USERNAME);
//    }
//    [iCEForget setDidBindPhoneSuccessHandle:^(NSString *phone) {
//        self.modelSelfInfo.phone = phone;
//        self.cellDetailTitles2[3] = phone;
//        _canUnbindPhone = YES;
//        [self.tableView reloadData];
//    }];
//    [iCEForget setDidUnbindPhoneSuccessHandle:^(){
////        [self loadTableViewData];
//    }];
//    [self.navigationController pushViewController:iCEForget animated:YES];
//}


#pragma mark - 私有方法
//
//- (void)popSelectViewDidSelectedCell:(NSString *)cellName {
//    if ([cellName isEqualToString:@"男"]) {
//        [self editSelfInfo:@"gender" value:@"0"];
//        self.modelSelfInfo.gender = @"0";
//    } else {
//        [self editSelfInfo:@"gender" value:@"1"];
//        self.modelSelfInfo.gender = @"1";
//    }
//    [super popSelectViewDidSelectedCell:cellName];
//}

//- (void)editSelfInfo:(NSString *)strKey value:(NSString *)strValue {
//    [self hideHud];
//    [self showHint:NSLocalizedString(@"setting.saving", "saving...")];
//    RACSignal *signal = [ICEImporter editPersonWithKey:strKey value:strValue];
//    [signal subscribeNext:^(id x) {
//        if ([strKey isEqualToString:@"nickname"]) {
//            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
//            userModel.nickname = strValue;
//        }
//        if ([strKey isEqualToString:@"gender"]) {
//            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
//            userModel.gender = strValue;
//        }
//        [self showHint:@"修改成功"];
//    }];
//}


/** 日期picker*/
- (void)datePickerViewDidClickOKButton:(UIDatePicker *)datePicker {
    [super datePickerViewDidClickOKButton:datePicker];
//    NSString *birth = self.cellDetailTitles2[3];
//    NSString *strBirth = [ICETools timeStamp:birth];
//    DLog(@"%@", birth);
#warning 陈冰 日期回调
//    [self editSelfInfo:@"birthday" value:strBirth];
}

/// 显示一行输入框
- (void)showInputViewWithTitle:(NSString *)title item:(NSString *)item keyBoardType:(UIKeyboardType)keyBoardType {
    self.inputView.titleLable.text = title;
    [self.inputView setItems:@[item]];
    [self.inputView show];
    self.inputView.textFiled1.keyboardType = keyBoardType;
    __weak typeof(self) weakSelf = self;
    self.inputView.okButtonClickBolck = ^(NSMutableArray *arr){
        // 修改手机号
        [TZHttpTool postWithURL:ApiBindPhone params:@{@"username":arr[0],@"uid":weakSelf.modelSelfInfo.uid} success:^(id json) {
            [weakSelf showHint:@"绑定成功"];
            [mUserDefaults setObject:arr[0] forKey:DEF_USERNAME];
            [mUserDefaults synchronize];
            weakSelf.modelSelfInfo.phone = arr[0];
            weakSelf.cellDetailTitles2[1] = arr[0];
            [weakSelf.tableView reloadData];
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            userModel.phone = arr[0];
            userModel.username = arr[0];
        } failure:^(NSString *error) {
            [weakSelf showHint:error];
        }];
    };
}


- (void)updataHeadImg:(UIImage *)image isIcon:(BOOL)isIcon {
    if (!image) return;
    NSArray *fileArr = @[
                         @{
                             @"file": image,
                             @"name" : @"headImage.png",
                             @"key" : @"avatar"
                             }
                         ];
    [self showTextHUDWithPleaseWait];
    RACSignal *signal = [ICEImporter uploadFilesWithUrl:ApiUploadPersonImg params:@{ @"avatar": @"headImage" } files:fileArr];
    [signal subscribeNext:^(NSDictionary *result) {
        [self hideTextHud];
        NSLog(@"%@",result);
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *str = [ApiSystemImage stringByAppendingString:result[@"data"]];
        self.iconPath = str;
        userModel.avatar = str;
        if (isIcon) {
            userModel.avatar = str;
            params[@"avatar"] = str;
        } else {
            userModel.background = str;
            params[@"background"] = str;
        }
//        [TZHttpTool postWithURL:ApiEditUser params:params success:^(NSDictionary *result) {
////            [self showHint:@"修改成功"];
//        } failure:^(NSString *msg) {
//            [self showErrorHUDWithError:msg];
//        }];
    }];
}

#pragma mark   ----- LFindLocationViewControllerDelegete

- (void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation {
    self.editHome = YES;
    [self refreshCellDetailNamesWith:city];
    NSString *cityID = [ZYLocationTools getCityIDWithCityName:city];
    if (self.row == 2) {
        self.homeID = cityID.integerValue;
    } else if (self.row == 5) {
        self.addressID = cityID.integerValue;
    }
}


@end
